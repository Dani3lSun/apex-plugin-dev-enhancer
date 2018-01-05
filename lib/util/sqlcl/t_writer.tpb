CREATE OR REPLACE TYPE BODY t_writer AS
  --
  /****************************************************************************
  * Purpose:  constructor
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  CONSTRUCTOR FUNCTION t_writer(SELF IN OUT NOCOPY t_writer)
    RETURN SELF AS RESULT IS
  BEGIN
    self.l_temp_length := 0;
    RETURN;
  END t_writer;
  --
  /****************************************************************************
  * Purpose:  free the resource
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  MEMBER PROCEDURE free(SELF IN OUT NOCOPY t_writer) IS
  BEGIN
    self.l_temp_length := 0;
    self.l_temp        := NULL;
  END free;
  --
  /****************************************************************************
  * Purpose:  write any pending changes, in case the writer does caching
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  MEMBER PROCEDURE flush(SELF IN OUT NOCOPY t_writer) IS
  BEGIN
    self.l_temp_length := 0;
    self.l_temp        := NULL;
  END flush;
  --
  /****************************************************************************
  * Purpose:  internal prn routine - do not use directly
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FINAL MEMBER PROCEDURE prn_internal(SELF          IN OUT NOCOPY t_writer,
                                      p_text        IN VARCHAR2,
                                      p_text_length IN NUMBER) IS
  BEGIN
    IF p_text_length > 0 THEN
      IF self.l_temp_length = 0 THEN
        self.l_temp        := p_text;
        self.l_temp_length := p_text_length;
      ELSIF p_text_length + self.l_temp_length <= 32767 THEN
        self.l_temp        := self.l_temp || p_text;
        self.l_temp_length := self.l_temp_length + p_text_length;
      ELSE
        flush;
        self.l_temp        := p_text;
        self.l_temp_length := p_text_length;
      END IF;
    END IF;
  END prn_internal;
  --
  /****************************************************************************
  * Purpose:  write a string, without line break
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FINAL MEMBER PROCEDURE prn(SELF   IN OUT NOCOPY t_writer,
                             p_text IN VARCHAR2) IS
  BEGIN
    IF p_text IS NULL THEN
      RETURN;
    END IF;
  
    self.prn_internal(p_text        => p_text,
                      p_text_length => lengthb(p_text));
  END prn;
  --
  /****************************************************************************
  * Purpose:  write a clob, without line break
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FINAL MEMBER PROCEDURE prn(SELF   IN OUT NOCOPY t_writer,
                             p_text IN CLOB) IS
    l_text_length  NUMBER;
    l_start        NUMBER;
    l_db_version   VARCHAR2(100);
    c_max_length   PLS_INTEGER;
    l_chunk        VARCHAR2(32767 CHAR);
    l_chunk_length NUMBER;
  BEGIN
    --
    SELECT pcv.version
      INTO l_db_version
      FROM product_component_version pcv
     WHERE pcv.product LIKE 'PL/SQL%';
    --
    c_max_length := CASE
                      WHEN l_db_version LIKE '11.2.0.%' THEN
                       8191
                      ELSE
                       32767
                    END;
    --
    IF p_text IS NULL THEN
      RETURN;
    END IF;
  
    l_text_length := nvl(sys.dbms_lob.getlength(p_text),
                         0);
    l_start       := 1;
    WHILE l_start <= l_text_length LOOP
      l_chunk        := sys.dbms_lob.substr(lob_loc => p_text,
                                            amount  => c_max_length,
                                            offset  => l_start);
      l_chunk_length := length(l_chunk);
      IF l_chunk_length > 0 THEN
        self.prn_internal(p_text        => l_chunk,
                          p_text_length => lengthb(l_chunk));
        l_start := l_start + l_chunk_length;
      ELSE
        EXIT;
      END IF;
    END LOOP;
  END prn;
  --
  /****************************************************************************
  * Purpose:  write a formatted string, without line break (simplified fprintf)
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FINAL MEMBER PROCEDURE prnf(SELF   IN OUT NOCOPY t_writer,
                              p_text IN VARCHAR2,
                              p0     IN VARCHAR2,
                              p1     IN VARCHAR2 DEFAULT NULL,
                              p2     IN VARCHAR2 DEFAULT NULL,
                              p3     IN VARCHAR2 DEFAULT NULL,
                              p4     IN VARCHAR2 DEFAULT NULL,
                              p5     IN VARCHAR2 DEFAULT NULL,
                              p6     IN VARCHAR2 DEFAULT NULL,
                              p7     IN VARCHAR2 DEFAULT NULL,
                              p8     IN VARCHAR2 DEFAULT NULL,
                              p9     IN VARCHAR2 DEFAULT NULL) IS
    l_start PLS_INTEGER;
    l_pos   PLS_INTEGER;
    l_pi    PLS_INTEGER;
    l_len   PLS_INTEGER;
  BEGIN
    IF p_text IS NULL THEN
      RETURN;
    END IF;
  
    l_start := 1;
    l_pi    := 0;
    LOOP
      l_pos := instr(p_text,
                     '%s',
                     l_start);
      IF l_pos = 0 THEN
      
        IF l_start = 1 THEN
          self.prn(p_text => p_text);
        ELSE
          self.prn(p_text => substr(p_text,
                                    l_start));
        END IF;
        EXIT;
      END IF;
    
      l_len := l_pos - l_start;
      IF l_len > 0 THEN
        self.prn(p_text => substr(p_text,
                                  l_start,
                                  l_len));
      END IF;
    
      self.prn(p_text => CASE l_pi
                           WHEN 0 THEN
                            p0
                           WHEN 1 THEN
                            p1
                           WHEN 2 THEN
                            p2
                           WHEN 3 THEN
                            p3
                           WHEN 4 THEN
                            p4
                           WHEN 5 THEN
                            p5
                           WHEN 6 THEN
                            p6
                           WHEN 7 THEN
                            p7
                           WHEN 8 THEN
                            p8
                           WHEN 9 THEN
                            p9
                         END);
      l_pi := l_pi + 1;
    
      l_start := l_pos + 2;
    END LOOP;
  END prnf;
  --
  /****************************************************************************
  * Purpose:  write a string, and a line break
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FINAL MEMBER PROCEDURE p(SELF   IN OUT NOCOPY t_writer,
                           p_text IN VARCHAR2) IS
    l_text_length NUMBER := nvl(lengthb(p_text),
                                0);
  BEGIN
    IF l_text_length = 32767 THEN
      self.prn_internal(p_text        => p_text,
                        p_text_length => l_text_length);
      self.prn_internal(p_text        => wwv_flow.lf,
                        p_text_length => 1);
    ELSE
      self.prn_internal(p_text        => p_text || wwv_flow.lf,
                        p_text_length => l_text_length + 1);
    END IF;
  END p;
  --
  /****************************************************************************
  * Purpose:  write a clob, and a line break
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FINAL MEMBER PROCEDURE p(SELF   IN OUT NOCOPY t_writer,
                           p_text IN CLOB) IS
  BEGIN
    self.prn(p_text => p_text);
    self.prn_internal(p_text        => wwv_flow.lf,
                      p_text_length => 1);
  END p;
  --
  /****************************************************************************
  * Purpose:  write a formatted string, with line break (simplified fprintf)
  *           Inspired by wwv_flow_t_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  FINAL MEMBER PROCEDURE pf(SELF   IN OUT NOCOPY t_writer,
                            p_text IN VARCHAR2,
                            p0     IN VARCHAR2,
                            p1     IN VARCHAR2 DEFAULT NULL,
                            p2     IN VARCHAR2 DEFAULT NULL,
                            p3     IN VARCHAR2 DEFAULT NULL,
                            p4     IN VARCHAR2 DEFAULT NULL,
                            p5     IN VARCHAR2 DEFAULT NULL,
                            p6     IN VARCHAR2 DEFAULT NULL,
                            p7     IN VARCHAR2 DEFAULT NULL,
                            p8     IN VARCHAR2 DEFAULT NULL,
                            p9     IN VARCHAR2 DEFAULT NULL) IS
  BEGIN
    self.prnf(p_text => p_text || wwv_flow.lf,
              p0     => p0,
              p1     => p1,
              p2     => p2,
              p3     => p3,
              p4     => p4,
              p5     => p5,
              p6     => p6,
              p7     => p7,
              p8     => p8,
              p9     => p9);
  END pf;
END;
/
