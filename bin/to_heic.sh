#!/bin/bash

if [[ $(uname -s) != Darwin ]]; then
    printf 'Error: to_heic is only supported on macOS.\n' >&2
    exit 1
fi

if [[ $# -ne 1 || ! -d $1 ]]; then
    printf 'Usage: %s SOURCE_DIRECTORY\n' "${0##*/}" >&2
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

shopt -s nullglob nocaseglob
for src in *.jpg *.jpeg; do
    ((total += 1))
    target=${src%.*}.heic

    if [[ -e $target || -L $target ]]; then
        printf '%sSKIP%s  %s: target already exists (%s)\n' "$yellow_out" "$reset_out" "$src" "$target"
        ((skipped += 1))
        continue
    fi

    if [[ -e $archive_dir/$src || -L $archive_dir/$src ]]; then
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

    if ! mkdir -p -- "$archive_dir" ||
       ! mv -n -- "./$src" "$archive_dir/" ||
       [[ -e $src ]]; then
        printf '%sFAIL%s  %s: could not archive source; HEIC kept\n' "$red_err" "$reset_err" "$src" >&2
        ((failed += 1))
        continue
    fi

    printf '%sOK%s    %s -> %s\n' "$green_out" "$reset_out" "$src" "$target"
    ((converted += 1))
done

printf '\nSummary: %d found, %s%d converted%s, %s%d skipped%s, %s%d failed%s.\n' \
    "$total" "$green_out" "$converted" "$reset_out" \
    "$yellow_out" "$skipped" "$reset_out" "$red_out" "$failed" "$reset_out"

cleanup_failed=0
if ((total > 0 && converted == total && skipped == 0 && failed == 0)) &&
   [[ -d $archive_dir && ! -L $archive_dir ]]; then
    archived_entries=$(find "$archive_dir" -mindepth 1 -print | wc -l)
    archived_entries=${archived_entries//[[:space:]]/}
    remove_skipped_dir=0
    if [[ -d skipped_source_files && ! -L skipped_source_files ]] &&
       [[ -z $(find skipped_source_files -mindepth 1 -print -quit) ]]; then
        remove_skipped_dir=1
    fi

    printf '\nThe HEIC files are ready. The originals remain in %s.\n' \
        "$PWD/$archive_dir"
    printf 'Archived entries: %d.\n' "$archived_entries"
    printf 'After verifying the HEIC files, you can delete the originals with:\n'
    printf '  rm -r -- %q\n' "$PWD/$archive_dir"
    if ((remove_skipped_dir)); then
        printf '  rmdir -- %q\n' "$PWD/skipped_source_files"
    fi

    if [[ -t 0 ]]; then
        printf 'Type DELETE to run the listed cleanup commands, or press Enter to keep the directories: '
        if IFS= read -r confirmation && [[ $confirmation == DELETE ]]; then
            if rm -r -- "$archive_dir"; then
                printf '%sDeleted%s %s.\n' "$green_out" "$reset_out" "$PWD/$archive_dir"
            else
                printf '%sFAIL%s  Could not delete %s.\n' "$red_err" "$reset_err" "$PWD/$archive_dir" >&2
                cleanup_failed=1
            fi
            if ((remove_skipped_dir)); then
                if rmdir -- skipped_source_files; then
                    printf '%sDeleted%s empty %s.\n' "$green_out" "$reset_out" "$PWD/skipped_source_files"
                else
                    printf '%sFAIL%s  Could not delete %s.\n' "$red_err" "$reset_err" "$PWD/skipped_source_files" >&2
                    cleanup_failed=1
                fi
            fi
        else
            printf 'Directories kept.\n'
        fi
    else
        printf 'No interactive terminal; directories kept.\n'
    fi
fi

((failed == 0 && cleanup_failed == 0))
