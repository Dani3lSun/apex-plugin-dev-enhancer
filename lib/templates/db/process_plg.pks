CREATE OR REPLACE PACKAGE #plg_short_name#_plg_pkg IS
  --
  -- Plug-in Execution Function
  -- #param p_process
  -- #param p_plugin
  -- #return apex_plugin.t_process_exec_result
  FUNCTION exec_#plg_short_name#(p_process IN apex_plugin.t_process,
                                 p_plugin  IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_process_exec_result;
  --
END #plg_short_name#_plg_pkg;
/
