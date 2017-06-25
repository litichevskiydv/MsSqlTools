SELECT EQP.query_plan, *
FROM sys.dm_exec_requests AS ER
   CROSS APPLY sys.dm_exec_query_plan(ER.plan_handle) AS EQP
WHERE ER.session_id = 172