var system = require('system');
var page   = require('webpage').create();

var args   = system.args;
var host   = args[1]; // The domain to request, for example: https://toolkit.afscme.org
var docId  = args[2]; // The ID of the document to generate
var userId = args[3]; // The ID of the user who initiated the request
var type   = args[4]; // The type of document to generate ('pdf' or 'png').

var endpoint   = host + '/documents/' + docId + '/preview';
var exportPath = './public/share_graphics/' + docId + '.' + type;

phantom.onError = function(msg, trace) {
  var msgStack = ['PHANTOM ERROR: ' + msg];
  if (trace && trace.length) {
    msgStack.push('TRACE:');
    trace.forEach(function(t) {
      msgStack.push(' -> ' + (t.file || t.sourceURL) + ': ' + t.line + (t.function ? ' (in function ' + t.function +')' : ''));
    });
  }
  console.log(msgStack.join('\n'));
  phantom.exit();
};

page.customHeaders = {
  "X-TOOLKIT-USERID": userId
};

console.log('Requesting: ' + endpoint);

page.open(endpoint, function(status) {
  console.log("Status: " + status);

  if(status === "success") {
    console.log("Exporting to: " + exportPath);
    page.render(exportPath);
  }

  phanton.exit();
});
