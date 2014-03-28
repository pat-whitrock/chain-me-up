// $.getJSON( link, function( data ) {
//   drawTree(data);
// });

$(function () {

  var tree = d3.layout.tree()
    .size([400,400])
    .children(function(d) {
      return d.child_trees
    }); 

  var link = window.location + ".json"

  d3.json(link, function(data) {
    drawTree(tree, data); 
    // console.log(data);
  });

  var svg = d3.select("body")
    .append("svg")

});

function drawTree(tree, data) {
  console.log("Draw tree was triggered with")
  console.log(data)

  // d3.selectAll("svg")
  //   .html("")

  var key = function(d){
    return d.depth
  }

  var svg = d3.select("svg")

  var nodes = tree.nodes(data);
  // console.log(nodes);
  var links = tree.links(nodes);
  // console.log(links);
 
  var diagonal = d3.svg.diagonal()
    .projection(function (d) {
      return [d.x, d.y];
    });  

  var link = svg.selectAll(".link")
    .data(links);

  link
    .exit()
    .transition()
    .duration(1000)
    .attr("d", diagonal)
    .remove();


  link
    .enter()
    .append("path")
    .attr("class", "link")
    .attr("fill", "none")
    .attr("stroke", "gray")
    .attr("d", diagonal);


    // d3.json(window.location + ".json", function(error, first_element)
    //   {console.log("function worked");
    //   // console.log(first_element);
    //   // root = first_element;

    //   function collapse(d) {

    //     // if (d.child_trees) {
    //     //   d._child_trees = d.child_trees;
    //     //   d._child_trees.forEach(collapse);
    //     //   d.child_trees = null;
    //     // }
    //     }

    //   // root.child_trees.forEach(collapse);
    //   // console.log(root);
    //   });


// d3.json(nodes, function(error, flare) {
//   root = flare;
//   root.x0 = height / 2;
//   root.y0 = 0;

//   function collapse(d) {
//     if (d.children) {
//       d._children = d.children;
//       d._children.forEach(collapse);
//       d.children = null;
//     }
//   }

//   root.children.forEach(collapse);
//   update(root);
// });

 // var nodeUpdate = node.transition()
 //   .duration('1000') 

  var node = svg.selectAll(".node")
    .data(nodes);

  node
    .exit()
    .transition()
    .duration(1000)
    .attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")"})
    .remove();

  node    
    .enter()
    .append("g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
  });


  node.on("click", function(d){
    drawTree(tree,d)
  })  

  node.on("mouseover", function(d){
    console.log(d)
  })  

  node.append("circle")
    .attr("r", 5)
    .attr("fill", "#ccc");

  // node.append("text")
  //   .text(function(d) {
  //     return d.content;
  //   });    

  // var circles = d3.selectAll("circle")
  // circles.on("click", function(){alert("hello")})

}



