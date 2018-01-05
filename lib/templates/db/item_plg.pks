CREATE OR REPLACE PACKAGE #plg_short_name#_plg_pkg IS
  --
  -- Plug-in Render Function
  -- #param p_item
  -- #param p_plugin
  -- #param p_value
  -- #param p_is_readonly
  -- #param p_is_printer_friendly
  -- #return apex_plugin.t_page_item_render_result
  FUNCTION render_#plg_short_name#(p_item                IN apex_plugin.t_page_item,
                                   p_plugin              IN apex_plugin.t_plugin,
                                   p_value               IN VARCHAR2,
                                   p_is_readonly         IN BOOLEAN,
                                   p_is_printer_friendly IN BOOLEAN)
    RETURN apex_plugin.t_page_item_render_result;
  --
  -- Plug-in AJAX Function
  -- #param p_item
  -- #param p_plugin
  -- #return apex_plugin.t_page_item_ajax_result
  FUNCTION ajax_#plg_short_name#(p_item   IN apex_plugin.t_page_item,
                                 p_plugin IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_page_item_ajax_result;
  --
  -- Plug-in Validation Function
  -- #param p_item
  -- #param p_plugin
  -- #param p_value
  -- #return apex_plugin.t_page_item_validation_result
  FUNCTION validate_#plg_short_name#(p_item   IN apex_plugin.t_page_item,
                                     p_plugin IN apex_plugin.t_plugin,
                                     p_value  IN VARCHAR2)
    RETURN apex_plugin.t_page_item_validation_result;
  --
END #plg_short_name#_plg_pkg;
/
