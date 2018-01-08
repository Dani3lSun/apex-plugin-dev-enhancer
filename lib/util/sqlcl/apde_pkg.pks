CREATE OR REPLACE PACKAGE apde_pkg IS
  --
  g_version      VARCHAR2(10) := '0.9.4';
  g_writer       t_writer := t_dbms_output_writer();
  g_blob_writer  t_blob_writer;
  g_format       VARCHAR2(30) := 'DB';
  g_block_length BINARY_INTEGER := 0;
  g_cr           VARCHAR2(1) := unistr('\000d');
  --
  -- Get Version of APDE Package
  -- #return VARCHAR2
  FUNCTION get_apde_version RETURN VARCHAR2;
  --
  -- Build final plugin export file containing plg export, pkg spec and body
  -- #param p_plg_export
  -- #param p_db_pkg_spec
  -- #param p_db_pkg_body
  -- #return BLOB
  FUNCTION build_plugin_file(p_plg_export  IN BLOB,
                             p_db_pkg_spec IN BLOB,
                             p_db_pkg_body IN BLOB) RETURN BLOB;
  --
END apde_pkg;
/
