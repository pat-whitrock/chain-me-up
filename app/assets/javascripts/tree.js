
// $.getJSON( link, function( data ) {
//   drawTree(data);
// });


$(function () {
  

  var tree = d3.layout.tree()
    .size([600,600])
    .children(function(d) {
      return d.child_trees
    }); 

  var link = window.location + ".json"
  d3.json(link, function(data) {
    drawTree(tree, data); 
  });
 

});


function drawTree(tree, data) {

  var svg = d3.select("body")
    .append("svg")

  var nodes = tree.nodes(data);
  var links = tree.links(nodes);
  
 

  var diagonal = d3.svg.diagonal()
    .projection(function (d) {
      return [d.y, d.x];
    });  

  svg.selectAll(".link")
    .data(links)
    .enter()
    .append("path")
    .attr("class", "link")
    .attr("fill", "none")
    .attr("stroke", "gray")
    .attr("d", diagonal);

  var node = svg.selectAll(".node")
    .data(nodes)
    .enter()
    .append("g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return "translate(" + d.y + "," + d.x + ")";
      })

  node.append("circle")
    .attr("r", 5)
    .attr("fill", "#ccc");  


}



// function Tree(dataset) {
//   this.h = 400;
//   this.w = 600;
//   this.counter = 0;
//   this.dataset = dataset;
//   this.currentNode = dataset[0];
//   this.svg = d3.select(".container")
//     .append("svg")
//     .attr("width", this.w)
//     .attr("height", this.h);
// }; 

// Tree.prototype.drawNode = function(data) {

//   this.svg.selectAll("circle")
//     .data(data)
//     .enter()
//     .append("circle")
//     .attr("cx", function(d, i) {

//       return this.counter;

//     })
//     .attr("cy", 100 + this.counter)
//     .attr("r", 10);
  

// };

// Tree.prototype.getChildren = function(node) {
//   return node.child_trees;
// };

// function setWidth(d, i) {
//   return this.w/2 + (100*i)
// };




