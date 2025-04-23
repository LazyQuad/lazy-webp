#!/bin/bash

# lazy-webp - Advanced Bash version v1.3.1
# Author: LazyQuad - https://github.com/LazyQuad

VERSION="1.3.1"

MODE=""
BASE=""
QUALITY=80
OUT_DIR=""
INPUT_DIR="."
DELETE_ORIGINALS=false
KEEP_META=false
SEO_NAMES=true
TAG_DIMENSIONS=false
NO_OVERWRITE=false
QUIET=false
EXTENSIONS="jpg,jpeg,png"
BASE_FROM_DIR=false

# Handle --version and --help
if [[ "$1" == "--version" ]]; then
    echo "lazy-webp version $VERSION"
    exit 0
elif [[ "$1" == "--help" ]]; then
    echo "lazy-webp $VERSION - Batch convert images to SEO-optimized WebP"
    echo "Usage: ./advanced-convert.sh [options]"
    echo "--mode [batch|manual]           Set conversion mode"
    echo "--base [name]                   Set base name for batch output"
    echo "--base-from-dir                 Use current directory name as base"
    echo "--input [folder]                Set input folder"
    echo "--out [folder]                  Set output folder"
    echo "--quality [0-100]               Set quality (default 80)"
    echo "--keep-meta                     Preserve metadata (default is stripped)"
    echo "--tag-dimensions                Append WxH to filenames"
    echo "--delete-originals              Delete source files after conversion"
    echo "--no-overwrite                  Skip existing files"
    echo "--ext [list]                    File extensions (default jpg,jpeg,png)"
    echo "--quiet                         Suppress output except errors"
    echo "--version                       Show version"
    echo "--help                          Show help"
    exit 0
fi

# Ensure cwebp is available and native (not .exe)
if ! command -v cwebp &> /dev/null; then
    echo "[!] cwebp not found on your system."
    read -p "Would you like to install it now using apt? (y/n): " install
    if [[ "$install" == "y" ]]; then
        sudo apt update && sudo apt install webp
    else
        echo "Aborted. Please install the 'webp' package manually."
        exit 1
    fi
fi

CWEBP=$(command -v cwebp)

while [[ $# -gt 0 ]]; do
    case $1 in
        --mode) MODE="$2"; shift ;;
        --base) BASE="$2"; shift ;;
        --base-from-dir) BASE_FROM_DIR=true ;;
        --quality) QUALITY="$2"; shift ;;
        --input) INPUT_DIR="$2"; shift ;;
        --out) OUT_DIR="$2"; shift ;;
        --delete-originals) DELETE_ORIGINALS=true ;;
        --keep-meta) KEEP_META=true ;;
        --tag-dimensions) TAG_DIMENSIONS=true ;;
        --no-overwrite) NO_OVERWRITE=true ;;
        --quiet) QUIET=true ;;
        --ext) EXTENSIONS="$2"; shift ;;
        *) echo "[!] Unknown option: $1"; exit 1 ;;
    esac
    shift
done

if ! [[ "$QUALITY" =~ ^[0-9]+$ ]] || ((QUALITY < 0 || QUALITY > 100)); then
    echo "[!] Invalid quality value. Must be a number between 0 and 100."
    exit 1
fi

if $TAG_DIMENSIONS && ! command -v identify &> /dev/null; then
    echo "[!] 'identify' (ImageMagick) not found. Dimension tagging will be disabled."
    echo "    Install it using: sudo apt install imagemagick"
    TAG_DIMENSIONS=false
fi

if $BASE_FROM_DIR; then
    MODE="batch"
    BASE=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
    existing_files=("$OUT_DIR/${BASE}-"*.webp)
    highest=0
    for f in "${existing_files[@]}"; do
        num=$(basename "$f" | sed -n "s/^${BASE}-\([0-9]\+\)\.webp$/\1/p")
        [[ "$num" =~ ^[0-9]+$ && "$num" -gt "$highest" ]] && highest=$num
    done
    COUNT_START=$((highest + 1))
else
    COUNT_START=1
fi

seo_sanitize() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g'
}

get_dimensions() {
    identify -format "%wx%h" "$1" 2>/dev/null
}

convert_image() {
    input="$1"
    output="$2"
    if $NO_OVERWRITE && [[ -e "$output" ]]; then
        $QUIET || echo "Skipping (exists): $output"
        return
    fi
    $QUIET || echo "Converting: $input -> $output"
    if $KEEP_META; then
        "$CWEBP" -q "$QUALITY" "$input" -o "$output"
    else
        "$CWEBP" -q "$QUALITY" -metadata none "$input" -o "$output"
    fi
    $DELETE_ORIGINALS && rm -f "$input"
}

run_conversion() {
    mkdir -p "$OUT_DIR"
    $QUIET || echo "Output directory: $OUT_DIR"
    IFS=',' read -ra EXT_ARR <<< "$EXTENSIONS"
    shopt -s nullglob
    files=()
    for ext in "${EXT_ARR[@]}"; do
        files+=( "$INPUT_DIR"/*."$ext" "$INPUT_DIR"/*."${ext^^}" )
    done
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "[!] No matching image files found in $INPUT_DIR"
        exit 1
    fi

    count=$COUNT_START

    $QUIET || {
        echo
        echo "=================================="
        echo "Starting Conversion - Settings:"
        echo "Input: $INPUT_DIR"
        echo "Output: $OUT_DIR"
        echo "Quality: $QUALITY"
        echo "Base name: $BASE"
        echo "Mode: $MODE"
        echo "Overwrite: $([[ $NO_OVERWRITE == true ]] && echo no || echo yes)"
        echo "Delete originals: $([[ $DELETE_ORIGINALS == true ]] && echo yes || echo no)"
        echo "Keep metadata: $([[ $KEEP_META == true ]] && echo yes || echo no)"
        echo "Tag dimensions: $([[ $TAG_DIMENSIONS == true ]] && echo yes || echo no)"
        echo "=================================="
    }

    if [[ "$MODE" == "batch" && -n "$BASE" ]]; then
        $SEO_NAMES && BASE=$(seo_sanitize "$BASE")
        for file in "${files[@]}"; do
            name="$BASE-$count"
            if $TAG_DIMENSIONS; then
                dims=$(get_dimensions "$file")
                [[ -n "$dims" ]] && name="${name}-${dims}"
            fi
            output="$OUT_DIR/${name}.webp"
            convert_image "$file" "$output"
            ((count++))
        done
    elif [[ "$MODE" == "manual" ]]; then
        for file in "${files[@]}"; do
            echo "File: $file"
            read -p "Enter name (no extension, or type QUIT to exit): " newname
            [[ "$newname" == "QUIT" ]] && break
            $SEO_NAMES && newname=$(seo_sanitize "$newname")
            output="$OUT_DIR/${newname}.webp"
            convert_image "$file" "$output"
        done
    else
        echo "[!] Invalid mode or missing base name for batch mode."
        exit 1
    fi

    $QUIET || {
        echo
        echo "Conversion complete. Total processed: $((count - COUNT_START))"
        echo "Output directory: $OUT_DIR"
    }
}

# Wizard mode if no mode supplied
if [[ -z "$MODE" ]]; then
    clear
    echo "lazy-webp - Interactive Mode"
    echo "Choose mode:"
    echo "1) Batch rename (base name + number)"
    echo "2) Manual rename (prompt for each)"
    echo "3) Use directory name as base (auto-numbered)"
    read -p "Choice [1/2/3]: " opt

    read -p "Input directory (default .): " i
    [[ -n "$i" ]] && INPUT_DIR="$i"
    echo "Input directory set to: $INPUT_DIR"

    read -p "Output directory (default same as input): " o
    if [[ -n "$o" ]]; then
        OUT_DIR="$o"
    else
        OUT_DIR="$INPUT_DIR"
    fi
    echo "Output directory set to: $OUT_DIR"

    read -p "Quality (default 80): " q
    [[ -n "$q" ]] && QUALITY="$q"

    read -p "Extensions (default: jpg,jpeg,png): " e
    [[ -n "$e" ]] && EXTENSIONS="$e"

    read -p "Keep metadata? (y/n, default n): " meta
    [[ "$meta" == "y" ]] && KEEP_META=true

    read -p "Tag dimensions in filenames? (y/n, default n): " tag
    [[ "$tag" == "y" ]] && TAG_DIMENSIONS=true

    read -p "Delete originals? (y/n, default n): " del
    [[ "$del" == "y" ]] && DELETE_ORIGINALS=true

    read -p "Prevent overwriting existing files? (y/n, default n): " nowrite
    [[ "$nowrite" == "y" ]] && NO_OVERWRITE=true

    if [[ "$opt" == "1" ]]; then
        MODE="batch"
        read -p "Base name: " BASE
    elif [[ "$opt" == "3" ]]; then
        BASE_FROM_DIR=true
        MODE="batch"
        BASE=$(basename "$PWD" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
    else
        MODE="manual"
    fi
fi

run_conversion
