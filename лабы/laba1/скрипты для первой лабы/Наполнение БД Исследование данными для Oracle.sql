INSERT ALL
	INTO "rooms" ("r_id", "r_name", "r_space") VALUES (1, N'Комната с двумя компьютерами', 5)
	INTO "rooms" ("r_id", "r_name", "r_space") VALUES (2, N'Комната с тремя компьютерами', 5)
	INTO "rooms" ("r_id", "r_name", "r_space") VALUES (3, N'Пустая комната 1', 2)
	INTO "rooms" ("r_id", "r_name", "r_space") VALUES (4, N'Пустая комната 2', 2)
	INTO "rooms" ("r_id", "r_name", "r_space") VALUES (5, N'Пустая комната 3', 2)
SELECT 1 FROM "DUAL";

INSERT ALL
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (1, 1, N'Компьютер A в комнате 1')
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (2, 1, N'Компьютер B в комнате 1')
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (3, 2, N'Компьютер A в комнате 2')
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (4, 2, N'Компьютер B в комнате 2')
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (5, 2, N'Компьютер C в комнате 2')
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (6, NULL, N'Свободный компьютер A')
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (7, NULL, N'Свободный компьютер B')
	INTO "computers" ("c_id", "c_room", "c_name") VALUES (8, NULL, N'Свободный компьютер C')
SELECT 1 FROM "DUAL";


INSERT ALL
  INTO "library_in_json" ("lij_id", "lij_book", "lij_author", "lij_genre")
   VALUES (1, N'Евгений Онегин', N'[{"id":7,"name":"А.С. Пушкин"}]',
              N'[{"id":1,"name":"Поэзия"},{"id":5,"name":"Классика"}]')
  INTO "library_in_json" ("lij_id", "lij_book", "lij_author", "lij_genre")
   VALUES (2, N'Сказка о рыбаке и рыбке',
              N'[{"id":7,"name":"А.С. Пушкин"}]',
              N'[{"id":1,"name":"Поэзия"},{"id":5,"name":"Классика"}]')
  INTO "library_in_json" ("lij_id", "lij_book", "lij_author", "lij_genre")
   VALUES (3, N'Основание и империя', N'[{"id":2,"name":"А. Азимов"}]',
              N'[{"id":6,"name":"Фантастика"}]')
  INTO "library_in_json" ("lij_id", "lij_book", "lij_author", "lij_genre")
   VALUES (4, N'Психология программирования',
              N'[{"id":3,"name":"Д. Карнеги"},
                 {"id":6,"name":"Б. Страуструп"}]',
              N'[{"id":2,"name":"Программирование"},
                 {"id":3,"name":"Психология"}]')
  INTO "library_in_json" ("lij_id", "lij_book", "lij_author", "lij_genre")
   VALUES (5, N'Язык программирования С++',
              N'[{"id":6,"name":"Б. Страуструп"}]', 
              N'[{"id":2,"name":"Программирование"}]')
  INTO "library_in_json" ("lij_id", "lij_book", "lij_author", "lij_genre")
   VALUES (6, N'Курс теоретической физики',
              N'[{"id":4,"name":"Л.Д. Ландау"},
                 {"id":5,"name":"Е.М. Лифшиц"}]',
              N'[{"id":5,"name":"Классика"}]')
  INTO "library_in_json" ("lij_id", "lij_book", "lij_author", "lij_genre")
   VALUES (7, N'Искусство программирования',
              N'[{"id":1,"name":"Д. Кнут"}]',
              N'[{"id":2,"name":"Программирование"},
                 {"id":5,"name":"Классика"}]')
SELECT 1 FROM "DUAL";



ALTER TRIGGER "TRG_site_pages_sp_id" DISABLE;
INSERT ALL
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (1, NULL, N'Главная')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (2, 1, N'Читателям')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (3, 1, N'Спонсорам')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (4, 1, N'Рекламодателям')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (5, 2, N'Новости')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (6, 2, N'Статистика')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (7, 3, N'Предложения')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (8, 3, N'Истории успеха')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (9, 4, N'Акции')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (10, 1, N'Контакты')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (11, 3, N'Документы')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (12, 6, N'Текущая')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (13, 6, N'Архивная')
 INTO "site_pages" ("sp_id", "sp_parent", "sp_name") VALUES (14, 6, N'Неофициальная')
SELECT 1 FROM "DUAL";
ALTER TRIGGER "TRG_site_pages_sp_id" ENABLE;

ALTER TRIGGER "TRG_cities_ct_id" DISABLE;
INSERT ALL
 INTO "cities" ("ct_id", "ct_name") VALUES (1, N'Лондон')
 INTO "cities" ("ct_id", "ct_name") VALUES (2, N'Париж')
 INTO "cities" ("ct_id", "ct_name") VALUES (3, N'Мадрид')
 INTO "cities" ("ct_id", "ct_name") VALUES (4, N'Токио')
 INTO "cities" ("ct_id", "ct_name") VALUES (5, N'Москва')
 INTO "cities" ("ct_id", "ct_name") VALUES (6, N'Киев')
 INTO "cities" ("ct_id", "ct_name") VALUES (7, N'Минск')
 INTO "cities" ("ct_id", "ct_name") VALUES (8, N'Рига')
 INTO "cities" ("ct_id", "ct_name") VALUES (9, N'Варшава')
 INTO "cities" ("ct_id", "ct_name") VALUES (10, N'Берлин')
SELECT 1 FROM "DUAL";
ALTER TRIGGER "TRG_cities_ct_id" ENABLE;

INSERT ALL
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(1, 5, 10, 'Y')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(1, 7, 20, 'N')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(7, 1, 25, 'N')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(7, 2, 15, 'Y')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(2, 6, 50, 'N')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(6, 8, 40, 'Y')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(8, 4, 30, 'N')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(4, 8, 35, 'N')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(8, 9, 15, 'Y')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(9, 1, 20, 'N')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(7, 3, 5, 'N')
 INTO "connections" ("cn_from", "cn_to", "cn_cost", "cn_bidir") VALUES(3, 6, 5, 'N')
SELECT 1 FROM "DUAL";


INSERT ALL
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES (1, 1, N'Сумка')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(2, 1, N'Платье')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(3, 1, N'Сумка')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(4, 2, N'Сумка')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(5, 2, N'Юбка')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(6, 3, N'Платье')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(7, 3, N'Юбка')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(8, 3, N'Туфли')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(9, 3, N'Шляпка')
 INTO "shopping" ("sh_id", "sh_transaction", "sh_category")
  VALUES(10, 4, N'Сумка')
SELECT 1 FROM "DUAL";