#! /bin/bash
# check markdown output
pandoc -f markdown -t html -o README.html README.md
