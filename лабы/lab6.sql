/*
1. ������� �������� �������, ���������� �� ���� ������������� �������� � 
������������ ������ ��������������� ����, ������� �� ��� �������� � ������ � ����������.
*/
DROP FUNCTION

IF EXISTS get_completed_books;

GO

CREATE FUNCTION get_completed_books (@id INT)
RETURNS @book_keys TABLE (book_key INT)
AS
BEGIN
	INSERT @book_keys
	SELECT books.b_id
	FROM books
	JOIN subscriptions
		ON b_id = sb_book
	WHERE sb_subscriber = @id
		AND sb_is_active = N'N'

	RETURN
END;

GO

SELECT *
FROM get_completed_books(1);

/*
2.	������� �������� �������, ������������ ������ ������� ��������� ��������� 
�������� �������������������� ��������� ������ � ��������� ������� 
(��������, ���� � ������� ���� ��������� ����� 1, 4, 8, �� ������ ��������� �������� � ��� �������� 2 � 3).
*/
-- ��� � �����, ��������� �� ��� �����
DROP FUNCTION

IF EXISTS get_first_free_keys;

GO

CREATE FUNCTION get_first_free_keys ()
RETURNS @free_keys TABLE (
	[start] INT
	,[stop] INT
	)
AS
BEGIN
	INSERT @free_keys
	SELECT TOP 1 [start]
		,[stop]
	FROM (
		SELECT [min_t].[sb_id] + 1 AS [start]
			,(
				SELECT MIN([sb_id]) - 1
				FROM [subscriptions] AS [x]
				WHERE [x].[sb_id] > [min_t].[sb_id]
				) AS [stop]
		FROM [subscriptions] AS [min_t]
			
		UNION
			
		SELECT 1 AS [start]
			,(
				SELECT MIN([sb_id]) - 1
				FROM [subscriptions] AS [x]
				WHERE [sb_id] > 0
				) AS [stop]
		) AS [data]
	WHERE [stop] >= [start]
	ORDER BY [start]
		,[stop]

	RETURN
END;

GO

SELECT *
FROM get_first_free_keys();

/*
3.	������� �������� �������, ���������� �� ���� ������������� �������� 
� ������������ 1, ���� � �������� �� ����� ������ ����� ������ ����, � 0 � ��������� ������.
*/
DROP FUNCTION

IF EXISTS is_less_10_books;

GO

CREATE FUNCTION is_less_10_books (@id INT)
RETURNS INT
AS
BEGIN
	DECLARE @result INT = 1;
	DECLARE @books_remained INT;

	SET @books_remained = (
			SELECT count(sb_id)
			FROM subscriptions
			WHERE sb_id = @id
				AND sb_is_active = N'Y'
			);

	IF (@books_remained > 10)
		SET @result = 0;

	RETURN @result;
END;

GO

SELECT dbo.is_less_10_books(4) AS is_less_10_books;

/*
4.	������� �������� �������, ���������� �� ���� ��� ������� ����� � 
������������ 1, ���� ����� ������ ����� ��� ��� �����, � 0 � ��������� ������.
*/
DROP FUNCTION

IF EXISTS is_younger_100_years;

GO

CREATE FUNCTION is_younger_100_years (@year INT)
RETURNS INT
AS
BEGIN
	DECLARE @result INT = 1;
	DECLARE @currYear INT = Year(Getdate());

	IF (@currYear - @year < 100)
		SET @result = 0;

	RETURN @result;
END;

GO

SELECT dbo.is_younger_100_years(4) AS is_younger_100_years;

/*
5.	������� �������� ���������, ����������� ��� ���� ���� DATE 
(���� ����� ����) ���� ������� ��������� ������� �� �������� ������� ����.
*/
DROP PROCEDURE

IF EXISTS update_dates_subsriptions;

GO

CREATE PROCEDURE UpdateDateFields (@tableName NVARCHAR(128))
AS
BEGIN
	DECLARE @sql NVARCHAR(MAX);

	SET @sql = 'UPDATE ' + QUOTENAME(@tableName) + ' SET ';

	SELECT @sql = @sql + QUOTENAME(c.[name]) + ' = GETDATE(), '
	FROM sys.columns c
	INNER JOIN sys.tables t
		ON c.[object_id] = t.[object_id]
	INNER JOIN sys.types ty
		ON c.system_type_id = ty.system_type_id
	WHERE t.[name] = @tableName
		AND ty.[name] = 'date';

	SET @sql = LEFT(@sql, LEN(@sql) - 1);

	EXEC sp_executesql @sql;
END;
		/*
8.	������� �������� ���������, ����������� �� ���������� ��� � ������ � 
�������������� (�����������������, ������������������) ��� ������� ���� ������, 
� ������� ��������� �� ����� ������ �������� �������.
*/
GO

CREATE OR ALTER VIEW database_tables
AS
(
	SELECT DISTINCT [tables].[name]				AS [table_name]
		,[indexes].[name]						AS [index_name]
		,[stats].[avg_fragmentation_in_percent] AS [avg_fragm_perc]
		,[p].[rows]								AS [total_rows]
	FROM sys.indexes AS [indexes]
	INNER JOIN sys.tables AS [tables]
		ON [indexes].[object_id] = [tables].[object_id]
	INNER JOIN sys.dm_db_index_physical_stats(DB_ID(DB_NAME()), NULL, NULL, NULL, 'SAMPLED') AS [stats]
		ON [indexes].[object_id] = [stats].[object_id]
			AND [indexes].[index_id] = [stats].[index_id]
	INNER JOIN sys.partitions AS p
		ON [indexes].[object_id] = [p].[object_id]
			AND [indexes].[index_id] = [p].[index_id]
	WHERE [indexes].[type] = 1
);
GO

DROP PROCEDURE

IF EXISTS OPTIMIZE_ALL_TABLES;

GO

CREATE PROCEDURE OPTIMIZE_ALL_TABLES
AS
BEGIN
	DECLARE @table_name		NVARCHAR(200);
	DECLARE @index_name		NVARCHAR(200);
	DECLARE @avg_fragm_perc DOUBLE PRECISION;
	DECLARE @query_text		NVARCHAR(2000);

	DECLARE indexes_cursor CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT DISTINCT [table_name]
		,[index_name]
		,[avg_fragm_perc]
	FROM database_tables
	WHERE total_rows > = 1000000;

	OPEN indexes_cursor;

	FETCH NEXT
	FROM indexes_cursor
	INTO @table_name
		,@index_name
		,@avg_fragm_perc;

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@avg_fragm_perc >= 5.0)
			AND (@avg_fragm_perc <= 30.0)
		BEGIN
			SET @query_text = CONCAT (
					'ALTER INDEX ['
					,@index_name
					,'] ON ['
					,@table_name
					,'] REORGANIZE'
					);

			PRINT CONCAT (
					'Index ['
					,@index_name
					,'] on ['
					,@table_name
					,'] will be REORGANIZED...'
					);

			EXECUTE sp_executesql @query_text;
		END;

		IF (@avg_fragm_perc > 30.0)
		BEGIN
			SET @query_text = CONCAT (
					'ALTER INDEX ['
					,@index_name
					,'] ON ['
					,@table_name
					,'] REBUILD'
					);

			PRINT CONCAT (
					'Index ['
					,@index_name
					,'] on ['
					,@table_name
					,'] will be REBUILT...'
					);

			EXECUTE sp_executesql @query_text;
		END;

		IF (@avg_fragm_perc < 5.0)
		BEGIN
			PRINT CONCAT (
					'Index ['
					,@index_name
					,'] on ['
					,@table_name
					,'] needs no optimization...'
					);
		END;

		FETCH NEXT
		FROM indexes_cursor
		INTO @table_name
			,@index_name
			,@avg_fragm_perc;
	END;

	CLOSE indexes_cursor;

	DEALLOCATE indexes_cursor;
END;

EXEC msdb.dbo.sp_add_job @job_name = N'OptimizeIndexesWeekly';

EXEC msdb.dbo.sp_add_jobstep @job_name = N'OptimizeIndexesWeekly'
	,@step_name = N'RunOptimization'
	,@subsystem = N'TSQL'
	,@command = N'EXEC OPTIMIZE_ALL_TABLES;'
	,@on_success_action = 1;

EXEC msdb.dbo.sp_add_schedule @schedule_name = N'WeeklyOptimization'
	,@freq_type = 8
	,@freq_interval = 1
	,@active_start_time = 010000;

EXEC msdb.dbo.sp_attach_schedule @job_name = N'OptimizeIndexesWeekly'
	,@schedule_name = N'WeeklyOptimization';

EXEC msdb.dbo.sp_add_jobserver @job_name = N'OptimizeIndexesWeekly';