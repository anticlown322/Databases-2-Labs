--WARNING! ERRORS ENCOUNTERED DURING SQL PARSING!
--1. Создать представление, позволяющее получать список читателей с 
--количеством находящихся у каждого читателя на руках книг, 
--но отображающее только таких читателей, по которым имеются задолженности, 
--т.е. на руках у читателя есть хотя бы одна книга, которую он должен был 
--вернуть до наступления текущей даты.
CREATE OR ALTER VIEW subscribers_with_book_debt
AS
SELECT subscribers.s_id
	,subscribers.s_name
	,count(subscriptions.sb_id) AS debt
FROM subscribers
INNER JOIN subscriptions
	ON subscribers.s_id = subscriptions.sb_subscriber
WHERE subscriptions.sb_is_active = 'Y'
	AND subscriptions.sb_finish < GETDATE()
GROUP BY subscribers.s_id
	,subscribers.s_name;
GO

SELECT *
FROM subscribers_with_book_debt;

--2. Создать кэширующее представление, позволяющее получать список всех книг 
--и их жанров (две колонки: первая – название книги, 
--вторая – жанры книги, перечисленные через запятую).
DROP TABLE IF EXISTS book_names_and_genres;
CREATE TABLE book_names_and_genres (
		book_name NVARCHAR(255)
		,book_genres NVARCHAR(511)
		);
TRUNCATE TABLE book_names_and_genres;

INSERT INTO book_names_and_genres (
	book_name
	,book_genres
	)
SELECT books.b_name
	,string_agg(genres.g_name, ', ') AS genres
FROM books
JOIN m2m_books_genres bg
	ON books.b_id = bg.b_id
JOIN genres
	ON genres.g_id = bg.g_id
GROUP BY books.b_name;

SELECT *
FROM book_names_and_genres;

--3. Создать кэширующее представление, позволяющее получать список 
--всех авторов и их книг (две колонки: первая – имя автора, 
--вторая – написанные автором книги, перечисленные через запятую).
DROP TABLE IF EXISTS authors_and_their_books;
CREATE TABLE authors_and_their_books (
		author_name NVARCHAR(255) NOT NULL
		,author_books NVARCHAR(max)
		);
TRUNCATE TABLE authors_and_their_books;

INSERT INTO authors_and_their_books (
	author_name
	,author_books
	)
SELECT authors.a_name
	,string_agg(books.b_name, ', ')
FROM authors
JOIN m2m_books_authors ba
	ON authors.a_id = ba.a_id
JOIN books
	ON books.b_id = ba.b_id
GROUP BY authors.a_name;

SELECT *
FROM authors_and_their_books;

--4. Создать представление, через которое невозможно получить информацию 
--о том, какая конкретно книга была выдана читателю в любой из выдач.
GO

CREATE OR ALTER VIEW subscriptions_with_no_book_id
AS
SELECT subscriptions.sb_id
	,subscriptions.sb_subscriber
	,subscriptions.sb_start
	,subscriptions.sb_finish
	,subscriptions.sb_is_active
FROM subscriptions;

GO

SELECT *
FROM subscriptions_with_no_book_id;
--5. Создать представление, возвращающее всю информацию из таблицы 
--subscriptions, преобразуя даты из полей sb_start и sb_finish в формат 
--«ГГГГ-ММ-ДД НН», где «НН» – день недели в виде своего полного названия 
--(т.е. «Понедельник», «Вторник» и т.д.)
GO

CREATE OR ALTER VIEW subscriptions_with_enhanced_dates
AS
SELECT sb_id
	,sb_book
	,sb_subscriber
	,CONVERT(NVARCHAR(10), sb_start, 120) + ' ' + DATENAME(dw, sb_start) AS sb_start_enhanced
	,CONVERT(NVARCHAR(10), sb_finish, 120) + ' ' + DATENAME(dw, sb_finish) AS sb_finish_enhanced
	,sb_is_active
FROM subscriptions;

GO

SELECT *
FROM subscriptions_with_enhanced_dates;

--6. Создать представление, извлекающее информацию о книгах, переводя 
--весь текст в верхний регистр и при этом допускающее модификацию списка книг.
GO

CREATE OR ALTER VIEW books_upper_case
AS
SELECT b_id
	,UPPER(b_name) AS upper_b_name
	,b_quantity
	,b_year
FROM books;
GO

SELECT *
FROM books_upper_case;
GO

CREATE OR ALTER TRIGGER books_upper_case_ins 
ON books_upper_case
INSTEAD OF INSERT
AS
SET IDENTITY_INSERT books ON;

INSERT INTO books (
	b_id
	,b_name
	,b_quantity
	,b_year
	)
SELECT (
		CASE 
			WHEN b_id IS NULL
				OR b_id = 0
				THEN IDENT_CURRENT('subscribers') 
				+ IDENT_INCR('subscribers') 
				+ ROW_NUMBER() OVER (
						ORDER BY (
								SELECT 1
								)
						) - 1
			ELSE b_id
			END
		) AS b_id
	,upper_b_name
	,b_quantity
	,b_year
FROM inserted;

SET IDENTITY_INSERT books OFF;

GO

CREATE OR ALTER TRIGGER books_upper_case_upd 
ON books_upper_case
INSTEAD OF UPDATE
AS
IF UPDATE (b_id)
BEGIN
	RAISERROR (
			'UPDATE of Primary Key through
		 [subscribers_upper_case_upd]
		view is prohibited.'
			,16
			,1
			);

	ROLLBACK;
END ELSE
UPDATE books
SET books.b_name = inserted.upper_b_name
	,books.b_quantity = inserted.b_quantity
	,books.b_year = inserted.b_year
FROM books
JOIN inserted
	ON inserted.b_id = books.b_id;

--7. Создать представление, извлекающее информацию о датах выдачи и возврата 
--книг и состоянии выдачи книги в виде единой строки в формате 
--«ГГГГ-ММ-ДД - ГГГГ-ММ-ДД - Возвращена» и при этом допускающее обновление 
--информации в таблице subscriptions.
GO

CREATE OR ALTER VIEW subsriptions_compressed_dates
AS
SELECT sb_id
	,sb_book
	,sb_subscriber
	,convert(NVARCHAR(10), sb_start, 120) + N' - ' + convert(NVARCHAR(10), sb_finish, 120) + N' - ' + sb_is_active AS dates_and_status
FROM subscriptions;

GO

SELECT *
FROM subsriptions_compressed_dates;
GO

CREATE OR ALTER TRIGGER subsriptions_compressed_dates_ins 
ON subsriptions_compressed_dates
INSTEAD OF INSERT
AS
SET IDENTITY_INSERT subscriptions ON;

INSERT INTO subscriptions (
	sb_id
	,sb_subscriber
	,sb_book
	,sb_start
	,sb_finish
	,sb_is_active
	)
SELECT (
		CASE 
			WHEN sb_id IS NULL
				OR sb_id = 0
				THEN IDENT_CURRENT('subscriptions') 
				+ IDENT_INCR('subscriptions') 
				+ ROW_NUMBER() OVER (
						ORDER BY (
								SELECT 1
								)
						) - 1
			ELSE sb_id
			END
		) AS sb_id
	,sb_subscriber
	,sb_book
	,SUBSTRING(dates_and_status, 1, 10) -- 10 - длина даты в формате гггг-мм-дд
	AS sb_start
	,SUBSTRING(dates_and_status, 14, 10) -- 14 - первый символ второй даты
	AS sb_finish
	,SUBSTRING(dates_and_status, 27, 1) -- 27 - символ активности подписки
	AS sb_is_active
FROM inserted;

SET IDENTITY_INSERT subscriptions OFF;

GO

CREATE OR ALTER TRIGGER subsriptions_compressed_dates_upd 
ON subsriptions_compressed_dates
INSTEAD OF UPDATE
AS
IF UPDATE ([sb_id])
BEGIN
	RAISERROR (
			'UPDATE of Primary Key through
					 [subscriptions_wcd_upd]
					view is prohibited.'
			,16
			,1
			);

	ROLLBACK;
END ELSE
UPDATE subscriptions
SET subscriptions.sb_subscriber = inserted.sb_subscriber
	,subscriptions.sb_book = inserted.sb_book
	,subscriptions.sb_start = SUBSTRING(dates_and_status, 1, 10)
	,subscriptions.sb_finish = SUBSTRING(dates_and_status, 14, 10)
	,subscriptions.sb_is_active = SUBSTRING(dates_and_status, 27, 1)
FROM subscriptions
JOIN inserted
	ON subscriptions.sb_id = inserted.sb_id;

--13. Создать триггер, не позволяющий добавить в базу данных информацию о 
--выдаче книги, если выполняется хотя бы одно из условий:
--•	дата выдачи или возврата приходится на воскресенье;
--•	читатель брал за последние полгода более 100 книг;
--•	промежуток времени между датами выдачи и возврата менее трёх дней.
GO

CREATE OR ALTER TRIGGER add_subscription_by_conditions 
ON subscriptions
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @count INT;
	SET @count = (
			SELECT COUNT(*)
			FROM subscriptions s
			WHERE s.sb_subscriber = sb_subscriber
				AND s.sb_start >= DATEADD(MONTH, - 6, GETDATE())
			);

	IF NOT EXISTS (
			SELECT 1
			FROM inserted
			WHERE (
					DATEPART(WEEKDAY, sb_start) = 1
					OR DATEPART(WEEKDAY, sb_finish) = 1
					)
				OR @count > 100
				OR DATEDIFF(DAY, sb_start, sb_finish) < 3
			)
	BEGIN
		INSERT INTO subscriptions (
			sb_subscriber
			,sb_book
			,sb_start
			,sb_finish
			,sb_is_active
			)
		SELECT sb_subscriber
			,sb_book
			,sb_start
			,sb_finish
			,sb_is_active
		FROM inserted;
	END
END;