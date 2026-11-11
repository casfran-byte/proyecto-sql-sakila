-- 1. Crea el esquema de la BBDD.
-- El esquema se ha generado con DBeaver (clic derecho en el esquema public > Ver diagrama)
-- y está en el archivo esquema_sakila.png del repositorio.
-- Muestra las 15 tablas y sus relaciones. Las más usadas en este proyecto:
--   film <-> film_actor <-> actor          (qué actores salen en cada película)
--   film <-> film_category <-> category    (a qué categoría pertenece cada película)
--   film <-> inventory <-> rental          (copias de cada película y sus alquileres)
--   rental <-> customer / payment          (quién alquila y cuánto paga)


-- 2. Muestra los nombres de todas las películas con una clasificación por edades de 'R'.

SELECT title
FROM film
WHERE rating = 'R';

-- Resultado: 195 películas


-- 3. Encuentra los nombres de los actores que tengan un "actor_id" entre 30 y 40.

SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 30 AND 40;

-- Resultado: 11 actores.


-- 4. Obtén las películas cuyo idioma coincide con el idioma original. Con alias

SELECT title
FROM film f
WHERE f.original_language_id = f.language_id;

-- Resultado: 0 filas. La columna original_language_id está vacía (NULL) en todas
-- las películas, así que la comparación nunca se cumple.


-- 4.1 Variante sin alias (mismo resultado: 0 filas).

SELECT title
FROM film
WHERE original_language_id = language_id;

-- mismo resultado 0 filas.


-- 5. Ordena las películas por duración de forma ascendente.

SELECT title, length
FROM film
ORDER BY length ASC;

-- Resultado: 1000 películas. Las más cortas (empatan 5) duran 46 min.


-- 5.1 Ordena las películas por duración de forma ascendente y además por orden alfabético.

SELECT title, length
FROM film
ORDER BY length ASC, title ASC;

-- Resultado: 1000 películas. Las más cortas (empatan 5) duran 46 min y la primera es ALIEN CENTER.


-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%Allen%';

-- Resultado: 0 filas. Porque en la tabla los apellidos están en mayúsculas.


-- 6.1 Variante en mayúscula ‘ALLEN’.

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%ALLEN%';

-- Resultado: 3 actores. CUBA, KIM y MERYL ALLEN.

-- 6.2 Variante con ILIKE, que no distingue mayúsculas de minúsculas.

SELECT first_name, last_name
FROM actor
WHERE last_name ILIKE '%allen%';

-- Resultado: Los mismos 3 actores. CUBA, KIM y MERYL ALLEN.


-- 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento.

SELECT rating, COUNT(*) AS total_peliculas
FROM film
GROUP BY rating
ORDER BY total_peliculas DESC;

-- Resultado: 5 clasificaciones. La más frecuente es PG-13 (223), seguida de NC-17 (210), R (195), PG (194) y la menos G (178).
-- Suman 1000, el total de películas: el reparto está bastante equilibrado.


-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film

SELECT title
FROM film
WHERE rating = 'PG-13'
OR length > 180;

-- Resultado: 253 películas que cumplen una u otra condición.


-- 8.1 Desglose de las 253 películas, mostrando clasificación y duración.

SELECT title, rating, length
FROM film
WHERE rating = 'PG-13'
   OR length > 180;

-- Resultado: 253 películas (223 PG-13 + 39 de más de 3 h − 9 que cumplen ambas).


-- 8.2 Comparación: con AND solo salen las películas que cumplen las dos condiciones a la vez. (No responde al enunciado; sirve para ver la diferencia con OR.)

SELECT title, rating, length
FROM film
WHERE rating = 'PG-13'
   AND length > 180;

-- Resultado: 9 que cumplen ambas.



-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

SELECT ROUND(VARIANCE(replacement_cost), 2) AS varianza_coste
FROM film;

-- Resultado: 36,61 (la varianza no está en euros, sino en euros al cuadrado).

-- 9.1 Variante sin redondear.

SELECT VARIANCE(replacement_cost) AS varianza_coste
FROM film;

-- Resultado: 36.6125765765765766


-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

SELECT MAX(length) AS mayor_duracion, MIN(length) AS menor_duracion
FROM film;

-- Resultado: la mayor duración es 185 min y la menor 46 min.


-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.

SELECT amount
FROM payment
ORDER BY payment_date DESC, payment_id DESC
LIMIT 1 OFFSET 2;

-- Resultado: 0,99 €.

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.


SELECT title
FROM film
WHERE rating NOT IN ('NC-17', 'G');

-- Resultado: 612 películas (1000 - 210 NC-17 - 178 G).


-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT rating, ROUND(AVG(length), 2) AS promedio_duracion
FROM film
GROUP BY rating;

-- Resultado: 5 clasificaciones. Todas rondan las 2 horas, de 111,05 min (G) a 120,44 min (PG-13).



-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

SELECT title
FROM film
WHERE length > 180;

-- Resultado: 39 películas.


-- 15. ¿Cuánto dinero ha generado en total la empresa?

SELECT SUM(amount) AS total_ingresos
FROM payment;

-- Resultado: 67.416,51 €.

-- 16. Muestra los 10 clientes con mayor valor de id.

SELECT customer_id, first_name, last_name
FROM customer
ORDER BY customer_id DESC
LIMIT 10;

-- Resultado: 10 clientes, del 599 al 590.

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.

SELECT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
WHERE film.title = 'EGG IGBY';

-- Resultado: 5 actores: LUCILLE TRACY, TOM MCKELLEN, NATALIE HOPKINS, MERYL GIBSON y OPRAH KILMER.


-- 17.1 Variante con alias (mismo resultado: 5 actores).

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'EGG IGBY';


-- 18. Selecciona todos los nombres de las películas únicos.

SELECT DISTINCT title
FROM film;

-- Resultado: 1000 títulos únicos, igual que el total de películas: no hay títulos repetidos.


-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”.

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Comedy'
  AND f.length > 180;

-- Resultado: CONTROL ANTHEM, SATURN NAME y SEARCHERS WAIT.


-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos
-- y muestra el nombre de la categoría junto con el promedio de duración.

SELECT c.name, ROUND(AVG(f.length), 2) AS promedio_duracion
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
HAVING AVG(f.length) > 110;

-- Resultado: 13 de las 16 categorías superan los 110 minutos de media.
-- La más larga es Sports (128,20 min).


-- 21. ¿Cuál es la media de duración del alquiler de las películas?

SELECT ROUND(AVG(rental_duration), 2) AS duracion_media_alquiler
FROM film;

-- Resultado: 4,99 días de media


-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.

SELECT first_name || ' ' || last_name AS nombre_completo
FROM actor;

-- Resultado: 200 actores y actrices. SUSAN DAVIS aparece dos veces: son dos personas distintas con distinto actor_id.


-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

SELECT rental_date::date AS dia, COUNT(*) AS total_alquileres
FROM rental
GROUP BY rental_date::date
ORDER BY total_alquileres DESC;

-- Resultado: 41 días con alquileres. El que más, el 31/07/2005 con 679 alquileres.


-- 24. Encuentra las películas con una duración superior al promedio.

SELECT title
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- Resultado: 489 películas superan la duración media (115,27 min).


-- 25. Averigua el número de alquileres registrados por mes.

SELECT TO_CHAR(rental_date, 'YYYY-MM') AS mes, COUNT(*) AS total_alquileres
FROM rental
GROUP BY TO_CHAR(rental_date, 'YYYY-MM')
ORDER BY mes;

-- Resultado: 5 meses. Julio de 2005 es el de más alquileres (6.709).
-- No hay datos de septiembre de 2005 a enero de 2006, y febrero de 2006 solo tiene 182.


-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.

SELECT
    ROUND(AVG(amount), 2)      AS promedio_pago,
    ROUND(STDDEV(amount), 2)   AS desviacion_pago,
    ROUND(VARIANCE(amount), 2) AS varianza_pago
FROM payment;

-- Resultado: promedio 4,20 €, desviación estándar 2,36 € y varianza 5,58.


-- 27. ¿Qué películas se alquilan por encima del precio medio?

SELECT title
FROM film
WHERE rental_rate > (SELECT AVG(rental_rate) FROM film);

-- Resultado: 659 películas. El precio medio es 2,98 €, así que entran todas las de
-- 2,99 € y 4,99 €; solo quedan fuera las de 0,99 €.


-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.

SELECT actor_id, COUNT(*) AS total_peliculas
FROM film_actor
GROUP BY actor_id
HAVING COUNT(*) > 40;

-- Resultado: 2 actores: el 107 (42 películas) y el 102 (41 películas).



-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

SELECT f.title, COUNT(i.inventory_id) AS copias_disponibles
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id, f.title
ORDER BY f.title;

-- Resultado: 1000 películas. 42 no tienen ninguna copia en inventario (salen con 0)
-- y el máximo son 8 copias por película.


-- 30. Obtener los actores y el número de películas en las que ha actuado.

SELECT a.actor_id, a.first_name, a.last_name, COUNT(fa.film_id) AS total_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC;

-- Resultado: 200 actores. Encabezan la lista GINA DEGENERES (42 películas),
-- WALTER TORN (41) y MARY KEITEL (40). El mínimo es 14 películas.



-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas,
-- incluso si algunas películas no tienen actores asociados.

SELECT f.title, a.first_name, a.last_name
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
ORDER BY f.title;

-- Resultado: 5465 filas (una por cada pareja película-actor).
-- 3 películas no tienen actores y salen con el nombre vacío (NULL):
-- DRUMLINE CYCLONE, FLIGHT LIES y SLACKER LIAISONS.



-- 32. Obtener todos los actores y mostrar las películas en las que han actuado,
-- incluso si algunos actores no han actuado en ninguna película.

SELECT a.first_name, a.last_name, f.title
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id
ORDER BY a.last_name, a.first_name;

-- Resultado: 5462 filas (una por cada pareja actor-película).
-- Todos los actores tienen al menos una película, así que ninguno sale con la película vacía.



-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.

SELECT f.title, r.rental_id, r.rental_date
FROM film f
FULL JOIN inventory i ON f.film_id = i.film_id
FULL JOIN rental r ON i.inventory_id = r.inventory_id
ORDER BY f.title, r.rental_date;

-- Resultado: 16087 filas = 16044 alquileres + 43 filas sin alquiler.
-- Esas 43 son las 42 películas sin ninguna copia en inventario (como vimos en la 29)
-- y 1 copia de ACADEMY DINOSAUR que nunca se ha alquilado. No hay alquileres sin película.



-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.

SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_gastado
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_gastado DESC, c.customer_id
LIMIT 5;

-- Resultado: KARL SEAL (221,55 €), ELEANOR HUNT (216,54 €), CLARA SHAW (195,58 €),
-- RHONDA KENNEDY y MARION SNYDER (empatados con 194,61 €).



-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.

SELECT *
FROM actor
WHERE first_name = 'JOHNNY';

-- Resultado: 2 actores: JOHNNY LOLLOBRIGIDA (id 5) y JOHNNY CAGE (id 40).


-- 36. Renombra la columna "first_name" como Nombre y "last_name" como Apellido.

SELECT first_name AS "Nombre", last_name AS "Apellido"
FROM actor;

-- Resultado: 200 actores, con las columnas mostradas como Nombre y Apellido.
-- La tabla no cambia; el alias solo afecta a esta consulta.


-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

SELECT MIN(actor_id) AS id_mas_bajo, MAX(actor_id) AS id_mas_alto
FROM actor;

-- Resultado: el id más bajo es 1 y el más alto 200.


-- 38. Cuenta cuántos actores hay en la tabla "actor".

SELECT COUNT(*) AS total_actores
FROM actor;

-- Resultado: 200 actores (cuadra con los ids del 1 al 200 de la consulta 37).


-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.

SELECT *
FROM actor
ORDER BY last_name ASC, first_name ASC;

-- Resultado: 200 actores. Los primeros son los tres AKROYD (CHRISTIAN, DEBBIE y KIRSTEN).


-- 40. Selecciona las primeras 5 películas de la tabla "film".

SELECT *
FROM film
ORDER BY film_id
LIMIT 5;

-- Resultado: las películas con id del 1 al 5: ACADEMY DINOSAUR, ACE GOLDFINGER,
-- ADAPTATION HOLES, AFFAIR PREJUDICE y AFRICAN EGG.


-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre.
-- ¿Cuál es el nombre más repetido?

SELECT first_name, COUNT(*) AS total_actores
FROM actor
GROUP BY first_name
ORDER BY total_actores DESC, first_name;

-- Resultado: 128 nombres distintos para 200 actores.


-- 41.1 Nombre más repetido (incluyendo empates).

SELECT first_name, COUNT(*) AS total_actores
FROM actor
GROUP BY first_name
HAVING COUNT(*) = (
    SELECT MAX(total)
    FROM (SELECT COUNT(*) AS total FROM actor GROUP BY first_name) AS recuentos
);

-- Resultado: empatan tres nombres con 4 actores cada uno: JULIA, KENNETH y PENELOPE.


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.

SELECT r.rental_id, r.rental_date, c.first_name, c.last_name
FROM rental r
JOIN customer c ON r.customer_id = c.customer_id
ORDER BY r.rental_date;

-- Resultado: 16044 alquileres, todos con su cliente (el mismo total que la tabla rental).


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

SELECT c.customer_id, c.first_name, c.last_name, r.rental_id, r.rental_date
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
ORDER BY c.customer_id, r.rental_date;

-- Resultado: 16044 filas. Todos los clientes tienen al menos un alquiler,
-- así que ninguno sale con el alquiler vacío (NULL).


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué?

SELECT f.title, c.name AS categoria
FROM film f
CROSS JOIN category c;

-- Resultado: 16000 filas (1000 películas x 16 categorías).
-- ¿Aporta valor? No. El CROSS JOIN combina cada película con todas las categorías,
-- aunque cada película pertenece en realidad a una sola. La relación real está en la
-- tabla film_category (1000 filas), así que este resultado mezcla 1000 combinaciones
-- reales con 15000 inventadas y puede llevar a conclusiones falsas.
-- Un CROSS JOIN solo tiene sentido cuando se buscan todas las combinaciones posibles
-- (por ejemplo, cada trabajador con cada tienda, como en la consulta 63).



-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.

SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action'
ORDER BY a.last_name, a.first_name;

-- Resultado: 166 actores distintos (sin DISTINCT saldrían 363 filas,
-- porque muchos actores tienen varias películas de acción).


-- 46. Encuentra todos los actores que no han participado en películas.

SELECT a.actor_id, a.first_name, a.last_name
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
WHERE fa.actor_id IS NULL;

-- Resultado: 0 filas. Todos los actores han participado en al menos una película
-- (el que menos tiene 14, como vimos en la consulta 30).


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.

SELECT a.first_name || ' ' || a.last_name AS actor, COUNT(fa.film_id) AS total_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY total_peliculas DESC;

-- Resultado: 200 actores, el mismo resultado que la consulta 30.
-- Aquí se usa JOIN en vez de LEFT JOIN: como todos los actores tienen películas
-- (consulta 46), no se pierde ninguno.


-- 48. Crea una vista llamada "actor_num_peliculas" que muestre los nombres de los actores
-- y el número de películas en las que han participado.

CREATE OR REPLACE VIEW actor_num_peliculas AS
SELECT a.actor_id, a.first_name || ' ' || a.last_name AS actor, COUNT(fa.film_id) AS total_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name;

-- Comprobación: la vista se consulta como si fuera una tabla.
SELECT *
FROM actor_num_peliculas
ORDER BY total_peliculas DESC;

-- Resultado: vista creada. Al consultarla salen 200 actores con su número de películas.



-- 49. Calcula el número total de alquileres realizados por cada cliente.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;

-- Resultado: 599 clientes. Encabezan la lista ELEANOR HUNT (46 alquileres),
-- KARL SEAL (45) y CLARA SHAW (42). El mínimo es 12 alquileres.


-- 50. Calcula la duración total de las películas en la categoría 'Action'.

SELECT SUM(f.length) AS duracion_total_minutos
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Action';

-- Resultado: 7143 minutos (unas 119 horas) entre las 64 películas de acción.


-- 51. Crea una tabla temporal llamada "cliente_rentas_temporal" para almacenar el total de alquileres por cliente.

DROP TABLE IF EXISTS cliente_rentas_temporal;

CREATE TEMPORARY TABLE cliente_rentas_temporal AS
SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- Comprobación:
SELECT *
FROM cliente_rentas_temporal
ORDER BY total_alquileres DESC;

-- Resultado: tabla temporal creada con 599 clientes y su total de alquileres.
-- Desaparece al cerrar la conexión.


-- 52. Crea una tabla temporal llamada "peliculas_alquiladas" que almacene las películas
-- que han sido alquiladas al menos 10 veces.

DROP TABLE IF EXISTS peliculas_alquiladas;

CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT f.film_id, f.title, COUNT(r.rental_id) AS total_alquileres
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10;

-- Comprobación:
SELECT *
FROM peliculas_alquiladas
ORDER BY total_alquileres DESC;

-- Resultado: 792 películas alquiladas al menos 10 veces.
-- La más alquilada es BUCKET BROTHERHOOD (34 veces).


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre
-- 'Tammy Sanders' y que aún no se han devuelto. Ordena los resultados alfabéticamente por título.

SELECT f.title
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE c.first_name = 'TAMMY'
  AND c.last_name = 'SANDERS'
  AND r.return_date IS NULL
ORDER BY f.title;

-- Resultado: 3 películas sin devolver: LUST LOCK, SLEEPY JAPANESE y TROUBLE DATE.



-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece
-- a la categoría 'Sci-Fi'. Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film_category fc ON fa.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
ORDER BY a.last_name, a.first_name;

-- Resultado: 167 actores han actuado en al menos una película de ciencia ficción.


-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron
-- después de que la película 'Spartacus Cheaper' se alquilara por primera vez.
-- Ordena los resultados alfabéticamente por apellido.

SELECT DISTINCT a.actor_id, a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN inventory i ON fa.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_date > (
    SELECT MIN(r2.rental_date)
    FROM rental r2
    JOIN inventory i2 ON r2.inventory_id = i2.inventory_id
    JOIN film f2 ON i2.film_id = f2.film_id
    WHERE f2.title = 'SPARTACUS CHEAPER'
)
ORDER BY a.last_name, a.first_name;

-- Resultado: los 200 actores. SPARTACUS CHEAPER se alquiló por primera vez el 08/07/2005,
-- y después hubo tantos alquileres (julio y agosto son los meses fuertes) que todos los
-- actores tienen alguna película alquilada tras esa fecha.



-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película
-- de la categoría 'Music'.

SELECT a.first_name, a.last_name
FROM actor a
WHERE a.actor_id NOT IN (
    SELECT fa.actor_id
    FROM film_actor fa
    JOIN film_category fc ON fa.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Music'
)
ORDER BY a.last_name, a.first_name;

-- Resultado: 56 actores no han actuado en ninguna película de música.
-- (Los otros 144 tienen al menos una.)


-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.

SELECT DISTINCT f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE r.return_date - r.rental_date > INTERVAL '8 days'
ORDER BY f.title;

-- Resultado: 876 películas han estado alquiladas más de 8 días al menos una vez
-- (en total son 2664 alquileres de más de 8 días).


-- 58. Encuentra el título de todas las películas que son de la misma categoría que 'Animation'.

SELECT f.title
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id = (
    SELECT category_id
    FROM category
    WHERE name = 'Animation'
)
ORDER BY f.title;

-- Resultado: 66 películas de la categoría Animation.

-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película
-- con el título 'Dancing Fever'. Ordena los resultados alfabéticamente por título de película.

SELECT title
FROM film
WHERE length = (
    SELECT length
    FROM film
    WHERE title = 'DANCING FEVER'
)
ORDER BY title;

-- Resultado: 8 películas duran 144 minutos, como DANCING FEVER (que se incluye a sí misma).


-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas.
-- Ordena los resultados alfabéticamente por apellido.

SELECT c.first_name, c.last_name, COUNT(DISTINCT i.film_id) AS peliculas_distintas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.film_id) >= 7
ORDER BY c.last_name, c.first_name;

-- Resultado: los 599 clientes. El que menos películas distintas ha alquilado tiene 12,
-- así que todos superan el mínimo de 7.


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre
-- de la categoría junto con el recuento de alquileres.

SELECT c.name AS categoria, COUNT(r.rental_id) AS total_alquileres
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name
ORDER BY total_alquileres DESC;

-- Resultado: 16 categorías. La más alquilada es Sports (1179 alquileres)
-- y la que menos, Music (830). Entre todas suman los 16044 alquileres.


-- 62. Encuentra el número de películas por categoría estrenadas en 2006.

SELECT c.name AS categoria, COUNT(f.film_id) AS total_peliculas
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE f.release_year = 2006
GROUP BY c.name
ORDER BY total_peliculas DESC;

-- Resultado: 16 categorías. Todas las películas de la base de datos son de 2006,
-- así que el filtro no excluye ninguna. Sports tiene más (74) y Music menos (51).


-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.

SELECT s.staff_id, s.first_name, s.last_name, st.store_id
FROM staff s
CROSS JOIN store st
ORDER BY s.staff_id, st.store_id;

-- Resultado: 4 combinaciones (2 trabajadores x 2 tiendas).
-- Aquí el CROSS JOIN sí tiene sentido, porque se piden todas las combinaciones posibles.



-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente,
-- su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS peliculas_alquiladas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY peliculas_alquiladas DESC;

-- Resultado: 599 clientes, el mismo resultado que la consulta 49.
-- Encabeza la lista ELEANOR HUNT (46 alquileres).

