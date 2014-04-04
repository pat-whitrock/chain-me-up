$(function() {

  $('.instruction li').tooltip();
  $('.content h2').tooltip();
  $('.content p').tooltip();

  $("#tree_prompt").on("change", function(e) {
   
    var $value = $(this).val(); 
    var $array = $(this).children("option")
    var $array = $.map($array, function(val, i) { return val.value })
    var $content = $("#tree_content").val();
    if($content == "") {
      $("#tree_content").val($value);
    } else {
      $array.forEach(function(n) {
        var patt = new RegExp(n)
        if($content.match(patt)) {     
          $content = $content.replace(n, $value)
          return $("#tree_content").val($content);
        }
      });
    }  
  });

});