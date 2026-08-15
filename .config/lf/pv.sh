#!/bin/sh
# minimal preview script for lf

# extensions in lowercase
FPATH="${1}"
FEXT="${FPATH##*.}"
FEXTL="$(printf "%s" "${FEXT}" | tr '[:upper:]' '[:lower:]')"
# exiftool options
EXIFAV="exiftool -s2 -fast \
    -FileName \
    -FileSize \
    -FileType \
    -MimeType \
    -ImageSize \
    -Artist \
    -Title \
    -Album \
    -DateTimeOriginal \
    -Duration"

# filter preview by extension
case "${FEXTL}" in
    # archives
    bz|bz2|gz|tar|tbz|tbz2|tgz|txz|xz) tar tf "$1";;
    zip) unzip -l "$1";;
    rar) unrar l "$1";;
    7z) 7z l "$1";;
    deb|rpm) als "$1";;
    # documents
    pdf) pdftotext -l 10 -nopgbrk -q "$1" -;;
    odt|ods|odp|ott|sxw) odt2txt "$1";;
    # html
    html|htm|xhtml) w3m -dump "$1";;
    # torrent
    torrent) transmission-show -- "$1";;
    # image
    jpg|jpeg|png|gif|ico|tga|xpm|xbm|tif|tiff|svg|xcf) exiftool \
        -fast -s2 -common "$1";;
    # videos/audios
    ogv|mp4|mov|flv|avi|mpeg|mpg|mkv|webm|m4v|vob|wmv|\
        mp3|aac|flac|m4a|ogg|wav) $EXIFAV "$1";;
    # simply view
    cfg|conf|config|rc) less -R "$1";;
    # iso
    iso|qcow) file -b "$1";;
    # other
    *) highlight \
        --force \
        -O ansi -s pablo \
        "$1" || less -R "$1";;
esac
