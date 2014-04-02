

$("document").ready(function() {
  var $svg = $("<svg>") 
  $svg.addClass("background-svg")

  $("body").append($svg);

  var width = window.width
  var height = window.height

  var bg = d3.layout.tree().size([height, width])

  var data = {
    key: 1,
    children: []
  }

  var nodes = bg.nodes(data);
  var links = bg.links(nodes);

  console.log(nodes);

});

function Node() {
  Node.numInstances = (MyObj.numInstances || 0) + 1;
  this.key = Node.numInstances
  this.children = []
}

function addChild(data) {
  node = new Node()
  data.children.push(node) 
};



