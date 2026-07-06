# Guía de Navegación del Proyecto: Limpieza de Datos y Carga SQL

Este repositorio contiene un conjunto de herramientas en Python y guías detalladas en SQL/Markdown para realizar la limpieza, homologación y estructuración de un dataset sucio de compras, permitiendo su correcta inserción en una base de datos relacional (PostgreSQL).

A continuación se detalla la estructura del proyecto, la ruta relativa de navegación hacia cada archivo y su funcionalidad.

---

## 📁 Estructura General del Proyecto

```text
.
├── .csv/                             # Archivos de datos de entrada, intermedios y salida
│   ├── Dataset_Riwi.csv
│   ├── Dataset_Riwi_errores.csv
│   └── Dataset_Riwi_limpio.csv
├── py/                               # Scripts en Python para automatizar limpieza y conversión
│   ├── clear.py
│   ├── excel_a_csv.py
│   ├── limpiar_dataset_generico.py
│   └── limpiar_dataset_riwi_mejorado.py
├── .gitignore
├── consultas_para_revisar_datos.md   # Chuleta SQL para calidad de datos
├── diseno_bd_desde_dataset_desordenado.md # Guía teórica sobre normalización y modelo ER
├── documentacion_dataset_riwi_limpio.md   # Informe del estado y etapas de la limpieza
├── errores_comunes_sql.md            # Diagnóstico y soluciones a errores comunes en PostgreSQL
├── guia_general_postgresql.md        # Documentación de referencia para PostgreSQL
├── guia_limpieza_sql.md              # Limpieza directo en BD mediante SQL
├── guia_reutilizable_limpieza_datasets.md # Metodología genérica de procesamiento
├── inserts_desde_dataset_sucio_con_fk.md  # Relacionamiento de llaves foráneas dinámicas
├── inserts_desde_staging.md          # Chuleta de consultas INSERT para transaccionales
├── limpieza_pandas.md                # Chuleta con fragmentos de código de Pandas
├── maestras_dataset_sucio.md         # Inserciones y limpieza en tablas maestras
└── mapeos_y_homologacion.md          # Estandarización de ciudades, países y unidades
```

---

## 📑 1. Guías de SQL, Modelado y Buenas Prácticas (Raíz)

Estos documentos en formato Markdown sirven como guías prácticas y conceptuales para el diseño de bases de datos y la carga/depuración mediante sentencias SQL.

| Nombre del Archivo | Ruta Relativa | Descripción |
| :--- | :--- | :--- |
| [diseno_bd_desde_dataset_desordenado.md](./diseno_bd_desde_dataset_desordenado.md) | `./diseno_bd_desde_dataset_desordenado.md` | Guía de diseño de BD relacionales a partir de datos no estructurados. Explica entidades, atributos, claves primarias/foráneas, relaciones de cardinalidad, normalización hasta 3FN y diagramas ER en Draw.io. |
| [guia_general_postgresql.md](./guia_general_postgresql.md) | `./guia_general_postgresql.md` | Manual de referencia amplio de PostgreSQL. Abarca desde la distinción de comandos (DDL, DML, DQL, TCL, DCL), tipos de datos, creación de tablas y restricciones, hasta joins, subconsultas, vistas, funciones y procedimientos PL/pgSQL. |
| [guia_limpieza_sql.md](./guia_limpieza_sql.md) | `./guia_limpieza_sql.md` | Técnicas para limpiar datos sucios directamente en PostgreSQL usando consultas SQL (uso de `NULLIF`, `CASE WHEN`, `INITCAP`, limpieza de fechas heterogéneas, notación científica y expresiones regulares). |
| [guia_reutilizable_limpieza_datasets.md](./guia_reutilizable_limpieza_datasets.md) | `./guia_reutilizable_limpieza_datasets.md` | Enfoque metodológico paso a paso para afrontar la limpieza de cualquier dataset nuevo clasificando columnas por tipo lógico (IDs, fechas, números y texto libre). |
| [limpieza_pandas.md](./limpieza_pandas.md) | `./limpieza_pandas.md` | Chuleta de código que documenta los fragmentos de Pandas en Python más comunes para resolver problemas de formatos de fecha, números, notación científica, normalización de encabezados y valores nulos. |
| [mapeos_y_homologacion.md](./mapeos_y_homologacion.md) | `./mapeos_y_homologacion.md` | Guía conceptual y de código sobre homologación de datos. Explica cómo consolidar variantes (p. ej., homologar "Bogot" y "Bogotá D.C." a "Bogotá") para evitar duplicados lógicos. |
| [maestras_dataset_sucio.md](./maestras_dataset_sucio.md) | `./maestras_dataset_sucio.md` | Scripts SQL ordenados y recomendados para poblar las tablas maestras (`pais`, `ciudad`, `empleado`, `bodega`, `proveedor`, etc.) usando sentencias `INSERT INTO ... SELECT DISTINCT` desde una tabla staging. |
| [inserts_desde_dataset_sucio_con_fk.md](./inserts_desde_dataset_sucio_con_fk.md) | `./inserts_desde_dataset_sucio_con_fk.md` | Guía explicativa sobre cómo realizar inserts en tablas relacionales que contienen llaves foráneas (`compra`, `detalle_compra`, `movimiento`) asociándolas de forma dinámica mediante `JOIN` contra las maestras. |
| [inserts_desde_staging.md](./inserts_desde_staging.md) | `./inserts_desde_staging.md` | Código SQL de referencia rápida (chuleta) con las consultas completas de `INSERT ... SELECT ... JOIN` para migrar datos de staging a tablas de negocio. |
| [consultas_para_revisar_datos.md](./consultas_para_revisar_datos.md) | `./consultas_para_revisar_datos.md` | Consultas SQL de auditoría rápida para detectar registros duplicados, nulos inesperados, inconsistencias relacionales (huérfanos) y errores de fechas o rangos. |
| [errores_comunes_sql.md](./errores_comunes_sql.md) | `./errores_comunes_sql.md` | Guía de diagnóstico rápido que asocia errores comunes de PostgreSQL (violación de FK, duplicados PK/Unique, errores de casteo de datos, desbordamiento de cadenas) con su causa y código SQL para solucionarlo. |
| [documentacion_dataset_riwi_limpio.md](./documentacion_dataset_riwi_limpio.md) | `./documentacion_dataset_riwi_limpio.md` | Documento que detalla el alcance y resultados de la limpieza sobre el dataset Riwi, especificando qué mejoras se aplicaron (fechas, nulos, decimales) y qué aspectos lógicos se mantuvieron sucios para homologación posterior. |

---

## 🐍 2. Scripts en Python (`/py/`)

Scripts listos para ejecutar que resuelven problemas de lectura, limpieza, conversión y tipado de datos usando Python y la librería `pandas`.

| Nombre del Archivo | Ruta Relativa | Descripción |
| :--- | :--- | :--- |
| [excel_a_csv.py](./py/excel_a_csv.py) | `./py/excel_a_csv.py` | Script utilitario con interfaz de línea de comandos (argparse) para convertir archivos Excel (.xls o .xlsx) a formato CSV compatible, permitiendo configurar la codificación y delimitador. |
| [clear.py](./py/clear.py) | `./py/clear.py` | Primer script de limpieza adaptado al dataset de Riwi. Realiza limpieza de formato en nombres de columnas, espacios en blanco, valores nulos lógicos, parseo de múltiples formatos de fecha y limpieza de números en notación científica. |
| [limpiar_dataset_generico.py](./py/limpiar_dataset_generico.py) | `./py/limpiar_dataset_generico.py` | Script parametrizable y reutilizable para limpiar cualquier dataset nuevo. Clasifica y limpia columnas de manera dinámica infiriendo tipos por patrones de texto (fechas, números, teléfonos, emails, IDs y textos). |
| [limpiar_dataset_riwi_mejorado.py](./py/limpiar_dataset_riwi_mejorado.py) | `./py/limpiar_dataset_riwi_mejorado.py` | Versión avanzada del script de limpieza para Riwi. Integra diccionarios de homologación manual para normalizar los valores textuales de ciudades, países, proveedores, bodegas, tipos de movimiento y unidades. Genera el dataset limpio y uno adicional con registros de error detectados. |

---

## 📊 3. Archivos de Datos (`/.csv/`)

Archivos planos tipo CSV que representan los diferentes estados por los que viaja la información desde el origen hasta el destino limpio.

| Nombre del Archivo | Ruta Relativa | Descripción |
| :--- | :--- | :--- |
| [Dataset_Riwi.csv](./.csv/Dataset_Riwi.csv) | `./.csv/Dataset_Riwi.csv` | Dataset original que contiene los registros de compra sin limpiar. Posee formatos heterogéneos de fechas, espacios, notaciones científicas y textos sucios. |
| [Dataset_Riwi_limpio.csv](./.csv/Dataset_Riwi_limpio.csv) | `./.csv/Dataset_Riwi_limpio.csv` | Dataset resultante tras ejecutar el script de limpieza y homologación mejorado. Listo para ser importado directamente a una base de datos PostgreSQL como staging. |
| [Dataset_Riwi_errores.csv](./.csv/Dataset_Riwi_errores.csv) | `./.csv/Dataset_Riwi_errores.csv` | Contiene los registros que fallaron alguna regla de validación de negocio y no se exportaron en el archivo limpio, facilitando la auditoría de calidad de datos. |

---

## 🛠️ 4. Configuración del Repositorio

- **[.gitignore](./.gitignore)** (`./.gitignore`): Archivo de configuración para omitir del control de versiones de Git directorios como entornos virtuales (`venv/`), caches y archivos temporales.
