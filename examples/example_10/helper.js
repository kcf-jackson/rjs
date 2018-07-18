// This file contains a few functions that mimic the corresponding R functions 

// This function returns a sequence.
function seq(from, to, by, length_out) {
  if (by && length_out) {
    throw "Too many arguments. You can only specify one of the third and the fourth argument.";
  }
  var res = [];
  if (!from) {
    from = 1;
  }
  if (!to) {
    to = from;
    from = 1;
  }
  if (!by) {
    by = 1;
  }
  if (length_out) {
    by = (to - from) / (length_out - 1);
  }
  for (var i = from; i - to <= 1e-8; i = i + by) {
    res.push(i);
  }
  return res;
}


// This function returns an array of length n containing the number n.
function rep(x, n) {
  var res = [];
  for (var i = 0; i < n; i++) {
    res.push(x);
  }
  return res;
}


// This function transposes a list, e.g.
//   input: list(x:[1,2,3], y:[4,5,6]}
//   output: [{x:1, y:4}, {x:2, y:5}, {x:3, y:6}]
// To use D3, data should be in the format like output.
function list_transpose(data0) {
  // transpose
  var res = [];
  var obj_keys = Object.keys(data0);
  data_len = data0[obj_keys[0]].length;
  key_len = obj_keys.length;
  for (var j = 0; j < data_len; j++) {
    datum = {};
    for (var i = 0; i < key_len; i++) {
      var k = obj_keys[i];
      datum[k] = data0[k][j];
    }  
    res.push(datum);
  }
  return res;
}
