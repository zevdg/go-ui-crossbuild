#!/bin/bash

PACKAGE_DIR="."
OUTPUT_DIR="."
SRC_DIR="."

read -r -d '' USAGE << EOM
Usage: gouicrossbuild [-s src_directory] [-p package_directory] [-o output_directory] [go_build_args...]

Options:
    All paths must be relative to the project root

    src_directory (default '$SRC_DIR')
        The root source folder
        Must contain a vendor directory that includes "github.com/andlabs/ui"
        This parameter will be deprecated once https://github.com/andlabs/ui/issues/230 is fixed

    package_directory (default '$PACKAGE_DIR')
        The directory containing the package to be built

    output_directory (default '$OUTPUT_DIR')
        Where to save the build output

Examples:
    # build the package at <project_root> with vendor directory <project_root>/vendor
    # output to <project_root>
    gouicrossbuild

    # build the package at <project_root>/src/cmd/gui with vendor directory <project_root>/src/vendor
    # output to <project_root>/bin
    gouicrossbuild -s src -p src/cmd/gui -o bin
EOM

while getopts "s:p:o:h" FLAG
do	case "$FLAG" in
	s) # Remove when https://github.com/andlabs/ui/issues/230 fixed
        SRC_DIR="$OPTARG"
        ;;
	p)
        PACKAGE_DIR="$OPTARG"
        ;;
	o)
        OUTPUT_DIR="$OPTARG"
        ;;
    h)
        echo "$USAGE"
        exit 0
        ;;
	[?])
        printf >&2 "Error: Invalid Flag\n\n$USAGE"
        exit 2
        ;;
	esac
done
shift $((OPTIND -1))

# Copy locally compiled libui to avoid linking error
# Remove when https://github.com/andlabs/ui/issues/230 fixed
UI_VENDOR_DIR=$SRC_DIR/vendor/github.com/andlabs/ui
if [[ ! -d $UI_VENDOR_DIR ]]; then
    printf >&2 "'$UI_VENDOR_DIR' expected but not found (relative to project root)"
    exit 1
fi
cp /tmp/libui_linux_amd64.a "$UI_VENDOR_DIR"
# End of section to remove

export GOARCH=amd64
export CGO_ENABLED=1
echo "Building linux binary"
GOOS=linux \
CC=clang CXX=clang++ \
go build -o $OUTPUT_DIR/linux ${PACKAGE_DIR} $*

echo "Building windows binary"
GOOS=windows \
CC=x86_64-w64-mingw32-gcc CXX=x86_64-w64-mingw32-g++ \
go build -o $OUTPUT_DIR/windows.exe -ldflags "-H=windowsgui -extldflags=-s" ${PACKAGE_DIR} $*

echo "Building darwin binary"
GOOS=darwin \
CGO_LDFLAGS_ALLOW="-mmacosx-version-min.*" CC=o64-clang CXX=o64-clang++ \
go build -o $OUTPUT_DIR/darwin.app ${PACKAGE_DIR} $*
