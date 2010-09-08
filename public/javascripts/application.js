;

// http://www.somacon.com/p355.php
String.prototype.trim = function() {
  return this.replace(/^\s+|\s+$/g,"");
}
String.prototype.ltrim = function() {
  return this.replace(/^\s+/,"");
}
String.prototype.rtrim = function() {
  return this.replace(/\s+$/,"");
}

var Bakery = {
  isBlank: function(value){
    return ( value === undefined
      || value === null
      || value.trim() === "" );
  },
  
  defaultNA: function(onBlank) {
    return onBlank === undefined ? "N/A" : onBlank;
  },

  na: function(value, onBlank) {
    if ( Bakery.isBlank(value) ) {
      value = Bakery.defaultNA(onBlank);
    }
    return value;  
  },

  dollars: function(value, onBlank) {
    if ( Bakery.isBlank(value) ) {
      value = "$" + Bakery.defaultNA(onBlank);
    }
    else {
      // http://www.willmaster.com/library/tutorials/currency-formatting-and-putting-commas-in-numbers-with-javascript-and-perl.php#G1283899839764
      var i = parseFloat(value);
      if( isNaN(i) ) { i = 0.00; }
      var minus = '';
      if(i < 0) { minus = '-'; }
      i = Math.abs(i);
      i = parseInt((i + .005) * 100);
      i = i / 100;
      s = new String(i);
      if(s.indexOf('.') < 0) { s += '.00'; }
      if(s.indexOf('.') == (s.length - 2)) { s += '0'; }
      value = minus + "$" + s;
    }
    return value;
  }
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content, handleContent) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).before(content.replace(regexp, new_id));
}

jQuery.fn.clickToEdit = function(options){
  options = options === undefined ? {} : options;
  options.format = options.format === undefined ? function(value) { return value; } : options.format;
  
  $(this).each(function(index,element){
    var input = $(element);
    input.hide();

    var wrapper = $("<span />");
    if ( input.attr("id") !== undefined ){
      wrapper.attr("id", "click-to-edit-" + input.attr("id") );
    }

    var classes = "click-to-edit";
    if ( input.attr("class") !== undefined ){
      classes += " " + input.attr("class");
    }
    wrapper.addClass(classes);

    var display = $("<span class='click-to-edit-display' title='Click to Edit'>" + options.format(input.val()) + "</span>");

    var cancel = $("<button type='button' class='click-to-edit-cancel' title='Cancel Edit'>Cancel</button>");
    cancel.css("display", "inline");
    cancel.hide();

    display.click(function(){
      display.hide();
      input.attr("undo", input.val());
      input.show();
      input.focus();
      cancel.show();
    });

    cancel.click(function(){
      input.hide();
      cancel.hide();
      display.show();
      input.val(input.attr("undo"));
    });

    input.change(function(){
      if ( display.is(":visible") ){
        display.text(options.format(input.val()));
      }
    });

    input.wrap(wrapper);
    input.before(display);
    input.after(cancel);
    
  });
}

