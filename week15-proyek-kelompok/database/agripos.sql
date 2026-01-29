--
-- PostgreSQL database dump
--

\restrict EhlggEmQ9GMHt4UYameadJWxB069cJa2dyuY6KfIG6ODXX4fWjncJ8BFfpXy3lH

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-29 16:06:20

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
-- TOC entry 221 (class 1259 OID 24583)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    kode character varying(50) NOT NULL,
    nama character varying(100),
    kategori character varying(50),
    harga numeric(10,2),
    stok integer
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24589)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id character varying(50) NOT NULL,
    total_amount double precision NOT NULL,
    cashier_username character varying(100),
    payment_method character varying(50),
    transaction_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16395)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    role character varying(20) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16394)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 4864 (class 2604 OID 16398)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 5023 (class 0 OID 24583)
-- Dependencies: 221
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (kode, nama, kategori, harga, stok) FROM stdin;
P002	Benih Jagung Hibrida 1kg	Bibit	75000.00	40
P007	Benih Kangkung 100gr	Bibit	20000.00	70
P008	Benih Sawi 100gr	Bibit	22000.00	65
P013	Pupuk KCL 5kg	Pupuk	70000.00	60
P015	Insektisida Anti Ulat 250ml	Pestisida	45000.00	40
P017	Herbisida Rumput 500ml	Pestisida	60000.00	30
P019	Rodentisida Tikus 100gr	Pestisida	30000.00	25
P020	Cangkul Baja	Alat	85000.00	20
P021	Sekop Besi	Alat	75000.00	25
P025	Timbangan Digital 10kg	Alat	180000.00	10
P026	Beras Medium 5kg	Hasil Panen	68000.00	100
P028	Cabai Merah 1kg	Hasil Panen	55000.00	80
P030	Bawang Merah 1kg	Hasil Panen	40000.00	70
P031	Wortel 1kg	Hasil Panen	15000.00	75
P032	Kentang 1kg	Hasil Panen	15000.00	75
P034	Pisang 1 sisir	Hasil Panen	35000.00	40
P035	Semangka 1 buah	Hasil Panen	45000.00	30
P011	Pupuk Organik Cair 1L	Pupuk	35000.00	80
P018	Pestisida Nabati 1L	Pestisida	52000.00	43
P022	Sprayer Manual 16L	Alat	250000.00	14
P023	Selang Air 20m	Alat	120000.00	29
P001	Benih Padi IR64 1kg	Bibit	65000.00	49
P027	Jagung Pipil 1kg	Hasil Panen	12000.00	149
P033	Kubis 1kg	Hasil Panen	10000.00	58
P003	Benih Cabai Merah 50gr	Bibit	45000.00	59
P005	Benih Bawang Merah 1kg	Bibit	80000.00	29
P006	Benih Terong 50gr	Bibit	35000.00	44
P010	Pupuk NPK 5kg	Pupuk	75000.00	89
P024	Gunting Pangkas	Alat	45000.00	34
P004	Benih Tomat 50gr	Bibit	40000.00	48
P009	Pupuk Urea 5kg	Pupuk	60000.00	97
P012	Pupuk Kompos 10kg	Pupuk	50000.00	68
P014	Pupuk ZA 5kg	Pupuk	55000.00	63
P016	Fungisida Anti Jamur 250ml	Pestisida	48000.00	34
P029	Tomat 1kg	Hasil Panen	12000.00	88
\.


--
-- TOC entry 5024 (class 0 OID 24589)
-- Dependencies: 222
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, total_amount, cashier_username, payment_method, transaction_date) FROM stdin;
TRX-AE9D9	200000	kasir	CASH	2026-01-29 15:47:00.628802
TRX-AAC7E	410000	kasir	EWALLET	2026-01-29 15:47:37.611591
\.


--
-- TOC entry 5022 (class 0 OID 16395)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, role) FROM stdin;
1	admin	admin123	ADMIN
2	kasir	kasir123	KASIR
\.


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 4871 (class 2606 OID 24588)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (kode);


--
-- TOC entry 4873 (class 2606 OID 24596)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- TOC entry 4867 (class 2606 OID 16404)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 16406)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


-- Completed on 2026-01-29 16:06:20

--
-- PostgreSQL database dump complete
--

\unrestrict EhlggEmQ9GMHt4UYameadJWxB069cJa2dyuY6KfIG6ODXX4fWjncJ8BFfpXy3lH

