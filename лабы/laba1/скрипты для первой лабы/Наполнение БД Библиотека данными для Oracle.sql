-- ВАЖНО! Перед вставкой данных в таблицу "subscriptions" отключите триггер:
-- ALTER TRIGGER "TRG_subscriptions_sb_id" DISABLE;
-- После вставки данных включите триггер:
-- ALTER TRIGGER "TRG_subscriptions_sb_id" ENABLE;
-- Если этого не сделать, будут неверно вставлены значения первичных ключей
-- в таблице "subscriptions".

INSERT ALL
  INTO "books" ("b_id", "b_name", "b_year", "b_quantity") VALUES (1, N'Евгений Онегин', 1985, 2)
  INTO "books" ("b_id", "b_name", "b_year", "b_quantity") VALUES (2, N'Сказка о рыбаке и рыбке', 1990, 3)
  INTO "books" ("b_id", "b_name", "b_year", "b_quantity") VALUES (3, N'Основание и империя', 2000, 5)
  INTO "books" ("b_id", "b_name", "b_year", "b_quantity") VALUES (4, N'Психология программирования', 1998, 1)
  INTO "books" ("b_id", "b_name", "b_year", "b_quantity") VALUES (5, N'Язык программирования С++', 1996, 3)
  INTO "books" ("b_id", "b_name", "b_year", "b_quantity") VALUES (6, N'Курс теоретической физики', 1981, 12)
  INTO "books" ("b_id", "b_name", "b_year", "b_quantity") VALUES (7, N'Искусство программирования', 1993, 7)
SELECT 1 FROM "DUAL";

INSERT ALL
 INTO "authors" ("a_id", "a_name") VALUES (1, N'Д. Кнут')
 INTO "authors" ("a_id", "a_name") VALUES (2, N'А. Азимов')
 INTO "authors" ("a_id", "a_name") VALUES (3, N'Д. Карнеги')
 INTO "authors" ("a_id", "a_name") VALUES (4, N'Л.Д. Ландау')
 INTO "authors" ("a_id", "a_name") VALUES (5, N'Е.М. Лифшиц')
 INTO "authors" ("a_id", "a_name") VALUES (6, N'Б. Страуструп')
 INTO "authors" ("a_id", "a_name") VALUES (7, N'А.С. Пушкин')
SELECT 1 FROM "DUAL";

INSERT ALL
 INTO "genres" ("g_id", "g_name") VALUES (1, N'Поэзия')
 INTO "genres" ("g_id", "g_name") VALUES (2, N'Программирование')
 INTO "genres" ("g_id", "g_name") VALUES (3, N'Психология')
 INTO "genres" ("g_id", "g_name") VALUES (4, N'Наука')
 INTO "genres" ("g_id", "g_name") VALUES (5, N'Классика')
 INTO "genres" ("g_id", "g_name") VALUES (6, N'Фантастика')
SELECT 1 FROM "DUAL";

INSERT ALL
 INTO "subscribers" ("s_id", "s_name") VALUES (1, N'Иванов И.И.')
 INTO "subscribers" ("s_id", "s_name") VALUES (2, N'Петров П.П.')
 INTO "subscribers" ("s_id", "s_name") VALUES (3, N'Сидоров С.С.')
 INTO "subscribers" ("s_id", "s_name") VALUES (4, N'Сидоров С.С.')
SELECT 1 FROM "DUAL";

INSERT ALL
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (1, 7)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (2, 7)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (3, 2)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (4, 3)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (4, 6)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (5, 6)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (6, 5)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (6, 4)
 INTO "m2m_books_authors" ("b_id", "a_id") VALUES (7, 1)
SELECT 1 FROM "DUAL";

INSERT ALL
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (1, 1)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (1, 5)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (2, 1)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (2, 5)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (3, 6)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (4, 2)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (4, 3)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (5, 2)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (6, 5)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (7, 2)
 INTO "m2m_books_genres" ("b_id", "g_id") VALUES (7, 5)
SELECT 1 FROM "DUAL";

ALTER TRIGGER "TRG_subscriptions_sb_id" DISABLE;
INSERT ALL
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (100, 1, 3, TO_DATE('2011-01-12', 'YYYY-MM-DD'), TO_DATE('2011-02-12', 'YYYY-MM-DD'), 'N')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (2, 1, 1, TO_DATE('2011-01-12', 'YYYY-MM-DD'), TO_DATE('2011-02-12', 'YYYY-MM-DD'), 'N')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (3, 3, 3, TO_DATE('2012-05-17', 'YYYY-MM-DD'), TO_DATE('2012-07-17', 'YYYY-MM-DD'), 'Y')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (42, 1, 2, TO_DATE('2012-06-11', 'YYYY-MM-DD'), TO_DATE('2012-08-11', 'YYYY-MM-DD'), 'N')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (57, 4, 5, TO_DATE('2012-06-11', 'YYYY-MM-DD'), TO_DATE('2012-08-11', 'YYYY-MM-DD'), 'N')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (61, 1, 7, TO_DATE('2014-08-03', 'YYYY-MM-DD'), TO_DATE('2014-10-03', 'YYYY-MM-DD'), 'N')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (62, 3, 5, TO_DATE('2014-08-03', 'YYYY-MM-DD'), TO_DATE('2014-10-03', 'YYYY-MM-DD'), 'Y')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (86, 3, 1, TO_DATE('2014-08-03', 'YYYY-MM-DD'), TO_DATE('2014-09-03', 'YYYY-MM-DD'), 'Y')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (91, 4, 1, TO_DATE('2015-10-07', 'YYYY-MM-DD'), TO_DATE('2015-03-07', 'YYYY-MM-DD'), 'Y')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (95, 1, 4, TO_DATE('2015-10-07', 'YYYY-MM-DD'), TO_DATE('2015-11-07', 'YYYY-MM-DD'), 'N')
 INTO "subscriptions" ("sb_id", "sb_subscriber", "sb_book", "sb_start", "sb_finish", "sb_is_active") VALUES (99, 4, 4, TO_DATE('2015-10-08', 'YYYY-MM-DD'), TO_DATE('2025-11-08', 'YYYY-MM-DD'), 'Y')
SELECT 1 FROM "DUAL";
ALTER TRIGGER "TRG_subscriptions_sb_id" ENABLE;