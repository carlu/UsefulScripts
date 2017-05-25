# Useful Scripts

A place for some short scripts I find useful for day to day computing tasks.  These will mostly be in python or bash but maybe other languages will pop up.  Many scripts exist already but I will add them to the repo as I find time to check them and add comments.  I will try and include credit when I use code cut and pasted from elsewhere (StackOverflow, Project documentation, etc) but I may miss some which I copied long ago.  Mainly for use on Linux and OS X but you might find something that's useful elsewhere.

## Contents

### Markdown Tools

Here are some tools I use for handling markdown documents.

* BuildMarkdownDocument_ChromeHeadless.sh
  * Uses Pandoc and Google Chrome (headless mode) to produce html and pdf from md.
  * Optional inclusion of css file for formatting.  
  * If Chrome is not available will use Pandoc to produce pdf without formatting.
* BuildMarkdownDocument_PhantomJS.sh
  * Uses Pandoc and PhantomJS to produce html and pdf from md.
  * Optional inclusion of css file for formatting.  
  * If PhantomJS is not available will use Pandoc to produce pdf without formatting.
* PhantomJS_SavePDF.js
  * Short script copied from PhantomJS documentation to build pdf from html and css.
