--гр.251004, Карась А.С.
--1. Показать всю информацию об авторах.
SELECT *
FROM authors

--2. Показать всю информацию о жанрах.
SELECT *
FROM genres

--3. Показать без повторений идентификаторы книг, которые были взяты читателями.
SELECT DISTINCT [sb_book]
FROM [subscriptions]

-- 4. Показать по каждой книге, которую читатели брали в библиотеке, 
-- количество выдач этой книги читателям.
SELECT count(*) AS [taken_times]
FROM [subscriptions]
GROUP BY [sb_book]

--5. Показать, сколько всего читателей зарегистрировано в библиотеке.
SELECT count(*) AS [total_subscribers]
FROM [subscribers]

--6. Показать, сколько всего раз читателям выдавались книги.
SELECT count(*) AS [total_subscriptions]
FROM [subscriptions]

--7. Показать, сколько читателей брало книги в библиотеке.
SELECT count(DISTINCT [sb_subscriber]) AS [subscribers_that_took_book]
FROM [subscriptions]

--8. Показать первую и последнюю даты выдачи книги читателю.
SELECT min(sb_start) AS [first]
	,max(sb_start) AS [last]
FROM [subscriptions]

--9. Показать список авторов в обратном алфавитном порядке (т.е. «Я - А»).
SELECT [a_name]
FROM [authors]
ORDER BY [a_name] DESC

--10. Показать книги, количество экземпляров которых меньше среднего по библиоте-ке.
SELECT b_name
	,b_quantity
FROM books
WHERE b_quantity < (
		SELECT AVG(CAST(b_quantity AS FLOAT)) AS avg_quantity
		FROM books
		)

--11. Показать идентификаторы и даты выдачи книг за первый год работы библиотеки 
--(первым годом работы библиотеки считать все даты с первой выдачи книги 
--по 31-е декабря (включительно) того года, когда библиотека начала работать).
SELECT sb_book
	,sb_start
FROM subscriptions
WHERE YEAR(sb_start) = (
		SELECT MIN(Year(sb_start)) AS min_year
		FROM subscriptions
		)

--12. Показать идентификатор одного (любого) читателя, 
--взявшего в библиотеке больше всего книг.
SELECT TOP 1 sb_subscriber --, count(sb_subscriber) as total_subscriptions --- дописать для наглядности
FROM subscriptions
GROUP BY sb_subscriber
ORDER BY count(sb_subscriber) DESC

--13. Показать идентификаторы всех «самых читающих читателей», 
--взявших в библиотеке больше всего книг.
SELECT DISTINCT sb_subscriber
FROM subscriptions AS outtable
WHERE (
		SELECT count(*)
		FROM subscriptions AS inttable
		WHERE inttable.sb_subscriber = outtable.sb_subscriber
		) = (
		SELECT max(total_books)
		FROM (
			SELECT count(*) AS total_books
			FROM subscriptions
			GROUP BY sb_subscriber
			) AS subquery
		)

--14. Показать идентификатор «читателя-рекордсмена», 
--взявшего в библиотеке боль-ше книг, чем любой другой читатель.
SELECT DISTINCT sb_subscriber
FROM subscriptions AS outtable
WHERE (
		SELECT count(*)
		FROM subscriptions AS inttable
		WHERE inttable.sb_subscriber = outtable.sb_subscriber
		) > ALL (
		SELECT count(*)
		FROM subscriptions AS inttable2
		WHERE inttable2.sb_subscriber != outtable.sb_subscriber
		GROUP BY sb_subscriber
		)
