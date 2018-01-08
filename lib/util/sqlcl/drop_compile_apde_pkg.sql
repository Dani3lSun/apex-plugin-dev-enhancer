set define off

ALTER SESSION SET plsql_compiler_flags = 'NATIVE';
ALTER SESSION SET plsql_code_type='NATIVE';

DROP PACKAGE APDE_PKG;
DROP TYPE T_BLOB_WRITER;
DROP TYPE T_DBMS_OUTPUT_WRITER;
DROP TYPE T_WRITER;

@t_writer.tps
@t_writer.tpb
@t_blob_writer.tps
@t_blob_writer.tpb
@t_dbms_output_writer.tps
@t_dbms_output_writer.tpb
@apde_pkg.pks
@apde_pkg.pkb
