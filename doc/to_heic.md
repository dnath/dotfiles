# Convert JPEGs to HEIC

Run `bin/to_heic.sh` on macOS with a directory of images:

```shell
bin/to_heic.sh "/path/to/photos"
# Include JPEGs in subdirectories:
bin/to_heic.sh -r "/path/to/photos"
# Delete archived originals after every JPEG converts successfully:
bin/to_heic.sh -r -y "/path/to/photos"
```

The script processes `.jpg` and `.jpeg` files in that directory, regardless of
extension case. With `-r`, it also searches subdirectories, excluding
`converted_source_files` and `skipped_source_files` directories. Other files,
such as `.mov` videos, remain in place and are not included in the summary.

For each successful conversion, the HEIC file appears beside the JPEG. The
original JPEG moves to `converted_source_files` beside it, including within a
subdirectory when using `-r`. The HEIC file keeps the source file's creation
and modification times. An existing
HEIC or a matching file in `converted_source_files` causes a skip; the JPEG
stays in place. If conversion or timestamp handling fails, the JPEG stays in
place and the script exits with an error after processing the remaining files.
A failed conversion can leave a partial HEIC file that needs inspection before
retrying.

The output labels each file `OK`, `SKIP`, or `FAIL` and ends with counts of
found, converted, skipped, and failed JPEGs. Labels and summary counts are
colored when the terminal supports color; set `NO_COLOR=1` to disable it.

## Cleanup confirmation

If at least one JPEG was found and every JPEG converted with no skips or
failures, the script can delete the originals archived by that run. It lists
the exact cleanup commands and their count first. Without `-r` or `-y`, type
`DELETE` at the terminal prompt to confirm; a noninteractive run keeps the
originals. With `-y`, cleanup proceeds without a prompt, including when used
with `-r`. Recursive runs without `-y` keep the originals.

Cleanup removes only JPEGs archived by the current run and removes their
archive directories if they become empty. Files from previous runs and other
contents of those directories remain. **Use `-y` only when you are ready to
delete the original JPEGs without checking the HEIC files first.**
