# Diseño de base de datos desde un dataset desordenado

Esta guía explica cómo pasar de un dataset sucio o desordenado a un diseño de base de datos relacional bien estructurado, aplicando normalización hasta 3FN, definiendo entidades, relaciones, cardinalidades y representando el modelo en draw.io con notación de entidad-relación. La normalización busca reducir redundancia y dependencias incorrectas, mientras que un diagrama ER bien hecho ayuda a visualizar entidades, atributos y relaciones antes de crear tablas reales. [web:81][web:80][web:84]

## Objetivo del proceso

Cuando recibes un CSV o tabla sucia, no debes convertirlo directo en una sola tabla final. Lo correcto es identificar grupos de datos, separar entidades, detectar relaciones y luego diseñar el modelo relacional. [web:84][web:81]  
Ese proceso mejora integridad, reduce duplicados y facilita consultas, mantenimiento y crecimiento futuro. [web:74][web:79]

## Paso 1: leer el dataset como negocio

Antes de pensar en SQL, interpreta qué representa cada columna del dataset. Un dataset desordenado suele mezclar datos de varias entidades en una sola fila, por ejemplo proveedor, producto, ciudad, bodega, movimiento y compra al mismo tiempo. [web:80][web:84]  
La pregunta clave es: “¿qué objetos reales del negocio aparecen aquí?”; casi siempre esas respuestas serán sustantivos como Cliente, Producto, Empleado, Pedido o Ciudad. [web:80]

### Qué buscar

- Columnas que describen personas, empresas o lugares.
- Columnas que describen eventos, como compras o ventas.
- Columnas repetidas en muchas filas.
- Valores duplicados con pequeñas variaciones.
- Campos que parecen depender de otros.

Ejemplo mental:

- `nombre_proveedor`, `nit_proveedor`, `telefono_proveedor` apuntan a la entidad **Proveedor**.
- `nombre_producto`, `categoria`, `unidad_medida` apuntan a **Producto**.
- `nombre_bodega`, `direccion_bodega`, `responsable_bodega` apuntan a **Bodega**.
- `fecha_compra`, `valor_total_compra` apuntan a **Compra**.

## Paso 2: identificar entidades

Una entidad es un objeto del negocio sobre el que quieres guardar datos. En modelado ER se suele representar con un rectángulo. [web:80]  
Si varias columnas describen consistentemente al mismo “objeto”, probablemente forman una entidad. [web:84]

### Señales de que algo es una entidad

- Tiene identidad propia.
- Puede existir en muchas filas distintas.
- Tiene varios atributos asociados.
- Puede relacionarse con otras entidades.

Ejemplos comunes:

- Proveedor.
- Producto.
- Categoría.
- Ciudad.
- País.
- Bodega.
- Empleado.
- Compra.
- Movimiento.

## Paso 3: identificar atributos

Los atributos son las características de una entidad, y en el modelo ER clásico se representan con óvalos conectados a la entidad. [web:80]  
Cada atributo debe describir una propiedad de una sola entidad, no mezclar información de dos conceptos distintos. [web:80][web:84]

Ejemplo:

- Entidad **Proveedor**: `id_proveedor`, `nombre`, `nit`, `telefono`, `email`.
- Entidad **Ciudad**: `id_ciudad`, `nombre`.
- Entidad **Producto**: `id_producto`, `nombre`, `descripcion`, `precio_unitario`.

### Buenas prácticas con atributos

- Usa nombres claros y consistentes.
- Evita columnas ambiguas como `dato1` o `tipo` sin contexto.
- Separa atributos compuestos si luego se consultarán por partes.
- Evita guardar listas en una sola columna, por ejemplo “rojo, azul, verde”. [web:84][web:79]

## Paso 4: encontrar claves primarias

Cada entidad debe tener una clave primaria que identifique de forma única cada fila. Una buena clave primaria debe ser única, estable y no nula. [web:84][web:79]  
En la implementación relacional, normalmente será una columna como `id`, `id_producto`, `id_cliente` o una clave natural realmente confiable. [web:79]

### Recomendaciones

- Prefiere claves sustitutas simples si el origen es muy sucio.
- Conserva claves naturales importantes como `nit` o `email` con restricción `UNIQUE` si aplican.
- No uses como clave primaria campos que cambian con frecuencia.

## Paso 5: descubrir relaciones

Una relación muestra cómo se asocian dos entidades. En un diagrama ER clásico se representa con un rombo entre entidades, y el nombre de la relación suele ser un verbo. [web:80]  
Por ejemplo: un proveedor **suministra** productos, una compra **incluye** productos, una bodega **almacena** productos. [web:80]

### Cómo reconocer relaciones desde el dataset

Busca dependencias como estas:

- Un proveedor aparece muchas veces con distintos productos.
- Una ciudad aparece asociada a muchos proveedores.
- Una compra puede incluir varios productos.
- Un producto puede aparecer en muchas compras.

Eso te ayuda a definir si la relación es 1:1, 1:N o N:M. [web:75][web:80]

## Paso 6: definir cardinalidad

La cardinalidad indica cuántas ocurrencias de una entidad se relacionan con cuántas de otra. Draw.io explica la cardinalidad con conectores tipo crow’s foot: círculo para cero, línea para uno y pata de cuervo para muchos. [web:75]  
Las combinaciones comunes son uno a uno, uno a muchos y muchos a muchos. [web:75]

### Tipos principales

- **1:1**: una fila de A se relaciona con una sola de B.
- **1:N**: una fila de A se relaciona con muchas de B.
- **N:M**: muchas filas de A se relacionan con muchas de B.

### Ejemplos

- Un **país** tiene muchas **ciudades**: 1:N.
- Una **ciudad** tiene muchos **proveedores**: 1:N.
- Una **compra** tiene muchos **detalles_compra**: 1:N.
- Un **producto** puede estar en muchas **compras**, y una **compra** puede incluir muchos **productos**: N:M; eso se resuelve con una entidad intermedia como `detalle_compra`. [web:75][web:80]

## Paso 7: aplicar normalización

La normalización organiza los datos para reducir redundancia y anomalías de inserción, actualización y borrado. La tercera forma normal exige que la tabla esté en 2FN y que no tenga dependencias transitivas entre atributos no clave. [web:80][web:81]  
Para diseño desde un dataset sucio, normalmente se revisan 1FN, 2FN y 3FN en ese orden. [web:80][web:81]

## Primera forma normal (1FN)

Una tabla está en 1FN cuando cada columna contiene valores atómicos y no hay grupos repetitivos dentro de una misma fila. [web:80][web:81]  
Si una celda contiene varios teléfonos, varias categorías o listas separadas por comas, no está en 1FN. [web:81]

### Qué revisar para 1FN

- Que cada celda tenga un solo valor.
- Que no existan columnas duplicadas por posición, como `telefono1`, `telefono2`, `telefono3` si en realidad es otra entidad.
- Que no existan listas dentro de una columna.

Ejemplo malo:

- `colores = 'rojo, azul, verde'`

Ejemplo mejor:

- una tabla aparte si realmente un registro tiene varios colores.

## Segunda forma normal (2FN)

Una tabla está en 2FN cuando ya está en 1FN y todos los atributos no clave dependen de la clave completa, no solo de una parte de ella. [web:80][web:81]  
Este problema aparece sobre todo cuando la clave primaria es compuesta. [web:80]

### Ejemplo conceptual

Si tienes una tabla con clave compuesta `(id_compra, id_producto)` y además guardas `nombre_producto`, ese nombre depende solo de `id_producto`, no de toda la clave. [web:80][web:81]  
Entonces `nombre_producto` debe salir de esa tabla y pasar a la entidad **Producto**. [web:80]

## Tercera forma normal (3FN)

Una tabla está en 3FN cuando está en 2FN y no tiene dependencias transitivas entre atributos no clave. [web:80][web:81]  
Una dependencia transitiva ocurre cuando un atributo no clave depende de otro atributo no clave en vez de depender directamente de la clave primaria. [web:80]

### Ejemplo típico

Si en la tabla **Proveedor** guardas:

- `id_proveedor`
- `nombre_proveedor`
- `ciudad_proveedor`
- `pais_proveedor`

pero el país depende de la ciudad y no directamente del proveedor, entonces ahí hay una dependencia transitiva. [web:80][web:81]  
La solución es separar **País** y **Ciudad**, y hacer que `Proveedor` apunte a `Ciudad`, mientras `Ciudad` apunta a `País`. [web:81]

## Cómo pasar del dataset al modelo 3FN

Una forma práctica es esta:

1. Lista todas las columnas del dataset.
2. Agrúpalas por tema de negocio.
3. Propón entidades tentativas.
4. Marca la clave primaria de cada entidad.
5. Detecta repeticiones y dependencias parciales.
6. Detecta dependencias transitivas.
7. Crea tablas puente para relaciones N:M.
8. Ajusta cardinalidades.

Ese flujo reduce mucho el caos de un archivo desordenado y te lleva a un diseño relacional coherente. [web:81][web:84]

## Ejemplo práctico de descomposición

Supón un dataset con estas columnas en una sola tabla:

- `id_registro`
- `fecha_compra`
- `nombre_proveedor`
- `nit_proveedor`
- `ciudad_proveedor`
- `pais_proveedor`
- `nombre_producto`
- `categoria_producto`
- `unidad_medida`
- `nombre_bodega`
- `direccion_bodega`
- `responsable_bodega`
- `tipo_movimiento`
- `cantidad_movimiento`

### Posibles entidades resultantes

- **País**.
- **Ciudad**.
- **Proveedor**.
- **Categoría**.
- **UnidadMedida**.
- **Producto**.
- **Empleado**.
- **Bodega**.
- **Compra**.
- **DetalleCompra**.
- **TipoMovimiento**.
- **Movimiento**.

### Relaciones posibles

- País 1:N Ciudad.
- Ciudad 1:N Proveedor.
- Ciudad 1:N Bodega.
- Empleado 1:N Bodega, si un responsable puede encargarse de varias bodegas.
- Proveedor 1:N Compra.
- Compra 1:N DetalleCompra.
- Producto 1:N DetalleCompra.
- TipoMovimiento 1:N Movimiento.
- Producto 1:N Movimiento.
- Bodega 1:N Movimiento.

## Cuándo crear una entidad intermedia

Debes crear una entidad intermedia cuando la relación entre dos entidades sea muchos a muchos. [web:75][web:80]  
Además, si la relación tiene atributos propios, casi seguro necesita su propia entidad. [web:80]

Ejemplo:

- `Compra` y `Producto` no deben unirse directamente con N:M en el modelo relacional final.
- Se crea `DetalleCompra` con atributos como `cantidad`, `precio_compra` y quizá `subtotal`.

## Buenas prácticas de diseño

Un buen diseño de base de datos no depende solo de normalizar; también depende de claridad, consistencia y escalabilidad. [web:74][web:79][web:84]  
Las buenas prácticas ayudan a que el modelo sea más fácil de implementar, consultar y mantener. [web:74][web:84]

### Recomendaciones clave

- Usa nombres consistentes para entidades y atributos.
- Evita abreviaciones confusas si no están documentadas.
- No mezcles datos maestros con datos transaccionales en una sola tabla.
- Separa catálogos pequeños, por ejemplo `pais`, `ciudad`, `categoria`, `tipo_movimiento`.
- Usa claves primarias simples y claves foráneas explícitas.
- Crea restricciones `UNIQUE` donde tenga sentido, por ejemplo NIT o código.
- Piensa primero en integridad y después en optimización.
- Evita duplicar atributos derivables, salvo casos justificados. [web:74][web:79][web:84]

## Cómo diagramar en draw.io

Draw.io permite crear diagramas ER habilitando la librería de Entity Relation y usando conectores con notación crow’s foot para cardinalidad. La propia documentación indica activar *More Shapes*, seleccionar *Entity Relation* y aplicar la librería. [web:75]  
Luego puedes elegir conectores y cambiar sus extremos para reflejar cero, uno o muchos en cada lado. [web:75]

### Según lo que te piden en clase

Si te pidieron el modelo ER clásico de Chen:

- **Rectángulos** para entidades.
- **Óvalos** para atributos.
- **Rombos** para relaciones.
- Cardinalidad marcada junto a la relación o en los extremos.

Ese estilo es correcto para análisis conceptual, aunque draw.io también soporta crow’s foot, que suele verse más en diseño lógico. [web:75][web:80]

### Pasos en draw.io

1. Entra a [draw.io / diagrams.net](https://www.drawio.com/). [web:75]
2. Crea un diagrama en blanco. [web:73][web:78]
3. Ve a **More Shapes** y activa **Entity Relation**. [web:75][web:78]
4. Arrastra figuras para entidades, atributos y relaciones. [web:75][web:78]
5. Nombra entidades en mayúscula o con estilo consistente. [web:76]
6. Conecta atributos a su entidad. [web:80]
7. Conecta entidades mediante rombos con nombres verbales, por ejemplo “suministra”, “incluye”, “pertenece”. [web:80]
8. Añade cardinalidades claras en cada relación. [web:75][web:76]
9. Ordena el diagrama para que no cruce líneas innecesarias. [web:75][web:78]

## Cómo representar cardinalidad

La guía de draw.io explica estas combinaciones en crow’s foot: círculo equivale a cero, línea a uno y crow’s foot a muchos. [web:75]  
Combinaciones como círculo + línea significan 0..1, línea + línea significan 1..1, círculo + crow’s foot significan 0..N y línea + crow’s foot significan 1..N. [web:75]

Si estás en notación Chen, puedes escribir junto a cada lado valores como `1`, `N`, `0..1` o `1..N` para que la relación quede inequívoca. [web:75][web:80]

## Consejos visuales para el diagrama

- Coloca entidades fuertes en el centro del modelo.
- Deja catálogos alrededor, por ejemplo país, ciudad, categoría.
- Usa nombres de relación como verbos.
- Subraya o marca la clave primaria en los atributos clave.
- Evita saturar el diagrama con demasiados detalles físicos si aún estás en fase conceptual. [web:75][web:78][web:80]

## Conceptual, lógico y físico

Es útil distinguir tres niveles de diseño:

- **Conceptual**: entidades, atributos, relaciones y cardinalidad; aquí encajan rectángulos, óvalos y rombos. [web:80]
- **Lógico**: tablas, PK, FK y resolución de N:M; aquí ya piensas en 3FN. [web:81][web:84]
- **Físico**: tipos de datos, índices, nombres finales SQL y restricciones de implementación en PostgreSQL. [web:74][web:79][web:84]

Si tu profesor pide ER con rectángulos, óvalos y rombos, normalmente espera sobre todo el **modelo conceptual**, y luego una traducción lógica a tablas. [web:80]

## Errores comunes

- Convertir cada columna en una entidad.
- Dejar todo en una sola tabla porque “ya viene en el CSV”.
- Duplicar país dentro de proveedor, bodega y cliente sin crear catálogos.
- No resolver relaciones N:M con entidad intermedia.
- Poner atributos en relaciones cuando en realidad pertenecen a una entidad.
- No especificar cardinalidad.
- Confundir modelo conceptual con script SQL final. [web:80][web:81][web:84]

## Plantilla de análisis para cualquier dataset

Puedes usar esta checklist:

- ¿Qué sustantivos aparecen? → posibles entidades.
- ¿Qué verbos conectan esos sustantivos? → posibles relaciones.
- ¿Qué columnas describen a cada sustantivo? → atributos.
- ¿Cuál atributo identifica de forma única? → clave primaria.
- ¿Hay valores repetidos por grupo? → posible catálogo.
- ¿Hay relación muchos a muchos? → entidad puente.
- ¿Hay atributos que dependen de otro atributo no clave? → romper por 3FN.

## Resultado esperado

Al final debes poder entregar al menos dos cosas:

1. Un diagrama ER conceptual claro con entidades, atributos, relaciones y cardinalidades.
2. Un modelo lógico en 3FN traducido a tablas con PK y FK.

Si haces bien esa transición, luego crear el SQL en PostgreSQL resulta mucho más fácil y más limpio. [web:81][web:84][web:74]
