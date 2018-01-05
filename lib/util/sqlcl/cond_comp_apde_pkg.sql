set define on

define EXEC_PATH = '&1'
col exec_script new_val exec_script noprint;

SELECT CASE
         WHEN (SELECT COUNT(uo.object_name)
                 FROM user_objects uo
                WHERE uo.object_type = 'PACKAGE'
                  AND uo.object_name = 'APDE_PKG'
                  AND uo.status = 'VALID') >= 1 THEN
          'null'
         ELSE
          'compile_apde_pkg'
       END AS exec_script
  FROM dual;
  
cd &EXEC_PATH.
@&exec_script