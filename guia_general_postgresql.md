# Guía general de PostgreSQL

Esta guía reúne los conceptos y comandos más usados de PostgreSQL: creación de tablas, inserciones, consultas, subconsultas, vistas, funciones, procedimientos y objetos relacionados. PostgreSQL documenta oficialmente los comandos SQL soportados, la sintaxis general del lenguaje y las referencias específicas para `CREATE VIEW`, funciones SQL y sentencias PL/pgSQL. [web:57][web:60][web:62][web:65][web:64][web:66]

## Qué es PostgreSQL

PostgreSQL es un sistema de gestión de bases de datos relacional y orientado a objetos, de código abierto, con soporte amplio para SQL, tipos de datos, funciones, vistas, índices, transacciones y programación del lado del servidor. [web:61][web:62]  
Normalmente se trabaja con PostgreSQL desde clientes como `psql`, DBeaver, pgAdmin o aplicaciones conectadas por driver. [web:62][web:67]

## Estructura básica

En PostgreSQL trabajas principalmente con estos objetos:

- Base de datos.
- Esquemas.
- Tablas.
- Vistas.
- Índices.
- Secuencias.
- Funciones.
- Procedimientos.
- Triggers.

Los comandos SQL de PostgreSQL están organizados en una referencia oficial de comandos, y la sintaxis general del lenguaje se describe por separado en la documentación de SQL Syntax. [web:57][web:60]

## Tipos de comandos SQL

Los comandos suelen agruparse así:

- **DDL**: definen estructura, por ejemplo `CREATE`, `ALTER`, `DROP`, `TRUNCATE`. [web:57]
- **DML**: manipulan datos, por ejemplo `INSERT`, `UPDATE`, `DELETE`. [web:57]
- **DQL**: consultan datos, principalmente `SELECT`. [web:57]
- **TCL**: controlan transacciones, por ejemplo `BEGIN`, `COMMIT`, `ROLLBACK`. [web:57][web:59]
- **DCL**: controlan permisos, por ejemplo `GRANT` y `REVOKE`. [web:57]

## Crear bases y esquemas

Una base de datos se crea con `CREATE DATABASE`, y dentro de ella puedes usar esquemas para organizar objetos. [web:57]  
Un flujo común es crear la base, conectarse a ella y luego crear tablas dentro del esquema `public` o en un esquema propio. [web:57][web:67]

```sql
CREATE DATABASE tienda;
```

```sql
CREATE SCHEMA inventario;
```

## Crear tablas

`CREATE TABLE` define la estructura de una tabla, sus columnas, tipos de datos y restricciones. [web:57][web:62]  
También puedes crear una tabla desde una consulta con `CREATE TABLE AS`, lo cual sirve mucho para staging o resultados intermedios. [web:57]

```sql
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    fecha_registro DATE DEFAULT CURRENT_DATE
);
```

### Tipos de datos frecuentes

PostgreSQL incluye tipos numéricos, de texto, fecha/hora, booleanos y otros más avanzados. [web:62]  
Entre los más usados están:

- `INTEGER`, `BIGINT`, `NUMERIC`, `REAL`.
- `VARCHAR`, `TEXT`, `CHAR`.
- `DATE`, `TIME`, `TIMESTAMP`.
- `BOOLEAN`.

```sql
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL,
    activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Restricciones comunes

Las restricciones permiten asegurar integridad de datos. [web:57][web:62]  
Las más comunes son:

- `PRIMARY KEY`.
- `FOREIGN KEY`.
- `UNIQUE`.
- `NOT NULL`.
- `CHECK`.
- `DEFAULT`.

```sql
CREATE TABLE pedidos (
    id SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL,
    total NUMERIC(12,2) CHECK (total >= 0),
    fecha DATE DEFAULT CURRENT_DATE,
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id)
);
```

## Insertar datos

`INSERT` crea nuevas filas en una tabla. [web:57][web:59]  
Puedes insertar una fila, varias filas o el resultado de una consulta. [web:57]

```sql
INSERT INTO clientes (nombre, email)
VALUES ('Ana Gómez', 'ana@email.com');
```

```sql
INSERT INTO productos (nombre, precio)
VALUES
    ('Teclado', 120000),
    ('Mouse', 45000),
    ('Monitor', 850000);
```

### Insertar desde un `SELECT`

Es muy útil para poblar tablas maestras desde staging o transformar datos. [web:57][web:62]

```sql
INSERT INTO categorias (nombre)
SELECT DISTINCT categoria
FROM staging_productos
WHERE categoria IS NOT NULL;
```

## Consultas básicas

La consulta central en PostgreSQL es `SELECT`, que recupera filas de tablas o vistas. [web:57][web:62]  
`SELECT` puede combinar filtros, orden, agrupación, joins y subconsultas. [web:57][web:62]

```sql
SELECT *
FROM productos;
```

```sql
SELECT nombre, precio
FROM productos
WHERE precio > 100000
ORDER BY precio DESC;
```

### Cláusulas importantes

Las más usadas son:

- `SELECT`.
- `FROM`.
- `WHERE`.
- `ORDER BY`.
- `GROUP BY`.
- `HAVING`.
- `LIMIT`.

```sql
SELECT id_cliente, COUNT(*) AS total_pedidos, SUM(total) AS valor_total
FROM pedidos
GROUP BY id_cliente
HAVING SUM(total) > 500000;
```

## Joins

Los joins combinan filas de dos o más tablas relacionadas. [web:62][web:69]  
Los más comunes son `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN` y `FULL JOIN`. [web:62]

```sql
SELECT p.id, c.nombre, p.total
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id;
```

```sql
SELECT c.nombre, p.total
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.id_cliente;
```

## Subconsultas

Una subconsulta es una consulta dentro de otra consulta. PostgreSQL permite usarlas en `SELECT`, `FROM`, `WHERE` y otras partes de la sentencia. [web:62][web:69]  
Sirven para filtrar, calcular valores agregados o construir conjuntos intermedios. [web:62]

### Subconsulta en `WHERE`

```sql
SELECT nombre
FROM clientes
WHERE id IN (
    SELECT id_cliente
    FROM pedidos
    WHERE total > 300000
);
```

### Subconsulta escalar

```sql
SELECT nombre, precio
FROM productos
WHERE precio > (
    SELECT AVG(precio)
    FROM productos
);
```

### Subconsulta en `FROM`

```sql
SELECT resumen.id_cliente, resumen.total_pedidos
FROM (
    SELECT id_cliente, COUNT(*) AS total_pedidos
    FROM pedidos
    GROUP BY id_cliente
) AS resumen
WHERE resumen.total_pedidos >= 3;
```

### `EXISTS`

`EXISTS` es útil cuando solo necesitas comprobar si hay filas relacionadas. [web:62]

```sql
SELECT c.nombre
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.id_cliente = c.id
);
```

## Actualizar y borrar datos

`UPDATE` modifica filas existentes y `DELETE` elimina filas. [web:57][web:59]  
Siempre conviene probar primero el `WHERE` con un `SELECT`. [web:57]

```sql
UPDATE productos
SET precio = precio * 1.10
WHERE activo = TRUE;
```

```sql
DELETE FROM pedidos
WHERE fecha < DATE '2023-01-01';
```

## Vistas

`CREATE VIEW` define una vista a partir de una consulta. Una vista presenta datos como si fueran una tabla, pero en general no almacena físicamente el resultado como una tabla normal. [web:65][web:70]  
Las vistas sirven para simplificar consultas largas, encapsular lógica y controlar acceso a datos. [web:65]

```sql
CREATE VIEW vista_pedidos_clientes AS
SELECT p.id, c.nombre AS cliente, p.total, p.fecha
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id;
```

Luego se consulta igual que una tabla:

```sql
SELECT *
FROM vista_pedidos_clientes;
```

### Reemplazar una vista

PostgreSQL soporta `CREATE OR REPLACE VIEW` para redefinirla sin borrarla primero. [web:65]

```sql
CREATE OR REPLACE VIEW vista_productos_activos AS
SELECT id, nombre, precio
FROM productos
WHERE activo = TRUE;
```

## Funciones

PostgreSQL permite crear funciones en SQL y en lenguajes procedurales como PL/pgSQL. [web:64][web:66]  
Una función recibe argumentos, ejecuta lógica y devuelve un valor, una fila o un conjunto de filas. [web:64]

### Función simple en SQL

```sql
CREATE FUNCTION precio_con_iva(precio NUMERIC)
RETURNS NUMERIC
LANGUAGE SQL
AS $$
    SELECT precio * 1.19;
$$;
```

Uso:

```sql
SELECT nombre, precio_con_iva(precio)
FROM productos;
```

### Función en PL/pgSQL

PL/pgSQL permite variables, condiciones, ciclos y sentencias más complejas. [web:66]

```sql
CREATE OR REPLACE FUNCTION clasificar_precio(precio NUMERIC)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN
    IF precio < 50000 THEN
        RETURN 'Bajo';
    ELSIF precio < 200000 THEN
        RETURN 'Medio';
    ELSE
        RETURN 'Alto';
    END IF;
END;
$$;
```

### Funciones que retornan tabla

```sql
CREATE OR REPLACE FUNCTION pedidos_por_cliente(cliente_id INTEGER)
RETURNS TABLE(id_pedido INTEGER, total NUMERIC, fecha DATE)
LANGUAGE SQL
AS $$
    SELECT id, total, fecha
    FROM pedidos
    WHERE id_cliente = cliente_id;
$$;
```

## Procedures

PostgreSQL distingue funciones y procedimientos. `CREATE PROCEDURE` define procedimientos que se invocan con `CALL`, mientras que las funciones normalmente se usan dentro de expresiones SQL y retornan un valor o conjunto. [web:68][web:64]  
Los procedimientos son útiles para lógica administrativa o procesos por pasos. [web:68]

```sql
CREATE PROCEDURE insertar_cliente(
    p_nombre VARCHAR,
    p_email VARCHAR
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO clientes(nombre, email)
    VALUES (p_nombre, p_email);
END;
$$;
```

Uso:

```sql
CALL insertar_cliente('Luis Pérez', 'luis@email.com');
```

## Bloques y control en PL/pgSQL

En PL/pgSQL puedes usar variables, `IF`, `CASE`, `LOOP`, `WHILE`, `FOR` y manejo de errores. [web:66]  
Eso permite construir lógica del lado del servidor sin depender de la aplicación. [web:66]

```sql
DO $$
DECLARE
    total_productos INTEGER;
BEGIN
    SELECT COUNT(*) INTO total_productos
    FROM productos;

    RAISE NOTICE 'Total productos: %', total_productos;
END;
$$;
```

## Secuencias y `SERIAL`

PostgreSQL usa secuencias para generar valores incrementales, y `SERIAL` es una forma práctica de crear una columna entera con secuencia asociada. [web:57]  
También existen `BIGSERIAL` y opciones modernas basadas en identidad según la definición de tabla. [web:57][web:62]

```sql
CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);
```

## Índices

Los índices aceleran búsquedas y joins sobre columnas frecuentes. PostgreSQL permite crearlos con `CREATE INDEX`. [web:57]  
Un índice mejora rendimiento de lectura, aunque agrega costo a inserciones y actualizaciones. [web:57][web:62]

```sql
CREATE INDEX idx_productos_nombre
ON productos(nombre);
```

```sql
CREATE UNIQUE INDEX idx_clientes_email
ON clientes(email);
```

## Transacciones

Las transacciones agrupan operaciones para que se confirmen o deshagan juntas. PostgreSQL soporta `BEGIN`, `COMMIT` y `ROLLBACK`. [web:57][web:59]  
Esto es clave cuando un proceso tiene varios `INSERT` o `UPDATE` dependientes entre sí. [web:57]

```sql
BEGIN;

INSERT INTO clientes(nombre, email)
VALUES ('María López', 'maria@email.com');

INSERT INTO pedidos(id_cliente, total)
VALUES (1, 250000);

COMMIT;
```

Si ocurre un error, puedes revertir:

```sql
ROLLBACK;
```

## Restricciones y calidad de datos

PostgreSQL permite reforzar calidad de datos con `CHECK`, claves foráneas y unicidad. [web:57][web:62]  
Eso ayuda a evitar duplicados, referencias inválidas y valores fuera de rango. [web:57]

```sql
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario NUMERIC(12,2) CHECK (salario >= 0)
);
```

## Vistas vs tablas

Una tabla almacena físicamente datos, mientras que una vista representa una consulta guardada. [web:65][web:70]  
Las tablas se usan para persistencia; las vistas, para simplificar acceso y reutilizar lógica de consulta. [web:65]

## Funciones vs procedures

Las funciones se enfocan en devolver un resultado y suelen usarse dentro de consultas, mientras que los procedimientos se invocan con `CALL` para ejecutar procesos completos. [web:64][web:68]  
Esa diferencia es importante cuando diseñas lógica reutilizable en PostgreSQL. [web:64][web:68]

## Ejemplo integrado

```sql
CREATE TABLE departamentos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    salario NUMERIC(12,2) NOT NULL,
    id_departamento INTEGER REFERENCES departamentos(id)
);

INSERT INTO departamentos(nombre)
VALUES ('Ventas'), ('TI'), ('Finanzas');

INSERT INTO empleados(nombre, salario, id_departamento)
VALUES
    ('Ana', 2500000, 1),
    ('Luis', 3200000, 2),
    ('Marta', 2800000, 1);

CREATE VIEW vista_empleados_departamento AS
SELECT e.nombre, e.salario, d.nombre AS departamento
FROM empleados e
JOIN departamentos d ON e.id_departamento = d.id;

CREATE OR REPLACE FUNCTION total_salarios_departamento(dep_id INTEGER)
RETURNS NUMERIC
LANGUAGE SQL
AS $$
    SELECT COALESCE(SUM(salario), 0)
    FROM empleados
    WHERE id_departamento = dep_id;
$$;
```

## Buenas prácticas

- Usa nombres consistentes para tablas y columnas.
- Define claves primarias y foráneas desde el inicio.
- Prueba primero los `SELECT` antes de `UPDATE` o `DELETE`.
- Usa vistas para consultas repetidas.
- Usa funciones para cálculos reutilizables.
- Usa procedimientos para procesos más completos.
- Agrupa operaciones críticas en transacciones.
- Crea índices en columnas consultadas con frecuencia. [web:57][web:62][web:65][web:64][web:68]

## Documentación oficial útil

- [SQL Commands](https://www.postgresql.org/docs/current/sql-commands.html) [web:57]
- [SQL Syntax](https://www.postgresql.org/docs/current/sql-syntax.html) [web:60]
- [The SQL Language](https://www.postgresql.org/docs/current/sql.html) [web:62]
- [CREATE VIEW](https://www.postgresql.org/docs/current/sql-createview.html) [web:65]
- [SQL Functions](https://www.postgresql.org/docs/current/xfunc-sql.html) [web:64]
- [PL/pgSQL Basic Statements](https://www.postgresql.org/docs/current/plpgsql-statements.html) [web:66]
- [psql](https://www.postgresql.org/docs/current/app-psql.html) [web:67]
