function Tree(data) {

  this.data = data;
  this.masterData = data;
  this.tree = d3.layout.tree()
    .size([500,800])
    .children(function(d) {
        return d.child_trees
    }); 

  d3.select("body").append("svg"); 
  this.svg = d3.select("svg");
}

Tree.prototype.nodeKey = function(d) {
  return d._id.$oid;
}

Tree.prototype.linkKey = function(d) {
  return d.target._id.$oid;
}

Tree.prototype.draw = function(data) {

  this.nodes = this.tree.nodes(data);
  this.links = this.tree.links(this.nodes);

  this.diagonal = d3.svg.diagonal()
    .projection(function (d) {
      return [d.y, d.x];
  });  

  this.transitionLinks();
  this.transitionNodes();
}

Tree.prototype.transitionLinks = function() {

  var link = this.svg.selectAll(".link")
    .data(this.links, this.linkKey);

  link  
    .transition()
    .duration(1000)
    .each("start", function() {  
       d3.select(this)
        .style('opacity', 0)
    })
    .attr("d", this.diagonal)
    .each("end", function() {  
       d3.select(this)
        .style('opacity', 1)
    });

  link
    .exit()
    .attr("d", this.diagonal)
    .remove();  

  link
    .enter()
    .append("path")
    .attr("class", "link")
    .attr("fill", "none")
    .attr("stroke", "gray")
    .attr("d", this.diagonal);  
}

Tree.prototype.transitionNodes = function() {

  var node = this.svg.selectAll(".node")
    .data(this.nodes, this.nodeKey);

  var self = this;  
  node    
    .enter()
    .append("g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return self.xTranslation(d);
      });

  node
    .exit()
    .attr("transform", function(d) {
        return self.xTranslation(d);
      })
    .remove();

  node 
    .transition()
    .duration(1000)
    .attr("transform", function(d) {
        return self.xTranslation(d);
      })
    .attr("class", "node");
 
  var tree = this;
  node.on("click", function(d) {
    tree.data = d
    tree.draw(d);
  });  

  node.on("mouseover", function(d){
    console.log(d);
  })  

  node.append("circle")
    .attr("r", 5)
    .attr("fill", "#ccc");

}

Tree.prototype.xTranslation = function(d) {
  
  if(this.isRoot()) {
   console.log("This is root");
   return "translate(" + d.y + "," + d.x + ")"; 
  } else {
    console.log("This is not root");
   return "translate(" + (50 + d.y) + "," + d.x + ")"; 
  }
}

Tree.prototype.isRoot = function() {
  if(this.data.parent === undefined) {
    return true;
  } else {
    return false;
  }
}

Tree.prototype.traverseUp = function() {
  this.draw(this.data.parent);
  this.data = this.data.parent;
}


Tree.prototype.reset = function() {
  this.draw(this.masterData);
}


$(document).ready(function () {
  
  var link = window.location + ".json"

  d3.json(link, function(data) {
    tree = new Tree(data);
    tree.draw(data); 
  });

});