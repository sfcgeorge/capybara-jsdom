// (function(program, execJS) { execJS(program) })(
//   function(global, process, module, exports, require, console, setTimeout, setInterval, clearTimeout, clearInterval, setImmediate, clearImmediate) {
//     THESOURCEHERE
//   }, function(program) {
//     var output, print = function(string) {
//       process.stdout.write('' + string);
//     };
//     try {
//       var __process__ = process;
//       delete this.process;
//       result = program();
//       this.process = __process__;
//       if (typeof result == 'undefined' && result !== null) {
//         print('["ok"]');
//       } else {
//         try {
//           print(JSON.stringify(['ok', result]));
//         } catch (err) {
//           print(JSON.stringify(['err', '' + err, err.stack]));
//         }
//       }
//     } catch (err) {
//       this.process = __process__;
//       print(JSON.stringify(['err', '' + err, err.stack]));
//     }
//   }
// );


var output, print = function(string) {
  process.stdout.write('' + string);
};

var program = function() {
  #{source}
}

try {
  var __process__ = process;
  delete this.process;
  result = program();
  this.process = __process__;
  if (typeof result == 'undefined' && result !== null) {
    print('["ok"]');
  } else {
    try {
      print(JSON.stringify(['ok', result]));
    } catch (err) {
      print(JSON.stringify(['err', '' + err, err.stack]));
    }
  }
} catch (err) {
  this.process = __process__;
  print(JSON.stringify(['err', '' + err, err.stack]));
}
