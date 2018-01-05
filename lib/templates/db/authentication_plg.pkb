CREATE OR REPLACE PACKAGE BODY #plg_short_name#_plg_pkg IS
  --
  -- Plug-in Session Sentry Function
  -- #param p_authentication
  -- #param p_plugin
  -- #param p_is_public_page
  -- #return apex_plugin.t_authentication_sentry_result
  FUNCTION sentry_#plg_short_name#(p_authentication IN apex_plugin.t_authentication,
                                   p_plugin         IN apex_plugin.t_plugin,
                                   p_is_public_page IN BOOLEAN)
    RETURN apex_plugin.t_authentication_sentry_result IS
    l_result apex_plugin.t_authentication_sentry_result;
  BEGIN
    RETURN l_result;
  END sentry_#plg_short_name#;
  --
  -- Plug-in Invalid Session Function
  -- #param p_authentication
  -- #param p_plugin
  -- #return apex_plugin.t_authentication_inval_result
  FUNCTION inval_#plg_short_name#(p_authentication IN apex_plugin.t_authentication,
                                  p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_authentication_inval_result IS
    l_result apex_plugin.t_authentication_inval_result;
  BEGIN
    RETURN l_result;
  END inval_#plg_short_name#;
  --
  -- Plug-in Authentication Function
  -- #param p_authentication
  -- #param p_plugin
  -- #param p_password
  -- #return apex_plugin.t_authentication_auth_result
  FUNCTION auth_#plg_short_name#(p_authentication IN apex_plugin.t_authentication,
                                 p_plugin         IN apex_plugin.t_plugin,
                                 p_password       IN VARCHAR2)
    RETURN apex_plugin.t_authentication_auth_result IS
    l_result apex_plugin.t_authentication_auth_result;
  BEGIN
    RETURN l_result;
  END auth_#plg_short_name#;
  --
  -- Plug-in Post Logout Function
  -- #param p_authentication
  -- #param p_plugin
  -- #return apex_plugin.t_authentication_logout_result
  FUNCTION logout_#plg_short_name#(p_authentication IN apex_plugin.t_authentication,
                                   p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_authentication_logout_result IS
    l_result apex_plugin.t_authentication_logout_result;
  BEGIN
    RETURN l_result;
  END logout_#plg_short_name#;
  --
  -- Plug-in AJAX Function
  -- #param p_authentication
  -- #param p_plugin
  -- #return apex_plugin.t_authentication_ajax_result
  FUNCTION ajax_#plg_short_name#(p_authentication IN apex_plugin.t_authentication,
                                 p_plugin         IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_authentication_ajax_result IS
    l_result apex_plugin.t_authentication_ajax_result;
  BEGIN
    RETURN l_result;
  END ajax_#plg_short_name#;
  --
END #plg_short_name#_plg_pkg;
/
