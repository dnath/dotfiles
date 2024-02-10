if [ $(uname -s) != 'Darwin' ]; then
  echo "Error: to_heic only supported in MacOS!"
  exit 1
fi

SRC_DIR="$1"
if [ -d "${SRC_DIR}" ]; then
    echo "Found source dir: ${SRC_DIR}."
else
    echo "Error: Directory '${SRC_DIR}' does not exist!"
    exit 1
fi

cd ${SRC_DIR}

NEW_SRC_DIR=converted_source_files
SKIPPED_SRC_DIR=skipped_source_files
mkdir -p ${NEW_SRC_DIR}
mkdir -p ${SKIPPED_SRC_DIR}

for src in *.{jpeg,JPEG,jpg,JPG}; do
    if ! test -f "${src}"; then
        echo "File: '${src}' does not exist! Skipping..."
        continue
    fi

    echo "Processing ${src}..."
    target="${src%.*}.heic"

    if test -f "${target}"; then
        echo "File with target filename: '${target}' already exist! Skipping..."
        mv "${src}" "${SKIPPED_SRC_DIR}/"
        continue
    fi

    # Get the creation date time stamp of the target file, saved as 't'.
    creation_date="$(/usr/bin/GetFileInfo -d "${src}")"

    # Conversion
    /usr/bin/sips -s format heic "${src}" --out "${target}"
    
    # Set the modified and creation date time stamps of the target file to the saved value held in 't'.
    /usr/bin/SetFile -m "${creation_date}" -d "${creation_date}" "${target}"

    echo "Converted file: ${target}"

    mv "${src}" "${NEW_SRC_DIR}/"
    echo "Moved source to ${NEW_SRC_DIR}"
done
