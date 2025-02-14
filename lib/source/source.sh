#!/usr/bin/env bash

if ! type -f bpkg-run &>/dev/null; then
  echo "error: bpkg-run not found, aborting"
  exit 1
else
  # shellcheck source=lib/run/run.sh
  source "$(which bpkg-run)"
fi

bpkg_source () {
  # shellcheck disable=SC2068
  bpkg_run --emit-source --target "$1" ${@:2}
  return $?
}

## Use as lib or perform install
if [[ ${BASH_SOURCE[0]} != "$0" ]]; then
  export -f bpkg_source
else
  bpkg_source "$@"
  exit $?
fi
