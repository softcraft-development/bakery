# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def jquery_lib_tag
    if APP_CONFIG[:offline_mode]
      javascript_include_tag "jquery.1.4.2.min.js"
    else
      javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"
    end
  end
  
  def jquery_ui_lib_tags
    if APP_CONFIG[:offline_mode]
      js = javascript_include_tag "jquery-ui-1.8.4.custom.min.js"
    else
      js = javascript_include_tag "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.4/jquery-ui.min.js"
    end
    return js + stylesheet_link_tag("smoothness/jquery-ui-1.8.4.custom.css")
  end
end
