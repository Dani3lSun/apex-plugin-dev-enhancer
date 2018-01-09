var helpers = helpers || {};

/* for complex type a java hashmap is needed for binds */
helpers.getBindMap = function() {
  var HashMap = Java.type('java.util.HashMap');
  map = new HashMap();
  return map;
};

/* create a temp blob and load it from a local to sqlcl file */
helpers.getBlobFromFile = function(fileName) {
  try {
    var b = conn.createBlob();
    var out = b.setBinaryStream(1);
    var path = java.nio.file.FileSystems.getDefault().getPath(fileName);

    java.nio.file.Files.copy(path, out);
    out.flush();

    return b;
  } catch (e) {
    ctx.write(e);
  }
};

/* arguments */
var plgFilePath = args[1];
var pkgSpecFilePath = args[2];
var pkgBodyFilePath = args[3];
var distPath = args[4];
var pkgName = args[5];

/* create file objects */
var File = Java.type('java.io.File');
var plgFile = new File(plgFilePath);
var pkgSpecFile = new File(pkgSpecFilePath);
var pkgBodyFile = new File(pkgBodyFilePath);

/* load binds */
binds = helpers.getBindMap();

blobPlg = helpers.getBlobFromFile(plgFile);
blobPkgSpec = helpers.getBlobFromFile(pkgSpecFile);
blobPkgBody = helpers.getBlobFromFile(pkgBodyFile);

ctx.write('Uploaded: ' + plgFile + '\n');
ctx.write('Uploaded: ' + pkgSpecFile + '\n');
ctx.write('Uploaded: ' + pkgBodyFile + '\n');

/* add more binds */
binds.put('blob_plg', blobPlg);
binds.put('blob_pkg_spec', blobPkgSpec);
binds.put('blob_pkg_body', blobPkgBody);
binds.put('pkg_name', pkgName);

/* get final file back from sql statement */
var sqlStmt =
  'SELECT apde_pkg.build_plugin_file(p_plg_export  => :blob_plg,' +
  '                                  p_db_pkg_spec => :blob_pkg_spec,' +
  '                                  p_db_pkg_body => :blob_pkg_body,' +
  '                                  p_pkg_name    => :pkg_name) AS "PLG_DIST_FILE"' +
  '  FROM dual';

var ret = util.executeReturnList(sqlStmt, binds);

var ex = util.getLastException();

if (ex) {
  ctx.write(ex + "\n");
}

// loop the results
for (i = 0; i < ret.length; i++) {
  var blobStream = ret[i].PLG_DIST_FILE.getBinaryStream(1);
  var path = java.nio.file.FileSystems.getDefault().getPath(distPath);
  java.nio.file.Files.copy(blobStream, path);
}
