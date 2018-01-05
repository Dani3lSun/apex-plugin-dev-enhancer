CREATE OR REPLACE TYPE BODY t_blob_writer AS
  --
  /****************************************************************************
  * Purpose:  constructor that creates a temporary blob
  *           Inspired by wwv_flow_t_blob_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  CONSTRUCTOR FUNCTION t_blob_writer(SELF           IN OUT NOCOPY t_blob_writer,
                                     p_from_charset IN VARCHAR2 DEFAULT NULL,
                                     p_to_charset   IN VARCHAR2 DEFAULT 'american_america.al32utf8',
                                     p_cache        IN BOOLEAN DEFAULT TRUE,
                                     p_dur          IN PLS_INTEGER DEFAULT NULL)
    RETURN SELF AS RESULT IS
    l_db_charset VARCHAR2(200);
  BEGIN
    --
    SELECT ndp.value
      INTO l_db_charset
      FROM nls_database_parameters ndp
     WHERE ndp.parameter = 'NLS_CHARACTERSET';
    --
    self.l_temp_length     := 0;
    self.l_temp            := NULL;
    self.l_from_charset    := coalesce(p_from_charset,
                                       'american_america.' ||
                                       lower(l_db_charset));
    self.l_to_charset      := lower(p_to_charset);
    self.l_need_convert_01 := CASE self.l_from_charset
                                WHEN self.l_to_charset THEN
                                 0
                                ELSE
                                 1
                              END;
    self.l_cache_01 := CASE
                         WHEN p_cache THEN
                          1
                         ELSE
                          0
                       END;
    self.l_dur             := nvl(p_dur,
                                  sys.dbms_lob.call);
    RETURN;
  END t_blob_writer;
  --
  /****************************************************************************
  * Purpose:  free the temporary blob
  *           Inspired by wwv_flow_t_blob_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  OVERRIDING MEMBER PROCEDURE free(SELF IN OUT NOCOPY t_blob_writer) IS
  BEGIN
    IF sys.dbms_lob.istemporary(lob_loc => self.l_blob) = 1 THEN
      sys.dbms_lob.freetemporary(lob_loc => self.l_blob);
    END IF;
  
    self.l_temp_length := 0;
    self.l_temp        := NULL;
    self.l_blob        := NULL;
  END free;
  --
  /****************************************************************************
  * Purpose:  write any pending changes to l_blob
  *           Inspired by wwv_flow_t_blob_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  OVERRIDING MEMBER PROCEDURE flush(SELF IN OUT NOCOPY t_blob_writer) IS
    l_raw RAW(32767);
    l_len PLS_INTEGER;
    l_pos PLS_INTEGER;
  BEGIN
    IF self.l_temp_length > 0 THEN
      IF self.l_blob IS NULL THEN
        sys.dbms_lob.createtemporary(lob_loc => self.l_blob,
                                     cache   => self.l_cache_01 = 1,
                                     dur     => self.l_dur);
      END IF;
      IF self.l_need_convert_01 = 0 THEN
        sys.dbms_lob.writeappend(lob_loc => self.l_blob,
                                 amount  => self.l_temp_length,
                                 buffer  => sys.utl_raw.cast_to_raw(self.l_temp));
      ELSE
        l_len := length(self.l_temp);
        l_pos := 1;
        WHILE l_pos <= l_len LOOP
          l_raw := sys.utl_raw.cast_to_raw(substr(self.l_temp,
                                                  l_pos,
                                                  8191));
          l_raw := sys.utl_raw.convert(r            => l_raw,
                                       to_charset   => self.l_to_charset,
                                       from_charset => self.l_from_charset);
          sys.dbms_lob.writeappend(lob_loc => self.l_blob,
                                   amount  => sys.utl_raw.length(l_raw),
                                   buffer  => l_raw);
          l_pos := l_pos + 8191;
        END LOOP;
      END IF;
    
      self.l_temp_length := 0;
      self.l_temp        := NULL;
    END IF;
  END flush;
  --
  /****************************************************************************
  * Purpose:  flush changes and return the blob value
  *           Inspired by wwv_flow_t_blob_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  MEMBER FUNCTION get_value(SELF IN OUT NOCOPY t_blob_writer) RETURN BLOB IS
  BEGIN
    self.flush;
    RETURN self.l_blob;
  END get_value;

END;
/
