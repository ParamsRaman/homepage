#!/bin/sh

jekyll build
jekyll serve
#rsync -vaz _site/ praman1@unix.ic.ucsc.edu:public_html
