function Tree(data) {

  this.data = data;
  this.masterData = data;
  this.tree = d3.layout.tree()
    .children(function(d) {
        return d.child_trees
    }); 

  
  d3.select("body").append("svg").attr("width","700").attr("height","400").attr("class","vis");
  this.svg = d3.select("svg.vis");
}

Tree.prototype.nodeKey = function(d) {
  return d._id.$oid;
}

Tree.prototype.linkKey = function(d) {
  return d.target._id.$oid;
}

Tree.prototype.draw = function(data) {
  var depth = getDepth(this.data);
  console.log(depth);
  this.calcSize(depth);

  this.nodes = this.tree.nodes(data);
  this.links = this.tree.links(this.nodes);

  this.diagonal = d3.svg.diagonal()
    .projection(function (d) {
      return [d.y, d.x];
  });  

   
  this.transitionLinks();
  this.transitionNodes();
  this.isRoot() ? this.removeButtons() : this.addButtons();
  

};

Tree.prototype.calcSize = function(depth) {
  var sum = .5
  var i = 2

  while(i < (depth)) {
    sum += Math.pow(.5, i);
    i++;
  }
    console.log(sum)
  this.tree.size([400, 700*sum]);
};

Tree.prototype.transitionLinks = function() {

  var link = this.svg.selectAll(".link")
    .data(this.links, this.linkKey);

  var self = this;  

  link  
    .transition()
    .duration(1000)  
    .attr("d", function(d) {
      if(self.isRoot()) {
        var s = {x: d.source.x, y:  d.source.y }
        var t = {x: d.target.x, y:  d.target.y }
      } else {
        var s = {x: d.source.x, y:  d.source.y + 75}
        var t = {x: d.target.x, y:  d.target.y + 75}
      }
      return self.diagonal({source: s, target: t})
    })

  link
    .exit()
    .attr("d", function(d) {
      if(self.isRoot()) {
        var s = {x: d.source.x, y:  d.source.y }
        var t = {x: d.target.x, y:  d.target.y }
      } else {
        var s = {x: d.source.x, y:  d.source.y + 75}
        var t = {x: d.target.x, y:  d.target.y + 75}
      }
      return self.diagonal({source: s, target: t})
    })
    .remove();  

  link
    .enter() 
    .append("path")
    .attr("opacity", "0")
    .transition()
    .duration(1000) 
    .delay(1000)  
    .attr("opacity", "1")
    .attr("class", "link")
    .attr("fill", "none")
    .attr("stroke", "gray")
    .attr("d", function(d) {
      if(self.isRoot()) {
        var s = {x: d.source.x, y:  d.source.y }
        var t = {x: d.target.x, y:  d.target.y }
      } else {
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
      })


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
    $(".story-panel span.future").text(self.getHistory(d));
  })  

  node.append("circle")
    .attr("r", 5)
    .attr("fill", "#ccc");

  d3.selectAll("circle")
    .on("mouseover", function() { 
       d3.select(this)
        .transition()
        .duration(300)
        .attr("r", 8);
         })
    .on("mouseout", function() { 

       d3.select(this)
        .transition()
        .duration(300)
        .attr("r", 5);
         });  

}

Tree.prototype.xTranslation = function(d) {
  
  if(this.isRoot()) {
   return "translate(" + d.y + "," + d.x + ")"; 
  } else {
   return "translate(" + (75 + d.y) + "," + d.x + ")"; 
  }
};

Tree.prototype.getHistory = function(d) {
  var string = "";
  string += d.content;
  while(d.parent !== undefined) {
    string = d.content + string;
    d = d.parent
  }
  return string;
}; 

Tree.prototype.addButtons = function(d) {

  var self = this;  

  this.removeButtons();

  var traverseUpButton = this.svg.append("circle")
    .attr("data-toggle","tooltip")
    .attr("title","one level up")
    .attr("data-placement","top")
    .attr("cx", this.data.y + 50)
    .attr("cy", this.data.x)
    .attr("r", 5)
    .attr("fill", "#ccc")
    .attr("class", "controls");

  var resetButton = this.svg.append("circle")
    .attr("data-toggle","tooltip")
    .attr("data-placement","top")
    .attr("title","reset to full tree")
    .attr("cx", this.data.y + 25)
    .attr("cy", this.data.x)
    .attr("r", 5)
    .attr("fill", "#ccc")
    .attr("class", "controls");

 

  traverseUpButton.on("click", function(d){
    self.traverseUp();
    })

  resetButton.on("click", function(d){
    self.reset();
    })

   $(".controls").tooltip({container:'body'});

};

Tree.prototype.removeButtons = function(d) {
  $(".controls").remove();
  $(".tooltip").remove();
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


function getDepth(obj) {
    var depth = 0;
    if (obj.child_trees) {
        obj.child_trees.forEach(function (d) {
            
            var tmpDepth = getDepth(d)
            if (tmpDepth > depth) {
                depth = tmpDepth
            }
        })
    }
    return 1 + depth
}

$(document).ready(function () {
  
  var link = window.location + ".json"
  console.log(link);
  d3.json(link, function(error, data) {
    if (error) {
      
    }
    else if(data) {
      tree = new Tree(data);
      tree.draw(data); 
      $(".story-panel").addClass("open");
    }  
  });
});