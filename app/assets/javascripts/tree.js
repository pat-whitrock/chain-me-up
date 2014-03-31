function Tree(data) {

  this.data = data;
  this.masterData = data;
  this.tree = d3.layout.tree()
    .size([500,650])
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
  this.isRoot() ? this.removeButtons() : this.addButtons();

}

Tree.prototype.transitionLinks = function() {

  var link = this.svg.selectAll(".link")
    .data(this.links, this.linkKey);

  var self = this;  

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
    })
    .attr("d", function(d) {
      if(self.isRoot()) {
        console.log("root!");
        var s = {x: d.source.x, y:  d.source.y }
        var t = {x: d.target.x, y:  d.target.y }
      } else {
        console.log("not root!");
        var s = {x: d.source.x, y:  d.source.y + 75}
        var t = {x: d.target.x, y:  d.target.y + 75}
      }
      return self.diagonal({source: s, target: t})
    })

  link
    .exit()
    .attr("d", this.diagonal)
    .attr("d", function(d) {
      if(self.isRoot()) {
        console.log("root!");
        var s = {x: d.source.x, y:  d.source.y }
        var t = {x: d.target.x, y:  d.target.y }
      } else {
        console.log("not root!");
        var s = {x: d.source.x, y:  d.source.y + 75}
        var t = {x: d.target.x, y:  d.target.y + 75}
      }
      return self.diagonal({source: s, target: t})
    })
    .remove();  

  link
    .enter()
    .append("path")
    .attr("class", "link")
    .attr("fill", "none")
    .attr("stroke", "gray")
    .attr("d", function(d) {
      if(self.isRoot()) {
        console.log("root!");
        var s = {x: d.source.x, y:  d.source.y }
        var t = {x: d.target.x, y:  d.target.y }
      } else {
        console.log("not root!");
        var s = {x: d.source.x, y:  d.source.y + 75}
        var t = {x: d.target.x, y:  d.target.y + 75}
      }
      return self.diagonal({source: s, target: t})
    })
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
    $(".story-panel p").text(self.getHistory(d));
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
   return "translate(" + (75 + d.y) + "," + d.x + ")"; 
  }
};

Tree.prototype.getHistory = function(d) {
  var string = "";
  string += d.content;
  while(d.depth > 0) {
    d = d.parent
    string = d.content + string;
  }
  return string;
}; 

Tree.prototype.addButtons = function(d) {

  var self = this;  

  var traverseUpButton = this.svg.append("circle")
    .attr("cx", this.masterData.y + 50)
    .attr("cy", this.masterData.x)
    .attr("r", 5)
    .attr("fill", "#ccc")
    .attr("class", "controls");

  var resetButton = this.svg.append("circle")
    .attr("cx", this.masterData.y + 25)
    .attr("cy", this.masterData.x)
    .attr("r", 5)
    .attr("fill", "#ccc")
    .attr("class", "controls");

  traverseUpButton.on("click", function(d){
    self.traverseUp();
    })

  resetButton.on("click", function(d){
    self.reset();
    })

};

Tree.prototype.removeButtons = function(d) {
  $(".controls").remove();
}

Tree.prototype.isRoot = function() {
  if(this.data.parent === undefined) {
    return true;
  } else {
    return false;
  }
}

Tree.prototype.traverseUp = function() {
  console.log("This is this" + this);
  // console.log("This is self" + self);
  this.data = this.data.parent;
  this.draw(this.data);
}

Tree.prototype.reset = function() {
  this.data = this.masterData;
  this.draw(this.data);
}


$(document).ready(function () {
  
  var link = window.location + ".json"

  d3.json(link, function(data) {
    tree = new Tree(data);
    tree.draw(data); 
  });

});