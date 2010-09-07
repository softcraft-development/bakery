;
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content, handleContent) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).before(content.replace(regexp, new_id));
}

jQuery.fn.clickToEdit = function(){
  var input = $(this);
  input.hide();
  var display = $("<span />");
  if ( input.attr("id") !== undefined ){
    display.attr("id", input.attr("id") + "-display" );
  }
  var classes = "input-display";
  if ( input.attr("class") !== undefined ){
    classes += " " + input.attr("class");
  }
  display.addClass(classes)
  display.attr("title", "Click to Edit");
  display.text(input.val());
  input.before(display);
  input.change(function(){
    display.text(input.val());
  });
  display.click(function(){
    display.hide();
    input.show();
  });
}