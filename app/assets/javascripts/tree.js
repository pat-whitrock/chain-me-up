
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
  console.log(nodes);
  var links = tree.links(nodes);
  console.log(links);
 

  var diagonal = d3.svg.diagonal()
    .projection(function (d) {
      return [d.x, d.y];
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
        return "translate(" + d.x + "," + d.y + ")";
      })

  
      

  node.append("circle")
    .attr("r", 5)
    .attr("fill", "#ccc");

  node.append("text")
    .text(function(d) {
      return d.content;
    });    


}




