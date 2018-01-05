CREATE OR REPLACE TYPE t_blob_writer UNDER t_writer
(
--
-- input and output character sets
  l_from_charset    VARCHAR2(100),
  l_to_charset      VARCHAR2(100),
  l_need_convert_01 NUMBER,
  l_cache_01        NUMBER,
  l_dur             NUMBER,
--
-- the blob value
  l_blob BLOB,
--
-- constructor that creates a temporary blob
-- #param self
-- #param p_from_charset
-- #param p_to_charset
-- #param p_cache
-- #param p_dur
  CONSTRUCTOR FUNCTION t_blob_writer(SELF           IN OUT NOCOPY t_blob_writer,
                                     p_from_charset IN VARCHAR2 DEFAULT NULL,
                                     p_to_charset   IN VARCHAR2 DEFAULT 'american_america.al32utf8',
                                     p_cache        IN BOOLEAN DEFAULT TRUE,
                                     p_dur          IN PLS_INTEGER DEFAULT NULL)
    RETURN SELF AS RESULT,
--
-- free the temporary blob
-- #param self
  OVERRIDING MEMBER PROCEDURE free(SELF IN OUT NOCOPY t_blob_writer),
--
-- write any pending changes to l_blob
-- #param self
  OVERRIDING MEMBER PROCEDURE flush(SELF IN OUT NOCOPY t_blob_writer),
--
-- flush changes and return the blob value
-- #param self
-- #return BLOB
  MEMBER FUNCTION get_value(SELF IN OUT NOCOPY t_blob_writer) RETURN BLOB
)
/
