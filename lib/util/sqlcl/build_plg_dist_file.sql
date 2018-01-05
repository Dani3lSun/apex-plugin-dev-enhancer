set define on

define EXEC_PATH = '&1'
define PLG_FILE_PATH = '&2'
define PKG_SPEC_FILE_PATH = '&3'
define PKG_BODY_FILE_PATH = '&4'
define DIST_FILE_PATH = '&5'

cd &EXEC_PATH.
script buildPlgDistFile.js "&PLG_FILE_PATH." "&PKG_SPEC_FILE_PATH." "&PKG_BODY_FILE_PATH." "&DIST_FILE_PATH."
