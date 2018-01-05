set define on

define EXEC_PATH = '&1'
define APP_ID = '&2'

cd &EXEC_PATH.
apex export -applicationid &APP_ID. -split -splitNoCheckSum
