--
-- PostgreSQL database dump
--

-- Dumped from database version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.15 (Ubuntu 14.15-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: bought_items; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.bought_items (
    item_id integer,
    onetime_trans_id integer,
    recurring_trans_id integer,
    num_item integer NOT NULL,
    items_cost numeric(10,2) NOT NULL,
    CONSTRAINT check_transaction_type CHECK ((((onetime_trans_id IS NOT NULL) AND (recurring_trans_id IS NULL)) OR ((onetime_trans_id IS NULL) AND (recurring_trans_id IS NOT NULL))))
);


ALTER TABLE public.bought_items OWNER TO root;

--
-- Name: crud_logging; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.crud_logging (
    action_id integer NOT NULL,
    user_id integer,
    action_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    action_taken text NOT NULL,
    x_requested_with text NOT NULL
);


ALTER TABLE public.crud_logging OWNER TO root;

--
-- Name: crud_logging_action_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

ALTER TABLE public.crud_logging ALTER COLUMN action_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.crud_logging_action_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: item_attributes; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.item_attributes (
    item_type integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.item_attributes OWNER TO root;

--
-- Name: item_types; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.item_types (
    item_type_id integer NOT NULL,
    item_type_name text NOT NULL
);


ALTER TABLE public.item_types OWNER TO root;

--
-- Name: item_types_item_type_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

ALTER TABLE public.item_types ALTER COLUMN item_type_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.item_types_item_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: items; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.items (
    item_id integer NOT NULL,
    item_name text NOT NULL,
    description text,
    item_type integer,
    price numeric(10,2) NOT NULL
);


ALTER TABLE public.items OWNER TO root;

--
-- Name: items_item_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

ALTER TABLE public.items ALTER COLUMN item_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.items_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: logins_logging; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.logins_logging (
    login_id integer NOT NULL,
    user_id integer,
    login_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    logout_at timestamp without time zone,
    ip_addr inet NOT NULL,
    device_type text NOT NULL,
    browser text NOT NULL,
    cpu_arch text NOT NULL,
    host text NOT NULL,
    origin text NOT NULL
);


ALTER TABLE public.logins_logging OWNER TO root;

--
-- Name: logins_logging_login_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

ALTER TABLE public.logins_logging ALTER COLUMN login_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.logins_logging_login_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: onetime_trans; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.onetime_trans (
    trans_id integer NOT NULL,
    trans_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_id integer,
    item_count integer NOT NULL,
    cost_total numeric(10,2) NOT NULL
);


ALTER TABLE public.onetime_trans OWNER TO root;

--
-- Name: onetime_trans_trans_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

ALTER TABLE public.onetime_trans ALTER COLUMN trans_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.onetime_trans_trans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: recurring_trans; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.recurring_trans (
    trans_id integer NOT NULL,
    cost_total numeric(10,2) NOT NULL,
    item_count integer NOT NULL,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone,
    month_fee numeric(10,2),
    year_fee numeric(10,2),
    user_id integer
);


ALTER TABLE public.recurring_trans OWNER TO root;

--
-- Name: recurring_trans_payment; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.recurring_trans_payment (
    trans_id integer NOT NULL,
    payment_rcvd numeric(10,2),
    date_rcvd timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.recurring_trans_payment OWNER TO root;

--
-- Name: recurring_trans_trans_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

ALTER TABLE public.recurring_trans ALTER COLUMN trans_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.recurring_trans_trans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    user_name text NOT NULL,
    user_email text NOT NULL,
    user_pass text NOT NULL,
    birthdate date NOT NULL,
    address text NOT NULL,
    phone_num text NOT NULL,
    role text NOT NULL
);


ALTER TABLE public.users OWNER TO root;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: bought_items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.bought_items (item_id, onetime_trans_id, recurring_trans_id, num_item, items_cost) FROM stdin;
\.


--
-- Data for Name: crud_logging; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.crud_logging (action_id, user_id, action_at, action_taken, x_requested_with) FROM stdin;
\.


--
-- Data for Name: item_attributes; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.item_attributes (item_type, item_id) FROM stdin;
\.


--
-- Data for Name: item_types; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.item_types (item_type_id, item_type_name) FROM stdin;
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.items (item_id, item_name, description, item_type, price) FROM stdin;
\.


--
-- Data for Name: logins_logging; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.logins_logging (login_id, user_id, login_at, logout_at, ip_addr, device_type, browser, cpu_arch, host, origin) FROM stdin;
\.


--
-- Data for Name: onetime_trans; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.onetime_trans (trans_id, trans_date, user_id, item_count, cost_total) FROM stdin;
\.


--
-- Data for Name: recurring_trans; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.recurring_trans (trans_id, cost_total, item_count, start_date, end_date, month_fee, year_fee, user_id) FROM stdin;
\.


--
-- Data for Name: recurring_trans_payment; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.recurring_trans_payment (trans_id, payment_rcvd, date_rcvd) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.users (user_id, user_name, user_email, user_pass, birthdate, address, phone_num, role) FROM stdin;
\.


--
-- Name: crud_logging_action_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.crud_logging_action_id_seq', 1, false);


--
-- Name: item_types_item_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.item_types_item_type_id_seq', 1, false);


--
-- Name: items_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.items_item_id_seq', 1, false);


--
-- Name: logins_logging_login_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.logins_logging_login_id_seq', 1, false);


--
-- Name: onetime_trans_trans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.onetime_trans_trans_id_seq', 1, false);


--
-- Name: recurring_trans_trans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.recurring_trans_trans_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- Name: crud_logging crud_logging_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.crud_logging
    ADD CONSTRAINT crud_logging_pkey PRIMARY KEY (action_id);


--
-- Name: item_attributes item_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.item_attributes
    ADD CONSTRAINT item_attributes_pkey PRIMARY KEY (item_type, item_id);


--
-- Name: item_types item_types_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.item_types
    ADD CONSTRAINT item_types_pkey PRIMARY KEY (item_type_id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- Name: logins_logging logins_logging_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.logins_logging
    ADD CONSTRAINT logins_logging_pkey PRIMARY KEY (login_id);


--
-- Name: onetime_trans onetime_trans_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.onetime_trans
    ADD CONSTRAINT onetime_trans_pkey PRIMARY KEY (trans_id);


--
-- Name: recurring_trans_payment recurring_trans_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.recurring_trans_payment
    ADD CONSTRAINT recurring_trans_payment_pkey PRIMARY KEY (trans_id);


--
-- Name: recurring_trans recurring_trans_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.recurring_trans
    ADD CONSTRAINT recurring_trans_pkey PRIMARY KEY (trans_id);


--
-- Name: bought_items unique_onetime; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.bought_items
    ADD CONSTRAINT unique_onetime UNIQUE (item_id, onetime_trans_id);


--
-- Name: bought_items unique_recurring; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.bought_items
    ADD CONSTRAINT unique_recurring UNIQUE (item_id, recurring_trans_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: crud_logging crud_logging_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.crud_logging
    ADD CONSTRAINT crud_logging_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: item_attributes fk_item_id; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.item_attributes
    ADD CONSTRAINT fk_item_id FOREIGN KEY (item_id) REFERENCES public.items(item_id);


--
-- Name: item_attributes fk_item_type; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.item_attributes
    ADD CONSTRAINT fk_item_type FOREIGN KEY (item_type) REFERENCES public.item_types(item_type_id);


--
-- Name: bought_items fk_onetime; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.bought_items
    ADD CONSTRAINT fk_onetime FOREIGN KEY (onetime_trans_id) REFERENCES public.onetime_trans(trans_id);


--
-- Name: bought_items fk_recurring; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.bought_items
    ADD CONSTRAINT fk_recurring FOREIGN KEY (recurring_trans_id) REFERENCES public.recurring_trans(trans_id);


--
-- Name: recurring_trans_payment fk_trans_id; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.recurring_trans_payment
    ADD CONSTRAINT fk_trans_id FOREIGN KEY (trans_id) REFERENCES public.recurring_trans(trans_id);


--
-- Name: items items_item_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_item_type_fkey FOREIGN KEY (item_type) REFERENCES public.item_types(item_type_id);


--
-- Name: logins_logging logins_logging_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.logins_logging
    ADD CONSTRAINT logins_logging_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: onetime_trans onetime_trans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.onetime_trans
    ADD CONSTRAINT onetime_trans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: recurring_trans recurring_trans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.recurring_trans
    ADD CONSTRAINT recurring_trans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- PostgreSQL database dump complete
--

