set define on

define EXEC_PATH = '&1'
define PKG_VERSION = '&2'

col exec_script_version new_val exec_script_version noprint;

SELECT CASE
         WHEN apde_pkg.get_apde_version = '&PKG_VERSION.' THEN
          'null'
         ELSE
          'drop_compile_apde_pkg'
       END AS exec_script_version
  FROM dual;

cd &EXEC_PATH.
@&exec_script_version
