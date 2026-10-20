#!/bin/bash

if [[ $(uname -s) != Darwin ]]; then
    printf 'Error: to_heic is only supported on macOS.\n' >&2
    exit 1
fi

recursive=0
assume_yes=0
batch_size=0
usage() {
    printf 'Usage: %s [-r] [-y] [-b [SIZE]] SOURCE_DIRECTORY\n' "${0##*/}" >&2
    exit 1
}

while (( $# > 0 )); do
    case $1 in
        -r) recursive=1; shift ;;
        -y) assume_yes=1; shift ;;
        -b)
            batch_size=50
            assume_yes=1
            shift
            if [[ ${1:-} =~ ^[0-9]+$ ]]; then
                [[ $1 =~ ^[1-9][0-9]{0,14}$ ]] || usage
                batch_size=$1
                shift
            fi
            ;;
        -ry|-yr) recursive=1; assume_yes=1; shift ;;
        --) shift; break ;;
        -*) usage ;;
        *) break ;;
    esac
done

if [[ $# -ne 1 || ! -d $1 ]]; then
    usage
fi

for tool in /usr/bin/sips /usr/bin/GetFileInfo /usr/bin/SetFile; do
    if [[ ! -x $tool ]]; then
        printf 'Error: required tool is unavailable: %s\n' "$tool" >&2
        exit 1
    fi
done

if ! cd -- "$1"; then
    printf 'Error: cannot enter source directory: %s\n' "$1" >&2
    exit 1
fi

archive_dir=converted_source_files
converted=0
skipped=0
failed=0
processed=0
deleted=0
archived_sources=()
cleanup_failed=0

green_out= yellow_out= red_out= reset_out=
red_err= reset_err=
if [[ -z ${NO_COLOR:-} && ${TERM:-dumb} != dumb ]] && command -v tput >/dev/null; then
    color_count=$(tput colors 2>/dev/null)
    if [[ $color_count =~ ^[0-9]+$ ]] && ((color_count >= 8)); then
        reset=$(tput sgr0)
        if [[ -t 1 ]]; then
            green_out=$(tput setaf 2)
            yellow_out=$(tput setaf 3)
            red_out=$(tput setaf 1)
            reset_out=$reset
        fi
        if [[ -t 2 ]]; then
            red_err=$(tput setaf 1)
            reset_err=$reset
        fi
    fi
fi

show_cleanup() {
    local suffix=s
    if (( ${#archived_sources[@]} == 1 )); then
        suffix=
    fi
    printf '\nCleanup commands for %d archived original%s:\n' "${#archived_sources[@]}" "$suffix"
    for archived_src in "${archived_sources[@]}"; do
        printf '  rm -- %q\n' "$PWD/$archived_src"
    done
}

cleanup_archived() {
    local archived_src count=${#archived_sources[@]} suffix=s
    if (( count == 1 )); then
        suffix=
    fi
    for archived_src in "${archived_sources[@]}"; do
        if ! rm -- "$archived_src"; then
            printf '%sFAIL%s  Could not delete %s.\n' "$red_err" "$reset_err" "$PWD/$archived_src" >&2
            return 1
        fi
        ((deleted += 1))
        rmdir -- "${archived_src%/*}" 2>/dev/null || :
    done
    archived_sources=()
    printf '%sDeleted%s %d archived original%s.\n' "$green_out" "$reset_out" "$count" "$suffix"
}

show_progress() {
    printf '%s: %d/%d processed (%d left); %d converted, %d skipped, %d failed, %d originals deleted, %d archived.\n' \
        "$1" "$processed" "$total" "$((total - processed))" \
        "$converted" "$skipped" "$failed" "$deleted" "$((converted - deleted))"
}

find_args=()
if (( ! recursive )); then
    find_args=(-maxdepth 1)
fi

sources=()
while IFS= read -r -d '' src; do
    sources+=("${src#./}")
done < <(find . "${find_args[@]}" \
    \( -type d \( -name "$archive_dir" -o -name skipped_source_files \) -prune \) -o \
    \( \( -type f -o -type l \) \( -iname '*.jpg' -o -iname '*.jpeg' \) -print0 \))
total=${#sources[@]}

for src in "${sources[@]}"; do
    ((processed += 1))
    target=${src%.*}.heic
    src_dir=${src%/*}
    if [[ $src_dir == "$src" ]]; then
        src_dir=.
    fi
    archived_src=$src_dir/$archive_dir/${src##*/}

    if [[ -e $target || -L $target ]]; then
        printf '%sSKIP%s  %s: target already exists (%s)\n' "$yellow_out" "$reset_out" "$src" "$target"
        ((skipped += 1))
        continue
    fi

    if [[ -e $archived_src || -L $archived_src ]]; then
        printf '%sSKIP%s  %s: archived source already exists\n' "$yellow_out" "$reset_out" "$src"
        ((skipped += 1))
        continue
    fi

    if ! creation_date=$(/usr/bin/GetFileInfo -d "./$src") ||
       ! modification_date=$(/usr/bin/GetFileInfo -m "./$src"); then
        printf '%sFAIL%s  %s: could not read timestamps\n' "$red_err" "$reset_err" "$src" >&2
        ((failed += 1))
        continue
    fi

    if ! /usr/bin/sips -s format heic "./$src" --out "./$target" >/dev/null ||
       [[ ! -s $target ]]; then
        printf '%sFAIL%s  %s: conversion failed; source kept\n' "$red_err" "$reset_err" "$src" >&2
        ((failed += 1))
        continue
    fi

    if ! /usr/bin/SetFile -d "$creation_date" -m "$modification_date" "./$target"; then
        printf '%sFAIL%s  %s: could not set timestamps; source kept\n' "$red_err" "$reset_err" "$src" >&2
        ((failed += 1))
        continue
    fi

    if [[ -L $src_dir/$archive_dir ]] ||
       ! mkdir -p -- "$src_dir/$archive_dir" ||
       ! mv -n -- "./$src" "$src_dir/$archive_dir/" ||
       [[ -e $src ]]; then
        printf '%sFAIL%s  %s: could not archive source; HEIC kept\n' "$red_err" "$reset_err" "$src" >&2
        ((failed += 1))
        continue
    fi

    printf '%sOK%s    %s -> %s\n' "$green_out" "$reset_out" "$src" "$target"
    ((converted += 1))
    archived_sources+=("$archived_src")
    if (( batch_size > 0 && ${#archived_sources[@]} >= batch_size )); then
        show_cleanup
        if ! cleanup_archived; then
            cleanup_failed=1
            printf 'Stopping conversions because cleanup failed.\n' >&2
            show_progress 'Batch'
            break
        fi
        show_progress 'Batch'
    fi
done

if (( batch_size > 0 )); then
    if (( ${#archived_sources[@]} > 0 && ! cleanup_failed )); then
        show_cleanup
        cleanup_archived || cleanup_failed=1
        show_progress 'Batch'
    fi
elif (( total > 0 && converted == total && skipped == 0 && failed == 0 &&
        (assume_yes || ! recursive) )); then
    printf '\nThe HEIC files are ready. %d originals were archived.\n' "${#archived_sources[@]}"
    show_cleanup
    delete_sources=$assume_yes
    if (( ! assume_yes )); then
        if [[ -t 0 ]]; then
            printf 'Type DELETE to run the listed cleanup commands, or press Enter to keep the originals: '
            if IFS= read -r confirmation && [[ $confirmation == DELETE ]]; then
                delete_sources=1
            fi
        else
            printf 'No interactive terminal; originals kept.\n'
        fi
    fi

    if ((delete_sources)); then
        cleanup_archived || cleanup_failed=1
    elif (( ! assume_yes )) && [[ -t 0 ]]; then
        printf 'Originals kept.\n'
    fi
fi

printf '\n'
show_progress 'Final'

((failed == 0 && cleanup_failed == 0))
