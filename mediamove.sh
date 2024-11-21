#!/bin/bash

LOGFILE="/mnt/user/data/mediamove_inuse.log"

echo "Script started at $(date)" >> "$LOGFILE"

SRC_PATH="/mnt/user/data/media"
DEST_PATH="/mnt/remotes/SMB-o/media"

echo "SRC_PATH: $SRC_PATH" >> "$LOGFILE"
echo "DEST_PATH: $DEST_PATH" >> "$LOGFILE"

# Function to copy files, verify the copy, and then delete the source file
copy_verify_delete() {
  src_file="$1"
  dest_dir="$2"

  if [ -f "$src_file" ]; then
    file_size=$(stat --format="%s" "$src_file")
    echo "File size before moving: $file_size bytes" >> "$LOGFILE"

    mkdir -p "$dest_dir"
    dest_file="$dest_dir/$(basename "$src_file")"
    cp "$src_file" "$dest_file"

    if [ -f "$dest_file" ]; then
      dest_file_size=$(stat --format="%s" "$dest_file")
      echo "File size after copying: $dest_file_size bytes" >> "$LOGFILE"

      if [ "$file_size" -eq "$dest_file_size" ]; then
        echo "File copied successfully. Deleting source file." >> "$LOGFILE"
        rm "$src_file"
      else
        echo "Warning: File sizes do not match! Source: $file_size, Destination: $dest_file_size" >> "$LOGFILE"
      fi
    else
      echo "Error: Destination file does not exist after copying." >> "$LOGFILE"
    fi
  fi
}

export -f copy_verify_delete  # Export the function for use by find

# Move TV shows
echo "Processing TV shows..." >> "$LOGFILE"
find "$SRC_PATH/tv" -type f -exec bash -c 'copy_verify_delete "$0" "$1"' {} "$DEST_PATH/tv" \;

# Move Movies
echo "Processing Movies..." >> "$LOGFILE"
find "$SRC_PATH/movies" -type f -exec bash -c 'copy_verify_delete "$0" "$1"' {} "$DEST_PATH/movies" \;

# Delete empty directories in the source folders, but not the top-level directories
echo "Cleaning up empty directories in TV shows..." >> "$LOGFILE"
find "$SRC_PATH/tv" -mindepth 1 -type d -empty -delete >> "$LOGFILE" 2>&1

echo "Cleaning up empty directories in Movies..." >> "$LOGFILE"
find "$SRC_PATH/movies" -mindepth 1 -type d -empty -delete >> "$LOGFILE" 2>&1

echo "Script ended at $(date)" >> "$LOGFILE"
exit 0
