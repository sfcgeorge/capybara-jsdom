// var global = global || this;
// var self = self || this;
// window = global;
const { JSDOM } = jsdom;
const cookieJar = new jsdom.CookieJar();

jsdomWaiting = true;
dom = null;
document = null;
XMLHttpRequest = null;

jsdomDone = function(d) {
  jsdomWaiting = false;
  dom = d;
  document = dom.window.document;
  XMLHttpRequest = dom.window.XMLHttpRequest;
  return dom;
};

var nodes = [];

cacheNode = function(node) {
  nodes.push(node);
  return nodes.length - 1;
};

getNode = function(idx) {
  return nodes[idx];
};

getNodes = function() {
  return nodes;
};
