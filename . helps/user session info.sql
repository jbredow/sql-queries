SELECT s.inst_id,
       s."TYPE",
       s.sid,
       s.serial#,
       p.spid,
       s.username,
       E.ASSOC_NAME,
       E.WAREHOUSE_ASSIGNED_NK,
       E.TITLE_DESC,
       s.program,
       --s.COMMAND,
       s.STATUS,
       --s.PROCESS,
       --s.WAIT_TIME,
       ROUND (s.SECONDS_IN_WAIT / 60, 3) AS MIN_IN_WAIT,
       p.PGA_USED_MEM,
       p.PGA_ALLOC_MEM,
       p.PGA_FREEABLE_MEM,
       p.PGA_MAX_MEM
  --s.CURRENT_QUEUE_DURATION,
  --s.TIME_REMAINING_MICRO
  FROM gv$session s
       JOIN gv$process p ON p.addr = s.paddr AND p.inst_id = s.inst_id
       LEFT OUTER JOIN DW_FEI.EMPLOYEE_DIMENSION E
          ON s.USERNAME = E.USER_LOGON
WHERE s.TYPE != 'BACKGROUND';
