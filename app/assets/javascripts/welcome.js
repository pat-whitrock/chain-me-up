

$("document").ready(function() {


  $("#explore").click(function() {
    $('html,body').animate({
      scrollTop: 700
     }, 1000);
  });

  $("#demo").waypoint({
    handler: function(direction) {
      console.log('aasdfads')
      if(direction === "up") {
        $(".story-panel").removeClass("open");
      } else if(direction === "down") {
        $(".story-panel").addClass("open");
      }
    },
    offset: 700
  });

  // $("#demo").waypoint({
  //   handler: function(direction) {
     
  //   },
  //   triggerOnce: true,
  //   offset: 400
  // });  

 d3.json(window.location + "home.json", function(data) {
        if(data) {
          tree = new Tree(data);
          tree.draw(data); 
        }
      })

if(window.location !== '')

var width = window.width,
    height = window.height - 50;

var tree = d3.layout.tree()
    .size([width - 20, height - 20]);

var root = {},
    nodes = tree(root);

root.parent = root;
root.px = root.x;
root.py = root.y;

var diagonal = d3.svg.diagonal();
  //   .projection(function (d) {
  //     return [d.y, d.x];
  // }); 

// $("body").prepend("<svg>")
var svg = d3.select("svg.home")
    .attr("class", "bg")
    .append("g")
  

var node = svg.selectAll(".node"),
    link = svg.selectAll(".link");

var duration = 1500,
    timer = setInterval(update, duration);


function update() {

function calcSize(depth) {
  var sum = .5
  var i = 2

  while(i < (depth)) {
    sum += Math.pow(.5, i);
    i++;
  }
  return sum
  // this.tree.size([960, 500*sum]);
};

function getDepth(obj) {
    var depth = 0;
    if (obj.children) {
        obj.children.forEach(function (d) {
            
            var tmpDepth = getDepth(d)
            if (tmpDepth > depth) {
                depth = tmpDepth
            }
        })
    }
    return 1 + depth
}
  
  if(nodes){
  var depth = getDepth(nodes[0]);
  }

  var tree = d3.layout.tree()
    .size([1200, 500*calcSize(getDepth(nodes[0]))]);

  if (nodes.length >= 50) return clearInterval(timer);

  // tree.size([])

  // Add a new node to a random parent.
  var n = {id: nodes.length},
      p = nodes[Math.random() * nodes.length | 0];
  if (p.children) p.children.push(n); else p.children = [n];
  nodes.push(n);

  // Recompute the layout and data join.
  node = node.data(tree.nodes(root), function(d) { return d.id; });
  link = link.data(tree.links(nodes), function(d) { return d.source.id + "-" + d.target.id; });

  // Add entering nodes in the parent’s old position.
  node.enter().append("circle")
      .attr("class", "node")
      .attr("r", 4)
      .attr("cx", function(d) { return d.parent.px; })
      .attr("cy", function(d) { return d.parent.py; });

  // Add entering links in the parent’s old position.
  link.enter().insert("path", ".node")
      .attr("class", "link")
      .attr("d", function(d) {
        var o = {x: d.source.px, y: d.source.py};
        return diagonal({source: o, target: o});
      });

  //Recalculate the tree depth

  // Transition nodes and links to their new positions.
  var t = svg.transition()
      .duration(duration);

  t.selectAll(".link")
      .attr("d", diagonal);

  t.selectAll(".node")
      .attr("cx", function(d) { return d.px = d.x; })
      .attr("cy", function(d) { return d.py = d.y; });
}
      
 
});


   

