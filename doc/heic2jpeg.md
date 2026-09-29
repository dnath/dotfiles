# Convert HEICs to JPEG

Run `bin/heic2jpeg.sh` on macOS with a directory of images:

```shell
bin/heic2jpeg.sh "/path/to/photos"
```

The script processes `.heic` and `.heif` files in that directory, regardless of
extension case. It does not search subdirectories. Other files, such as `.mov`
videos, remain in place and are not included in the summary.

For each successful conversion, the JPEG appears beside the HEIC with a `.jpeg`
extension. The original HEIC moves to `converted_source_files` in the same
directory. The JPEG keeps the source file's creation and modification times, and
its EXIF metadata — camera model, capture date, orientation, GPS — carries over
unchanged. An existing JPEG or a matching file in `converted_source_files`
causes a skip; the HEIC stays in place. If
conversion or timestamp handling fails, the HEIC stays in place and the script
exits with an error after processing the remaining files. A failed conversion
can leave a partial JPEG that needs inspection before retrying.

Unlike HEIC, JPEG is lossy on every write, so this direction re-encodes rather
than round-trips. Converting a JPEG to HEIC with `bin/to_heic.sh` and back does
not restore the original bytes.

The output labels each file `OK`, `SKIP`, or `FAIL` and ends with counts of
found, converted, skipped, and failed HEICs. Labels and summary counts are
colored when the terminal supports color; set `NO_COLOR=1` to disable it.

## Options

```shell
bin/heic2jpeg.sh [-q QUALITY] [-d DIR] [-k] [-e EXT] SOURCE_DIRECTORY
```

| Option | Effect |
| --- | --- |
| `-q`, `--quality QUALITY` | JPEG quality: `low`, `normal`, `high`, `best`, or `0`-`100`. Defaults to `$HEIC2JPEG_QUALITY`, else `best`. |
| `-d`, `--destination DIR` | Write JPEGs to `DIR` instead of beside the source. |
| `-k`, `--keep_originals` | Leave the HEIC files in place. |
| `-e`, `--extension EXT` | Output extension: `jpeg` or `jpg`. Defaults to `$HEIC2JPEG_EXTENSION`, else `jpeg`. |
| `-h`, `--help` | Show usage. |

Every option takes a separated, attached, or `=` form: `-q 80`, `-q80`, and
`--quality=80` are equivalent. Use `--` before the source directory if its name
begins with a dash.

`--destination` takes an absolute path, or one relative to the directory you
ran the command from — not relative to the source directory. It is created if
missing. Skip detection looks for the target in the destination, so rerunning
the same command skips files already converted there.

`--extension` accepts `jpeg` or `jpg`, case-insensitively and with an optional
leading dot, and defaults to `jpeg`. Apple is inconsistent here, which is why
the flag exists: `UTType("public.jpeg").preferredFilenameExtension` is `jpeg`
and Photos names every JPEG in its library `.jpeg`, but `sips` warns that the
suffix "should be jpg", and macOS ships hundreds of `.jpg` files in
`/System/Library` and none named `.jpeg`. Either spelling is correct; `sips`
accepts both without complaint. Skip detection looks for *both* spellings, so
changing this flag between runs does not produce a second copy of a file already
converted.

`--keep_originals` leaves the HEIC files where they are instead of moving them
to `converted_source_files`. Because the JPEG uses a different extension, it
lands beside the original without collision. No archive directory is created,
and the cleanup confirmation below is skipped — there is nothing to delete.

## Cleanup confirmation

Without `--keep_originals`, if at least one HEIC was found and every HEIC
converted with no skips or failures, the script offers to delete
`converted_source_files`. It shows the number of entries and the exact command
first. In an interactive terminal, type `DELETE` to confirm or press Enter to
keep the directory. Without an interactive terminal, the script keeps it.

**Check the JPEG files before confirming.** Deleting `converted_source_files`
deletes *everything* inside it, including files from previous runs and any other
file types placed there. Other files in the source directory, such as `.mov`
videos, are never part of this cleanup. Since JPEG re-encoding is lossy, the
archived HEICs are the only copies at original quality.
