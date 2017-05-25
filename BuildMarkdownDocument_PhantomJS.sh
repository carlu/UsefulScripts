#! /bin/bash

# BuildMarkdownDocument.sh
# Carl Unsworth, University of Liverpool
# August 2016
# -----------------------------------------------------------------------------
# Short bash script to build pdf and html documents from Markdown Source
# Use: BuildMarkdownDocument.sh Markdownfile [CssFile]
#   - Uses Pandoc to compile HTML from Markdown
#   - Uses PhantomJS to build PDF from HTML if available
#   - If PhantomJS not available then uses Pandoc for PDF also (no CSS)
#   - If using PhantomJS then PhantomJS_SavePDF.js should also be available.
#   - Original contents of PhantomJS_SavePDF.js included at bottom of this file

# Set location for PhantomJS binary
PHANTOMJSDIR=/Users/cu/Packages/phantomjs/bin
PHANTOMJSSCRIPT=/Users/cu/Code/UsefulScripts/PhantomJS_SavePDF.js

# Check arguments and establish various filenames
if [ $# -eq 1 ]
then
  FULLFILENAME=$(basename "$1")
  EXTENSION="${FULLFILENAME##*.}"
  FILENAME="${FULLFILENAME%.*}"
  CSSFILE="$FILENAME.css"
elif [ $# -eq 2 ]
then
  FULLFILENAME=$(basename "$1")
  FILENAME="${FULLFILENAME%.*}"
  CSSFILE=$(basename "$2")
else
  echo "Requires one or two arguments (Either Markdown file, or Markdown file and CSS file)!"
  echo "If no CSS file specified will try to find one with same name as Markdown file but .css extension."
  echo "Will look for headless browser at $PHANTOMJSDIR.  If not found then PDF will not be formatted."
  exit 0
fi

# Check source file exists...
if [ -f $FULLFILENAME ]
then
  echo "Markdown file = $FULLFILENAME"
else
  echo "Source file not found ($FULLFILENAME)"
  exit 0
fi

# Check CSS file exists...
if [ -f $CSSFILE ]
then
  echo "CSS file = $CSSFILE"
  USECSS=1
else
  echo "CSS file not found ($CSSFILE), building without CSS..."
  USECSS=0
fi

# Create Html from markdown (and CSS if available...)
if [ $USECSS -eq 1 ]
then
  pandoc -s -S -c "$CSSFILE" --toc "$FULLFILENAME" -o "$FILENAME.html"
else
  pandoc -s -S --toc "$FULLFILENAME" -o "$FILENAME.html"
fi

# If phatomjs available compile pdf with css, else compile plain pdf with pandoc
if [ -x $PHANTOMJSDIR/phantomjs ];
then
  $PHANTOMJSDIR/phantomjs $PHANTOMJSSCRIPT $FILENAME
else
  echo "PhantomJS not found - CSS will be ignored for pdf output..."
  pandoc -V geometry:margin=2cm --toc -o "$FILENAME.pdf" "$FULLFILENAME"
fi

exit 0

# Original contents of SavePDF.js:

# var system = require('system');
# var args = system.args;
#
# if (args.length != 2) {
#   console.log('Pass html filename as only argument (no extension).');
# } else {
#   var page = require('webpage').create();
#   page.open(args[1]+'.html', function() {
#     page.render(args[1] + '.pdf');
#     phantom.exit();
#   });
# }
