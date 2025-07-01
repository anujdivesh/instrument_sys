--
-- PostgreSQL database dump
--

-- Dumped from database version 15.9 (Homebrew)
-- Dumped by pg_dump version 15.9 (Homebrew)

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
-- Name: access_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_method (
    id integer NOT NULL,
    function character varying
);


ALTER TABLE public.access_method OWNER TO postgres;

--
-- Name: access_method_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_method_id_seq OWNER TO postgres;

--
-- Name: access_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_method_id_seq OWNED BY public.access_method.id;


--
-- Name: station; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.station (
    id integer NOT NULL,
    description character varying,
    station_id character varying,
    latitude double precision,
    longitude double precision,
    owner character varying,
    maintainer character varying,
    is_active boolean,
    variable_id character varying,
    variable_label character varying,
    project character varying,
    type_id integer,
    access_method_id integer,
    status_id integer
);


ALTER TABLE public.station OWNER TO postgres;

--
-- Name: station_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.station_id_seq OWNER TO postgres;

--
-- Name: station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.station_id_seq OWNED BY public.station.id;


--
-- Name: status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status (
    id integer NOT NULL,
    value character varying
);


ALTER TABLE public.status OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.status_id_seq OWNER TO postgres;

--
-- Name: status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_id_seq OWNED BY public.status.id;


--
-- Name: type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type (
    id integer NOT NULL,
    value character varying
);


ALTER TABLE public.type OWNER TO postgres;

--
-- Name: type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.type_id_seq OWNER TO postgres;

--
-- Name: type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_id_seq OWNED BY public.type.id;


--
-- Name: access_method id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_method ALTER COLUMN id SET DEFAULT nextval('public.access_method_id_seq'::regclass);


--
-- Name: station id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station ALTER COLUMN id SET DEFAULT nextval('public.station_id_seq'::regclass);


--
-- Name: status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status ALTER COLUMN id SET DEFAULT nextval('public.status_id_seq'::regclass);


--
-- Name: type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type ALTER COLUMN id SET DEFAULT nextval('public.type_id_seq'::regclass);


--
-- Data for Name: access_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_method (id, function) FROM stdin;
1	sofa api
\.


--
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.station (id, description, station_id, latitude, longitude, owner, maintainer, is_active, variable_id, variable_label, project, type_id, access_method_id, status_id) FROM stdin;
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.status (id, value) FROM stdin;
\.


--
-- Data for Name: type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.type (id, value) FROM stdin;
1	Wave Buoy
\.


--
-- Name: access_method_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_method_id_seq', 1, true);


--
-- Name: station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.station_id_seq', 1, false);


--
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_id_seq', 1, false);


--
-- Name: type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_id_seq', 1, true);


--
-- Name: access_method access_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_method
    ADD CONSTRAINT access_method_pkey PRIMARY KEY (id);


--
-- Name: station station_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (id);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- Name: type type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type
    ADD CONSTRAINT type_pkey PRIMARY KEY (id);


--
-- Name: ix_access_method_function; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_access_method_function ON public.access_method USING btree (function);


--
-- Name: ix_access_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_access_method_id ON public.access_method USING btree (id);


--
-- Name: ix_station_description; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_description ON public.station USING btree (description);


--
-- Name: ix_station_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_id ON public.station USING btree (id);


--
-- Name: ix_station_latitude; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_latitude ON public.station USING btree (latitude);


--
-- Name: ix_station_longitude; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_longitude ON public.station USING btree (longitude);


--
-- Name: ix_station_maintainer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_maintainer ON public.station USING btree (maintainer);


--
-- Name: ix_station_owner; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_owner ON public.station USING btree (owner);


--
-- Name: ix_station_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_project ON public.station USING btree (project);


--
-- Name: ix_station_station_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_station_id ON public.station USING btree (station_id);


--
-- Name: ix_station_variable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_variable_id ON public.station USING btree (variable_id);


--
-- Name: ix_station_variable_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_variable_label ON public.station USING btree (variable_label);


--
-- Name: ix_status_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_status_id ON public.status USING btree (id);


--
-- Name: ix_status_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_status_value ON public.status USING btree (value);


--
-- Name: ix_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_type_id ON public.type USING btree (id);


--
-- Name: ix_type_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_type_value ON public.type USING btree (value);


--
-- Name: station station_access_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_access_method_id_fkey FOREIGN KEY (access_method_id) REFERENCES public.access_method(id);


--
-- Name: station station_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.status(id);


--
-- Name: station station_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.type(id);


--
-- PostgreSQL database dump complete
--

