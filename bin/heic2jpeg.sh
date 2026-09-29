#!/bin/bash

if [[ $(uname -s) != Darwin ]]; then
    printf 'Error: heic2jpeg is only supported on macOS.\n' >&2
    exit 1
fi

usage() {
    printf 'Usage: %s [OPTIONS] SOURCE_DIRECTORY\n\n' "${0##*/}"
    printf '  -q, --quality QUALITY      JPEG quality: low, normal, high, best, or 0-100.\n'
    printf '                             Defaults to HEIC2JPEG_QUALITY, else best.\n'
    printf '  -d, --destination DIR      Write JPEGs here instead of beside the source.\n'
    printf '                             Absolute, or relative to the current directory.\n'
    printf '                             Created if missing.\n'
    printf '  -k, --keep_originals       Leave the HEIC files in place instead of moving\n'
    printf '                             them to converted_source_files.\n'
    printf '  -e, --extension EXT        Output extension: jpeg or jpg. Default: jpeg.\n'
    printf '  -h, --help                 Show this message.\n'
}

quality=${HEIC2JPEG_QUALITY:-best}
destination=
keep_originals=0
extension=${HEIC2JPEG_EXTENSION:-jpeg}
while (($#)); do
    case $1 in
        -q | --quality)
            if (($# < 2)); then
                printf 'Error: %s requires a value.\n' "$1" >&2
                usage >&2
                exit 1
            fi
            quality=$2
            shift 2
            ;;
        -q?* | --quality=*)
            quality=${1#*=}
            quality=${quality#-q}
            shift
            ;;
        -d | --destination)
            if (($# < 2)); then
                printf 'Error: %s requires a value.\n' "$1" >&2
                usage >&2
                exit 1
            fi
            if [[ -z $2 ]]; then
                printf 'Error: %s requires a non-empty value.\n' "$1" >&2
                exit 1
            fi
            destination=$2
            shift 2
            ;;
        -d?* | --destination=*)
            destination=${1#*=}
            destination=${destination#-d}
            if [[ -z $destination ]]; then
                printf 'Error: %s requires a non-empty value.\n' "$1" >&2
                exit 1
            fi
            shift
            ;;
        -k | --keep_originals | --keep-originals)
            keep_originals=1
            shift
            ;;
        -e | --extension)
            if (($# < 2)); then
                printf 'Error: %s requires a value.\n' "$1" >&2
                usage >&2
                exit 1
            fi
            extension=$2
            shift 2
            ;;
        -e?* | --extension=*)
            extension=${1#*=}
            extension=${extension#-e}
            shift
            ;;
        -h | --help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'Error: unknown option: %s\n' "$1" >&2
            usage >&2
            exit 1
            ;;
        *)
            break
            ;;
    esac
done

if [[ $# -ne 1 || ! -d $1 ]]; then
    usage >&2
    exit 1
fi

if [[ $quality =~ ^[0-9]{1,3}$ ]]; then
    if ((quality > 100)); then
        printf 'Error: numeric quality must be 0-100: "%s"\n' "$quality" >&2
        exit 1
    fi
elif [[ ! $quality =~ ^(low|normal|high|best)$ ]]; then
    printf 'Error: quality must be low, normal, high, best, or 0-100: "%s"\n' \
        "$quality" >&2
    exit 1
fi

# Accept .JPG, .jpeg and so on; sips treats jpg, jpeg and jpe alike.
extension=$(printf '%s' "${extension#.}" | tr 'A-Z' 'a-z')
if [[ ! $extension =~ ^(jpeg|jpg)$ ]]; then
    printf 'Error: extension must be jpeg or jpg: "%s"\n' "$extension" >&2
    exit 1
fi

for tool in /usr/bin/sips /usr/bin/GetFileInfo /usr/bin/SetFile; do
    if [[ ! -x $tool ]]; then
        printf 'Error: required tool is unavailable: %s\n' "$tool" >&2
        exit 1
    fi
done

# Resolve the destination before entering the source directory, so a relative
# path is relative to where the user ran the command.
dest_dir=
if [[ -n $destination ]]; then
    if ! mkdir -p -- "$destination"; then
        printf 'Error: cannot create destination directory: %s\n' "$destination" >&2
        exit 1
    fi
    if ! dest_dir=$(cd -- "$destination" && pwd -P); then
        printf 'Error: cannot enter destination directory: %s\n' "$destination" >&2
        exit 1
    fi
    if [[ ! -w $dest_dir ]]; then
        printf 'Error: destination directory is not writable: %s\n' "$dest_dir" >&2
        exit 1
    fi
fi

if ! cd -- "$1"; then
    printf 'Error: cannot enter source directory: %s\n' "$1" >&2
    exit 1
fi

source_dir=$(pwd -P)
if [[ -z $dest_dir || $dest_dir == "$source_dir" ]]; then
    dest_dir=$source_dir
    separate_dest=0
else
    separate_dest=1
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
for src in *.heic *.heif; do
    ((total += 1))
    target=${src%.*}.$extension
    out_path=$dest_dir/$target
    if ((separate_dest)); then
        display_target=$out_path
    else
        display_target=$target
    fi

    # A JPEG under either spelling means this source was already converted, so
    # changing --extension between runs does not produce a second copy.
    existing=
    for candidate in "${src%.*}.jpeg" "${src%.*}.jpg"; do
        if [[ -e $dest_dir/$candidate || -L $dest_dir/$candidate ]]; then
            existing=$candidate
            break
        fi
    done

    if [[ -n $existing ]]; then
        if ((separate_dest)); then
            existing=$dest_dir/$existing
        fi
        printf '%sSKIP%s  %s: target already exists (%s)\n' "$yellow_out" "$reset_out" "$src" "$existing"
        ((skipped += 1))
        continue
    fi

    if ((!keep_originals)) && [[ -e $archive_dir/$src || -L $archive_dir/$src ]]; then
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

    if ! /usr/bin/sips -s format jpeg -s formatOptions "$quality" \
           "./$src" --out "$out_path" >/dev/null ||
       [[ ! -s $out_path ]]; then
        printf '%sFAIL%s  %s: conversion failed; source kept\n' "$red_err" "$reset_err" "$src" >&2
        ((failed += 1))
        continue
    fi

    if ! /usr/bin/SetFile -d "$creation_date" -m "$modification_date" "$out_path"; then
        printf '%sFAIL%s  %s: could not set timestamps; source kept\n' "$red_err" "$reset_err" "$src" >&2
        ((failed += 1))
        continue
    fi

    if ((!keep_originals)); then
        if ! mkdir -p -- "$archive_dir" ||
           ! mv -n -- "./$src" "$archive_dir/" ||
           [[ -e $src ]]; then
            printf '%sFAIL%s  %s: could not archive source; JPEG kept\n' "$red_err" "$reset_err" "$src" >&2
            ((failed += 1))
            continue
        fi
    fi

    printf '%sOK%s    %s -> %s\n' "$green_out" "$reset_out" "$src" "$display_target"
    ((converted += 1))
done

printf '\nSummary: %d found, %s%d converted%s, %s%d skipped%s, %s%d failed%s.\n' \
    "$total" "$green_out" "$converted" "$reset_out" \
    "$yellow_out" "$skipped" "$reset_out" "$red_out" "$failed" "$reset_out"

if ((converted > 0 && separate_dest)); then
    printf 'JPEGs written to %s.\n' "$dest_dir"
fi

if ((converted > 0 && keep_originals)); then
    printf 'Originals left in place in %s.\n' "$source_dir"
fi

cleanup_failed=0
if ((!keep_originals)) &&
   ((total > 0 && converted == total && skipped == 0 && failed == 0)) &&
   [[ -d $archive_dir && ! -L $archive_dir ]]; then
    archived_entries=$(find "$archive_dir" -mindepth 1 -print | wc -l)
    archived_entries=${archived_entries//[[:space:]]/}

    printf '\nThe JPEG files are ready. The originals remain in %s.\n' \
        "$source_dir/$archive_dir"
    printf 'Archived entries: %d.\n' "$archived_entries"
    printf 'After verifying the JPEG files, you can delete the originals with:\n'
    printf '  rm -r -- %q\n' "$source_dir/$archive_dir"

    if [[ -t 0 ]]; then
        printf 'Type DELETE to run the listed cleanup command, or press Enter to keep the directory: '
        if IFS= read -r confirmation && [[ $confirmation == DELETE ]]; then
            if rm -r -- "$archive_dir"; then
                printf '%sDeleted%s %s.\n' "$green_out" "$reset_out" "$source_dir/$archive_dir"
            else
                printf '%sFAIL%s  Could not delete %s.\n' "$red_err" "$reset_err" "$source_dir/$archive_dir" >&2
                cleanup_failed=1
            fi
        else
            printf 'Directories kept.\n'
        fi
    else
        printf 'No interactive terminal; directory kept.\n'
    fi
fi

((failed == 0 && cleanup_failed == 0))
