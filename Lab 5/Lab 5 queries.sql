-- 1. Многотабличный запрос выборки с сортировкой и отбором данных (INNER JOIN, WHERE, ORDER BY)

-- Выбираем ФИО водителя, дату отправки и название транспортного средства для всех рейсов за последние 12 недель
-- Сортируем по убыванию даты
SELECT CONCAT(d.name, ' ', d.surname, ' ', d.patronymic) AS FIO,
       FORMAT(t.departure_date, 'dd.MM.yyyy')        as departure_date,
       vt.type_name
FROM Trips AS t
         JOIN Drivers AS d ON d.driver_id = t.driver_id
         JOIN Vehicles AS v ON v.vehicle_id = t.vehicle_id
         JOIN Vehicle_types as vt ON vt.type_id = v.type_id
WHERE t.departure_date >= DATEADD(day, -7 * 12, GETDATE())
ORDER BY YEAR(departure_date) DESC

-- 2. Запрос с применением вычисляемых полей (примечание: не применять агрегатные функции)

-- Выводим названия, протяженность в км и м, описание маршрутов
SELECT r.start + '-' + r.[end]                                                                    AS route_name,
       r.distance                                                                                 AS distance_km,
       r.distance * 1000                                                                          AS distance_m,
       'Route "' + r.start + '-' + r.[end] + '", distance: ' + CAST(r.distance AS VARCHAR) + 'km' AS route_descriptions
FROM Routes AS r
ORDER BY distance_km DESC

-- 3. Запрос выборки с внешним объединением двух отношений (LEFT|RIGHT JOIN)

-- Выберем все типы транспортных средств и зарегистрированные транспортные средства
-- Получим пустые строки, если транспортные средства указанного типа еще не были зарегистрированы
SELECT vt.*, v.plate_number, v.mileage
FROM Vehicle_types as vt
         LEFT OUTER JOIN Vehicles as v ON v.type_id = vt.type_id

-- 4. Запрос группировкой, вычислением итогов и отбором данных (GROUP BY, HAVING)

-- Посчитаем сумму всех обслуживаний для каждого типа транспортных средств
-- Выведем те из них, что дороже 30 тысяч
SELECT vt.type_name, SUM(m.cost) AS result_cost
FROM Vehicles AS v
         JOIN Maintenance AS m ON v.vehicle_id = m.vehicle_id
         JOIN Vehicle_types AS vt ON v.type_id = vt.type_id
GROUP BY vt.type_name
HAVING SUM(m.cost) > 30000
ORDER BY result_cost

-- 5. Запрос на добавление (INSERT INTO)

-- Регистрируем все машины, которые никогда не проходили ТО нынешней датой с нулевой стоимостью
INSERT INTO Maintenance (vehicle_id, maintenance_date, description, cost)
SELECT v.vehicle_id,
       GETDATE(),
       'Registration of ' + vt.type_name + ', plate number ' + v.plate_number,
       0
FROM Vehicles AS v
         JOIN Vehicle_types AS vt ON vt.type_id = v.type_id
         LEFT OUTER JOIN Maintenance AS m ON m.vehicle_id = v.vehicle_id
WHERE m.vehicle_id IS NULL

-- 6. Запрос на удаление

-- Удалим все записи о бесплатном обслуживании автобусов
DELETE m
FROM Maintenance AS m
         JOIN Vehicles AS v ON v.vehicle_id = m.vehicle_id
         JOIN Vehicle_types AS vt ON vt.type_id = v.type_id
WHERE vt.type_name LIKE 'Bus%'
  AND m.cost = 0

-- 7. Запрос на обновление

-- Удалим отчество всех водителей, чье имя - John
UPDATE Drivers
SET patronymic = NULL
WHERE name = 'John'

-- 8. Запрос на создание новой таблицы на основе существующей

-- Выделим в отдельную таблицу стоимость и количество обслуживаний по типам транспорта
SELECT vt.type_name,
       COUNT(m.maintenance_id) AS Maintenance_count,
       SUM(m.cost)             AS total_cost
INTO Maintenance_cost_by_vehicle_types
FROM Vehicles AS v
         JOIN Vehicle_types AS vt ON vt.type_id = v.type_id
         LEFT OUTER JOIN Maintenance AS m ON m.vehicle_id = v.vehicle_id
GROUP BY vt.type_name

-- 9. Запрос на объединение (UNION), где применимо (только в SQL)

-- Объединим в одну таблицу всех записи о ТО, где автобусам меняли масло и все бесплатные ТО
SELECT m.*
FROM Maintenance AS m
         JOIN Vehicles AS v ON v.vehicle_id = m.vehicle_id
         JOIN Vehicle_types AS vt ON vt.type_id = v.type_id
WHERE m.description = 'Oil change'
  AND vt.type_name LIKE 'Bus%'
UNION
SELECT *
FROM Maintenance AS m
WHERE m.cost = 0
ORDER BY vehicle_id

-- 10. Вложенный запрос на SQL (вложение во фразе WHERE)

-- Выбираем всю информацию о ТС, чей пробег больше среднего арифметического пробегов всех ТС с пробегом > 100000
SELECT *,
       (SELECT AVG(v1.mileage)
        FROM Vehicles AS v1
        WHERE v1.mileage > 100000) AS avg_mileage_for_vehiles_with_mt_100k_mileage
FROM Vehicles AS v
WHERE v.mileage >= (SELECT AVG(v2.mileage)
                    FROM Vehicles AS v2
                    WHERE v2.mileage > 100000)
ORDER BY v.mileage

-- 11. Запрос на создание новой таблицы

-- Выделим типы ТО в отдельную таблицу + добавим соответствующую колонку в основную таблицу с ТО для связи (one to many)
CREATE TABLE Maintenance_types(
    type_id INT PRIMARY KEY IDENTITY(1,1),
    type_name VARCHAR(50) UNIQUE NOT NULL,
    type_description VARCHAR(255) DEFAULT('')
);
ALTER TABLE Maintenance
    ADD maintenance_type_id INT;
ALTER TABLE Maintenance
    ADD CONSTRAINT [maint_type_id_fk] FOREIGN KEY (maintenance_type_id) REFERENCES Maintenance_types(type_id);

-- 12. Запрос на создание индекса

-- Добавим индекс по протяженности маршрутов
CREATE INDEX route_distance_idx ON Routes (distance DESC)

-- 13. Запрос на создание представления, объединяющего данные двух таблиц

-- Создадим представление, показывающее водителей и все ТС которыми они управляли
CREATE VIEW Drivers_w_vehicles_they_drove_view AS
    SELECT DISTINCT CONCAT(d.name, ' ', d.surname, ' ', d.patronymic) AS full_name,
           d.passport_id,
           vt.type_name,
           v.plate_number,
           v.mileage
    FROM Trips AS t
    JOIN Drivers AS d ON t.driver_id = d.driver_id
    JOIN Vehicles AS v ON t.vehicle_id = v.vehicle_id
    JOIN Vehicle_types AS vt ON v.type_id = vt.type_id
