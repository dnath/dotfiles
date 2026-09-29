# Convert JPEGs to HEIC

Run `bin/to_heic.sh` on macOS with a directory of images:

```shell
bin/to_heic.sh "/path/to/photos"
```

The script processes `.jpg` and `.jpeg` files in that directory, regardless of
extension case. It does not search subdirectories. Other files, such as `.mov`
videos, remain in place and are not included in the summary.

For each successful conversion, the HEIC file appears beside the JPEG. The
original JPEG moves to `converted_source_files` in the same directory. The
HEIC file keeps the source file's creation and modification times. An existing
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
failures, the script offers to delete `converted_source_files`. It shows the
number of entries and the exact command first. In an interactive terminal,
type `DELETE` to confirm or press Enter to keep the directory. Without an
interactive terminal, the script keeps it. If a legacy
`skipped_source_files` directory exists and is empty, the same confirmation
also removes it.

**Check the HEIC files before confirming.** Deleting
`converted_source_files` deletes *everything* inside it, including files from
previous runs and any other file types placed there. Other files in the source
directory, such as `.mov` videos, are never part of this cleanup.
