#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   ./subset_gff_by_seqid.sh keep_ids.txt annotation.gff > subset.annotation.gff
#
# keep_ids.txt: text file with seqids one per line, without ">" like
#   scaffold_1
#   scaffold_20
#   JBTAND010000223.1

keep_ids="$1"
gff="$2"

awk -F'\t' '
BEGIN {
    OFS = "\t"
}

# First file: sequence IDs to keep
NR == FNR {
    id = $1
    sub(/^>/, "", id)      # allow FASTA-style >seqid
    gsub(/\r$/, "", id)    # handle Windows line endings
    if (id != "") keep[id] = 1
    next
}

# Keep GFF header/comment lines unchanged
/^#/ {
    print
    next
}

# Keep only feature lines whose field 1 is in the ID list
($1 in keep) {
    print
}
' "$keep_ids" "$gff"
