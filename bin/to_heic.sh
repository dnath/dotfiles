#!/bin/bash

if [[ $(uname -s) != Darwin ]]; then
    printf 'Error: to_heic is only supported on macOS.\n' >&2
    exit 1
fi

recursive=0
assume_yes=0
while getopts ':ry' option; do
    case $option in
        r) recursive=1 ;;
        y) assume_yes=1 ;;
        *) printf 'Usage: %s [-r] [-y] SOURCE_DIRECTORY\n' "${0##*/}" >&2; exit 1 ;;
    esac
done
shift $((OPTIND - 1))

if [[ $# -ne 1 || ! -d $1 ]]; then
    printf 'Usage: %s [-r] [-y] SOURCE_DIRECTORY\n' "${0##*/}" >&2
    exit 1
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
total=0
archived_sources=()

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

find_args=()
if (( ! recursive )); then
    find_args=(-maxdepth 1)
fi

while IFS= read -r -d '' src; do
    src=${src#./}
    ((total += 1))
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
done < <(find . "${find_args[@]}" \
    \( -type d \( -name "$archive_dir" -o -name skipped_source_files \) -prune \) -o \
    \( \( -type f -o -type l \) \( -iname '*.jpg' -o -iname '*.jpeg' \) -print0 \))

printf '\nSummary: %d found, %s%d converted%s, %s%d skipped%s, %s%d failed%s.\n' \
    "$total" "$green_out" "$converted" "$reset_out" \
    "$yellow_out" "$skipped" "$reset_out" "$red_out" "$failed" "$reset_out"

cleanup_failed=0
if (( total > 0 && converted == total && skipped == 0 && failed == 0 &&
      (assume_yes || ! recursive) )); then
    printf '\nThe HEIC files are ready. %d originals were archived.\n' "${#archived_sources[@]}"
    printf 'Cleanup commands for this run:\n'
    for archived_src in "${archived_sources[@]}"; do
        printf '  rm -- %q\n' "$PWD/$archived_src"
    done

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
        for archived_src in "${archived_sources[@]}"; do
            if rm -- "$archived_src"; then
                rmdir -- "${archived_src%/*}" 2>/dev/null || :
            else
                printf '%sFAIL%s  Could not delete %s.\n' "$red_err" "$reset_err" "$PWD/$archived_src" >&2
                cleanup_failed=1
            fi
        done
        if (( ! cleanup_failed )); then
            printf '%sDeleted%s %d archived originals.\n' "$green_out" "$reset_out" "${#archived_sources[@]}"
        fi
    elif (( ! assume_yes )) && [[ -t 0 ]]; then
        printf 'Originals kept.\n'
    fi
fi

((failed == 0 && cleanup_failed == 0))
