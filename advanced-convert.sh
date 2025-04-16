#!/bin/bash

# ========== lazy-webp: Advanced Bash Script ==========
# by LazyQuad - https://github.com/LazyQuad
# Converts images to WebP with batch/manual mode, CLI flags, and SEO naming.

# -------- Default Config --------
MODE=""
BASE=""
QUALITY=80
OUT_DIR="."
DELETE_ORIGINALS=false
STRIP_META=false
EXTENSIONS="jpg,jpeg,png"

# -------- Detect cwebp --------
if [[ -x "./cwebp/cwebp.exe" ]]; then
    CWEBP="./cwebp/cwebp.exe"
elif command -v cwebp &> /dev/null; then
    CWEBP=$(command -v cwebp)
else
    echo "❌ Error: cwebp not found."
    echo "Download it from https://developers.google.com/speed/webp/download"
    echo "Place it in the ./cwebp/ folder or add to your system PATH."
    exit 1
fi

# -------- Argument Parser --------
while [[ $# -gt 0 ]]; do
    case $1 in
        --mode) MODE="$2"; shift ;;
        --base) BASE="$2"; shift ;;
        --quality) QUALITY="$2"; shift ;;
        --out) OUT_DIR="$2"; shift ;;
        --delete-originals) DELETE_ORIGINALS=true ;;
        --strip-meta) STRIP_META=true ;;
        --ext) EXTENSIONS="$2"; shift ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# -------- Helper Functions --------
convert_image() {
    input="$1"
    output="$2"
    cmd=""$CWEBP" -q $QUALITY"

    $STRIP_META && cmd="$cmd -metadata none"
    cmd="$cmd "$input" -o "$output""

    echo "Running: $cmd"
    eval $cmd

    $DELETE_ORIGINALS && rm -f "$input"
}

# -------- Main CLI/Prompt Logic --------
run_conversion() {
    mkdir -p "$OUT_DIR"
    IFS=',' read -ra EXT_ARR <<< "$EXTENSIONS"

    shopt -s nullglob
    files=()
    for ext in "${EXT_ARR[@]}"; do
        files+=( *."$ext" *."${ext^^}" )
    done

    if [[ "${#files[@]}" -eq 0 ]]; then
        echo "No matching image files found."
        exit 1
    fi

    if [[ "$MODE" == "batch" && -n "$BASE" ]]; then
        count=1
        for file in "${files[@]}"; do
            output="$OUT_DIR/${BASE}-${count}.webp"
            convert_image "$file" "$output"
            ((count++))
        done
    elif [[ "$MODE" == "manual" ]]; then
        for file in "${files[@]}"; do
            echo "File: $file"
            read -p "New name (no extension): " newname
            output="$OUT_DIR/${newname}.webp"
            convert_image "$file" "$output"
        done
    else
        echo "Invalid or missing --base for batch mode, or --mode unspecified."
        exit 1
    fi
}

# -------- If No Args, Run Interactive --------
if [[ -z "$MODE" ]]; then
    echo "🖼️  lazy-webp - Interactive Mode"
    echo "Choose mode:"
    echo "1) Batch rename (base name + number)"
    echo "2) Manual rename (prompt for each)"
    read -p "Choice: " opt

    read -p "Quality (default 80): " q
    [[ -n "$q" ]] && QUALITY="$q"

    read -p "Output directory (default current): " o
    [[ -n "$o" ]] && OUT_DIR="$o"

    read -p "Extensions (default: jpg,jpeg,png): " e
    [[ -n "$e" ]] && EXTENSIONS="$e"

    read -p "Strip metadata? (y/n): " strip
    [[ "$strip" == "y" ]] && STRIP_META=true

    read -p "Delete originals? (y/n): " del
    [[ "$del" == "y" ]] && DELETE_ORIGINALS=true

    if [[ "$opt" == "1" ]]; then
        MODE="batch"
        read -p "Base name: " BASE
    else
        MODE="manual"
    fi
fi

run_conversion
