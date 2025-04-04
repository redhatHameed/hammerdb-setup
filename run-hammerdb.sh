#!/bin/bash
set -euo pipefail

VERSION=${1:-4.12}
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
HAMMERDB_DIR="$ROOT_DIR/HammerDB-$VERSION"
SCRIPT_DIR="$ROOT_DIR"

if [[ ! -x "$HAMMERDB_DIR/hammerdbcli" ]]; then
  echo "Error: $HAMMERDB_DIR/hammerdbcli not found or not executable."
  echo "Run ./install-hammerdb.sh $VERSION first."
  exit 1
fi

if [[ ! -f "$SCRIPT_DIR/build.tcl" ]]; then
  echo "Missing scripts/build.tcl"
  exit 1
fi

if [[ ! -f "$SCRIPT_DIR/run.tcl" ]]; then
  echo "Missing scripts/run.tcl"
  exit 1
fi

echo "==> Running build.tcl..."
"$HAMMERDB_DIR/hammerdbcli" tcl auto "$SCRIPT_DIR/build.tcl"

echo "==> Running run.tcl..."
"$HAMMERDB_DIR/hammerdbcli" tcl auto "$SCRIPT_DIR/run.tcl"

echo "==> Done."