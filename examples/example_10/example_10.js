var n = 11;
var data0 = list_transpose({x: rep(315, n), y: rep(115, n)});
var s_x = 30;
var s_y = 14; 
var max_time = 31293, max_len = 8751;
var animation_speed = 20;  // delay (in ms) between update.
var i = 1;
var play = false;
var oneoff = false;

// Data
var table0 = list_transpose({
  labels: ['100%', '90%', '80%', '70%', '60%', '50%', '40%', '30%', '20%', '10%', '0%'],
  time: ['02:03:03', '03:16:22', '03:33:11', '03:46:07', '03:56:42', 
          '04:07:14', '04:19:32', '04:33:24', '04:50:44', '05:16:27', '08:41:33'],
  x: rep(55, n),
  y: seq(30, 30 + s_y * (n-1), s_y)
});
var text_data = list_transpose({
  loc: ["victory column", "Ernst-Reuter-Platz", "MOABIT", "PRENZLAUER BERG",
    "Television tower", "Kottbusser Tor", "KREUZBERG", "Hasenheide",
    "SCHONEBERG", "Rathaus Schoneberg", "Place at the wild boar", 
    "Fehrbelliner Platz", "Kurfurstendamm", "CLARLOTTENBURG", "Potsdamer Platz", 
    "Brandenburg Gate"],
  x: [285, 180, 287, 497, 467, 522, 442, 481,
          328, 194, 85, 171, 200, 166, 363, 355],
  y: [136, 142, 47, 38, 91, 209, 230, 292, 
          295, 283, 352, 259, 200, 159, 163, 132]
});

var svg = d3.select('svg');
svg.append("g").attr("id", "label_text");
svg.append("g").attr("id", "time_text");
svg.append("g").attr("id", "map_text");

svg.select("#label_text")
   .selectAll('text').data(table0).enter().append('text')
   .attr('x', d => d.x)
   .attr('y', d => d.y)
   .text(d => d.labels)
   .attr("font-family", "sans-serif")
   .attr("font-size", "9px")
   .attr("fill", "#ff5d00");
   
svg.select("#time_text")
   .selectAll('text').data(table0).enter().append('text')
   .attr('x', d => d.x + s_x)
   .attr('y', d => d.y)
   .text(d => d.time)
   .attr("font-family", "sans-serif")
   .attr("font-size", "9px")
   .attr("fill", "#ff5d00");
   
svg.select("#map_text")
   .selectAll('text').data(text_data).enter().append('text')
   .attr('x', d => d.x)
   .attr('y', d => d.y)
   .text(d => d.loc)
   .attr("font-family", "sans-serif")
   .attr("font-size", "6px")
   .attr("fill", "#777");

var circles = svg.selectAll('circle')
   .data(data0)
   .enter()
   .append('circle')
   .attr('transform', function(d,i) {
     return 'translate(' + d.x + ',' + d.y + ')';
    })
   .attr('r', '3')
   .attr('class', 'dot')
   .style('cursor', 'pointer');

ws.onopen = function() { 
  ws.send(JSON.stringify({i: i}));
};

ws.onmessage = function(msg) {
  if (oneoff || play) {
    data0 = list_transpose(JSON.parse(msg.data));
    map_update();
    
    i = i + 1;
    document.getElementById("slider_1").value = i;
    slider_update();
    label_update(i);
    oneoff = false;
    
    setTimeout(function() {
      ws.send(JSON.stringify({i: i}));
    }, animation_speed);  
  } 
};

map_update = function() {
  circles.data(data0)
    .attr('transform', d => 'translate(' + d.x + ',' + d.y + ')');
};

slider_update = function() {
  i = parseInt(document.getElementById("slider_1").value);
  if (play === false) {
    oneoff = true;
    ws.send(JSON.stringify({i: i}));
  }
};

label_update = function(k) {
  var time_passed = k * (max_time / max_len) + 1;
  document.getElementById("label_time").innerText = convert_to_time(time_passed);
};

button_toggle = function() {
  if (play === false) {
    play = true;
    document.getElementById("play_pause").innerText = "Pause";
    ws.send(JSON.stringify({i: i}));
  } else {
    document.getElementById("play_pause").innerText = "Play";
    play = false;
  }
};

set_x = function() { animation_speed = 20; };
set_half_x = function() { animation_speed *= 2; };
set_double_x = function() { animation_speed /= 2; };

// Helpers
convert_to_time = function(x) {
  var h = Math.floor(x / 3600);
  var m = Math.floor((x % 3600) / 60);
  var s = Math.floor(x % 60);
  return pad_zero(h) + ":" + pad_zero(m) + ":" + pad_zero(s);
};

pad_zero = function(x) {
  return (x >= 10) ? x.toString() : ("0" + x);
};
