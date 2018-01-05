CREATE OR REPLACE PACKAGE BODY #plg_short_name#_plg_pkg IS
  --
  -- Plug-in Render Function
  -- #param p_dynamic_action
  -- #param p_plugin
  -- #return apex_plugin.t_dynamic_action_render_result
  FUNCTION render_#plg_short_name#(p_dynamic_action IN apex_plugin.t_dynamic_action,
                                   p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_dynamic_action_render_result IS
    l_result apex_plugin.t_dynamic_action_render_result;
  BEGIN
    RETURN l_result;
  END render_#plg_short_name#;
  --
  -- Plug-in AJAX Function
  -- #param p_dynamic_action
  -- #param p_plugin
  -- #return apex_plugin.t_dynamic_action_ajax_result
  FUNCTION ajax_#plg_short_name#(p_dynamic_action IN apex_plugin.t_dynamic_action,
                                 p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_dynamic_action_ajax_result IS
    l_result apex_plugin.t_dynamic_action_ajax_result;
  BEGIN
    RETURN l_result;
  END ajax_#plg_short_name#;
  --
END #plg_short_name#_plg_pkg;
/
