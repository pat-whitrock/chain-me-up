function Tree(data) {

  this.data = data;
  this.masterData = data;
  this.tree = d3.layout.tree()
    .children(function(d) {
        return d.child_trees
    }); 

  this.svg = d3.select("svg.vis");

}

Tree.prototype = {

  nodeKey: function(d) {
    return d._id.$oid;
  },

  linkKey: function(d) {
    return d.target._id.$oid;
  },

  draw: function(data) {
    var depth = getDepth(this.data);
    // console.log(depth);
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
    
  },

  calcSize: function(depth) {
    var sum = .5
    var i = 2

    while(i < (depth)) {
      sum += Math.pow(.5, i);
      i++;
    }
      // console.log(sum)
    this.tree.size([400, 700*sum]);
  },

  transitionLinks: function() {

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
  },

  transitionNodes: function() {

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
   
    node.on("click", function(d) {
      self.data = d
      self.draw(d);
      var future = $(".story-panel span.future").html();
      $(".story-panel span.history").append(future);    
      $(".story-panel span.future").html(" ");
    });  

    node.on("mouseover", function(d){
      $(".story-panel span.future").html(self.getRecentHistory(d));
    });  

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

  },

  xTranslation: function(d) {
    var t = this.isRoot() ? "translate(" + d.y + "," + d.x + ")" : "translate(" + (75 + d.y) + "," + d.x + ")"; 
    return t;
  },


  getHistory: function(d) {
    var string = "";

    while(d.parent !== undefined && d !== this.data) {
      string = d.content + string;
      d = d.parent;    
    }

    return string;
  }, 

  getOriginalHistory: function(d) {
    var string = "";

    while(d.parent !== undefined) {
      string = d.content + string;
      d = d.parent;    
    }

    return string;
  },

  getRecentHistory: function(d) {
    var string = "";

    // console.log("within recent history, d is")

    while((d.content !== this.data.content) && (d.depth !== this.data.depth)) {
      // console.log("This is d")
      // console.log(d)
      // console.log("This is this.data")
      // console.log(this.data)
      // console.log(d.content)
      string = d.content + string;
      d = d.parent;    
    }

    return string;
  }, 

  addButtons: function() {

    var self = this;  
    this.removeButtons();
    var traverseUpButton = 
    treeButton({x: this.data.x, y: this.data.y  + 50}, 
      "one level up", 
      this, 
      function() {
      self.traverseUp();
      $(".story-panel span.history").html(self.masterData.content);
      $(".story-panel span.history").append(self.getOriginalHistory(self.data));    
      $(".story-panel span.future").html("");
    });

    var resetButton = 
      treeButton({x: this.data.x, y: this.data.y  + 25}, 
      "reset to full tree", 
      this, 
      function() {
        self.reset();
        $(".story-panel span.history").html(self.masterData.content);    
        $(".story-panel span.future").html("");
      });

    $(".controls").tooltip({container:'body'});

  },

  removeButtons: function() {
    $(".controls").remove();
    $(".tooltip").remove();
  },

  isRoot: function() {
    return !!(this.data.parent === undefined) 
  },

  traverseUp: function() {
    this.data = this.data.parent;
    this.draw(this.data);
  },

  reset: function() {
    this.data = this.masterData;
    this.draw(this.data);
  }
};

function getDepth(obj) {
    var depth = 0;
    if (obj.child_trees) {
      obj.child_trees.forEach(function (d) {
        var tmpDepth = getDepth(d)
          if (tmpDepth > depth) {
              depth = tmpDepth
          }
      });
    }
  return 1 + depth
};

function treeButton(placement, title, context, callback) {
  var button = context.svg.append("circle")
    .attr("data-toggle","tooltip")
    .attr("title", title)
    .attr("data-placement","top")
    .attr("cx", placement.y)
    .attr("cy", placement.x)
    .attr("r", 5)
    .attr("fill", "#ccc")
    .attr("class", "controls");

  if(callback) { button.on("click", function() {
    callback();
  }); }
  
  return button;  

};

var duration = 5000,
    timer = setInterval(update, duration);

function update() {
  var current_branch = tree.data._id.$oid
  console.log("Current branch is "+tree.data._id.$oid)

  var link = window.location + ".json" + "?current_branch=" + current_branch
  // console.log("Link within update function is " + link);
  
  d3.json(link, function(error, data) {
    if (error) {
      
    }
    else if(data) {
      // tree = new Tree(data);
      tree.draw(data); 
      $(".story-panel").addClass("open");
      $(".instruction").addClass("closed");
    }  
  });

}

$(document).ready(function () {
  var tree_id_regex = new RegExp("trees/.*\.")
  // console.log(window.location.href)
  var tree_id = window.location.href.match(tree_id_regex)
  var tree_id = tree_id[0].split("/")[1]

  var link = window.location + ".json" + "?current_branch=" + tree_id
  // console.log(link);
  d3.json(link, function(error, data) {
    if (error) {
      
    }
    else if(data) {
      tree = new Tree(data);
      tree.draw(data); 
      $(".story-panel").addClass("open");
      $(".instruction").addClass("closed");
    }  
  });
});