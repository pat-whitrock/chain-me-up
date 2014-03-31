$(document).ready(function () {
  
  var tree = d3.layout.tree()
    .size([500,800])
    .children(function(d) {
      return d.child_trees
    }); 

  var link = window.location + ".json"

  d3.json(link, function(data) {
    drawTree(tree, data); 
  });

  var svg = d3.select("body")
    .append("svg")

});

function key(d) {
  return d._id.$oid;
}

function linkKey(d) {
  return d.target._id.$oid;
}


function drawTree(tree, data) {

  var svg = d3.select("svg");
  
  var nodes = tree.nodes(data);
  var links = tree.links(nodes);


  var diagonal = d3.svg.diagonal()
    .projection(function (d) {
      return [d.y, d.x];
  });  

  var link = svg.selectAll(".link")
    .data(links, linkKey);



  link  
    .transition()
    .duration(1000)
    .each("start", function() {      // <-- Executes at start of transition
       d3.select(this)
        .style('opacity', 0)
    })
    .attr("d", diagonal)
    .each("end", function() {      // <-- Executes at start of transition
       d3.select(this)
        .style('opacity', 1)
    });


  link
    .exit()
    .attr("d", diagonal)
    .remove();  


  link
    .enter()
    .append("path")
    .attr("class", "link")
    .attr("fill", "none")
    .attr("stroke", "gray")
    .attr("d", diagonal);


  var node = svg.selectAll(".node")
    .data(nodes, key);

  node    
    .enter()
    .append("g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return "translate(" + d.y + "," + d.x + ")";
  });

  node
    .exit()
    .attr("transform", function(d) {
        return "translate(" + d.y + "," + d.x + ")"})
    .remove();


  node 
    .transition()
    .duration(1000)
    .attr("transform", function(d) {
        return "translate(" + d.y + "," + d.x + ")"})
    .attr("class", "node");

  node.on("click", function(d){
    drawTree(tree, d)
  })  

  node.on("mouseover", function(d){
    console.log(d)
  })  

  node.append("circle")
    .attr("r", 5)
    .attr("fill", "#ccc");
}



