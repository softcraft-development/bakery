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
  
  var wrapper = $("<span />");
  if ( input.attr("id") !== undefined ){
    wrapper.attr("id", input.attr("id") + "-click-to-edit" );
  }

  var classes = "click-to-edit";
  if ( input.attr("class") !== undefined ){
    classes += " " + input.attr("class");
  }
  wrapper.addClass(classes)
  
  var display = $("<span class='click-to-edit-display' title='Click to Edit'>" + input.val() + "</span>");
  
  var cancel = $("<button type='button' class='click-to-edit-cancel' title='Cancel Edit'>Cancel</button>")
  cancel.css("display", "inline");
  cancel.hide();

  display.click(function(){
    display.hide();
    input.show();
    cancel.show();
  });
  
  cancel.click(function(){
    input.hide();
    cancel.hide();
    display.show();
    input.val(display.text());
  });
  
  input.change(function(){
    if ( display.is(":visible") ){
      display.text(input.val());
    }
  });
  
  input.wrap(wrapper);
  input.before(display);
  input.after(cancel);
  
  return wrapper;
}