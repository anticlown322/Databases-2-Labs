-- 1.	Показать список книг, у которых более одного автора.
SELECT books.b_id
	,books.b_name
FROM books
JOIN m2m_books_authors ba
	ON ba.b_id = books.b_id
GROUP BY books.b_name
	,books.b_id
HAVING count(books.b_name) > 1;

-- 2. Показать список книг, относящихся ровно к одному жанру.
SELECT books.b_id
	,books.b_name
FROM books
JOIN m2m_books_genres bg
	ON books.b_id = bg.b_id
GROUP BY books.b_name
	,books.b_id
HAVING count(books.b_name) = 1;

--3. Показать все книги с их жанрами (дублирование названий книг не допускается).
SELECT b_name
	,string_agg(g_name, ', ') WITHIN GROUP ( ORDER BY g_name ASC) AS [genre(s)]
FROM books
JOIN m2m_books_genres bg
	ON books.b_id = bg.b_id
JOIN genres
	ON genres.g_id = bg.g_id
GROUP BY books.b_name
ORDER BY books.b_name;

--5. показать список книг, которые когда-либо были взяты читателями.
SELECT books.b_id
	,books.b_name
FROM books
JOIN subscriptions
	ON books.b_id = subscriptions.sb_book
GROUP BY books.b_id
	,books.b_name;

--6. Показать список книг, которые никто из читателей никогда не брал.
SELECT b_id
	,b_name
FROM books
WHERE b_id NOT IN (
		SELECT sb_book
		FROM subscriptions
		);

--7. Показать список книг, ни один экземпляр которых сейчас 
-- не находится на руках у читателей.
SELECT b_id
	,b_name
FROM books
WHERE b_id NOT IN (
		SELECT sb_book
		FROM subscriptions
		WHERE subscriptions.sb_is_active = 'Y'
		);

--8. Показать книги, написанные Пушкиным и/или Азимовым 
--(индивидуально или в соавторстве – не важно).
SELECT books.b_id
	,books.b_name
FROM books
JOIN m2m_books_authors ba
	ON books.b_id = ba.b_id
JOIN authors
	ON authors.a_id = ba.a_id
WHERE authors.a_name IN (
		N'А. Азимов'
		,N'А.С. Пушкин'
		)
GROUP BY books.b_id
	,books.b_name;

--альтернативно, вместо второго join и where вставить
--where ba.a_id in (select a_id
--					from authors
--					where a_name in (N'А. Азимов', N'А.С. Пушкин'))
--9. Показать книги, написанные Карнеги и Страуструпом в соавторстве.
SELECT books.b_id
	,books.b_name
FROM books
JOIN m2m_books_authors ba
	ON books.b_id = ba.b_id
JOIN authors
	ON authors.a_id = ba.a_id
WHERE authors.a_name IN (
		N'Д. Карнеги'
		,N'Б. Страуструп'
		)
GROUP BY books.b_id
	,books.b_name
HAVING count(authors.a_id) = 2;

--альтернативное решение аналогично предыдущему заданию
--10. Показать авторов, написавших более одной книги.
SELECT authors.a_id
	,authors.a_name
FROM authors
JOIN m2m_books_authors ba
	ON authors.a_id = ba.a_id
GROUP BY authors.a_id
	,authors.a_name
HAVING count(authors.a_id) > 1;

--11. Показать книги, относящиеся к более чем одному жанру.
SELECT books.b_id
	,b_name
FROM books
JOIN m2m_books_genres bg
	ON books.b_id = bg.b_id
GROUP BY books.b_id
	,b_name
HAVING count(g_id) > 1;

--12. Показать читателей, у которых сейчас на руках больше одной книги.
SELECT subscribers.s_id
	,subscribers.s_name
FROM subscribers
JOIN subscriptions
	ON subscribers.s_id = subscriptions.sb_subscriber
WHERE subscriptions.sb_is_active = 'Y'
GROUP BY subscribers.s_id
	,subscribers.s_name
HAVING count(subscribers.s_id) > 1;

--13. Показать, сколько экземпляров каждой книги сейчас выдано читателям.
SELECT b_name
	,count(b_id) AS active_count
FROM books
JOIN subscriptions sb
	ON books.b_id = sb.sb_book
WHERE sb.sb_is_active = 'Y'
GROUP BY b_name;

--14. Показать всех авторов и количество экземпляров книг по каждому автору.
SELECT authors.a_name
	,sum(books.b_quantity) AS quantity
FROM authors
JOIN m2m_books_authors ba
	ON authors.a_id = ba.a_id
JOIN books
	ON books.b_id = ba.b_id
GROUP BY authors.a_name;

--15.	Показать всех авторов и количество книг (не экземпляров книг, 
--а «книг как изда-ний») по каждому автору.
SELECT authors.a_name
	,count(books.b_id) AS amount
FROM authors
JOIN m2m_books_authors ba
	ON authors.a_id = ba.a_id
JOIN books
	ON books.b_id = ba.b_id
GROUP BY authors.a_name;

-- 16. Показать всех читателей, не вернувших книги, и количество 
--невозвращённых книг по каждому такому читателю.
SELECT subscribers.s_id
	,subscribers.s_name
	,count(subscriptions.sb_subscriber) AS not_returned
FROM subscribers
JOIN subscriptions
	ON subscribers.s_id = subscriptions.sb_subscriber
WHERE subscriptions.sb_is_active = 'Y'
GROUP BY subscribers.s_id
	,subscribers.s_name;

--17. Показать читаемость жанров, т.е. все жанры и то количество раз, 
--которое книги этих жанров были взяты читателями.
SELECT genres.g_id
	,genres.g_name
	,count(sb.sb_book) AS times
FROM genres
JOIN m2m_books_genres bg
	ON genres.g_id = bg.g_id
LEFT OUTER JOIN subscriptions sb
	ON bg.b_id = sb.sb_book
GROUP BY genres.g_id
	,genres.g_name;

--18.	Показать самый читаемый жанр, т.е. жанр (или жанры, если их несколько), 
-- относящиеся к которому книги читатели брали чаще всего.
WITH prepared_data
AS (
	SELECT genres.g_id
		,genres.g_name
		,count(sb_book) AS times
	FROM genres
	JOIN m2m_books_genres bg
		ON genres.g_id = bg.g_id
	LEFT OUTER JOIN subscriptions
		ON bg.b_id = subscriptions.sb_book
	GROUP BY genres.g_id
		,genres.g_name
	)
SELECT g_id
	,g_name
	,times
FROM prepared_data
WHERE times = (
		SELECT max(times)
		FROM prepared_data
		);

--19. Показать среднюю читаемость жанров, т.е. среднее значение 
-- от того, сколько раз читатели брали книги каждого жанра.
SELECT avg(cast(sb.sb_book AS FLOAT)) AS avg_times
FROM genres
JOIN m2m_books_genres bg
	ON genres.g_id = bg.g_id
LEFT OUTER JOIN subscriptions sb
	ON bg.b_id = sb.sb_book;

--20. Показать медиану читаемости жанров, т.е. медианное значение от того, 
--    сколько раз читатели брали книги каждого жанра.
WITH popularity
AS (
	SELECT COUNT(sb_book) AS books
	FROM genres
	JOIN m2m_books_genres bg
		ON genres.g_id = bg.g_id
	LEFT OUTER JOIN subscriptions
		ON bg.b_id = subscriptions.sb_book
	GROUP BY genres.g_id
	)
SELECT DISTINCT PERCENTILE_CONT(0.5) WITHIN
GROUP (
		ORDER BY books
		) OVER () AS median
FROM popularity;

--23. Показать читателя, последним взявшего в библиотеке книгу.
WITH last_dates
AS (
	SELECT sb_subscriber
		,sb_start
	FROM subscriptions
	GROUP BY sb_subscriber
		,sb_start
	)
SELECT sb_subscriber
	,sb_start
FROM last_dates
WHERE sb_start = (
		SELECT max(sb_start)
		FROM last_dates
		)