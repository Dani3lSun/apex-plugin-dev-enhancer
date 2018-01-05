CREATE OR REPLACE TYPE t_writer AS OBJECT
(
--
-- internal attributes for buffering output (may not be used by all subtypes)
  l_temp        VARCHAR2(32767 BYTE),
  l_temp_length NUMBER,
--
-- constructor
-- #param self
-- #return self
  CONSTRUCTOR FUNCTION t_writer(SELF IN OUT NOCOPY t_writer)
    RETURN SELF AS RESULT,
--
-- free the resource
-- #param self
  MEMBER PROCEDURE free(SELF IN OUT NOCOPY t_writer),
--
-- write any pending changes, in case the writer does caching
-- #param self
  MEMBER PROCEDURE flush(SELF IN OUT NOCOPY t_writer),
--
-- internal prn routine - do not use directly
-- #param self
-- #param p_text
-- #param p_text_length
  FINAL MEMBER PROCEDURE prn_internal(SELF          IN OUT NOCOPY t_writer,
                                      p_text        IN VARCHAR2,
                                      p_text_length IN NUMBER),
--
-- write a string, without line break
-- #param self
-- #param p_text
  FINAL MEMBER PROCEDURE prn(SELF   IN OUT NOCOPY t_writer,
                             p_text IN VARCHAR2),
--
-- write a clob, without line break
-- #param self
-- #param p_text
  FINAL MEMBER PROCEDURE prn(SELF   IN OUT NOCOPY t_writer,
                             p_text IN CLOB),
--
-- write a formatted string, without line break (simplified fprintf)
-- #param self
-- #param p_text
-- #param p0
-- #param p1
-- #param p2
-- #param p3
-- #param p4
-- #param p5
-- #param p6
-- #param p7
-- #param p8
-- #param p9
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
                              p9     IN VARCHAR2 DEFAULT NULL),
--
-- write a string, and a line break
-- #param self
-- #param p_text
  FINAL MEMBER PROCEDURE p(SELF   IN OUT NOCOPY t_writer,
                           p_text IN VARCHAR2),
--
-- write a clob, and a line break
-- #param self
-- #param p_text
  FINAL MEMBER PROCEDURE p(SELF   IN OUT NOCOPY t_writer,
                           p_text IN CLOB),
--
-- write a formatted string, with line break (simplified fprintf)
-- #param self
-- #param p_text
-- #param p0
-- #param p1
-- #param p2
-- #param p3
-- #param p4
-- #param p5
-- #param p6
-- #param p7
-- #param p8
-- #param p9
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
                            p9     IN VARCHAR2 DEFAULT NULL)

)
NOT INSTANTIABLE NOT FINAL;
/
