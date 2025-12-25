--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
/*1.	Создать хранимую процедуру, которая:
a.	добавляет каждой книге два случайных жанра;
b.	отменяет совершённые действия, если в процессе работы хотя бы 
	одна операция вставки завершилась ошибкой в силу дублирования значения 
	первичного ключа таблицы «m2m_books_genres» (т.е. у такой книги уже был такой жанр).*/
DROP PROCEDURE IF EXISTS TWO_RANDOM_GENRES;

GO

CREATE PROCEDURE TWO_RANDOM_GENRES
AS
BEGIN
	SET IMPLICIT_TRANSACTIONS OFF;

	DECLARE @b_id_value INT;
	DECLARE @g_id_value INT;

	DECLARE books_cursor CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT [b_id]
	FROM [books];

	DECLARE genres_cursor CURSOR LOCAL FAST_FORWARD
	FOR
	SELECT TOP 2 [g_id]
	FROM [genres]
	ORDER BY NEWID();

	DECLARE @fetch_books_cursor INT;
	DECLARE @fetch_genres_cursor INT;

	PRINT 'Starting transaction...';

	BEGIN TRANSACTION;

	OPEN books_cursor;

	FETCH NEXT
	FROM books_cursor
	INTO @b_id_value;

	SET @fetch_books_cursor = @@FETCH_STATUS;

	WHILE @fetch_books_cursor = 0
	BEGIN
		OPEN genres_cursor;

		FETCH NEXT
		FROM genres_cursor
		INTO @g_id_value;

		SET @fetch_genres_cursor = @@FETCH_STATUS;

		WHILE @fetch_genres_cursor = 0
		BEGIN
			INSERT INTO [m2m_books_genres] (
				[b_id]
				,[g_id]
				)
			VALUES (
				@b_id_value
				,@g_id_value
				);

			FETCH NEXT
			FROM genres_cursor
			INTO @g_id_value;

			SET @fetch_genres_cursor = @@FETCH_STATUS;
		END;

		CLOSE genres_cursor;

		FETCH NEXT
		FROM books_cursor
		INTO @b_id_value;

		SET @fetch_books_cursor = @@FETCH_STATUS;
	END;

	CLOSE books_cursor;

	DEALLOCATE books_cursor;

	DEALLOCATE genres_cursor;

	IF EXISTS (
			SELECT [b_id]
				,[g_id]
			FROM [m2m_books_genres]
			GROUP BY [b_id]
				,[g_id]
			HAVING COUNT(*) > 1
			)
	BEGIN
		PRINT 'Rolling transaction back...';

		ROLLBACK TRANSACTION;
	END
	ELSE
	BEGIN
		PRINT 'Committing transaction...';

		COMMIT TRANSACTION;
	END;

	SET IMPLICIT_TRANSACTIONS ON;
END;

GO

EXECUTE TWO_RANDOM_GENRES;

SELECT *
FROM genres;

/*2.	Создать хранимую процедуру, которая:
a.	увеличивает значение поля «b_quantity» для всех книг в два раза;
b.	отменяет совершённое действие, если по итогу выполнения операции 
	среднее количество экземпляров книг превысит значение 50.*/
DROP PROCEDURE IF EXISTS CHANGE_QUANTITY;

GO

CREATE PROCEDURE CHANGE_QUANTITY
AS
BEGIN
	DECLARE @avg_books DOUBLE PRECISION;

	PRINT 'Starting transaction...';

	BEGIN TRANSACTION;

	UPDATE [books]
	SET [b_quantity] = [b_quantity] * 2;

	SET @avg_books = (
			SELECT AVG(b_quantity)
			FROM [books]
			);

	IF (@avg_books > 50)
	BEGIN
		PRINT 'Rolling transaction back...';

		ROLLBACK TRANSACTION;
	END
	ELSE
	BEGIN
		PRINT 'Committing transaction...';

		COMMIT TRANSACTION;
	END;
END;

GO

EXECUTE CHANGE_QUANTITY;

SELECT *
FROM books;

/*3.	Написать запросы, которые, будучи выполненными параллельно, обеспечивали бы следующий эффект:
a.	первый запрос должен считать количество выданных на руки и возвращённых в библиотеку книг и 
	не зависеть от запросов на обновление таблицы «subscriptions» (не ждать их завершения);
b.	второй запрос должен инвертировать значения поля «sb_is_active» таблицы subscriptions с 
	«Y» на «N» и наоборот и не зависеть от первого запроса (не ждать его завершения).*/
/*транзакция a*/
SELECT @@SPID;

SET IMPLICIT_TRANSACTIONS ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION;

SELECT SUM(CASE 
			WHEN sb_is_active = 'Y'
				THEN 1
			ELSE 0
			END) AS issued_books
	,SUM(CASE 
			WHEN sb_is_active = 'N'
				THEN 1
			ELSE 0
			END) AS returned_books
FROM subscriptions;

-- WAITFOR DELAY '00:00:10'; --имитация долгого выполнения
COMMIT TRANSACTION;

/*транзакция b*/
SELECT @@SPID;

SET IMPLICIT_TRANSACTIONS ON;

BEGIN TRANSACTION;

UPDATE subscriptions
SET sb_is_active = CASE 
		WHEN sb_is_active = 'Y'
			THEN 'N'
		WHEN sb_is_active = 'N'
			THEN 'Y'
		ELSE sb_is_active
		END;

-- WAITFOR DELAY '00:00:10'; --имитация долгого выполнения
COMMIT TRANSACTION;

SELECT *
FROM subscriptions;

/*5.	Написать код, в котором запрос, инвертирующий значения поля «sb_is_active» 
таблицы «subscriptions» с «Y» на «N» и наоборот, будет иметь максимальные шансы на 
успешное завершение в случае возникновения ситуации взаимной блокировки с другими транзакциями.*/
SELECT @@SPID;

SET IMPLICIT_TRANSACTIONS ON;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRANSACTION;

UPDATE [subscriptions]
SET [sb_is_active] = CASE 
		WHEN [sb_is_active] = 'Y'
			THEN 'N'
		WHEN [sb_is_active] = 'N'
			THEN 'Y'
		END;

COMMIT TRANSACTION;
	/*6.	Создать на таблице «subscriptions» триггер, определяющий 
уровень изолированности транзакции, в котором сейчас проходит операция обновления, 
и отменяющий операцию, если уровень изолированности транзакции отличен от REPEATABLE READ.*/
GO

CREATE OR ALTER TRIGGER [subscriptions_ins_trans] 
ON [subscriptions]
AFTER INSERT
AS
BEGIN
	DECLARE @isolation_level INT;

	SET @isolation_level = (
			SELECT [transaction_isolation_level]
			FROM [sys].[dm_exec_sessions]
			WHERE [session_id] = @@SPID
			);

	IF (@isolation_level <> 3)
	BEGIN
		RAISERROR (
				'Please, switch your transaction to REPEATABLE READ isolation
					level and rerun this UPDATE again.'
				,16
				,1
				);

		ROLLBACK TRANSACTION;
	END;

	RETURN
END;
GO

/* проверочный код для первой транзакции */
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

UPDATE [subscriptions]
SET [sb_is_active] = CASE 
		WHEN [sb_is_active] = 'Y'
			THEN 'N'
		WHEN [sb_is_active] = 'N'
			THEN 'Y'
		END;

/* проверочный код для второй транзакции */
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

UPDATE [subscriptions]
SET [sb_is_active] = CASE 
		WHEN [sb_is_active] = 'Y'
			THEN 'N'
		WHEN [sb_is_active] = 'N'
			THEN 'Y'
		END;
	
/*7.	Создать хранимую функцию, порождающую исключительную ситуацию в случае, 
если выполняются оба условия (подсказка: эта задача имеет решение только для MS SQL Server):
a.	режим автоподтверждения транзакций выключен;
b.	функция запущена из вложенной транзакции.*/
GO

CREATE OR ALTER FUNCTION NO_AUTOCOMMITT_FROM_INNER_TRANSACTIONS ()
RETURNS INT
	WITH SCHEMABINDING
AS
BEGIN
	DECLARE @autocommit INT;

	IF (
			@@TRANCOUNT = 0
			AND (@@OPTIONS & 2 = 0)
			)
	BEGIN
		IF @@TRANCOUNT > 1
		BEGIN
			SET @autocommit = 1;
		END
	END
	ELSE IF (
			@@TRANCOUNT = 0
			AND (@@OPTIONS & 2 = 2)
			)
	BEGIN
		SET @autocommit = 0;
	END
	ELSE IF (@@OPTIONS & 2 = 0)
	BEGIN
		SET @autocommit = 1;
	END
	ELSE
	BEGIN
		SET @autocommit = 0;
	END;

	IF (@autocommit = 1)
	BEGIN
		RETURN CAST('Please, turn the autocommit off.' AS INT);
	END;

	RETURN 0;
END;

GO

/*8.	Создать хранимую процедуру, выполняющую подсчёт количества записей в указанной 
таблице таким образом, чтобы она возвращала максимально корректные данные, 
даже если для достижения этого результата придётся пожертвовать производительностью.*/
CREATE OR ALTER PROCEDURE COUNT_ROWS 
	@table_name NVARCHAR(150)
	,@rows_in_table INT OUTPUT
AS
BEGIN
	DECLARE @count_query NVARCHAR(1000) = '';

	BEGIN TRANSACTION

	BEGIN TRY
		-- избегаем фантомных записей
		SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
		SET @count_query = CONCAT (
				'SET @rows_f = (SELECT COUNT(1) FROM ['
				,@table_name
				,'])'
				);

		EXECUTE sp_executesql @count_query
			,N'@rows_f INT OUTPUT'
			,@rows_in_table OUTPUT;

		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;

		DECLARE @ErrorMessage NVARCHAR(2048) = ERROR_MESSAGE();

		THROW 50000
			,@ErrorMessage
			,1;
	END CATCH
END;

GO

DECLARE @res INT;

EXEC COUNT_ROWS 'books'
	,@res OUTPUT;

SELECT @res AS rows_count;