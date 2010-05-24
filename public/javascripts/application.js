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

jQuery(document).ready(function($){
  $(".recipe_form .ingredients .ingredient .remove input[type='checkbox']").hide();
  $(".recipe_form .ingredients .ingredient .remove label").click(function(){
    $(this).parent().find("input[type='hidden']").val("1");
    $(this).parent().parent().hide();
  });
});