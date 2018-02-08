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

// https://stackoverflow.com/a/2631931/2311847
getPathTo = function(element) {
  if (element.id !== '') return 'id("'+element.id+'")';
  if (element === document.body) return element.tagName;

  var ix = 0;
  var siblings = element.parentNode.childNodes;
  for (var i = 0; i < siblings.length; i++) {
    var sibling = siblings[i];
    if (sibling === element)
      return getPathTo(element.parentNode)+'/'+element.tagName+'['+(ix+1)+']';
    if (sibling.nodeType === 1 && sibling.tagName === element.tagName) ix++;
  }
};
