library(rjs)
create_html() %>% 
  add_js_library('d3') %>% 
  add_script(into = "body", 
"
var data0 = {x: [], y:[]};
var w = 600;
var h = 400;
var svg = d3.select('body').append('svg')
  .attr('width', w)
  .attr('height', h)
  .on('click', click);

var img = d3.select('svg').append('image')
  .attr('width', w)
  .attr('height', h)
  .attr('xlink:href', 'dev/track2.svg');

function click() {
  var point = d3.mouse(this), p = {x: point[0], y: point[1]};
  data0.x.push(p.x);
  data0.y.push(p.y);
  console.log(data0);

  svg.append('circle')
       .attr('transform', 'translate(' + p.x + ',' + p.y + ')')
       .attr('r', '2')
       .attr('class', 'dot')
       .style('cursor', 'pointer')
       .call(drag);
}
var drag = d3.drag()
             .on('drag', dragmove);

function dragmove(d) {
  var x = d3.event.x, y = d3.event.y;
  d3.select(this).attr('transform', 'translate(' + x + ',' + y + ')');
}
") %>% 
  start_app(assets_folder = '.')
