#! /bin/bash

# BuildMarkdownDocument_ChromeHeadless.sh
# Carl Unsworth, University of Liverpool
# May 2017
# Requires Pandoc and optionally Google Chrome v59+ if formatted PDF output is desired
# -----------------------------------------------------------------------------
# Short bash script to build pdf and html documents from Markdown Source
# Usage: BuildMarkdownDocument)ChromeHeadless.sh Markdownfile [CssFile]
#   - Uses Pandoc to compile HTML from Markdown
#   - Uses Google Chrome (headless mode, v59+) to build pdf from html if available
#   - If Google Chrome not available then uses pandoc for pdf also (no CSS)

# Set path for Google Chrome binary
CHROMEPATH="/Applications/Google Chrome Canary.app/Contents/MacOS/Google Chrome Canary"

#"$CHROMEPATH" --version  # Should be v59+ for headless mode to work

# If 1 argument passed in
if [ $# -eq 1 ]
then
  FULLFILENAME=$(basename "$1")
  EXTENSION="${FULLFILENAME##*.}"
  FILENAME="${FULLFILENAME%.*}"
  CSSFILE="$FILENAME.css"
# If two arguments
elif [ $# -eq 2 ]
then
  FULLFILENAME=$(basename "$1")
  FILENAME="${FULLFILENAME%.*}"
  CSSFILE=$(basename "$2")
# Otherwise print usage information
else
  echo "Requires one or two arguments (Either Markdown file, or Markdown file and CSS file)!"
  echo "If no CSS file specified will try to find one with same name as Markdown file but .css extension."
  echo "Will look for headless browser at $CHROMEPATH.  If not found then PDF will not be formatted."
  exit 1
fi

# Check source file exists...
if [ -f $FULLFILENAME ]
then
  echo "Markdown file = $FULLFILENAME"
else
  echo "Source file not found ($FULLFILENAME)"
  exit 1
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
  pandoc -s -S -c "$PWD/$CSSFILE" --toc "$FULLFILENAME" -o "$FILENAME.html"
else
  pandoc -s -S --toc "$FULLFILENAME" -o "$FILENAME.html"
fi

# If Chrome available compile pdf with css, else compile plain pdf with pandoc
if [ -x "$CHROMEPATH" ];
then
  #echo "$CHROMEPATH --headless --disable-gpu --print-to-pdf file://./$FULLFILENAME"
  # Need to be careful with handling of spaces in input strings here.
  # "--disable-gpu" will apparently not be required in later versions of Chrome.
  "$CHROMEPATH" --headless --disable-gpu --print-to-pdf file://$PWD/$FILENAME.html
  mv output.pdf $FILENAME.pdf
else
  echo "Chrome not found - CSS will be ignored for PDF output..."
  echo "$FULLFILENAME"
  pandoc -V geometry:margin=2cm --toc -o "$FILENAME.pdf" "$FULLFILENAME"
fi

exit 0
