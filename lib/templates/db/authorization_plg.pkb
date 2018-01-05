CREATE OR REPLACE PACKAGE BODY #plg_short_name#_plg_pkg IS
  --
  -- Plug-in Execution Function
  -- #param p_authorization
  -- #param p_plugin
  -- #return apex_plugin.t_authorization_exec_result
  FUNCTION exec_#plg_short_name#(p_authorization IN apex_plugin.t_authorization,
                                 p_plugin        IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_authorization_exec_result IS
    l_result apex_plugin.t_authorization_exec_result;
  BEGIN
    RETURN l_result;
  END exec_#plg_short_name#;
  --
END #plg_short_name#_plg_pkg;
/
