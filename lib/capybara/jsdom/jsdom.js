// require('jsdom-global')('<!DOCTYPE html><p>Hello world</p>');
// var global = global || this;
// var self = self || this;
// window = global;
// var console = require("console-browserify");
// console = global.console;
// const jsdom = require("jsdom");
// const jsdom = require("jsdom");
// const { JSDOM } = jsdom;
const jsdom = require("/Users/sfcgeorge/Documents/Projects/Coding/Ruby/capybara-jsdom/capybara-jsdom/node_modules/jsdom");
const { JSDOM } = jsdom;
const cookieJar = new jsdom.CookieJar();
// const h = require("/Users/sfcgeorge/Documents/Projects/Coding/Ruby/capybara-jsdom/capybara-jsdom/src/helpers");
// JSDOM = require("/Users/sfcgeorge/Documents/Projects/Coding/Ruby/capybara-jsdom/capybara-jsdom/node_modules/jsdom");
// dom = new JSDOM('<!DOCTYPE html><p>Hello there</p>');
// dom.window.document.querySelector('p').textContent;
// console.log(dom.window.document.querySelector('p').textContent);
// document.body.innerHTML = '<!DOCTYPE html><p>Hello world</p>';
// document.querySelector('p').textContent;

jsdomWaiting = true;
dom = null;
document = null;
XMLHttpRequest = null;

jsdomDone = function(d) {
  jsdomWaiting = false;
  dom = d
  document = dom.window.document;
  XMLHttpRequest = dom.window.XMLHttpRequest;
  return dom;
};

var nodes = [];

cacheNode = function(node) {
  nodes.push(node);
  return nodes.length - 1;
}

getNode = function(idx) {
  return nodes[idx];
}

getNodes = function() {
  return nodes;
}
