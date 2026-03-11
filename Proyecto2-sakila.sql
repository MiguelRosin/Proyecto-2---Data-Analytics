-- Ejercicio 2: Películas con clasificación 'R'
SELECT title 
FROM film 
WHERE rating = 'R';

-- Ejercicio 3: Actores con ID entre 30 y 40
SELECT first_name, last_name 
FROM actor 
WHERE actor_id BETWEEN 30 AND 40;

-- Ejercicio 4: Películas cuyo idioma coincide con el original
-- Mejora: Excluimos explícitamente los nulos antes de comparar
SELECT title 
FROM film 
WHERE original_language_id IS NOT NULL 
  AND language_id = original_language_id;

-- Ejercicio 5: Películas ordenadas por duración (de menor a mayor)
SELECT title, length 
FROM film 
ORDER BY length ASC;

-- Ejercicio 6: Actores con 'Allen' en su apellido
SELECT first_name, last_name 
FROM actor 
WHERE last_name LIKE '%ALLEN%';

-- Ejercicio 7: Cantidad total de películas por clasificación
SELECT rating, COUNT(*) 
FROM film 
GROUP BY rating;

-- Ejercicio 8: Películas 'PG-13' o de más de 3 horas (180 min)
SELECT title 
FROM film 
WHERE rating = 'PG-13' OR length > 180;

-- Ejercicio 9: Variabilidad (Desviación Estándar) del costo de reemplazo
-- STDDEV es la función para desviación estándar
SELECT STDDEV(replacement_cost) 
FROM film;

-- Ejercicio 10: Mayor y menor duración de una película
SELECT MAX(length) as duracion_maxima, MIN(length) as duracion_minima 
FROM film;

-- Ejercicio 11: Costo del antepenúltimo alquiler
-- Ordenamos por fecha (descendiente), saltamos 2 (los últimos) y cogemos 1
SELECT p.amount, r.rental_date 
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
ORDER BY r.rental_date DESC 
LIMIT 1 OFFSET 2;

-- Ejercicio 12: Películas que NO sean ni 'NC-17' ni 'G'
SELECT title, rating 
FROM film 
WHERE rating NOT IN ('NC-17', 'G');

-- Ejercicio 13: Promedio de duración de películas por clasificación
SELECT rating, AVG(length) 
FROM film 
GROUP BY rating;

-- Ejercicio 14: Películas con duración mayor a 180 minutos
SELECT title 
FROM film 
WHERE length > 180;

-- Ejercicio 15: Dinero total generado por la empresa
SELECT SUM(amount) 
FROM payment;

-- Ejercicio 16: Los 10 clientes con mayor ID
-- (Ordenamos por ID descendente y cogemos los 10 primeros)
SELECT * FROM customer 
ORDER BY customer_id DESC 
LIMIT 10;

-- Ejercicio 17: Actores que aparecen en la película 'Egg Igby'
SELECT a.first_name, a.last_name 
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY';

-- Ejercicio 18: Todos los nombres de películas únicos
-- (DISTINCT elimina duplicados si los hubiera)
SELECT DISTINCT title 
FROM film;

-- Ejercicio 19: Películas que son Comedias y duran más de 180 min
-- Necesitamos unir 3 tablas: film -> film_category -> category
SELECT f.title 
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy' AND f.length > 180;

-- Ejercicio 20: Categorías con promedio de duración > 110 min
-- Usamos HAVING porque filtramos sobre un resultado agrupado (el promedio)
SELECT c.name, AVG(f.length) as promedio_duracion
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

-- Ejercicio 21: Media de duración del alquiler de las películas
-- Se refiere a la columna 'rental_duration' (días permitidos) de la tabla film
SELECT AVG(rental_duration) as media_alquiler
FROM film;

-- Ejercicio 22: Columna con nombre y apellidos juntos
-- Usamos CONCAT para unir cadenas de texto
SELECT CONCAT(first_name, ' ', last_name) as nombre_completo 
FROM actor;

-- Ejercicio 23: Números de alquiler por día (orden descendente)
-- Convertimos la fecha exacta a solo 'Día' usando DATE()
SELECT DATE(rental_date) as fecha, COUNT(*) as total_alquileres
FROM rental 
GROUP BY DATE(rental_date)
ORDER BY total_alquileres DESC;

-- Ejercicio 24: Películas con duración superior al promedio
-- Esto requiere una SUBCONSULTA: primero calculamos el promedio, luego comparamos
SELECT title, length 
FROM film 
WHERE length > (SELECT AVG(length) FROM film);

-- Ejercicio 25: Número de alquileres por mes
-- Extraemos el mes y el año para agrupar
SELECT EXTRACT(YEAR FROM rental_date) as anio, EXTRACT(MONTH FROM rental_date) as mes, COUNT(*) 
FROM rental 
GROUP BY EXTRACT(YEAR FROM rental_date), EXTRACT(MONTH FROM rental_date);

-- Ejercicio 26: Promedio, desviación estándar y varianza del pago total
SELECT AVG(amount) as promedio, STDDEV(amount) as desviacion, VARIANCE(amount) as varianza
FROM payment;

-- Ejercicio 27: Películas que se alquilan por encima del precio medio
-- Comparamos el precio de alquiler (rental_rate) con el promedio
SELECT title, rental_rate 
FROM film 
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- Ejercicio 28: ID de actores que han participado en más de 40 películas
-- Agrupamos por actor y filtramos los grupos con HAVING
SELECT actor_id, COUNT(film_id) as cantidad_peliculas
FROM film_actor 
GROUP BY actor_id 
HAVING COUNT(film_id) > 40;

-- Ejercicio 29: Todas las películas y su cantidad disponible en inventario
-- Mejora: Agrupamos por el ID único de la película para evitar solapamientos de nombres
SELECT f.title, COUNT(i.inventory_id) AS copias_disponibles
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title;

-- Ejercicio 30: Actores y el número de películas en las que han actuado
-- Unimos actor con film_actor
SELECT a.first_name, a.last_name, COUNT(fa.film_id) as total_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Ejercicio 31: Todas las películas y sus actores (incluso si no tienen)
-- LEFT JOIN desde film hacia actor
SELECT f.title, a.first_name, a.last_name
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id;

-- Ejercicio 32: Todos los actores y sus películas (incluso si no han actuado)
-- LEFT JOIN desde actor hacia film
SELECT a.first_name, a.last_name, f.title
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id;

-- Ejercicio 33: Todas las películas y todos los registros de alquiler
-- Unimos film -> inventory -> rental asegurando que la tabla 'film' sea la base
SELECT f.title, r.rental_date, r.return_date
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id;

-- Ejercicio 34: Los 5 clientes que más dinero han gastado
-- Sumamos los pagos por cliente, ordenamos descendente y limitamos a 5
SELECT c.first_name, c.last_name, SUM(p.amount) as total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC 
LIMIT 5;

-- Ejercicio 35: Actores cuyo primer nombre es 'Johnny'
-- Recuerda: en esta BBDD los nombres están en mayúsculas
SELECT * FROM actor 
WHERE first_name = 'JOHNNY';

-- Ejercicio 36: Renombrar columnas (Alias)
SELECT first_name AS Nombre, last_name AS Apellido 
FROM actor;

-- Ejercicio 37: ID de actor más bajo y más alto
SELECT MIN(actor_id) as id_minimo, MAX(actor_id) as id_maximo
FROM actor;

-- Ejercicio 38: Cuántos actores hay en total
SELECT COUNT(*) as total_actores 
FROM actor;

-- Ejercicio 39: Todos los actores ordenados por apellido (A-Z)
SELECT first_name, last_name 
FROM actor 
ORDER BY last_name ASC;

-- Ejercicio 40: Las primeras 5 películas
-- (Nota: El orden dependerá de cómo las recupere la BBDD si no usas ORDER BY, 
-- pero LIMIT 5 cumple el enunciado estricto)
SELECT * FROM film 
LIMIT 5;

-- Ejercicio 41: Actores con el mismo nombre y cuál es el más repetido
-- Agrupamos por nombre, contamos y ordenamos de mayor a menor
SELECT first_name, COUNT(*) as repeticiones
FROM actor 
GROUP BY first_name 
ORDER BY repeticiones DESC
LIMIT 1; 
-- (Si quitas el LIMIT 1 verás la lista completa. 'PENELOPE', 'JULIA' y 'KENNETH' suelen ser los top)

-- Ejercicio 42: Todos los alquileres y los nombres de los clientes
-- INNER JOIN porque queremos alquileres que sí tengan cliente asociado (que son todos)
SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id;

-- Ejercicio 43: Todos los clientes y sus alquileres (incluso si no tienen)
-- LEFT JOIN desde cliente hacia alquiler para no perder a ningún cliente
SELECT c.first_name, c.last_name, r.rental_id
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id;

-- Ejercicio 44: CROSS JOIN entre film y category
SELECT f.title, c.name 
FROM film f
CROSS JOIN category c;

-- Ejercicio 45: Actores que han participado en películas de 'Action'
-- Unimos: actor -> film_actor -> film_category -> category
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- Ejercicio 46: Actores que no han participado en ninguna película
-- Usamos LEFT JOIN y buscamos donde la tabla de unión sea NULL
SELECT a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.film_id IS NULL;

-- Ejercicio 47: Nombre de los actores y cantidad de películas
SELECT a.first_name, a.last_name, COUNT(fa.film_id) as total_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Ejercicio 48: Crear una VISTA llamada "actor_num_peliculas"
-- (Es básicamente guardar la consulta anterior con un nombre para reusarla)
CREATE VIEW actor_num_peliculas AS
SELECT a.first_name, a.last_name, COUNT(fa.film_id) as total_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Ejercicio 49: Número total de alquileres por cliente
SELECT c.first_name, c.last_name, COUNT(r.rental_id) as total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Ejercicio 50: Duración total de las películas en la categoría 'Action'
-- Unimos category -> film_category -> film
SELECT SUM(f.length) as duracion_total_accion
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- Ejercicio 51: Crear tabla temporal "cliente_rentas_temporal"
-- Las tablas temporales solo duran mientras tienes abierta la sesión
CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as total_alquileres
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Ejercicio 52: Crear tabla temporal "peliculas_alquiladas" (alquiladas >= 10 veces)
CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.title, COUNT(r.rental_id) as veces_alquilada
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Ejercicio 53: Películas alquiladas por 'Tammy Sanders' NO devueltas
-- (return_date IS NULL significa que no se ha devuelto)
SELECT f.title 
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE c.first_name = 'TAMMY' AND c.last_name = 'SANDERS' 
AND r.return_date IS NULL
ORDER BY f.title ASC;

-- Ejercicio 54: Actores que han actuado en pelis 'Sci-Fi'
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name ASC;

-- Ejercicio 55: Actores en películas alquiladas después de que 'Spartacus Cheaper' se alquilara por primera vez
SELECT DISTINCT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name ASC;

-- Ejercicio 56: Actores que NO han actuado en 'Music'
-- Usamos una subconsulta para identificar a los que SÍ han actuado, y los excluimos.
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (
    SELECT DISTINCT a.actor_id
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
);

-- Ejercicio 57: Películas alquiladas por más de 8 días
-- Calculamos la diferencia entre fecha de devolución y fecha de alquiler
-- (Ojo: solo contamos alquileres ya devueltos, donde return_date no es NULL)
SELECT DISTINCT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days';

-- Ejercicio 58: Películas de la misma categoría que 'Animation'
-- (Básicamente, todas las películas de la categoría Animation)
SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Animation';

-- Ejercicio 59: Películas con la misma duración que 'Dancing Fever'
SELECT title
FROM film
WHERE length = (
    SELECT length 
    FROM film 
    WHERE title = 'DANCING FEVER'
)
ORDER BY title ASC;

-- Ejercicio 60: Clientes que han alquilado al menos 7 películas DISTINTAS
-- Usamos COUNT(DISTINCT f.film_id) para contar títulos únicos, no cintas.
SELECT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT f.film_id) >= 7
ORDER BY c.last_name ASC;

-- Ejercicio 61: Cantidad total de películas alquiladas por categoría
SELECT c.name, COUNT(r.rental_id) as total_alquileres
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

-- Ejercicio 62: Número de películas por categoría estrenadas en 2006
SELECT c.name, COUNT(f.film_id) as total_peliculas
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name;

-- Ejercicio 63: Combinaciones posibles de trabajadores y tiendas
SELECT s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st;

-- Ejercicio 64: Total de alquileres por cliente (ID, Nombre, Apellido, Cantidad)
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) as cantidad_alquilada
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY cantidad_alquilada DESC;