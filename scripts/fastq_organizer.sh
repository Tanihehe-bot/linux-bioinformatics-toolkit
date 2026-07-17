#!/usr/bin/env bash
set -euo pipefail

INPUT_DIR="$1"
OUTPUT_DIR="$2"

if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: input directory '$INPUT_DIR' does not exist." >&2
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

PATTERN='^(.+)[_-][Rr]([12])\.(fastq|fq)(\.gz)?$'

shopt -s nocasematch

matched_count=0
flagged_count=0

while IFS= read -r -d '' file; do
    filename=$(basename "$file")

if [[ "$filename" =~ $PATTERN ]]; then
    sample_id="${BASH_REMATCH[1]}"
    read_number="${BASH_REMATCH[2]}"
    gz_suffix="${BASH_REMATCH[4]}"

    sample_id_clean=$(echo "$sample_id" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9' '_')
    sample_id_clean="${sample_id_clean%_}"

    new_name="${sample_id_clean}_R${read_number}.fastq${gz_suffix}"

    mv -v "$file" "$OUTPUT_DIR/$new_name"
    matched_count=$((matched_count + 1))
else
    echo "FLAGGED: $filename (does not match naming pattern, left in place)"
    flagged_count=$((flagged_count + 1))
fi
done < <(find "$INPUT_DIR" -maxdepth 1 -type f -print0)

shopt -u nocasematch

echo ""
echo "Summary: $matched_count file(s) organized, $flagged_count file(s) flagged."
