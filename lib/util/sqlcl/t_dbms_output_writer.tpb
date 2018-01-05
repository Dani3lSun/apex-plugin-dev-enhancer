CREATE OR REPLACE TYPE BODY t_dbms_output_writer AS
  --
  /****************************************************************************
  * Purpose:  constructor
  *           Inspired by wwv_flow_t_dbms_output_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  CONSTRUCTOR FUNCTION t_dbms_output_writer(SELF IN OUT NOCOPY t_dbms_output_writer)
    RETURN SELF AS RESULT IS
  BEGIN
    self.l_temp_length := 0;
    self.l_temp        := NULL;
    RETURN;
  END t_dbms_output_writer;
  --
  /****************************************************************************
  * Purpose:  write any pending changes to dbms_output
  *           Inspired by wwv_flow_t_dbms_output_writer
  * Author:   Daniel Hochleitner
  * Created:  02.01.2018
  * Changed:
  ****************************************************************************/
  OVERRIDING MEMBER PROCEDURE flush(SELF IN OUT NOCOPY t_dbms_output_writer) IS
    l_start PLS_INTEGER := 1;
    l_pos   PLS_INTEGER := instr(self.l_temp,
                                 wwv_flow.lf);
  BEGIN
    IF self.l_temp_length > 0 THEN
      WHILE l_pos > 0 LOOP
        sys.dbms_output.put_line(substr(self.l_temp,
                                        l_start,
                                        l_pos - l_start));
        l_start := l_pos + 1;
        l_pos   := instr(self.l_temp,
                         wwv_flow.lf,
                         l_start);
      END LOOP;
      IF l_start > self.l_temp_length THEN
        NULL;
      ELSIF l_start = 1 THEN
        sys.dbms_output.put(self.l_temp);
      ELSE
        sys.dbms_output.put(substr(self.l_temp,
                                   l_start));
      END IF;
    
      self.l_temp_length := 0;
      self.l_temp        := NULL;
    END IF;
  END flush;
END;
/
