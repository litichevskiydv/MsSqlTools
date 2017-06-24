SELECT db_name(mid.database_id), OBJECT_NAME(mid.object_id), [Рекомендуемый индекс] = '-- CREATE INDEX [IX_' + OBJECT_NAME(mid.object_id) + '_' + CAST(mid.index_handle AS nvarchar) + '] ON ' + mid.statement + ' (' + ISNULL(mid.equality_columns,'') + ', ' + ISNULL(mid.inequality_columns,'') + ') INCLUDE (' + ISNULL(mid.included_columns,'') + ') with (online=on) on [primary]', eai = cast((migs.user_seeks + migs.user_scans * 10) * (avg_total_user_cost * ((migs.avg_user_impact + 100) / 100)) as int), [Число компиляций] = migs.unique_compiles, [Количество операций поиска] = migs.user_seeks, [Последняя операция поиска] = migs.last_user_seek, [Количество операций просмотра] = migs.user_scans, [Последняя операция просмотра] = migs.last_user_scan, [Средняя стоимость] = CAST(migs.avg_total_user_cost AS int), [Средний процент выигрыша] = CAST(migs.avg_user_impact AS int), db_name(mid.database_id) as dbName FROM sys.dm_db_missing_index_groups mig JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle AND mid.database_id = DB_ID() AND (migs.last_user_seek is not null or migs.last_user_scan is not null) AND (migs.last_user_seek is null or migs.last_user_seek > getDate()-7) AND (migs.last_user_scan is null or migs.last_user_scan > getDate()-7) --and (migs.last_user_seek > getDate() - 2 -- or migs.last_user_scan > getDate() - 2) -- and OBJECT_NAME(mid.object_id) = 'EventJournal' --and (migs.user_seeks > 50 or migs.user_scans > 5) 
order by migs.user_seeks desc, (migs.user_seeks + migs.user_scans * 10) * (avg_total_user_cost * ((migs.avg_user_impact + 100) / 100)) desc