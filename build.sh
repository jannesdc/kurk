#!/bin/sh
# Maakt index.html (dubbelklikbaar, offline) van app.html
cd "$(dirname "$0")"
{
  printf '<!doctype html>\n<html lang="nl">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">\n'
  printf '<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}[hidden]{display:none!important}img{max-width:100%%}</style>\n</head>\n<body>\n'
  cat app.html
  printf '\n</body>\n</html>\n'
} > index.html
