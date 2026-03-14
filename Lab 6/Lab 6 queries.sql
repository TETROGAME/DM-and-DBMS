-- 1. Многотабличный запрос выборки с сортировкой и отбором данных (INNER JOIN, WHERE, ORDER BY)

-- Выбираем имена и фамилии студентов, у которых нет отчества и оценка за предметы, преподаваемые >= 20 часов, это 2
SELECT s.name, s.surname, cs.hours FROM Student AS s
JOIN Certification_result AS cr ON cr.record_book_id = s.record_book_id
JOIN Curriculum_subject AS cs ON cs.subject_id = cr.subject_id
JOIN Subject AS sub ON sub.subject_id = cr.subject_id
WHERE cs.hours >= 20 AND s.patronymic is NULL AND cr.grade = 2
ORDER BY cs.hours DESC

-- 2. Запрос с применением вычисляемых полей (примечание: не применять агрегатные функции)

-- Выведем ФИО, предмет, номер семестра и сколько баллов в час получали студенты по данному предмету в семестре
-- Насколько оценка студента отличается от его же максимальной оценки
SELECT
    CONCAT(stud.name, ' ', stud.surname, ISNULL(' ' + stud.patronymic, '')) AS full_name,
    s.subject_name,
    cs.semester_number,
    cr.grade,
    cs.hours,
    cr.grade * 1.0 / cs.hours AS grade_per_hour
FROM Certification_result AS cr
         JOIN Curriculum_subject AS cs
              ON cs.subject_id = cr.subject_id
                  AND cs.semester_number = cr.semester_number
         JOIN Subject AS s ON s.subject_id = cr.subject_id
         JOIN Student AS stud ON stud.record_book_id = cr.record_book_id
ORDER BY grade_per_hour DESC


-- 3. Запрос выборки с внешним объединением двух отношений (LEFT|RIGHT JOIN)

-- Посчитаем, сколько студентов сдавали каждый предмет
SELECT
    s.subject_name,
    COUNT(cr.record_book_id) AS times_taken
FROM Subject AS s
LEFT JOIN Certification_result cr ON s.subject_id = cr.subject_id
GROUP BY s.subject_name


-- 4. Запрос группировкой, вычислением итогов и отбором данных (GROUP BY, HAVING)

-- Выберем ФИО и оценку студентов со средним баллом >= 4.3
SELECT
    CONCAT(stud.name, ' ', stud.surname, ISNULL(' ' + stud.patronymic, '')) AS full_name,
    CAST(ROUND(AVG(cr.grade * 1.0), 1) AS FLOAT) AS GPA
FROM Certification_result AS cr
JOIN Student AS stud ON stud.record_book_id = cr.record_book_id
GROUP BY stud.name, stud.surname, stud.patronymic, stud.record_book_id
HAVING CAST(ROUND(AVG(cr.grade * 1.0), 1) AS FLOAT) >= 4.3


-- 5. Запрос на добавление (INSERT INTO)

-- Добавим в 6 семестр студента на основе другого без отчества и с самым последним id зачетки
INSERT INTO Student
SELECT TOP(1)
    s.record_book_id + 1,
    s.name,
    s.surname,
    'Insertovich',
    6
FROM Student AS s
WHERE s.patronymic IS NULL
ORDER BY s.record_book_id DESC


-- 6. Запрос на удаление

-- Удалим все записи об аттестации студентов без отчества, которые получили 3 и ниже за матанализ
DELETE cr FROM Certification_result AS cr
JOIN Student AS stud ON stud.record_book_id = cr.record_book_id
JOIN Subject AS s ON s.subject_id = cr.subject_id
WHERE s.subject_name = 'Calculus' AND
      stud.patronymic IS NULL AND
      cr.grade <= 3


-- 7. Запрос на обновление

-- Добавим общее отчество всем студентам без него и чей номер зачетки кратен 4
UPDATE Student
SET patronymic = 'Insertovich'
WHERE patronymic IS NULL AND record_book_id % 4 = 0


-- 8. Запрос на создание новой таблицы на основе существующей

-- Выберем в отдельную номер зачетки студента и его среднюю оценку по всем предметам
SELECT cr.record_book_id,
       CAST(ROUND(AVG(cr.grade), 2) AS FLOAT) AS GPA
INTO GPA_wo_full_name
FROM Certification_result AS cr
GROUP BY cr.record_book_id


-- 9. Запрос на объединение (UNION), где применимо (только в SQL)

-- Выбираем ФИО, номер зачетки и средний балл студентов с баллом выше 4,
-- Объединяем их со студентами без отчества
SELECT
    CONCAT(stud.name, ' ', stud.surname, ISNULL(' ' + stud.patronymic, '')) AS full_name,
    stud.record_book_id,
    CAST(ROUND(AVG(cr.grade * 1.0), 1) AS FLOAT) AS GPA
FROM Student AS stud
JOIN Certification_result AS cr ON cr.record_book_id = stud.record_book_id
GROUP BY stud.name, stud.surname, stud.patronymic, stud.record_book_id
HAVING CAST(ROUND(AVG(cr.grade * 1.0), 1) AS FLOAT) > 4
UNION
SELECT
    CONCAT(stud.name, ' ', stud.surname, ISNULL(' ' + stud.patronymic, '')) AS full_name,
    stud.record_book_id,
    CAST(ROUND(AVG(cr.grade * 1.0), 1) AS FLOAT) AS GPA
FROM Student AS stud
JOIN Certification_result AS cr ON cr.record_book_id = stud.record_book_id
WHERE stud.patronymic IS NULL
GROUP BY stud.name, stud.surname, stud.patronymic, stud.record_book_id


-- 10. Вложенный запрос на SQL (вложение во фразе WHERE)

-- Выбираем ФИО, номер зачетки и семестра студентов, что аттестовывались >= 40 раз, а их ср.балл выше оного среди всех
SELECT CONCAT(stud.name, ' ', stud.surname, ISNULL(' ' + stud.patronymic, '')) AS full_name,
    stud.record_book_id,
    stud.current_semester
FROM Student AS stud
WHERE stud.record_book_id IN (
    SELECT cr_temp.record_book_id FROM Certification_result AS cr_temp
    GROUP BY cr_temp.record_book_id
    HAVING COUNT(cr_temp.record_book_id) >= 40 AND
           AVG(cr_temp.grade * 1.0) > (
               SELECT AVG(grade * 1.0)
               FROM Certification_result
               )
    )


-- 11. Запрос на создание новой таблицы

-- Добавим таблицу типов учебных предметов и свяжем её с таблицей предметов через внешний ключ
CREATE TABLE Subject_type(
    subject_type_id INT PRIMARY KEY IDENTITY(1,1),
    subject_type VARCHAR(20) NOT NULL
);
ALTER TABLE Subject
    ADD subject_type_id INT;
ALTER TABLE Subject
    ADD CONSTRAINT [subject_type_id_fk] FOREIGN KEY (subject_type_id) REFERENCES Subject_type(subject_type_id);


-- 12. Запрос на создание индекса

-- Добавим индекс к результатам аттестации по оценкам в убывающем порядке
CREATE INDEX certification_grade_idx ON Certification_result (grade DESC)


-- 13. Запрос на создание представления, объединяющего данные двух таблиц

-- Создадим представление студента по его зачетке, ФИО, будем показывать его средний балл и число сданных экзаменов/зачетов
CREATE VIEW Student_w_GPA_and_exam_count AS
    SELECT stud.record_book_id,
        CONCAT(stud.name, ' ', stud.surname, ISNULL(' ' + stud.patronymic, '')) AS full_name,
        CAST(ROUND(AVG(cr.grade * 1.0), 1) AS FLOAT) AS GPA,
        COUNT(cr.record_book_id) AS exam_count
    FROM Student AS stud
    JOIN Certification_result AS cr ON cr.record_book_id = stud.record_book_id
    GROUP BY stud.name, stud.surname, stud.patronymic, stud.record_book_id
