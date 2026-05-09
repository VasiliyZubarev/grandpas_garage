#!/usr/bin/env bash
set -euo pipefail

# Changes sequence IDs in annotation GFF file.
# Useful if you e.g. uploaded your assembly to NCBI and so sequence IDs have changed without change of actual sequence.
# Usage:
#   ./rename_gff_seqids.sh name_map.tsv annotation.gff > renamed.annotation.gff
#
# TSV format expected:
#   old_name<TAB>new_name
# Example:
#   scaffold_1    JBTAND010000223.1
#   scaffold_20   CM142095.1

map_tsv="$1"
gff="$2"

awk -F'\t' '
BEGIN {
    OFS = "\t"
}

# First file: name map
NR == FNR {
    old = $1
    new = $2

    # Remove leading ">" if present
    sub(/^>/, "", old)
    sub(/^>/, "", new)

    map[old] = new
    next
}

# GFF comments / headers
/^#/ {
    print
    next
}

# GFF feature lines
{
    if ($1 in map) {
        $1 = map[$1]
    }
    print
}
' "$map_tsv" "$gff"
