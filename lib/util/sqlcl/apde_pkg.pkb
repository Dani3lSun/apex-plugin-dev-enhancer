CREATE OR REPLACE PACKAGE BODY apde_pkg IS
  --
  /****************************************************************************
  * Purpose:  Convert CLOB to VARCHAR2
  *           Inspired by wwv_flow_gen_api2 (Plugin Export)
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FUNCTION clob_to_varchar2(p_clob   IN CLOB,
                            p_offset IN NUMBER DEFAULT 0,
                            p_raise  IN BOOLEAN DEFAULT FALSE)
    RETURN VARCHAR2 IS
    l_return_val VARCHAR2(32767 CHAR);
    l_buf        VARCHAR2(32767);
    l_pos        NUMBER;
    l_length     NUMBER;
  BEGIN
    BEGIN
    
      IF p_offset = 0 THEN
        l_return_val := p_clob;
      ELSE
        l_return_val := substr(p_clob,
                               p_offset + 1);
      END IF;
    EXCEPTION
      WHEN value_error THEN
        --
        IF p_clob IS NOT NULL THEN
          l_length := nvl(sys.dbms_lob.getlength(p_clob),
                          0);
          --
          IF l_length > 0 + p_offset THEN
            l_pos        := 1 + p_offset;
            l_buf        := sys.dbms_lob.substr(p_clob,
                                                8191,
                                                l_pos);
            l_return_val := l_buf;
            --
            IF l_length > 8191 + p_offset THEN
              l_pos        := 8192 + p_offset;
              l_buf        := sys.dbms_lob.substr(p_clob,
                                                  8191,
                                                  l_pos);
              l_return_val := l_return_val || l_buf;
              --
              IF l_length > 16382 + p_offset THEN
                l_pos        := 16383 + p_offset;
                l_buf        := sys.dbms_lob.substr(p_clob,
                                                    8191,
                                                    l_pos);
                l_return_val := l_return_val || l_buf;
                --
                IF l_length > 24573 + p_offset THEN
                  l_pos        := 24574 + p_offset;
                  l_buf        := sys.dbms_lob.substr(p_clob,
                                                      8191,
                                                      l_pos);
                  l_return_val := l_return_val || l_buf;
                  --
                  IF l_length > 32764 + p_offset THEN
                    l_pos        := 32765 + p_offset;
                    l_buf        := sys.dbms_lob.substr(p_clob,
                                                        3,
                                                        l_pos);
                    l_return_val := l_return_val || l_buf;
                  END IF;
                END IF;
              END IF;
            END IF;
          END IF;
        END IF;
    END;
    --
    RETURN l_return_val;
    --
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -6502 AND p_raise = FALSE THEN
        FOR i IN REVERSE 1 .. length(l_buf) LOOP
          IF lengthb(l_return_val) +
             lengthb(substr(l_buf,
                            1,
                            i)) <= 32767 THEN
            l_return_val := l_return_val || substr(l_buf,
                                                   1,
                                                   i);
            EXIT;
          END IF;
        END LOOP;
        RETURN l_return_val;
      ELSE
        RAISE;
      END IF;
  END clob_to_varchar2;
  --
  /****************************************************************************
  * Purpose:  Convert BLOB to CLOB
  *           https://github.com/OraOpenSource/oos-utils/blob/master/source/packages/oos_util_lob.pkb
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FUNCTION blob_to_clob(p_blob      IN BLOB,
                        p_blob_csid IN INTEGER DEFAULT dbms_lob.default_csid)
    RETURN CLOB AS
    l_clob         CLOB;
    l_dest_offset  INTEGER := 1;
    l_src_offset   INTEGER := 1;
    l_lang_context INTEGER := dbms_lob.default_lang_ctx;
    l_warning      INTEGER;
  BEGIN
    IF p_blob IS NULL THEN
      RETURN NULL;
    END IF;
    --
    dbms_lob.createtemporary(lob_loc => l_clob,
                             cache   => FALSE);
    --
    dbms_lob.converttoclob(dest_lob     => l_clob,
                           src_blob     => p_blob,
                           amount       => dbms_lob.lobmaxsize,
                           dest_offset  => l_dest_offset,
                           src_offset   => l_src_offset,
                           blob_csid    => p_blob_csid,
                           lang_context => l_lang_context,
                           warning      => l_warning);
    --  
    RETURN l_clob;
    --
  END blob_to_clob;
  --
  /****************************************************************************
  * Purpose:  Get NLS characterset of DB
  *           Inspired by wwv_flow_lang
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FUNCTION get_db_charset RETURN VARCHAR2 IS
    l_db_charset VARCHAR2(255);
  BEGIN
    --
    FOR c1 IN (SELECT VALUE
                 FROM sys.nls_database_parameters
                WHERE parameter = 'NLS_CHARACTERSET') LOOP
      l_db_charset := c1.value;
      EXIT;
    END LOOP;
    --
    l_db_charset := nvl(l_db_charset,
                        'AL32UTF8');
    --
    RETURN l_db_charset;
    --
  END get_db_charset;
  --
  /****************************************************************************
  * Purpose:  Get IANA characterset based on DB characterset
  *           Inspired by wwv_flow_lang
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FUNCTION get_iana_charset(p_db_charset IN VARCHAR2) RETURN VARCHAR2 IS
    l_iana_charset VARCHAR2(255);
    l_db_charset   VARCHAR2(255);
  BEGIN
    --
    l_db_charset := upper(p_db_charset);
    --
    IF l_db_charset = 'AL16UTF16' THEN
      l_iana_charset := 'utf-16be';
    ELSIF l_db_charset = 'AL16UTF16LE' THEN
      l_iana_charset := 'utf-16le';
    ELSIF l_db_charset = 'AL32UTF8' THEN
      l_iana_charset := 'utf-8';
    ELSIF l_db_charset = 'AR8ISO8859P6' THEN
      l_iana_charset := 'iso-8859-6';
    ELSIF l_db_charset = 'AR8MSWIN1256' THEN
      l_iana_charset := 'windows-1256';
    ELSIF l_db_charset = 'BLT8MSWIN1257' THEN
      l_iana_charset := 'windows-1257';
    ELSIF l_db_charset = 'CL8ISO8859P5' THEN
      l_iana_charset := 'iso-8859-5';
    ELSIF l_db_charset = 'CL8KOI8R' THEN
      l_iana_charset := 'koi8-r';
    ELSIF l_db_charset = 'CL8KOI8U' THEN
      l_iana_charset := 'koi8-u';
    ELSIF l_db_charset = 'CL8MSWIN1251' THEN
      l_iana_charset := 'windows-1251';
    ELSIF l_db_charset = 'EE8ISO8859P2' THEN
      l_iana_charset := 'iso-8859-2';
    ELSIF l_db_charset = 'EE8MSWIN1250' THEN
      l_iana_charset := 'windows-1250';
    ELSIF l_db_charset = 'EL8ISO8859P7' THEN
      l_iana_charset := 'iso-8859-7';
    ELSIF l_db_charset = 'EL8MSWIN1253' THEN
      l_iana_charset := 'windows-1253';
    ELSIF l_db_charset = 'IW8ISO8859P8' THEN
      l_iana_charset := 'iso-8859-8-i';
    ELSIF l_db_charset = 'IW8MSWIN1255' THEN
      l_iana_charset := 'windows-1255';
    ELSIF l_db_charset = 'JA16EUC' THEN
      l_iana_charset := 'euc-jp';
    ELSIF l_db_charset = 'JA16SJIS' THEN
      l_iana_charset := 'shift_jis';
    ELSIF l_db_charset = 'KO16MSWIN949' THEN
      l_iana_charset := 'euc-kr';
    ELSIF l_db_charset = 'NEE8ISO8859P4' THEN
      l_iana_charset := 'iso-8859-4';
    ELSIF l_db_charset = 'SE8ISO8859P3' THEN
      l_iana_charset := 'iso-8859-3';
    ELSIF l_db_charset = 'TH8TISASCII' THEN
      l_iana_charset := 'tis-620';
    ELSIF l_db_charset = 'TR8MSWIN1254' THEN
      l_iana_charset := 'windows-1254';
    ELSIF l_db_charset = 'US7ASCII' THEN
      l_iana_charset := 'us-ascii';
    ELSIF l_db_charset = 'VN8MSWIN1258' THEN
      l_iana_charset := 'windows-1258';
    ELSIF l_db_charset = 'WE8ISO8859P1' THEN
      l_iana_charset := 'iso-8859-1';
    ELSIF l_db_charset = 'WE8ISO8859P15' THEN
      l_iana_charset := 'iso-8859-15';
    ELSIF l_db_charset = 'WE8ISO8859P9' THEN
      l_iana_charset := 'iso-8859-9';
    ELSIF l_db_charset = 'WE8MSWIN1252' THEN
      l_iana_charset := 'windows-1252';
    ELSIF l_db_charset = 'ZHS16GBK' THEN
      l_iana_charset := 'gbk';
    ELSIF l_db_charset = 'ZHT16MSWIN950' THEN
      l_iana_charset := 'big5';
    ELSIF l_db_charset = 'ZHT32EUC' THEN
      l_iana_charset := 'euc-tw';
    ELSE
      l_iana_charset := 'utf-8';
    END IF;
    --
    RETURN l_iana_charset;
    --
  END get_iana_charset;
  --
  /****************************************************************************
  * Purpose:  Write Text into Buffer (DBMS_OUTPUT, HTP, BLOB)
  *           Inspired by wwv_flow_gen_api2 (Plugin Export)
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  PROCEDURE write_buffer(p_text IN VARCHAR2 DEFAULT NULL) IS
    l_p_text_length BINARY_INTEGER := nvl(lengthb(TRIM(p_text)),
                                          0);
  BEGIN
    IF g_format = 'DB' THEN
      g_blob_writer.p(p_text);
      g_block_length := g_block_length + l_p_text_length + 1;
    ELSIF g_format = 'DOS' THEN
      g_writer.p(p_text);
      g_block_length := g_block_length + l_p_text_length + 1;
      --g_writer.prn(p_text || g_cr || apex_application.lf);
      --g_block_length := g_block_length + l_p_text_length + 2;
    ELSE
      g_writer.p(p_text);
      g_block_length := g_block_length + l_p_text_length + 1;
    END IF;
  END write_buffer;
  --
  /****************************************************************************
  * Purpose:  Free Buffer of chosen writer (BLOB or DBMS_OUTPUT)
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  PROCEDURE free_writer_buffer IS
  BEGIN
    IF g_format = 'DB' THEN
      g_blob_writer.free;
    ELSIF g_format = 'DOS' THEN
      g_writer.free;
    END IF;
  END free_writer_buffer;
  --
  /****************************************************************************
  * Purpose:  Initialize new g_blob_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  PROCEDURE init_blob_writer IS
    l_file_charset VARCHAR2(255);
  BEGIN
    --
    l_file_charset := get_iana_charset(p_db_charset => get_db_charset);
    g_blob_writer  := NEW
                      t_blob_writer(p_from_charset => 'american_america.' ||
                                                      l_file_charset,
                                    p_to_charset   => 'american_america.' ||
                                                      l_file_charset);
    --
  END init_blob_writer;
  --
  /****************************************************************************
  * Purpose:  Generate EXECUTE IMMEDIATE Statement for given code - write into Buffer
  *           Inspired by wwv_flow_gen_api2 (Plugin Export)
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  PROCEDURE generate_exec_stmt(p_value IN VARCHAR2) IS
    l_prefix VARCHAR2(200);
    l_lines  apex_t_varchar2;
    --
    PROCEDURE write_line(p_prefix IN VARCHAR2,
                         p_line   IN VARCHAR2,
                         p_suffix IN VARCHAR2) IS
      l_length PLS_INTEGER := length(p_line);
      l_start  PLS_INTEGER := 1;
      l_prefix VARCHAR2(80) := p_prefix;
    BEGIN
      WHILE l_length > 250 LOOP
        PRAGMA inline(write_buffer,
                      'YES');
        write_buffer(l_prefix || '''' ||
                     REPLACE(substr(p_line,
                                    l_start,
                                    250),
                             '''',
                             '''''') || '''');
        l_prefix := '||';
        l_length := l_length - 250;
        l_start  := l_start + 250;
      END LOOP;
      PRAGMA inline(write_buffer,
                    'YES');
      write_buffer(l_prefix || '''' || REPLACE(substr(p_line,
                                                      l_start),
                                               '''',
                                               '''''') || '''' || p_suffix);
    END write_line;
    --
  BEGIN
    --
    IF p_value IS NOT NULL THEN
      l_prefix := 'set define off' || apex_application.lf || 'begin' ||
                  apex_application.lf ||
                  '  EXECUTE IMMEDIATE apex_string.join_clob(apex_t_varchar2(';
      IF instr(p_value,
               apex_application.lf) > 0 THEN
        l_lines := apex_string.split(REPLACE(p_value,
                                             g_cr,
                                             NULL));
        PRAGMA inline(write_buffer,
                      'YES');
        write_buffer(l_prefix);
        FOR i IN 1 .. l_lines.count LOOP
          PRAGMA inline(write_line,
                        'YES');
          write_line(p_prefix => NULL,
                     p_line   => l_lines(i),
                     p_suffix => CASE
                                   WHEN i = l_lines.count THEN
                                    '));' || apex_application.lf || 'end;' ||
                                    apex_application.lf || '/' || apex_application.lf
                                   ELSE
                                    ','
                                 END);
        END LOOP;
      ELSIF p_value IS NULL THEN
        PRAGMA inline(write_buffer,
                      'YES');
        write_buffer(l_prefix || 'null');
      ELSE
        PRAGMA inline(write_line,
                      'YES');
        write_line(p_prefix => l_prefix,
                   p_line   => REPLACE(p_value,
                                       g_cr,
                                       NULL),
                   p_suffix => NULL);
      END IF;
    END IF;
    IF g_format = 'DB' THEN
      g_blob_writer.flush;
    ELSIF g_format = 'DOS' THEN
      g_writer.flush;
    END IF;
  END generate_exec_stmt;
  --
  /****************************************************************************
  * Purpose:  Generate EXECUTE IMMEDIATE Statement for given code (CLOB) - write into Buffer
  *           Inspired by wwv_flow_gen_api2 (Plugin Export)
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  PROCEDURE generate_exec_stmt(p_value IN CLOB) IS
  BEGIN
    IF p_value IS NOT NULL AND sys.dbms_lob.getlength(p_value) > 0 THEN
      PRAGMA inline(generate_exec_stmt,
                    'YES');
      generate_exec_stmt(p_value => clob_to_varchar2(p_value));
    END IF;
  END generate_exec_stmt;
  --
  /****************************************************************************
  * Purpose:  Generate EXECUTE IMMEDIATE Statement for given code (BLOB) - write into Buffer
  *           Inspired by wwv_flow_gen_api2 (Plugin Export)
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  PROCEDURE generate_exec_stmt(p_value IN BLOB) IS
    l_clob CLOB;
  BEGIN
    l_clob := blob_to_clob(p_blob => p_value);
    generate_exec_stmt(p_value => l_clob);
  END generate_exec_stmt;
  --
  /****************************************************************************
  * Purpose: Build final plugin export file containing plg export, pkg spec and body
  * Author:  Daniel Hochleitner
  * Created: 02.01.2018
  * Changed:
  ****************************************************************************/
  FUNCTION build_plugin_file(p_plg_export  IN BLOB,
                             p_db_pkg_spec IN BLOB,
                             p_db_pkg_body IN BLOB) RETURN BLOB IS
    --
    l_blob BLOB;
    --
  BEGIN
    --
    dbms_lob.createtemporary(l_blob,
                             FALSE);
    -- append plg export file
    dbms_lob.append(l_blob,
                    p_plg_export);
    -- append plugin package spec and body
    init_blob_writer;
    generate_exec_stmt(p_value => p_db_pkg_spec);
    generate_exec_stmt(p_value => p_db_pkg_body);
    --
    dbms_lob.append(l_blob,
                    g_blob_writer.get_value);
    -- free blob buffer
    free_writer_buffer;
    --
    RETURN l_blob;
    --
  END build_plugin_file;
  --
END apde_pkg;
/
