--
-- PostgreSQL database dump
--

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg13+1)
-- Dumped by pg_dump version 17.0

-- Started on 2026-07-05 20:14:48

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE simulacro;
--
-- TOC entry 3572 (class 1262 OID 32995)
-- Name: simulacro; Type: DATABASE; Schema: -; Owner: pg_database_owner
--

CREATE DATABASE simulacro WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE simulacro OWNER TO pg_database_owner;

\connect simulacro

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 233 (class 1259 OID 33086)
-- Name: bodega; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.bodega (
    id integer NOT NULL,
    nombre character varying NOT NULL,
    direccion character varying NOT NULL,
    id_responsable integer NOT NULL,
    id_ciudad integer NOT NULL
);


ALTER TABLE public.bodega OWNER TO admin123;

--
-- TOC entry 232 (class 1259 OID 33085)
-- Name: bodega_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.bodega_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bodega_id_seq OWNER TO admin123;

--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 232
-- Name: bodega_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.bodega_id_seq OWNED BY public.bodega.id;


--
-- TOC entry 223 (class 1259 OID 33041)
-- Name: categorias_productos; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.categorias_productos (
    id integer NOT NULL,
    nombre character varying NOT NULL
);


ALTER TABLE public.categorias_productos OWNER TO admin123;

--
-- TOC entry 222 (class 1259 OID 33040)
-- Name: categorias_productos_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.categorias_productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categorias_productos_id_seq OWNER TO admin123;

--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 222
-- Name: categorias_productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.categorias_productos_id_seq OWNED BY public.categorias_productos.id;


--
-- TOC entry 219 (class 1259 OID 33011)
-- Name: ciudad; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.ciudad (
    id integer NOT NULL,
    nombre character varying NOT NULL,
    id_pais integer NOT NULL
);


ALTER TABLE public.ciudad OWNER TO admin123;

--
-- TOC entry 218 (class 1259 OID 33010)
-- Name: ciudad_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.ciudad_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ciudad_id_seq OWNER TO admin123;

--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 218
-- Name: ciudad_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.ciudad_id_seq OWNED BY public.ciudad.id;


--
-- TOC entry 241 (class 1259 OID 33171)
-- Name: compra; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.compra (
    id_registro integer NOT NULL,
    fecha_compra date,
    observaciones character varying,
    id_bodega integer NOT NULL,
    id_proveedor integer NOT NULL,
    valor_total_compra numeric NOT NULL
);


ALTER TABLE public.compra OWNER TO admin123;

--
-- TOC entry 240 (class 1259 OID 33170)
-- Name: compra_id_registro_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.compra_id_registro_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compra_id_registro_seq OWNER TO admin123;

--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 240
-- Name: compra_id_registro_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.compra_id_registro_seq OWNED BY public.compra.id_registro;


--
-- TOC entry 215 (class 1259 OID 32996)
-- Name: dataset_riwi; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.dataset_riwi (
    id_registro integer,
    fecha_compra character varying(50),
    id_proveedor integer,
    nombre_proveedor character varying(50),
    nit_proveedor character varying(50),
    telefono_proveedor character varying(50),
    email_proveedor character varying(50),
    ciudad_proveedor character varying(50),
    pais_proveedor character varying(50),
    id_producto integer,
    nombre_producto character varying(50),
    descripcion_producto character varying(50),
    categoria_producto character varying(50),
    subcategoria_producto character varying(50),
    unidad_medida character varying(50),
    precio_unitario integer,
    cantidad_comprada integer,
    valor_total_compra character varying(50),
    id_bodega integer,
    nombre_bodega character varying(50),
    ciudad_bodega character varying(50),
    direccion_bodega character varying(50),
    tipo_movimiento character varying(50),
    cantidad_movimiento integer,
    stock_actual integer,
    responsable_bodega character varying(50),
    observaciones character varying(50)
);


ALTER TABLE public.dataset_riwi OWNER TO admin123;

--
-- TOC entry 242 (class 1259 OID 33189)
-- Name: detalle_compra; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.detalle_compra (
    id_producto integer NOT NULL,
    id_registro integer NOT NULL,
    cantidad_comprada integer NOT NULL,
    precio_compra numeric NOT NULL
);


ALTER TABLE public.detalle_compra OWNER TO admin123;

--
-- TOC entry 229 (class 1259 OID 33068)
-- Name: empleado; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.empleado (
    id integer NOT NULL,
    nombre character varying NOT NULL
);


ALTER TABLE public.empleado OWNER TO admin123;

--
-- TOC entry 228 (class 1259 OID 33067)
-- Name: empleado_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.empleado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.empleado_id_seq OWNER TO admin123;

--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 228
-- Name: empleado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.empleado_id_seq OWNED BY public.empleado.id;


--
-- TOC entry 236 (class 1259 OID 33123)
-- Name: inventario; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.inventario (
    id_bodega integer NOT NULL,
    id_producto integer NOT NULL,
    stock_actual integer NOT NULL
);


ALTER TABLE public.inventario OWNER TO admin123;

--
-- TOC entry 238 (class 1259 OID 33144)
-- Name: movimiento; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.movimiento (
    id integer NOT NULL,
    fecha_movimienta date,
    cantidad_movimiento integer NOT NULL,
    id_bodega integer NOT NULL,
    id_producto integer NOT NULL,
    id_tipo_movimiento integer NOT NULL
);


ALTER TABLE public.movimiento OWNER TO admin123;

--
-- TOC entry 237 (class 1259 OID 33143)
-- Name: movimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.movimiento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movimiento_id_seq OWNER TO admin123;

--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 237
-- Name: movimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.movimiento_id_seq OWNED BY public.movimiento.id;


--
-- TOC entry 217 (class 1259 OID 33002)
-- Name: pais; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.pais (
    id integer NOT NULL,
    nombre character varying NOT NULL
);


ALTER TABLE public.pais OWNER TO admin123;

--
-- TOC entry 216 (class 1259 OID 33001)
-- Name: pais_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.pais_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pais_id_seq OWNER TO admin123;

--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 216
-- Name: pais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.pais_id_seq OWNED BY public.pais.id;


--
-- TOC entry 235 (class 1259 OID 33100)
-- Name: producto; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.producto (
    id integer NOT NULL,
    nombre_producto character varying NOT NULL,
    precio_unitario numeric NOT NULL,
    descripcion character varying,
    id_unidad_medida integer NOT NULL,
    id_categoria integer NOT NULL,
    id_subcategoria integer NOT NULL
);


ALTER TABLE public.producto OWNER TO admin123;

--
-- TOC entry 234 (class 1259 OID 33099)
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_id_seq OWNER TO admin123;

--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 234
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- TOC entry 221 (class 1259 OID 33025)
-- Name: proveedor; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.proveedor (
    id integer NOT NULL,
    nombre character varying NOT NULL,
    nit character varying,
    telefono character varying,
    email character varying,
    id_ciudad integer NOT NULL
);


ALTER TABLE public.proveedor OWNER TO admin123;

--
-- TOC entry 220 (class 1259 OID 33024)
-- Name: proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.proveedor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedor_id_seq OWNER TO admin123;

--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 220
-- Name: proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.proveedor_id_seq OWNED BY public.proveedor.id;


--
-- TOC entry 225 (class 1259 OID 33050)
-- Name: subcategorias_productos; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.subcategorias_productos (
    id integer NOT NULL,
    nombre character varying NOT NULL
);


ALTER TABLE public.subcategorias_productos OWNER TO admin123;

--
-- TOC entry 224 (class 1259 OID 33049)
-- Name: subcategorias_productos_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.subcategorias_productos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subcategorias_productos_id_seq OWNER TO admin123;

--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 224
-- Name: subcategorias_productos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.subcategorias_productos_id_seq OWNED BY public.subcategorias_productos.id;


--
-- TOC entry 239 (class 1259 OID 33165)
-- Name: temp_movimiento; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.temp_movimiento (
    id_registro text,
    fecha_sucia text,
    id_bodega text,
    id_producto text,
    id_tipo_movimiento text,
    cantidad_movimiento text
);


ALTER TABLE public.temp_movimiento OWNER TO admin123;

--
-- TOC entry 231 (class 1259 OID 33077)
-- Name: tipo_movimiento; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.tipo_movimiento (
    id integer NOT NULL,
    nombre character varying NOT NULL
);


ALTER TABLE public.tipo_movimiento OWNER TO admin123;

--
-- TOC entry 230 (class 1259 OID 33076)
-- Name: tipo_movimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.tipo_movimiento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tipo_movimiento_id_seq OWNER TO admin123;

--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 230
-- Name: tipo_movimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.tipo_movimiento_id_seq OWNED BY public.tipo_movimiento.id;


--
-- TOC entry 227 (class 1259 OID 33059)
-- Name: unidades_medidas; Type: TABLE; Schema: public; Owner: admin123
--

CREATE TABLE public.unidades_medidas (
    id integer NOT NULL,
    nombre_unidad character varying NOT NULL
);


ALTER TABLE public.unidades_medidas OWNER TO admin123;

--
-- TOC entry 226 (class 1259 OID 33058)
-- Name: unidades_medidas_id_seq; Type: SEQUENCE; Schema: public; Owner: admin123
--

CREATE SEQUENCE public.unidades_medidas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unidades_medidas_id_seq OWNER TO admin123;

--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 226
-- Name: unidades_medidas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin123
--

ALTER SEQUENCE public.unidades_medidas_id_seq OWNED BY public.unidades_medidas.id;


--
-- TOC entry 3346 (class 2604 OID 33089)
-- Name: bodega id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.bodega ALTER COLUMN id SET DEFAULT nextval('public.bodega_id_seq'::regclass);


--
-- TOC entry 3341 (class 2604 OID 33044)
-- Name: categorias_productos id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.categorias_productos ALTER COLUMN id SET DEFAULT nextval('public.categorias_productos_id_seq'::regclass);


--
-- TOC entry 3339 (class 2604 OID 33014)
-- Name: ciudad id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.ciudad ALTER COLUMN id SET DEFAULT nextval('public.ciudad_id_seq'::regclass);


--
-- TOC entry 3349 (class 2604 OID 33174)
-- Name: compra id_registro; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.compra ALTER COLUMN id_registro SET DEFAULT nextval('public.compra_id_registro_seq'::regclass);


--
-- TOC entry 3344 (class 2604 OID 33071)
-- Name: empleado id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.empleado ALTER COLUMN id SET DEFAULT nextval('public.empleado_id_seq'::regclass);


--
-- TOC entry 3348 (class 2604 OID 33147)
-- Name: movimiento id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.movimiento ALTER COLUMN id SET DEFAULT nextval('public.movimiento_id_seq'::regclass);


--
-- TOC entry 3338 (class 2604 OID 33005)
-- Name: pais id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.pais ALTER COLUMN id SET DEFAULT nextval('public.pais_id_seq'::regclass);


--
-- TOC entry 3347 (class 2604 OID 33103)
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- TOC entry 3340 (class 2604 OID 33028)
-- Name: proveedor id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id SET DEFAULT nextval('public.proveedor_id_seq'::regclass);


--
-- TOC entry 3342 (class 2604 OID 33053)
-- Name: subcategorias_productos id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.subcategorias_productos ALTER COLUMN id SET DEFAULT nextval('public.subcategorias_productos_id_seq'::regclass);


--
-- TOC entry 3345 (class 2604 OID 33080)
-- Name: tipo_movimiento id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.tipo_movimiento ALTER COLUMN id SET DEFAULT nextval('public.tipo_movimiento_id_seq'::regclass);


--
-- TOC entry 3343 (class 2604 OID 33062)
-- Name: unidades_medidas id; Type: DEFAULT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.unidades_medidas ALTER COLUMN id SET DEFAULT nextval('public.unidades_medidas_id_seq'::regclass);


--
-- TOC entry 3557 (class 0 OID 33086)
-- Dependencies: 233
-- Data for Name: bodega; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.bodega (id, nombre, direccion, id_responsable, id_ciudad) FROM stdin;
\.


--
-- TOC entry 3547 (class 0 OID 33041)
-- Dependencies: 223
-- Data for Name: categorias_productos; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.categorias_productos (id, nombre) FROM stdin;
\.


--
-- TOC entry 3543 (class 0 OID 33011)
-- Dependencies: 219
-- Data for Name: ciudad; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.ciudad (id, nombre, id_pais) FROM stdin;
\.


--
-- TOC entry 3565 (class 0 OID 33171)
-- Dependencies: 241
-- Data for Name: compra; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.compra (id_registro, fecha_compra, observaciones, id_bodega, id_proveedor, valor_total_compra) FROM stdin;
\.


--
-- TOC entry 3539 (class 0 OID 32996)
-- Dependencies: 215
-- Data for Name: dataset_riwi; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.dataset_riwi (id_registro, fecha_compra, id_proveedor, nombre_proveedor, nit_proveedor, telefono_proveedor, email_proveedor, ciudad_proveedor, pais_proveedor, id_producto, nombre_producto, descripcion_producto, categoria_producto, subcategoria_producto, unidad_medida, precio_unitario, cantidad_comprada, valor_total_compra, id_bodega, nombre_bodega, ciudad_bodega, direccion_bodega, tipo_movimiento, cantidad_movimiento, stock_actual, responsable_bodega, observaciones) FROM stdin;
1	2023-07-12	5	Tecno Partes Ltda.	700345678-5	6014567890	tecnopartes@empresa.com	Bogotá	CO	107	interruptor simple	Interruptor eléctrico sencillo 110V	Eléctrico	Controles	und	\N	184		2	Bodega Norte Barranquilla	BARRANQUILLA	Calle 80 # 43-20	Entrada	170	17	M. Pérez	
2	25-08-2023	4	Sum. Industriales Norte	901234567-4	3057891234	suministros.norte@empresa.co	barranquilla	colombia	104	válvula de paso 1/2 pulgada		plomería	Accesorios	UND	15000	66	990000	2	BDG NORTE BQ	Barranquilla	Calle 80 # 43-20	ingreso	39	487	MARIA PEREZ	Compra ordinaria
3	2023-10-04	1	Ferreteria Torres S.A.S.	900123456-1	3101234567	ferreteria.torres@gmail.com	Bogota	Colombia	107	INTERRUPTOR SENCILLO	Interruptor 110V sencillo	eléctricos	INTERRUPTORES	Unidad	8500	136	1047899,749	2	Bodega Norte Barranquilla	B/quilla	CL 80 43-20	egreso	26	18	M. Pérez	
4	27 Apr 2024	2	Distribuidora Electronica Medellin	800987654-2	320 987 6543	dist_electronica@gmail.com	medellin	COLOMBIA	103	TUBO PVC 4 PULGADAS	TUBO PVC SANITARIO 4 PULG	Plásticos	tuberías	mts	8900	81	720900	3	Bodega Sur-Cali	CALI	Av. Americas #5-30	ingreso	42	124	A. Gómez	Pedido urgente
5	07-06-2024	6	Metales y aleaciones s.a	890654321-6	3168765432		Bucaramanga, Sant.	Colombia	106	Perfil de aluminio 1"x1"	Perfil aluminio cuadrado	Metales	Perfiles	mts	22000	37	814000	2	Bodega Norte Barranquilla	Barranquilla	Clle 80 #43-20	INGRESO	17	361	María Pérez	
6	2024-06-17	5	TECNOPARTES LTDA	700345678-5	601-456-7890	tecnopartes.ltda@gmail.com	BOGOTA D.C.	Colombia	108	Cemento gris 50kg		construcción	cementos	BTO	27000	184	4968000	1	Bodega Cntrl Bogotá	BOGOTÁ	CRA 30 15-40	entrada	138	36	CARLOS RODRIGUEZ	N/A
7	2023-06-16	2	Distribuidora Electrónica Medellín	800987654-2	3209876543	electronicamedellin@hotmail.com	MEDELLIN	COLOMBIA	103	Tubo pvc 4 pulg.	TUBO PVC SANITARIO 4 PULG	PLASTICOS	Tuberías	mt	8900	147	1308300	3	Bodega Sur-Cali	Cali	AV LAS AMERICAS 5-30	Entrada	85	432	ANDRES GOMEZ	Compra ordinaria
8	07-18-2023	4	Sum. Industriales Norte	901234567-4	30-57-89-12-34	suministros.norte@empresa.co	BARRANQUILLA	Colombia	103	TUBO PVC 4 PULGADAS		Plomería	TUBERIAS	mts	8900	132	1174800	4	BODEGA MEDELLIN	Medellin	Cra 50 # 45-67	SALIDA	129	353	L. Martínez	
9	2023-03-03	1	ferretería torres sas	900123456-1	310-123-4567		Bogotá	Col	108	cemento 50 kilos	CEMENTO PORTLAND 50 KG	CONSTRUCCION	Aglomerantes	Bolsa	28000	72	2016000	2	Bodega Norte Barranquilla	Barranquilla	Calle 80 # 43-20	entrada	59	95	MARIA PEREZ	Reposición de stock
10	04/11/2024	4	Suministros Industriales del Norte	901234567-4	305 789 1234	sumnorte@gmail.com	B/quilla	colombia	108	cemento 50 kilos	Cemento 50kg	Materiales	cementos	bto	29000	133	3857000	3	BODEGA SUR CALI	Cali	AV LAS AMERICAS 5-30	egreso	61	492	Andrés Gómez	ninguna
11	2024-04-07	4	Suministros Industriales del Norte	901234567-4	305 789 1234	suministros.norte@empresa.co	B/quilla	colombia	101	TORNILLO HEX 1/2	Tornillo metálico para uso estructural	FERRETERIA	TORNILLOS	unidad	1250	24	30000	1	BODEGA CENTRAL BOGOTA	Bogotá	Carrera 30 #15-40	EGRESO	19	299	Carlos Rodríguez	
12	2024-08-24	2	Distribuidora Electrónica Medellín	800987654-2	32-09-87-65-43	dist_electronica@gmail.com	medellin	CO	105	Pintura base agua blanca 1GL	Pintura caucho blanca	Pinturas	Pinturas	GAL	35500	187	6638500	1	Bodega Central Bogotá	BOGOTÁ	Carrera 30 #15-40	EGRESO	81	218	CARLOS RODRIGUEZ	pedido urgente
13	12 Dec 2023	5	Tecno Partes Ltda.	700345678-5	601-456-7890	tecnopartes@empresa.com	Bogota	CO	104	Válvula de paso 1/2"	Válvula de paso en bronce 1/2"	PLOMERIA	válvulas	und	15000	111	1665000	3	BDG SUR	cali	Av. Las Américas # 5-30	EGRESO	5	490	ANDRES GOMEZ	OK
14	28-11-2023	5	Tecno Partes Ltda.	700345678-5	601456789	tecnopartes@empresa.com	BOGOTA D.C.	Colombia	106	Perfil Al. 1"x1"	PERFIL AL CUADRADO 1 PULG	Metales	perfiles	mts	22500	64	1440000	1	Bodega Cntrl Bogotá	Bogotá	Cra 30 # 15-40	Entrada	20	483	C. Rodríguez	Compra ordinaria
15	2023-11-10	2	Dist Electrónica MDE	800987654-2	320 987 6543	dist_electronica@gmail.com	Medellín, Ant.	CO	107	Interruptor sencillo	INTERRUPTOR 110V	Eléctrico	Controles	Uni	8500	104	884000	2	Bodega Norte Barranquilla	Barranquilla	Calle 80 # 43-20	Salida	75	59	M. Pérez	COMPRA ORDINARIA
16	18/05/2023	5	TecnoPartes Ltda	700345678-5	601456789	tecnopartes@empresa.com	Bogota	CO	103	Tubo pvc 4 pulg.		plasticos	tuberías	M	9000	111	999000	4	BDG MEDELLIN	MEDELLIN	Carrera 50 #45-67	ingreso	30	344	L. Martínez	Revisar calidad
17	09-17-2023	4	SUMINISTROS INDUSTRIALES DEL NORTE	901234567-4	3057891234	sumnorte@gmail.com	B/quilla	COLOMBIA	108	CEMENTO GRIS 50KG	Cemento 50kg	Construcción	cementos	bto	28000	165	4620000	4	Bodega Medellín	MEDELLIN	Cra 50 # 45-67	egreso	98	453	L. Martínez	
18	2024-05-06	1	Ferretería Torres S.A.S	900123456-1			Bogota D.C	COLOMBIA	105	Pintura base agua blanca 1GL		Pinturas	Acabados	gal	35000	195	6825000	4	BDG MEDELLIN	Medellín	CRA 50 45-67	egreso	25	455	L. Martínez	N/A
19	08/11/2024	3	plastiflex cali	860456789-3		plastiflex@cali.com	Cali	Colombia	103	Tubo pvc 4 pulg.	Tubo PVC sanitario 4"	PLASTICOS	Tuberías	ML	8800	163	1434400	1	BODEGA CENTRAL BOGOTA	Bogota	CRA 30 15-40	ingreso	143	258	C. Rodríguez	Pedido urgente
20	06-03-2023	3	PLASTIFLEX CALI LTDA.	860456789-3	3154567890	PLASTIFLEX@CALI.COM	CALI	CO	105	Pintura BL agua	Pintura de caucho base agua color blanco	pinturas	pinturas base agua	gl	\N	123		1	Bodega Central Bogotá	Bogotá	Carrera 30 #15-40	egreso	27	322	C. Rodríguez	ok
21	2024-05-31	5	TECNOPARTES LTDA	700345678-5	6014567890	tecnopartes@empresa.com	Bogota	CO	107	Interruptor 1 toma	INTERRUPTOR 110V	Electrónica	Interruptores	Unidad	\N	94		4	BODEGA MEDELLIN	Medellín	Cra 50 # 45-67	entrada	55	52	LUISA MARTINEZ	COMPRA ORDINARIA
22		2	Distribuidora Electrónica Medellín	800987654-2	3209876543	dist.electronica@outlook.com	Medellín, Ant.	COLOMBIA	106	Perfil Al. 1"x1"		Metales	PERFILES	ML	22000	70	1540000	4	BODEGA MEDELLIN	MEDELLIN	Carrera 50 #45-67	ENTRADA	43	360	L. Martínez	COMPRA ORDINARIA
23	01 Feb 2023	5	TecnoPartes Ltda	700345678-5	6014567890	tecnopartes.ltda@gmail.com	Bogotá	Colombia	101	tornillo hexagonal 1/2 pulgada	TORNILLO METALICO ESTRUCTURAL	Ferretería	Tornillos	UND	1200	9	10800	2	Bodega Norte Barranquilla	BARRANQUILLA	Clle 80 #43-20	ingreso	9	472	María Pérez	N/A
24	24 May 2023	6	Metales y aleaciones s.a	890654321-6	316-876-5432		Bucaramanga, Sant.	Colombia	105	PINTURA BASE AGUA BLANCA	Pintura caucho blanca	PINTURAS	Pinturas	GAL	35000	148	5180000	3	BDG SUR	cali	AV LAS AMERICAS 5-30	entrada	55	384	A. Gómez	Revisar calidad
25	2023-04-02	1	ferretería torres sas	900123456-1	3101234567	ferreteria.torres@gmail.com	Bogota	Col	103	Tubo PVC 4 pulgadas		PLASTICOS	Tubos	ML	8900	14	124600	4	Bodega MDE	MEDELLIN	Carrera 50 #45-67	salida	10	303	L. Martínez	ninguna
26	2024-05-19	3	Plastiflex Cali	860456789-3	3154567890	PLASTIFLEX@CALI.COM	Santiago de Cali	Colombia	108	Cemento gris 50kg		Construcción	Cementos	saco	28000	169	4732000	1	Bodega Cntrl Bogotá	BOGOTÁ	Cra 30 # 15-40	EGRESO	68	81	Carlos Rodríguez	Compra ordinaria
27	30 Apr 2024	5	TecnoPartes	700345678-5	601456789	tecnopartes.ltda@gmail.com	Bogota	Colombia	108	Cemento gris 50kg	CEMENTO PORTLAND 50 KG	Materiales	CEMENTOS	bto	28500	175	4987500	4	BODEGA MEDELLIN	MEDELLIN	CRA 50 45-67	salida	26	249	L. Martínez	Compra ordinaria
28	2023-09-12	4	SUMINISTROS INDUSTRIALES DEL NORTE	901234567-4	3057891234	suministros.norte@empresa.co	Barranquilla	COLOMBIA	105	PINTURA BASE AGUA BLANCA	PINTURA CAUCHO BLANCA	PINTURAS	PINTURAS	Galon	35500	40	1420000	4	BODEGA MEDELLIN	Medellin	Cra 50 # 45-67	EGRESO	36	258	LUISA MARTINEZ	
29	2023-04-28	4	Suministros Ind. del Norte	901234567-4	305 789 1234	sumnorte@gmail.com	Bquilla	COLOMBIA	103	Tubo PVC 4 pulgadas	TUBO PVC SANITARIO 4 PULG	Plásticos	tuberías	ML	8900	181		1	BDG CENTRAL	Bogotá	Cra 30 # 15-40	salida	175	99	CARLOS RODRIGUEZ	Revisar calidad
30	06-20-2024	2	Distribuidora Electronica Medellin	800987654-2		dist.electronica@outlook.com	medellin	Colombia	103	TUBO PVC 4 PULGADAS	Tubo de PVC sanitario diámetro 4 pulgadas	Plomería	TUBERIAS	mt	8900	67	596300	1	BODEGA CENTRAL BOGOTA	Bogotá	Cra 30 # 15-40	entrada	31	409	C. Rodríguez	
31	2024-12-02	1	Ferreteria Torres S.A.S.	900123456-1	310 123 4567		Bogota D.C	Col	107	Interruptor 1 toma		Eléctrico	INTERRUPTORES	Uni	8500	138	1173000	4	Bodega MDE	Medellin	Carrera 50 #45-67	Salida	2	110	L. Martínez	Devolución parcial
32	16 Oct 2024	6	METALES Y ALEACIONES SA	890654321-6	3168765432	m.aleaciones@yahoo.com	bucaramanga	Colombia	102	CABLE UTP CAT 6	Cable red Cat6	Electrónica	Redes	metros	4500	73	328500	3	BODEGA SUR CALI	cali	Av. Americas #5-30	ENTRADA	53	270	A. Gómez	Sin observaciones
33		2	DIST. ELECTRONICA MEDELLIN	800987654-2	32-09-87-65-43	dist_electronica@gmail.com	Medellín	COLOMBIA	102	Cable UTP Cat6	Cable red Cat6	Electrónica	Cables	m	4550	67	304850	1	Bodega Central Bogotá	Bogota	Cra 30 # 15-40	egreso	2	474	C. Rodríguez	Pedido urgente
34	28-02-2023	5	Tecno Partes Ltda.	700345678-5		tecnopartes@empresa.com	BOGOTA D.C.	Colombia	104	válvula de paso 1/2 pulgada		plomería	VALVULAS	Uni	15000	89	1335000	3	Bodega Sur-Cali	CALI	Av. Americas #5-30	ENTRADA	34	22	ANDRES GOMEZ	OK
35	2023-05-21	5	Tecno Partes Ltda.	700345678-5		tecnopartes.ltda@gmail.com	BOGOTA D.C.	Colombia	102	Cable UTP CAT6	Cable red Cat6	electronica	Redes	metros	4500	39	175500	3	BODEGA SUR CALI	cali	Av. Americas #5-30	salida	16	21	A. Gómez	OK
36	16/07/2024	1	ferretería torres sas	900123456-1	310 123 4567		Bogotá	Col	104	válvula de paso 1/2 pulgada	Válvula bronce 1/2 pulgada	Plomería	Accesorios	UND	15500	126	1953000	3	Bodega Sur-Cali	CALI	AV LAS AMERICAS 5-30	ingreso	60	334	ANDRES GOMEZ	Pedido urgente
37	2024-05-13	2	Distribuidora Electronica Medellin	800987654-2		dist_electronica@gmail.com	Medellin	Colombia	101	TORNILLO HEX 1/2	TORNILLO METALICO ESTRUCTURAL	Ferretería	Fijaciones	unidad	1200	186	223200	4	BDG MEDELLIN	Medellín	Carrera 50 #45-67	Salida	15	93	Luisa Martínez	pedido urgente
38	2024-10-05	6	Metales y aleaciones s.a	890654321-6	316-876-5432	metales@industriacol.com	bucaramanga	Colombia	104	VALVULA PASO 1/2	Válvula de paso en bronce 1/2"	plomería	Válvulas	Uni	15000	167	2505000	3	Bodega Sur Cali	Cali	Av. Las Américas # 5-30	EGRESO	162	27	A. Gómez	Revisar calidad
39	03-06-2024	4	Suministros Industriales del Norte	901234567-4	3057891234		B/quilla	COLOMBIA	108	CEMENTO GRIS 50KG	Cemento portland tipo I 50 kilos	Materiales	cementos	Bulto	28500	111	3163500	3	Bodega Sur Cali	Cali	Av. Americas #5-30	SALIDA	44	94	Andrés Gómez	Reposición de stock
40	23-03-2023	2	Dist Electrónica MDE	800987654-2	3209876543	dist.electronica@outlook.com	Medellín, Ant.	Colombia	107	interruptor simple	Interruptor eléctrico sencillo 110V	eléctricos	Interruptores	Unidad	8500	189	1606500	1	BODEGA CENTRAL BOGOTA	Bogota	Cra 30 # 15-40	INGRESO	29	371	CARLOS RODRIGUEZ	Compra ordinaria
41		5	TECNOPARTES LTDA			tecnopartes@empresa.com	Bogota	Colombia	102	Cable utp categoría 6	CABLE RED CAT 6	Electrónica	Redes	mt	4500	114	513000	4	Bodega MDE	Medellín	CRA 50 45-67	egreso	75	432	Luisa Martínez	N/A
42	18-07-2023	2	Distribuidora Electronica Medellin	800987654-2		dist.electronica@outlook.com	medellin	Colombia	107	INTERRUPTOR SENCILLO	INTERRUPTOR 110V	eléctricos	interruptores	Uni	8500	123		2	BODEGA NORTE B/QUILLA	B/quilla	Calle 80 # 43-20	Salida	43	473	MARIA PEREZ	ok
43	08-12-2023	5	TecnoPartes Ltda	700345678-5	6014567890	tecnopartes.ltda@gmail.com	Bogota	Colombia	104	Válvula de paso 1/2"	Válvula bronce 1/2 pulgada	plomería	VALVULAS	UND	15500	33	511500	3	Bodega Sur-Cali	CALI	Av. Las Américas # 5-30	salida	5	322	A. Gómez	pedido urgente
44		5	TECNOPARTES LTDA			tecnopartes.ltda@gmail.com	BOGOTA D.C.	Colombia	107	Interruptor sencillo	Interruptor 110V sencillo	eléctricos	interruptores	Unidad	8000	87	696000	3	BDG SUR	CALI	Av. Las Américas # 5-30	EGRESO	55	492	A. Gómez	pedido urgente
45	03 Jun 2023	4	Suministros Ind. del Norte	901234567-4	305 789 1234		B/quilla	Colombia	102	Cable UTP CAT6	CABLE RED CAT 6	electronica	Cables	metros	4400	199	875600	1	BDG CENTRAL	Bogotá	Carrera 30 #15-40	EGRESO	197	129	C. Rodríguez	Revisar calidad
46	11-14-2023	1	ferretería torres sas	900123456-1		ftorres@gmail.com	Bogota D.C	colombia	106	Perfil de aluminio 1"x1"	Perfil aluminio cuadrado	Aluminio	Estructuras	mt	21000	17	357000	2	Bodega Norte Barranquilla	B/quilla	CL 80 43-20	INGRESO	6	69	MARIA PEREZ	COMPRA ORDINARIA
47	2023-03-30	4	SUMINISTROS INDUSTRIALES DEL NORTE	901234567-4	30-57-89-12-34	sumnorte@gmail.com	BARRANQUILLA	colombia	105	Pintura base agua blanca	PINTURA CAUCHO BLANCA	pinturas	pinturas base agua	Galón	36000	116	4176000	4	BDG MEDELLIN	MEDELLIN	Cra 50 # 45-67	salida	84	139	LUISA MARTINEZ	pedido urgente
48	2024-10-28	4	Suministros Ind. del Norte	901234567-4	30-57-89-12-34	sumnorte@gmail.com	barranquilla	Colombia	101	TORNILLO HEX 1/2	TORNILLO METALICO ESTRUCTURAL	ferretería	Tornillos	Uni	1200	61	73200	2	BDG NORTE BQ	B/quilla	Calle 80 # 43-20	ENTRADA	46	43	M. Pérez	pedido urgente
49	2024-02-13	5	Tecno Partes Ltda.	700345678-5	601456789	tecnopartes.ltda@gmail.com	Bogotá	Colombia	105	Pintura base agua blanca	Pintura caucho blanca	pinturas	Acabados	gl	\N	194		3	Bodega Sur-Cali	CALI	Av. Americas #5-30	Entrada	101	494	ANDRES GOMEZ	ninguna
50	31/08/2023	6	METALES Y ALEACIONES SA	890654321-6	316-876-5432		Bucaramanga	Colombia	101	Tornillo Hex. 1/2"		Ferretería	tornillos	und	1200	93	104252,0747	2	BODEGA NORTE B/QUILLA	BARRANQUILLA	Calle 80 # 43-20	Entrada	6	318	María Pérez	Reposición de stock
51	14/02/2024	4	Suministros Ind. del Norte	901234567-4	3057891234	sumnorte@gmail.com	BARRANQUILLA	COLOMBIA	106	perfil aluminio 1 pulgada x 1 pulgada		Aluminio	PERFILES	mt	21000	49		2	Bodega Norte Barranquilla	B/quilla	CL 80 43-20	entrada	20	189	MARIA PEREZ	ok
52	26 Mar 2024	5	TecnoPartes	700345678-5	601456789	tecnopartes.ltda@gmail.com	Bogotá	Colombia	105	PINTURA BASE AGUA BLANCA	Pintura caucho blanca	PINTURAS	PINTURAS	gal	35000	169	5915000	1	Bodega Central Bogotá	BOGOTÁ	CRA 30 15-40	ingreso	149	367	CARLOS RODRIGUEZ	OK
53	10 Jan 2024	2	Dist Electrónica MDE	800987654-2	320 987 6543	dist_electronica@gmail.com	Medellín, Ant.	CO	106	Perfil Al. 1"x1"	Perfil de aluminio cuadrado 1 pulgada	Metales	perfiles	mt	21000	8	168000	2	Bodega Norte Barranquilla	B/quilla	Clle 80 #43-20	entrada	7	164	María Pérez	Pedido urgente
54	26/01/2023	6	METALES Y ALEACIONES SA	890654321-6	316 876 54 32	metales@industriacol.com	Bucaramanga	Colombia	106	Perfil de aluminio 1"x1"		METALES	Perfiles	ML	22500	151	3397500	3	Bodega Sur-Cali	Cali	Av. Americas #5-30	ENTRADA	76	92	ANDRES GOMEZ	Revisar calidad
55	2023-03-09	5	Tecno Partes Ltda.	700345678-5	601456789	tecnopartes.ltda@gmail.com	Bogota	Colombia	105	Pintura BL agua	PINTURA CAUCHO BLANCA	pinturas	Acabados	gal	35000	79	2765000	3	BODEGA SUR CALI	Cali	Av. Las Américas # 5-30	EGRESO	61	201	Andrés Gómez	
56	03-12-2023	1	Ferreteria Torres S.A.S.	900123456-1	310-123-4567	ftorres@gmail.com	bogota, d.c.	Col	107	Interruptor sencillo	Interruptor 110V sencillo	Electrónica	Interruptores	UND	\N	44		3	BODEGA SUR CALI	CALI	AV LAS AMERICAS 5-30	SALIDA	42	175	A. Gómez	N/A
57	2023-04-27	5	TecnoPartes	700345678-5	601-456-7890	tecnopartes@empresa.com	Bogota	CO	102	Cable utp categoría 6	CABLE RED CAT 6	Electrónica e IT	Cables	mt	4500	125	562500	2	BODEGA NORTE B/QUILLA	B/quilla	CL 80 43-20	Salida	100	22	MARIA PEREZ	
58	04 Mar 2023	1	Ferreteria Torres S.A.S.	900123456-1	3101234567		BOGOTÁ	COLOMBIA	106	Perfil de aluminio 1"x1"		metales	perfiles	ML	23000	34	782000	2	BODEGA NORTE B/QUILLA	B/quilla	CL 80 43-20	EGRESO	24	438	MARIA PEREZ	Reposición de stock
59	02 May 2023	1	ferretería torres sas	900123456-1	310 123 4567	ftorres@gmail.com	bogota, d.c.	COLOMBIA	102	Cable UTP CAT6	Cable de red categoría 6 para datos	Electrónica e IT	CABLES	m	4500	67	301500	2	Bodega Norte Barranquilla	BARRANQUILLA	CL 80 43-20	egreso	26	392	M. Pérez	Pedido urgente
60	2024-03-28	2	DIST. ELECTRONICA MEDELLIN	800987654-2	32-09-87-65-43	electronicamedellin@hotmail.com	Medellin	CO	104	VALVULA PASO 1/2		Ferretería	Válvulas	UND	15000	16	240000	2	Bodega Norte Barranquilla	Barranquilla	Clle 80 #43-20	EGRESO	14	333	MARIA PEREZ	N/A
61	08 Apr 2024	3	plastiflex cali	860456789-3		plastiflex@cali.com	Cali, Valle	CO	106	Perfil de aluminio 1"x1"		METALES	Estructuras	ML	23000	157	3611000	3	Bodega Sur Cali	CALI	Av. Americas #5-30	EGRESO	153	121	A. Gómez	
62	10-10-2023	1	ferretería torres sas		310 123 4567	ftorres@gmail.com	BOGOTÁ	COLOMBIA	102	CABLE UTP CAT 6	Cable red Cat6	electronica	Cables	mt	4400	77	338800	2	Bodega Norte Barranquilla	Barranquilla	Calle 80 # 43-20	entrada	27	106	María Pérez	N/A
63	11-09-2023	2	Dist Electrónica MDE	800987654-2	320 987 6543	dist_electronica@gmail.com	Medellín	CO	101	tornillo hexagonal 1/2 pulgada	TORNILLO METALICO ESTRUCTURAL	Ferretería	Fijaciones	UND	1150	144	165600	2	Bodega Norte Barranquilla	B/quilla	CL 80 43-20	Entrada	103	187	MARIA PEREZ	
64	2024-12-01	1	ferretería torres sas	900123456-1	3101234567	ftorres@gmail.com	bogota, d.c.	Colombia	108	Cemento gris 50kg	Cemento portland tipo I 50 kilos	Materiales	Aglomerantes	Bulto	28000	24	672000	4	BODEGA MEDELLIN	Medellin	Carrera 50 #45-67	Salida	21	26	L. Martínez	Reposición de stock
65	2024-06-27	1	Ferretería Torres S.A.S	900123456-1			Bogota D.C	Colombia	104	válvula de paso 1/2 pulgada	Válvula de paso en bronce 1/2"	plomería	VALVULAS	Unidad	15500	97	1503500	4	Bodega Medellín	Medellin	Cra 50 # 45-67	salida	34	362	L. Martínez	Reposición de stock
66	2024-03-20	2	DIST. ELECTRONICA MEDELLIN	800987654-2	32-09-87-65-43	electronicamedellin@hotmail.com	Medellín	COLOMBIA	101	TORNILLO HEX 1/2	TORNILLO METALICO ESTRUCTURAL	Ferretería	TORNILLOS	Uni	1300	21	27300	1	BODEGA CENTRAL BOGOTA	BOGOTÁ	Cra 30 # 15-40	entrada	18	42	Carlos Rodríguez	ok
67	01-23-2023	1	Ferretería Torres S.A.S	900123456-1	310 123 4567		Bogota	COLOMBIA	105	Pintura base agua blanca		pinturas	PINTURAS	Galón	35000	119	4165000	1	BDG CENTRAL	BOGOTÁ	CRA 30 15-40	entrada	32	163	C. Rodríguez	COMPRA ORDINARIA
68	20/06/2023	6	METALES Y ALEACIONES SA	890654321-6	316-876-5432	m.aleaciones@yahoo.com	Bucaramanga, Sant.	Colombia	108	cemento 50 kilos	CEMENTO PORTLAND 50 KG	construcción	cementos	BTO	28000	11	308000	2	Bodega Norte Barranquilla	B/quilla	CL 80 43-20	ENTRADA	7	88	María Pérez	N/A
69	25 May 2023	2	Distribuidora Electronica Medellin	800987654-2	32-09-87-65-43	dist_electronica@gmail.com	Medellin	CO	103	Tubo PVC 4"	Tubo de PVC sanitario diámetro 4 pulgadas	plasticos	Tubos	mt	8900	126	1121400	3	Bodega Sur-Cali	cali	Av. Americas #5-30	egreso	103	399	Andrés Gómez	pedido urgente
70	23 Jan 2024	6	METALES Y ALEACIONES SA	890654321-6	316 876 54 32		bucaramanga	col	106	Perfil Al. 1"x1"	Perfil de aluminio cuadrado 1 pulgada	metales	Estructuras	Metro	22000	153	3366000	3	BODEGA SUR CALI	CALI	AV LAS AMERICAS 5-30	ingreso	100	70	Andrés Gómez	OK
71	01-15-2024	4	Sum. Industriales Norte	901234567-4	30-57-89-12-34	suministros.norte@empresa.co	BARRANQUILLA	COLOMBIA	102	CABLE UTP CAT 6	Cable de red categoría 6 para datos	ELECTRONICA	Redes	Metro	4600	177	814200	4	Bodega MDE	Medellin	CRA 50 45-67	salida	121	159	LUISA MARTINEZ	ninguna
72		2	Dist Electrónica MDE	800987654-2	320 987 6543	dist.electronica@outlook.com	MEDELLIN	CO	103	Tubo PVC 4"	Tubo de PVC sanitario diámetro 4 pulgadas	Plásticos	tuberías	mts	9000	80	720000	3	Bodega Sur-Cali	Cali	Av. Las Américas # 5-30	entrada	65	197	Andrés Gómez	
73	29 Jun 2023	3	Plastiflex Cali Ltda	860456789-3	3154567890	plastiflex@cali.com	Cali	CO	104	válvula de paso 1/2 pulgada	VALVULA BRONCE 1/2	Ferretería	válvulas	Uni	15000	110	1650000	1	BDG CENTRAL	Bogotá	CRA 30 15-40	ingreso	42	338	C. Rodríguez	Devolución parcial
74		4	Suministros Industriales del Norte	901234567-4	305 789 1234	sumnorte@gmail.com	B/quilla	colombia	102	Cable UTP Cat6		Electrónica	Redes	MTS	4550	70	318500	1	Bodega Central Bogotá	Bogotá	Carrera 30 #15-40	INGRESO	35	255	Carlos Rodríguez	COMPRA ORDINARIA
75	2024-03-25	6	METALES Y ALEACIONES SA	890654321-6	316-876-5432	m.aleaciones@yahoo.com	Bucaramanga, Sant.	Colombia	103	Tubo PVC 4"	TUBO PVC SANITARIO 4 PULG	PLASTICOS	Tuberías	ML	\N	13		3	Bodega Sur Cali	CALI	AV LAS AMERICAS 5-30	INGRESO	2	93	A. Gómez	pedido urgente
76	2023-08-28	1	Ferreteria Torres S.A.S.	900123456-1	310-123-4567	ferreteria.torres@gmail.com	Bogota	colombia	104	Valvula paso 1/2"	Válvula de paso en bronce 1/2"	plomería	VALVULAS	und	15000	100	1500000	4	BDG MEDELLIN	Medellin	Cra 50 # 45-67	ENTRADA	46	142	L. Martínez	ninguna
77	05 May 2023	4	SUMINISTROS INDUSTRIALES DEL NORTE		3057891234		Barranquilla	Colombia	103	Tubo PVC 4"	Tubo de PVC sanitario diámetro 4 pulgadas	PLASTICOS	Tubos	M	8900	175	1557500	3	Bodega Sur-Cali	Cali	Av. Americas #5-30	entrada	95	55	Andrés Gómez	ok
78	11-24-2023	5	TECNOPARTES LTDA		601-456-7890	tecnopartes@empresa.com	Bogota	Colombia	102	Cable UTP Cat6	CABLE RED CAT 6	electronica	Cables	MTS	4600	106	487600	1	BODEGA CENTRAL BOGOTA	BOGOTÁ	Cra 30 # 15-40	Salida	90	465	Carlos Rodríguez	pedido urgente
79	07-11-2023	2	Dist Electrónica MDE	800987654-2	320 987 6543	electronicamedellin@hotmail.com	MEDELLIN	Colombia	106	perfil aluminio 1 pulgada x 1 pulgada	Perfil aluminio cuadrado	Aluminio	Perfiles	mts	22500	189	4252500	1	BDG CENTRAL	BOGOTÁ	CRA 30 15-40	Salida	117	248	C. Rodríguez	OK
80	12/06/2023	6	Met. & Aleaciones S.A.	890654321-6	3168765432		BUCARAMANGA	col	105	Pintura base agua blanca 1GL	Pintura caucho blanca	PINTURAS	PINTURAS	gal	34000	120	4080000	2	BDG NORTE BQ	Barranquilla	Calle 80 # 43-20	Salida	115	236	María Pérez	
6	2024-06-17	5	TECNOPARTES LTDA	700345678-5	601-456-7890	tecnopartes.ltda@gmail.com	BOGOTA D.C.	Colombia	108	Cemento gris 50kg		construcción	cementos	BTO	27000	184	4968000	1	Bodega Cntrl Bogotá	BOGOTÁ	CRA 30 15-40	entrada	138	36	CARLOS RODRIGUEZ	N/A
22		2	Distribuidora Electrónica Medellín	800987654-2	3209876543	dist.electronica@outlook.com	Medellín, Ant.	COLOMBIA	106	Perfil Al. 1"x1"		Metales	PERFILES	ML	22000	70	1540000	4	BODEGA MEDELLIN	MEDELLIN	Carrera 50 #45-67	ENTRADA	43	360	L. Martínez	COMPRA ORDINARIA
3	2023-10-04	1	Ferreteria Torres S.A.S.	900123456-1	3101234567	ferreteria.torres@gmail.com	Bogota	Colombia	107	INTERRUPTOR SENCILLO	Interruptor 110V sencillo	eléctricos	INTERRUPTORES	Unidad	8500	136	1047899,749	2	Bodega Norte Barranquilla	B/quilla	CL 80 43-20	egreso	26	18	M. Pérez	
28	2023-09-12	4	SUMINISTROS INDUSTRIALES DEL NORTE	901234567-4	3057891234	suministros.norte@empresa.co	Barranquilla	COLOMBIA	105	PINTURA BASE AGUA BLANCA	PINTURA CAUCHO BLANCA	PINTURAS	PINTURAS	Galon	35500	40	1420000	4	BODEGA MEDELLIN	Medellin	Cra 50 # 45-67	EGRESO	36	258	LUISA MARTINEZ	
22		2	Distribuidora Electrónica Medellín	800987654-2	3209876543	dist.electronica@outlook.com	Medellín, Ant.	COLOMBIA	106	Perfil Al. 1"x1"		Metales	PERFILES	ML	22000	70	1540000	4	BODEGA MEDELLIN	MEDELLIN	Carrera 50 #45-67	ENTRADA	43	360	L. Martínez	COMPRA ORDINARIA
28	2023-09-12	4	SUMINISTROS INDUSTRIALES DEL NORTE	901234567-4	3057891234	suministros.norte@empresa.co	Barranquilla	COLOMBIA	105	PINTURA BASE AGUA BLANCA	PINTURA CAUCHO BLANCA	PINTURAS	PINTURAS	Galon	35500	40	1420000	4	BODEGA MEDELLIN	Medellin	Cra 50 # 45-67	EGRESO	36	258	LUISA MARTINEZ	
87		\N						Colombia	\N						\N	\N		\N					\N	\N		
88		\N						Colombia	\N						\N	\N		\N					\N	\N		
89		\N						Colombia	\N						\N	\N		\N					\N	\N		
90		\N						Colombia	\N						\N	\N		\N					\N	\N		
\.


--
-- TOC entry 3566 (class 0 OID 33189)
-- Dependencies: 242
-- Data for Name: detalle_compra; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.detalle_compra (id_producto, id_registro, cantidad_comprada, precio_compra) FROM stdin;
\.


--
-- TOC entry 3553 (class 0 OID 33068)
-- Dependencies: 229
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.empleado (id, nombre) FROM stdin;
\.


--
-- TOC entry 3560 (class 0 OID 33123)
-- Dependencies: 236
-- Data for Name: inventario; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.inventario (id_bodega, id_producto, stock_actual) FROM stdin;
\.


--
-- TOC entry 3562 (class 0 OID 33144)
-- Dependencies: 238
-- Data for Name: movimiento; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.movimiento (id, fecha_movimienta, cantidad_movimiento, id_bodega, id_producto, id_tipo_movimiento) FROM stdin;
\.


--
-- TOC entry 3541 (class 0 OID 33002)
-- Dependencies: 217
-- Data for Name: pais; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.pais (id, nombre) FROM stdin;
\.


--
-- TOC entry 3559 (class 0 OID 33100)
-- Dependencies: 235
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.producto (id, nombre_producto, precio_unitario, descripcion, id_unidad_medida, id_categoria, id_subcategoria) FROM stdin;
\.


--
-- TOC entry 3545 (class 0 OID 33025)
-- Dependencies: 221
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.proveedor (id, nombre, nit, telefono, email, id_ciudad) FROM stdin;
\.


--
-- TOC entry 3549 (class 0 OID 33050)
-- Dependencies: 225
-- Data for Name: subcategorias_productos; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.subcategorias_productos (id, nombre) FROM stdin;
\.


--
-- TOC entry 3563 (class 0 OID 33165)
-- Dependencies: 239
-- Data for Name: temp_movimiento; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.temp_movimiento (id_registro, fecha_sucia, id_bodega, id_producto, id_tipo_movimiento, cantidad_movimiento) FROM stdin;
\.


--
-- TOC entry 3555 (class 0 OID 33077)
-- Dependencies: 231
-- Data for Name: tipo_movimiento; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.tipo_movimiento (id, nombre) FROM stdin;
\.


--
-- TOC entry 3551 (class 0 OID 33059)
-- Dependencies: 227
-- Data for Name: unidades_medidas; Type: TABLE DATA; Schema: public; Owner: admin123
--

COPY public.unidades_medidas (id, nombre_unidad) FROM stdin;
\.


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 232
-- Name: bodega_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.bodega_id_seq', 1, false);


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 222
-- Name: categorias_productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.categorias_productos_id_seq', 1, false);


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 218
-- Name: ciudad_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.ciudad_id_seq', 1, false);


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 240
-- Name: compra_id_registro_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.compra_id_registro_seq', 1, false);


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 228
-- Name: empleado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.empleado_id_seq', 1, false);


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 237
-- Name: movimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.movimiento_id_seq', 1, false);


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 216
-- Name: pais_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.pais_id_seq', 1, false);


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 234
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.producto_id_seq', 1, false);


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 220
-- Name: proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.proveedor_id_seq', 1, false);


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 224
-- Name: subcategorias_productos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.subcategorias_productos_id_seq', 1, false);


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 230
-- Name: tipo_movimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.tipo_movimiento_id_seq', 1, false);


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 226
-- Name: unidades_medidas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: admin123
--

SELECT pg_catalog.setval('public.unidades_medidas_id_seq', 1, false);


--
-- TOC entry 3369 (class 2606 OID 33093)
-- Name: bodega bodega_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.bodega
    ADD CONSTRAINT bodega_pk PRIMARY KEY (id);


--
-- TOC entry 3359 (class 2606 OID 33048)
-- Name: categorias_productos categorias_productos_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.categorias_productos
    ADD CONSTRAINT categorias_productos_pk PRIMARY KEY (id);


--
-- TOC entry 3353 (class 2606 OID 33018)
-- Name: ciudad ciudad_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.ciudad
    ADD CONSTRAINT ciudad_pk PRIMARY KEY (id);


--
-- TOC entry 3377 (class 2606 OID 33178)
-- Name: compra compra_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pk PRIMARY KEY (id_registro);


--
-- TOC entry 3379 (class 2606 OID 33195)
-- Name: detalle_compra detalle_compra_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_pk PRIMARY KEY (id_producto, id_registro);


--
-- TOC entry 3365 (class 2606 OID 33075)
-- Name: empleado empleado_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pk PRIMARY KEY (id);


--
-- TOC entry 3373 (class 2606 OID 33127)
-- Name: inventario inventario_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pk PRIMARY KEY (id_bodega, id_producto);


--
-- TOC entry 3375 (class 2606 OID 33149)
-- Name: movimiento movimiento_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.movimiento
    ADD CONSTRAINT movimiento_pk PRIMARY KEY (id);


--
-- TOC entry 3351 (class 2606 OID 33009)
-- Name: pais pais_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.pais
    ADD CONSTRAINT pais_pk PRIMARY KEY (id);


--
-- TOC entry 3371 (class 2606 OID 33107)
-- Name: producto producto_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pk PRIMARY KEY (id);


--
-- TOC entry 3355 (class 2606 OID 33032)
-- Name: proveedor proveedor_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pk PRIMARY KEY (id);


--
-- TOC entry 3357 (class 2606 OID 33034)
-- Name: proveedor proveedor_unique; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_unique UNIQUE (nit);


--
-- TOC entry 3361 (class 2606 OID 33057)
-- Name: subcategorias_productos subcategorias_productos_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.subcategorias_productos
    ADD CONSTRAINT subcategorias_productos_pk PRIMARY KEY (id);


--
-- TOC entry 3367 (class 2606 OID 33084)
-- Name: tipo_movimiento tipo_movimiento_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.tipo_movimiento
    ADD CONSTRAINT tipo_movimiento_pk PRIMARY KEY (id);


--
-- TOC entry 3363 (class 2606 OID 33066)
-- Name: unidades_medidas unidades_medidas_pk; Type: CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.unidades_medidas
    ADD CONSTRAINT unidades_medidas_pk PRIMARY KEY (id);


--
-- TOC entry 3382 (class 2606 OID 33216)
-- Name: bodega bodega_ciudad_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.bodega
    ADD CONSTRAINT bodega_ciudad_fk FOREIGN KEY (id_ciudad) REFERENCES public.ciudad(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3383 (class 2606 OID 33094)
-- Name: bodega bodega_empleado_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.bodega
    ADD CONSTRAINT bodega_empleado_fk FOREIGN KEY (id_responsable) REFERENCES public.empleado(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3380 (class 2606 OID 33019)
-- Name: ciudad ciudad_pais_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.ciudad
    ADD CONSTRAINT ciudad_pais_fk FOREIGN KEY (id_pais) REFERENCES public.pais(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3392 (class 2606 OID 33179)
-- Name: compra compra_bodega_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_bodega_fk FOREIGN KEY (id_bodega) REFERENCES public.bodega(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3393 (class 2606 OID 33184)
-- Name: compra compra_proveedor_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_proveedor_fk FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3394 (class 2606 OID 33196)
-- Name: detalle_compra detalle_compra_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_compra_fk FOREIGN KEY (id_registro) REFERENCES public.compra(id_registro) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3395 (class 2606 OID 33201)
-- Name: detalle_compra detalle_compra_producto_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.detalle_compra
    ADD CONSTRAINT detalle_compra_producto_fk FOREIGN KEY (id_producto) REFERENCES public.producto(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3387 (class 2606 OID 33206)
-- Name: inventario inventario_bodega_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_bodega_fk FOREIGN KEY (id_bodega) REFERENCES public.bodega(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3388 (class 2606 OID 33211)
-- Name: inventario inventario_producto_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_producto_fk FOREIGN KEY (id_producto) REFERENCES public.producto(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3389 (class 2606 OID 33150)
-- Name: movimiento movimiento_bodega_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.movimiento
    ADD CONSTRAINT movimiento_bodega_fk FOREIGN KEY (id_bodega) REFERENCES public.bodega(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3390 (class 2606 OID 33160)
-- Name: movimiento movimiento_producto_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.movimiento
    ADD CONSTRAINT movimiento_producto_fk FOREIGN KEY (id_producto) REFERENCES public.producto(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3391 (class 2606 OID 33155)
-- Name: movimiento movimiento_tipo_movimiento_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.movimiento
    ADD CONSTRAINT movimiento_tipo_movimiento_fk FOREIGN KEY (id_tipo_movimiento) REFERENCES public.tipo_movimiento(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3384 (class 2606 OID 33113)
-- Name: producto producto_categorias_productos_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_categorias_productos_fk FOREIGN KEY (id_categoria) REFERENCES public.categorias_productos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3385 (class 2606 OID 33118)
-- Name: producto producto_subcategorias_productos_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_subcategorias_productos_fk FOREIGN KEY (id_subcategoria) REFERENCES public.subcategorias_productos(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3386 (class 2606 OID 33108)
-- Name: producto producto_unidades_medidas_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_unidades_medidas_fk FOREIGN KEY (id_unidad_medida) REFERENCES public.unidades_medidas(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3381 (class 2606 OID 33035)
-- Name: proveedor proveedor_ciudad_fk; Type: FK CONSTRAINT; Schema: public; Owner: admin123
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_ciudad_fk FOREIGN KEY (id_ciudad) REFERENCES public.ciudad(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2026-07-05 20:14:48

--
-- PostgreSQL database dump complete
--

