CREATE OR REPLACE TYPE t_dbms_output_writer UNDER t_writer
(
--
-- constructor
-- #param self
-- #return self
  CONSTRUCTOR FUNCTION t_dbms_output_writer(SELF IN OUT NOCOPY t_dbms_output_writer)
    RETURN SELF AS RESULT,
--
-- write any pending changes to dbms_output
-- #param self
  OVERRIDING MEMBER PROCEDURE flush(SELF IN OUT NOCOPY t_dbms_output_writer)
)
;
/
