SET IDENTITY_INSERT [rooms] ON;
INSERT INTO [rooms] ([r_id], [r_name], [r_space])
VALUES
(1, N'Комната с двумя компьютерами', 5),
(2, N'Комната с тремя компьютерами', 5),
(3, N'Пустая комната 1', 2),
(4, N'Пустая комната 2', 2),
(5, N'Пустая комната 3', 2);
SET IDENTITY_INSERT [rooms] OFF;

SET IDENTITY_INSERT [computers] ON;
INSERT INTO [computers] ([c_id], [c_room], [c_name])
VALUES
(1, 1, N'Компьютер A в комнате 1'),
(2, 1, N'Компьютер B в комнате 1'),
(3, 2, N'Компьютер A в комнате 2'),
(4, 2, N'Компьютер B в комнате 2'),
(5, 2, N'Компьютер C в комнате 2'),
(6, NULL, N'Свободный компьютер A'),
(7, NULL, N'Свободный компьютер B'),
(8, NULL, N'Свободный компьютер C');
SET IDENTITY_INSERT [computers] OFF;

SET IDENTITY_INSERT [library_in_json] ON;
INSERT INTO [library_in_json]
(
    [lij_id],
	[lij_book],
    [lij_author],
    [lij_genre]
) VALUES
(1, N'Евгений Онегин', N'[{"id":7,"name":"А.С. Пушкин"}]', N'[{"id":1,"name":"Поэзия"},{"id":5,"name":"Классика"}]'),
(2, N'Искусство программирования', N'[{"id":1,"name":"Д. Кнут"}]', N'[{"id":2,"name":"Программирование"},{"id":5,"name":"Классика"}]'),
(3, N'Курс теоретической физики', N'[{"id":4,"name":"Л.Д. Ландау"},{"id":5,"name":"Е.М. Лифшиц"}]', N'[{"id":5,"name":"Классика"}]'),
(4, N'Основание и империя', N'[{"id":2,"name":"А. Азимов"}]', N'[{"id":6,"name":"Фантастика"}]'),
(5, N'Психология программирования', N'[{"id":3,"name":"Д. Карнеги"},{"id":6,"name":"Б. Страуструп"}]', N'[{"id":2,"name":"Программирование"},{"id":3,"name":"Психология"}]'),
(6, N'Сказка о рыбаке и рыбке', N'[{"id":7,"name":"А.С. Пушкин"}]', N'[{"id":1,"name":"Поэзия"},{"id":5,"name":"Классика"}]'),
(7, N'Язык программирования С++', N'[{"id":6,"name":"Б. Страуструп"}]', N'[{"id":2,"name":"Программирование"}]');
SET IDENTITY_INSERT [library_in_json] OFF;


SET IDENTITY_INSERT [site_pages] ON;
INSERT INTO [site_pages] ([sp_id], [sp_parent], [sp_name]) VALUES
(1, NULL, N'Главная'),
(2, 1, N'Читателям'),
(3, 1, N'Спонсорам'),
(4, 1, N'Рекламодателям'),
(5, 2, N'Новости'),
(6, 2, N'Статистика'),
(7, 3, N'Предложения'),
(8, 3, N'Истории успеха'),
(9, 4, N'Акции'),
(10, 1, N'Контакты'),
(11, 3, N'Документы'),
(12, 6, N'Текущая'),
(13, 6, N'Архивная'),
(14, 6, N'Неофициальная');
SET IDENTITY_INSERT [site_pages] OFF;

SET IDENTITY_INSERT [cities] ON;
INSERT INTO [cities] ([ct_id], [ct_name]) VALUES
(1, N'Лондон'),
(2, N'Париж'),
(3, N'Мадрид'),
(4, N'Токио'),
(5, N'Москва'),
(6, N'Киев'),
(7, N'Минск'),
(8, N'Рига'),
(9, N'Варшава'),
(10, N'Берлин');
SET IDENTITY_INSERT [cities] OFF;

INSERT INTO [connections] ([cn_from], [cn_to], [cn_cost], [cn_bidir]) VALUES
(1, 5, 10, 'Y'),
(1, 7, 20, 'N'),
(7, 1, 25, 'N'),
(7, 2, 15, 'Y'),
(2, 6, 50, 'N'),
(6, 8, 40, 'Y'),
(8, 4, 30, 'N'),
(4, 8, 35, 'N'),
(8, 9, 15, 'Y'),
(9, 1, 20, 'N'),
(7, 3, 5, 'N'),
(3, 6, 5, 'N');

SET IDENTITY_INSERT [shopping] ON;
INSERT INTO [shopping]
(
    [sh_id],
    [sh_transaction],
    [sh_category]
) VALUES
(1, 1, N'Сумка'),
(2, 1, N'Платье'),
(3, 1, N'Сумка'),
(4, 2, N'Сумка'),
(5, 2, N'Юбка'),
(6, 3, N'Платье'),
(7, 3, N'Юбка'),
(8, 3, N'Туфли'),
(9, 3, N'Шляпка'),
(10, 4, N'Сумка');
SET IDENTITY_INSERT [shopping] OFF;