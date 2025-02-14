#!/usr/bin/env bash

## output usage
usage () {
  echo "Installs dependencies for a package."
  echo "usage: bpkg-getdeps [-h|--help]"
  echo "   or: bpkg-getdeps"
}

## Read a package property
bpkg_getdeps () {
  local cwd="$(pwd)"
  local pkg="${cwd}/bpkg.json"

  ## parse flags
  case "$1" in
    -h|--help)
      usage
      return 0
      ;;
  esac

  ## ensure there is a package to read
  if ! test -f "${pkg}"; then
    pkg="${cwd}/package.json"
    if ! test -f "${pkg}"; then
      echo 1>&2 "error: Unable to find \`bpkg.json' or \`package.json' in $cwd"
      return 1
    fi
  fi

  # shellcheck disable=SC2002
  dependencies=$(cat "${pkg}" | bpkg-json -b | grep '\[\"dependencies' | sed "s/\[\"dependencies\",//" | sed "s/\"\]$(printf '\t')\"/@/" | tr -d '"')
  # shellcheck disable=SC2206
  dependencies=(${dependencies[@]})

  ## run bpkg install for each dependency
  for (( i = 0; i < ${#dependencies[@]} ; ++i )); do
    (
      local package=${dependencies[$i]}
      bpkg install "${package}"
    )
  done
  return 0
}

if [[ ${BASH_SOURCE[0]} != "$0" ]]; then
  export -f bpkg_getdeps
else
  bpkg_getdeps "${@}"
  exit $?
fi
