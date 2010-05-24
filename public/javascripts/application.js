;
jQuery(document).ready(function($){
  $(".recipe_form .ingredients .ingredient .remove input[type='checkbox']").hide();
  $(".recipe_form .ingredients .ingredient .remove label").click(function(){
    $(this).parent().find("input[type='hidden']").val("1");
    $(this).parent().parent().hide();
  });
});