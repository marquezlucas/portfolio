-- =============================================================================
-- e_commerce_eeuu · 01 · Creación de objetos (tablas, vistas, funciones, SP y triggers)
-- Motor: MySQL 8.0 (probado también en MariaDB 10.11 con sql_mode estricto de MySQL 8)
-- Revisión 2026: correcciones para que el script corra completo sin errores
-- (ver "Historial de cambios" en el README).
-- =============================================================================

-- Creando la base de datos e_commerce_eeuu.
 
SET NAMES utf8mb4
;
 
 
DROP SCHEMA IF EXISTS e_commerce_eeuu
;

CREATE SCHEMA e_commerce_eeuu
;
 
-- Se llama a la base de datos e_commerce_eeuu.
 
USE e_commerce_eeuu
;
 
-- Se comienzan a crear las diferentes tablas de la base de datos.

-- Se crea y se estructura la tabla ditail.
 
CREATE TABLE IF NOT EXISTS ditail (
	ditail_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    quantity INT NOT NULL,
    PRIMARY KEY (ditail_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;
 
-- Se crea y se estructura la tabla product.
 
CREATE TABLE IF NOT EXISTS product (
	product_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ditail_id INT UNSIGNED NOT NULL,
    product_name VARCHAR (100),
    PRIMARY KEY (product_id),
    FOREIGN KEY (ditail_id) REFERENCES ditail (ditail_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;

-- Se crea y se estructura la tabla sales.

CREATE TABLE IF NOT EXISTS sales (
	order_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ditail_id INT UNSIGNED NOT NULL,
    order_date DATE,
    discount DECIMAL (4,2),
    sales DECIMAL (11,3),
    profit DECIMAL (11,2),
    PRIMARY KEY (order_id),
    FOREIGN KEY (ditail_id) REFERENCES ditail (ditail_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;  

-- Se generan dos subtablas de category. Una es ship_mode y la otra sub_category.

-- Se crea y se estructura la tabla ship_mode.

CREATE TABLE IF NOT EXISTS ship_mode (
	ship_mode_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ship_mode VARCHAR (40) NOT NULL,
    PRIMARY KEY (ship_mode_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;  

-- Se crea y se estructura la tabla sub_category.
 
CREATE TABLE IF NOT EXISTS sub_category (
	sub_category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    sub_category VARCHAR (40),
    PRIMARY KEY (sub_category_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;  

 -- Se crea y se estructura la tabla category. Se continua con la rama de la tabla product.
 
CREATE TABLE IF NOT EXISTS category (
	category_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id INT UNSIGNED NOT NULL,
    ship_mode_id INT UNSIGNED NOT NULL,
    sub_category_id INT UNSIGNED NOT NULL,
    category VARCHAR (40),
    PRIMARY KEY (category_id),
    FOREIGN KEY (product_id) REFERENCES product (product_id),
    FOREIGN KEY (ship_mode_id) REFERENCES ship_mode (ship_mode_id),
    FOREIGN KEY (sub_category_id) REFERENCES sub_category (sub_category_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;


 -- Se continua con la rama de la tabla sales.
 
-- Se crea y se estructura la tabla segment para poder crear la tabla client ya que segment es una FK en client 
-- y si no la genero de antemano, al momento de crear la tabla client no me lo va a permitir. 

CREATE TABLE IF NOT EXISTS segment (
	segment_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    segment VARCHAR (40),
    PRIMARY KEY (segment_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;  
 
 -- Se crea y se estructura la tabla country.

CREATE TABLE IF NOT EXISTS country (
	country_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    country VARCHAR (40) NOT NULL,
    PRIMARY KEY (country_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
; 

 -- Se crea y se estructura la tabla client.

CREATE TABLE IF NOT EXISTS client (
	customer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	order_id INT UNSIGNED NOT NULL,
    segment_id INT UNSIGNED NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    mail VARCHAR(40) NOT NULL,
    PRIMARY KEY (customer_id),
    FOREIGN KEY (order_id) REFERENCES sales (order_id),
    FOREIGN KEY (segment_id) REFERENCES segment (segment_id),
    FOREIGN KEY (country_id) REFERENCES country (country_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;


-- Se generan tres subtablas de category. Son postal_code, city y state.

-- Se crea y se estructura la tabla postal_code.

CREATE TABLE IF NOT EXISTS postal_code (
	postal_code_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    postal_code INT NOT NULL,
    PRIMARY KEY (postal_code_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;   

-- Se crea y se estructura la tabla city.

CREATE TABLE IF NOT EXISTS city (
	city_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    city VARCHAR (40) NOT NULL,
    PRIMARY KEY (city_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;

-- Se crea y se estructura la tabla state.

CREATE TABLE IF NOT EXISTS state (
	state_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    state VARCHAR (40) NOT NULL,
    PRIMARY KEY (state_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;   

-- Se crea y se estructura la tabla region.
DROP TABLE IF EXISTS region;
CREATE TABLE IF NOT EXISTS region (
	region_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    country_id INT UNSIGNED NOT NULL,
    state_id INT UNSIGNED NOT NULL,
    city_id INT UNSIGNED NOT NULL,
    postal_code_id INT UNSIGNED NOT NULL,
    region VARCHAR (40) NOT NULL,
    PRIMARY KEY (region_id),
    FOREIGN KEY (country_id) REFERENCES country (country_id),
    FOREIGN KEY (state_id) REFERENCES state (state_id),
    FOREIGN KEY (city_id) REFERENCES city (city_id),
    FOREIGN KEY (postal_code_id) REFERENCES postal_code (postal_code_id)
) ENGINE=InnoDB AUTO_INCREMENT=1
;

-- -----------------------------------------------------------------------------
-- VISTAS
-- Nota de diseño: varias tablas no tienen FK directa entre sí (por ejemplo client y
-- region). Las vistas las unen por id porque cada id representa la misma fila del
-- dataset original (fila i de cada tabla = registro i). Ver "Limitaciones" en el README.
-- -----------------------------------------------------------------------------

USE e_commerce_eeuu;

-- Mail, fecha, descuento, venta y ganancia de los clientes con mail de Hotmail.
CREATE OR REPLACE VIEW client_sales_view
AS
    SELECT
        c.customer_id,
        c.mail,
        v.order_date,
        v.discount,
        v.sales,
        v.profit
    FROM client AS c
    JOIN sales AS v ON (c.order_id = v.order_id)
    WHERE c.mail LIKE '%@hotmail%'      -- antes: LIKE UPPER('%@hotmail%'), que solo funcionaba por la collation case-insensitive
;

-- Cantidad de clientes por región y segmento.
CREATE OR REPLACE VIEW region_segment_ditail_view
AS
    SELECT
        v.region,
        b.segment,
        COUNT(DISTINCT c.customer_id) AS cantidad_clientes
    FROM client AS c
    JOIN region  AS v ON (c.customer_id = v.region_id)
    JOIN segment AS b ON (c.segment_id = b.segment_id)
    GROUP BY v.region, b.segment       -- antes: GROUP BY v.region (error 1055 con ONLY_FULL_GROUP_BY)
;

-- Ciudad, venta, cantidad y producto, ordenado por ciudad descendente.
CREATE OR REPLACE VIEW city_sales_ditail_product_view
AS
    SELECT
        c.city,
        v.sales,
        b.quantity,
        n.product_name
    FROM client AS x
    JOIN city    AS c ON (x.customer_id = c.city_id)
    JOIN sales   AS v ON (x.order_id = v.order_id)
    JOIN ditail  AS b ON (v.ditail_id = b.ditail_id)   -- antes: v.order_id = b.ditail_id (unía por la columna equivocada)
    JOIN product AS n ON (b.ditail_id = n.ditail_id)
    ORDER BY c.city DESC
;

-- Ventas "First Class" con más de 2 unidades, con su categoría, subcategoría y producto.
CREATE OR REPLACE VIEW category_ship_mode_sub_category_product_ditail_sales_view
AS
    SELECT
        c.category,
        v.ship_mode,
        b.sub_category,
        n.product_name,
        m.quantity,
        l.order_id,
        l.order_date,
        l.discount,
        l.sales,
        l.profit                       -- antes: l.* (en una vista conviene listar columnas explícitas)
    FROM category AS c
    JOIN ship_mode    AS v ON (c.ship_mode_id = v.ship_mode_id)
    JOIN sub_category AS b ON (c.sub_category_id = b.sub_category_id)
    JOIN product      AS n ON (c.product_id = n.product_id)
    JOIN ditail       AS m ON (n.ditail_id = m.ditail_id)
    JOIN sales        AS l ON (m.ditail_id = l.ditail_id)
    WHERE m.quantity > 2 AND v.ship_mode = 'First Class'
;

-- Ganancia total por ciudad y código postal.
CREATE OR REPLACE VIEW product_sales_city_postal_code_view
AS
    SELECT
        b.city,
        n.postal_code,
        SUM(v.profit) AS suma_profit
    FROM sales AS v
    JOIN city        AS b ON (v.order_id = b.city_id)
    JOIN postal_code AS n ON (v.order_id = n.postal_code_id)
    GROUP BY b.city, n.postal_code     -- antes: GROUP BY n.postal_code (error 1055)
    ORDER BY b.city
;

-- -----------------------------------------------------------------------------
-- FUNCIONES
-- -----------------------------------------------------------------------------

DROP FUNCTION IF EXISTS func_segment_level;    -- antes: el DROP terminaba en $$ antes de declarar el DELIMITER
DROP FUNCTION IF EXISTS func_discount;

DELIMITER $$

-- Nivel del cliente (PLATINUM / GOLD / SILVER) según segmento y cantidad comprada.
-- Cada segmento tiene umbrales distintos.
CREATE FUNCTION func_segment_level(p_segment VARCHAR(40), p_quantity INT)
RETURNS VARCHAR(20)
DETERMINISTIC NO SQL
BEGIN
    DECLARE v_platinum INT;
    DECLARE v_gold INT;

    CASE p_segment
        WHEN 'Corporate'   THEN SET v_platinum = 11, v_gold = 7;
        WHEN 'Home Office' THEN SET v_platinum = 9,  v_gold = 6;
        WHEN 'Consumer'    THEN SET v_platinum = 7,  v_gold = 4;
        ELSE RETURN NULL;              -- segmento desconocido
    END CASE;

    -- antes: se comparaba una variable inexistente ("credit") y quedaban cantidades sin nivel
    RETURN CASE
        WHEN p_quantity >= v_platinum THEN 'PLATINUM'
        WHEN p_quantity >= v_gold     THEN 'GOLD'
        ELSE 'SILVER'
    END;
END $$

-- Descuento sugerido según el monto de la venta.
CREATE FUNCTION func_discount(p_sales DECIMAL(11,3))
RETURNS DECIMAL(4,2)                   -- antes: DECIMAL(3,2), distinto del tipo de la variable
DETERMINISTIC NO SQL
BEGIN
    RETURN CASE
        WHEN p_sales >= 100 THEN 0.50
        WHEN p_sales >= 50  THEN 0.30
        WHEN p_sales >= 10  THEN 0.10
        ELSE 0.00
    END;
END $$

-- -----------------------------------------------------------------------------
-- STORED PROCEDURES
-- -----------------------------------------------------------------------------

DROP PROCEDURE IF EXISTS sp_concate_location $$

-- Ubicación completa de cada cliente: "id - ciudad - estado - región - CP".
CREATE PROCEDURE sp_concate_location()
BEGIN
    SELECT
        CONCAT_WS(' - ', x.customer_id, c.city, v.state, b.region, n.postal_code) AS ubicacion
    FROM client AS x
    JOIN city        AS c ON (x.customer_id = c.city_id)
    JOIN state       AS v ON (x.customer_id = v.state_id)
    JOIN region      AS b ON (x.customer_id = b.region_id)
    JOIN postal_code AS n ON (x.customer_id = n.postal_code_id);
END $$

DROP PROCEDURE IF EXISTS sp_order_date_client $$

-- Ventas entre dos fechas (inclusive). Uso: CALL sp_order_date_client('2020-09-01', '2020-09-30');
CREATE PROCEDURE sp_order_date_client(IN p_desde DATE, IN p_hasta DATE)   -- antes: VARCHAR(15)
BEGIN
    SELECT *
    FROM sales
    WHERE order_date BETWEEN p_desde AND p_hasta     -- antes: > y < (excluía los extremos)
    ORDER BY order_date;
END $$

DELIMITER ;

-- -----------------------------------------------------------------------------
-- TABLAS DE AUDITORÍA Y TRIGGERS
-- Cambios: fecha es DATE y hora es TIME (antes estaban invertidas); id de log
-- autoincremental para poder registrar más de un evento por registro.
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS new_sales (
    log_id    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id  INT UNSIGNED NOT NULL,
    sales     DECIMAL(11,3),
    profit    DECIMAL(11,2),
    user      VARCHAR(80),
    fecha     DATE,
    hora      TIME
);

CREATE TABLE IF NOT EXISTS drop_sales (
    log_id    INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id  INT UNSIGNED NOT NULL,
    sales     DECIMAL(11,3),
    profit    DECIMAL(11,2),
    user      VARCHAR(80),
    fecha     DATE,
    hora      TIME
);

CREATE TABLE IF NOT EXISTS update_category (
    log_id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_id         INT UNSIGNED NOT NULL,
    category_anterior   VARCHAR(40),
    category_nueva      VARCHAR(40),
    user                VARCHAR(80),
    fecha               DATE,
    hora                TIME
);

CREATE TABLE IF NOT EXISTS new_category (
    log_id       INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    category_id  INT UNSIGNED NOT NULL,
    category     VARCHAR(40),
    user         VARCHAR(80),
    fecha        DATE,
    hora         TIME
);

DROP TRIGGER IF EXISTS tr_add_new_sales;
DROP TRIGGER IF EXISTS tr_delete_sales;
DROP TRIGGER IF EXISTS tr_update_category;
DROP TRIGGER IF EXISTS tr_add_new_category;

-- Registro de cada venta nueva.
CREATE TRIGGER tr_add_new_sales
AFTER INSERT ON sales
FOR EACH ROW
    INSERT INTO new_sales (order_id, sales, profit, user, fecha, hora)
    VALUES (NEW.order_id, NEW.sales, NEW.profit, SESSION_USER(), CURRENT_DATE(), CURRENT_TIME());

-- Registro de cada venta borrada (antes de borrarla).
CREATE TRIGGER tr_delete_sales
BEFORE DELETE ON sales
FOR EACH ROW
    INSERT INTO drop_sales (order_id, sales, profit, user, fecha, hora)
    VALUES (OLD.order_id, OLD.sales, OLD.profit, SESSION_USER(), CURRENT_DATE(), CURRENT_TIME());

-- Registro del valor anterior y nuevo de cada categoría modificada.
-- antes: insertaba 7 valores en una tabla de 5 columnas (error 1136 en cada UPDATE)
CREATE TRIGGER tr_update_category
BEFORE UPDATE ON category
FOR EACH ROW
    INSERT INTO update_category (category_id, category_anterior, category_nueva, user, fecha, hora)
    VALUES (OLD.category_id, OLD.category, NEW.category, SESSION_USER(), CURRENT_DATE(), CURRENT_TIME());

-- Registro de cada categoría nueva.
CREATE TRIGGER tr_add_new_category
AFTER INSERT ON category
FOR EACH ROW
    INSERT INTO new_category (category_id, category, user, fecha, hora)
    VALUES (NEW.category_id, NEW.category, SESSION_USER(), CURRENT_DATE(), CURRENT_TIME());
