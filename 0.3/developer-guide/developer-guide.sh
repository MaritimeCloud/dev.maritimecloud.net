#!/bin/bash

if [ "$1" = "pdf" ]; then
   cd adoc
   asciidoctor-pdf -r asciidoctor-diagram developer-guide.adoc -D ../target
   cd ..
   exit
elif [ "$1" = "html" ]; then
   asciidoctor -r asciidoctor-diagram adoc/developer-guide.adoc -D target
   exit
elif [ "$1" = "site" ]; then
   echo "Checking for changes to the faq"
   git status
   if ! git diff-index --quiet HEAD --; then
     echo "There are uncommitted changes to the development guide"
     exit 1
   fi
   asciidoctor -r asciidoctor-diagram adoc/developer-guide.adoc -D target
   cp images/*.png target/images
   cp images/*.svg target/images
   git checkout gh-pages
   cp target/developer-guide.html ../../devguide/index.html
   cp target/images/* ../../images/
   git add ../../devguide/index.html
   git add ../../images/*
   git commit -m "update faq"
   git push
   git checkout master
   exit   
elif [ -z "$1" ]; then 
	echo Usage: $0 target
	echo where target is:
else
	echo Unknown target: "$1"
	echo Valid targets are:
fi

echo "  pdf        Generates documentation in pdf"
echo "  html       Generates documentation in html"

