SET IDENTITY_INSERT [books] ON;
INSERT INTO [books] ([b_id], [b_name], [b_year], [b_quantity])
VALUES
(1, N'Евгений Онегин', 1985, 2),
(2, N'Сказка о рыбаке и рыбке', 1990, 3),
(3, N'Основание и империя', 2000, 5),
(4, N'Психология программирования', 1998, 1),
(5, N'Язык программирования С++', 1996, 3),
(6, N'Курс теоретической физики', 1981, 12),
(7, N'Искусство программирования', 1993, 7);
SET IDENTITY_INSERT [books] OFF;

SET IDENTITY_INSERT [authors] ON;
INSERT INTO [authors] ([a_id], [a_name])
VALUES
(1, N'Д. Кнут'),
(2, N'А. Азимов'),
(3, N'Д. Карнеги'),
(4, N'Л.Д. Ландау'),
(5, N'Е.М. Лифшиц'),
(6, N'Б. Страуструп'),
(7, N'А.С. Пушкин');
SET IDENTITY_INSERT [authors] OFF;

SET IDENTITY_INSERT [genres] ON;
INSERT INTO [genres] ([g_id], [g_name])
VALUES
(1, N'Поэзия'),
(2, N'Программирование'),
(3, N'Психология'),
(4, N'Наука'),
(5, N'Классика'),
(6, N'Фантастика');
SET IDENTITY_INSERT [genres] OFF;

SET IDENTITY_INSERT [subscribers] ON;
INSERT INTO [subscribers] ([s_id], [s_name])
VALUES
(1, N'Иванов И.И.'),
(2, N'Петров П.П.'),
(3, N'Сидоров С.С.'),
(4, N'Сидоров С.С.');
SET IDENTITY_INSERT [subscribers] OFF;

INSERT INTO [m2m_books_authors]
([b_id], [a_id])
VALUES
(1, 7),
(2, 7),
(3, 2),
(4, 3),
(4, 6),
(5, 6),
(6, 5),
(6, 4),
(7, 1);

INSERT INTO [m2m_books_genres] ([b_id], [g_id])
VALUES
(1, 1),
(1, 5),
(2, 1),
(2, 5),
(3, 6),
(4, 2),
(4, 3),
(5, 2),
(6, 5),
(7, 2),
(7, 5);

SET IDENTITY_INSERT [subscriptions] ON;
INSERT INTO [subscriptions] ([sb_id], [sb_subscriber], [sb_book], [sb_start], [sb_finish], [sb_is_active])
VALUES
(100, 1, 3, '2011-01-12', '2011-02-12', 'N'),
(2, 1, 1, '2011-01-12', '2011-02-12', 'N'),
(3, 3, 3, '2012-05-17', '2012-07-17', 'Y'),
(42, 1, 2, '2012-06-11', '2012-08-11', 'N'),
(57, 4, 5, '2012-06-11', '2012-08-11', 'N'),
(61, 1, 7, '2014-08-03', '2014-10-03', 'N'),
(62, 3, 5, '2014-08-03', '2014-10-03', 'Y'),
(86, 3, 1, '2014-08-03', '2014-09-03', 'Y'),
(91, 4, 1, '2015-10-07', '2015-03-07', 'Y'),
(95, 1, 4, '2015-10-07', '2015-11-07', 'N'),
(99, 4, 4, '2015-10-08', '2025-11-08', 'Y');
SET IDENTITY_INSERT [subscriptions] OFF;