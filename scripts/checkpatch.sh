#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
#
set -e

KERNEL_TAG=${KERNEL_TAG:-v6.10}
BASE_URL=https://raw.githubusercontent.com/torvalds/linux/$KERNEL_TAG/scripts
TOP=$(git rev-parse --show-toplevel)
CP_DIR=$TOP/build/checkpatch/$KERNEL_TAG

if [ ! -x "$CP_DIR/checkpatch.pl" ]; then
	mkdir -p "$CP_DIR"
	for f in checkpatch.pl spelling.txt const_structs.checkpatch; do
		curl -sSfL "$BASE_URL/$f" -o "$CP_DIR/$f"
	done
	chmod +x "$CP_DIR/checkpatch.pl"
fi

cd "$TOP"

if [ "$1" = "-f" ]; then
	shift
	exec "$CP_DIR/checkpatch.pl" --show-types -f "$@"
fi

RANGE=${1:-origin/main..HEAD}
[ $# -gt 0 ] && shift

BASE=${RANGE%%..*}
HEAD=${RANGE##*..}

EXCLUDE="^$BASE"
for ref in "$@"; do
	EXCLUDE="$EXCLUDE ^$ref"
done

# Newest first: checkpatch reverses the list, so it reports oldest first.
COMMITS=$(git rev-list --no-merges "$HEAD" $EXCLUDE)

if [ -z "$COMMITS" ]; then
	echo "checkpatch: no new commits to check in $RANGE"
	exit 0
fi

echo "checkpatch: checking $(echo "$COMMITS" | wc -l) commit(s)"
exec "$CP_DIR/checkpatch.pl" --show-types -g $COMMITS
