// Quick Javascript snippet for use with PhantomJS to converting
// html+css to pdf. 

// Carl Unsworth - July 2016 - Copied from PhantomJS example

var system = require('system');
var args = system.args;

if (args.length != 2) {
  console.log('Pass HTML filename as only argument to this script (no extension).');
} else {
  var page = require('webpage').create();
  page.open(args[1]+'.html', function() {
    page.render(args[1] + '.pdf');
    phantom.exit();
  });
}
