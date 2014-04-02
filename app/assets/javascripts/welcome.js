

$("document").ready(function() {

  $("#explore").click(function() {
    $('html,body').animate({
      scrollTop: $("#demo").offset().top
     }, 1000);
  });

  $("#demo").waypoint({
    handler: function(direction) {
      if(direction === "up") {
        $("#demo .story-panel").removeClass("open");
      } else if(direction === "down") {
        $("#demo .story-panel").addClass("open");
      }
    },  
    offset: 400,
  });

  $("#demo").waypoint({
    handler: function(direction) {
      d3.json(window.location + "home.json", function(data) {
        if(data) {
          tree = new Tree(data);
          tree.draw(data); 
        }
      })
    },
    offset: 400,
    triggerOnce: true
  });  
      
 
});

   

