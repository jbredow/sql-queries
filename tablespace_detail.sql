/*  
    tables in tablespace
*/
SELECT 
  OBJ.OBJECT_NAME,
  NVL(OBJ.SUBOBJECT_NAME, NULL) SUB_OBJECT,
  OBJ.OBJECT_ID,
  OBJ.DATA_OBJECT_ID ,
  OBJ.OBJECT_TYPE,
  OBJ.CREATED,
  OBJ.LAST_DDL_TIME,
  OBJ.TIMESTAMP,
  OBJ.STATUS,
/*OBJ.TEMPORARY,
  OBJ.GENERATED,
  OBJ.SECONDARY,*/
  OBJ.NAMESPACE,
  OBJ.EDITION_NAME,
  SEG.TABLESPACE_NAME,
  SUM(bytes) TABLE_SIZE,
  ROUND(
       SUM(bytes) / 1000000
       ,2) GB

FROM USER_OBJECTS OBJ
  LEFT OUTER JOIN USER_SEGMENTS SEG
 ON SEG.SEGMENT_NAME = OBJ.OBJECT_NAME

GROUP BY
  OBJ.OBJECT_NAME,
  NVL(OBJ.SUBOBJECT_NAME, NULL),
  OBJ.OBJECT_ID,
  OBJ.DATA_OBJECT_ID ,
  OBJ.OBJECT_TYPE,
  OBJ.CREATED,
  OBJ.LAST_DDL_TIME,
  OBJ.TIMESTAMP,
  OBJ.STATUS,
  /*OBJ.TEMPORARY,
  OBJ.GENERATED,
  OBJ.SECONDARY,*/
  OBJ.NAMESPACE,
  OBJ.EDITION_NAME,
  SEG.TABLESPACE_NAME
ORDER BY
  SEG.TABLESPACE_NAME,
  OBJ.OBJECT_NAME
;