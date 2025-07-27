--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.0

-- Started on 2025-07-10 14:59:41

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
-- TOC entry 222 (class 1259 OID 16412)
-- Name: access_method; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_method (
    id integer NOT NULL,
    function character varying
);


ALTER TABLE public.access_method OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16411)
-- Name: access_method_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_method_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.access_method_id_seq OWNER TO postgres;

--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 221
-- Name: access_method_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_method_id_seq OWNED BY public.access_method.id;


--
-- TOC entry 224 (class 1259 OID 16423)
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
    status_id integer,
    country_id integer,
    source_url character varying,
    token_id integer
);


ALTER TABLE public.station OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16422)
-- Name: station_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.station_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.station_id_seq OWNER TO postgres;

--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 223
-- Name: station_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.station_id_seq OWNED BY public.station.id;


--
-- TOC entry 220 (class 1259 OID 16401)
-- Name: status; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status (
    id integer NOT NULL,
    value character varying
);


ALTER TABLE public.status OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16400)
-- Name: status_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.status_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.status_id_seq OWNER TO postgres;

--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 219
-- Name: status_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.status_id_seq OWNED BY public.status.id;


--
-- TOC entry 226 (class 1259 OID 16490)
-- Name: token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token (
    id integer NOT NULL,
    token character varying NOT NULL,
    comments character varying
);


ALTER TABLE public.token OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16489)
-- Name: token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.token_id_seq OWNER TO postgres;

--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 225
-- Name: token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.token_id_seq OWNED BY public.token.id;


--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.type (
    id integer NOT NULL,
    value character varying
);


ALTER TABLE public.type OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.type_id_seq OWNER TO postgres;

--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 217
-- Name: type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.type_id_seq OWNED BY public.type.id;


--
-- TOC entry 4717 (class 2604 OID 16415)
-- Name: access_method id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_method ALTER COLUMN id SET DEFAULT nextval('public.access_method_id_seq'::regclass);


--
-- TOC entry 4718 (class 2604 OID 16426)
-- Name: station id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station ALTER COLUMN id SET DEFAULT nextval('public.station_id_seq'::regclass);


--
-- TOC entry 4716 (class 2604 OID 16404)
-- Name: status id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status ALTER COLUMN id SET DEFAULT nextval('public.status_id_seq'::regclass);


--
-- TOC entry 4719 (class 2604 OID 16493)
-- Name: token id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token ALTER COLUMN id SET DEFAULT nextval('public.token_id_seq'::regclass);


--
-- TOC entry 4715 (class 2604 OID 16393)
-- Name: type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type ALTER COLUMN id SET DEFAULT nextval('public.type_id_seq'::regclass);


--
-- TOC entry 4904 (class 0 OID 16412)
-- Dependencies: 222
-- Data for Name: access_method; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.access_method VALUES (3, 'dart_method');
INSERT INTO public.access_method VALUES (1, 'spot_method');
INSERT INTO public.access_method VALUES (2, 'pacioos_method');


--
-- TOC entry 4906 (class 0 OID 16423)
-- Dependencies: 224
-- Data for Name: station; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.station VALUES (125, 'SPOT-0285', 'SPOT-0285', -19.1278, 177.95632, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0285&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (126, 'SPOT-0298', 'SPOT-0298', -19.30632, 177.96413, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0298&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (7, 'AMCHITKA - 170 NM South of Amchitka, AK', '21414', 13.3555, 144.788, 'NDBC', 'NDBC', true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', 'instrument', 3, 3, 1, 2, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (161, '178', '178', 7.081486, 158.2442, 'PACIOOS', NULL, true, NULL, NULL, NULL, 1, 2, 1, 5, 'https://erddap.cdip.ucsd.edu/erddap/tabledap/wave_agg.geoJson?station_id,time,waveHs,waveTp,waveTa,waveDp,latitude,longitude&station_id=%22STATION_ID%22&time%3E=START_TIME&time%3C=END_TIME&waveFlagPrimary=1', NULL);
INSERT INTO public.station VALUES (162, '196', '196', 13.6833, 144.8155, 'PACIOOS', NULL, true, NULL, NULL, NULL, 1, 2, 1, 24, 'https://erddap.cdip.ucsd.edu/erddap/tabledap/wave_agg.geoJson?station_id,time,waveHs,waveTp,waveTa,waveDp,latitude,longitude&station_id=%22STATION_ID%22&time%3E=START_TIME&time%3C=END_TIME&waveFlagPrimary=1', NULL);
INSERT INTO public.station VALUES (163, '219', '219', 7.629632, 134.6704, 'PACIOOS', NULL, true, NULL, NULL, NULL, 1, 2, 1, 10, 'https://erddap.cdip.ucsd.edu/erddap/tabledap/wave_agg.geoJson?station_id,time,waveHs,waveTp,waveTa,waveDp,latitude,longitude&station_id=%22STATION_ID%22&time%3E=START_TIME&time%3C=END_TIME&waveFlagPrimary=1', NULL);
INSERT INTO public.station VALUES (164, '273', '273', -14.2965, -170.8747, 'PACIOOS', NULL, true, NULL, NULL, NULL, 1, 2, 1, 18, 'https://erddap.cdip.ucsd.edu/erddap/tabledap/wave_agg.geoJson?station_id,time,waveHs,waveTp,waveTa,waveDp,latitude,longitude&station_id=%22STATION_ID%22&time%3E=START_TIME&time%3C=END_TIME&waveFlagPrimary=1', NULL);
INSERT INTO public.station VALUES (165, '276', '276', 5.24042, 163.0008, 'PACIOOS', NULL, true, NULL, NULL, NULL, 1, 2, 1, 5, 'https://erddap.cdip.ucsd.edu/erddap/tabledap/wave_agg.geoJson?station_id,time,waveHs,waveTp,waveTa,waveDp,latitude,longitude&station_id=%22STATION_ID%22&time%3E=START_TIME&time%3C=END_TIME&waveFlagPrimary=1', NULL);
INSERT INTO public.station VALUES (169, '121', '121', 13.3555, 144.788, 'PACIOOS', NULL, true, NULL, NULL, NULL, 1, 2, 1, 24, 'https://erddap.cdip.ucsd.edu/erddap/tabledap/wave_agg.geoJson?station_id,time,waveHs,waveTp,waveTa,waveDp,latitude,longitude&station_id=%22STATION_ID%22&time%3E=START_TIME&time%3C=END_TIME&waveFlagPrimary=1', NULL);
INSERT INTO public.station VALUES (127, 'SPOT-0089', 'SPOT-0089', -18.17648, 178.41657, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0089&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (128, 'SPOT-0398', 'SPOT-0398', -9.42227, 159.94742, 'SPC', NULL, true, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 13, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0398&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (129, 'SPOT-0435', 'SPOT-0435', -21.74347, 165.335, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 20, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0435&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (130, 'SPOT-1931', 'SPOT-1931', -20.50715, 165.09363, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 20, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1931&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (131, 'SPOT-30187R', 'SPOT-30187R', -21.74685, 165.33293, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 20, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-30187R&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (132, 'SPOT-30815C', 'SPOT-30815C', -18.19448, 178.35897, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-30815C&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (133, 'SPOT-30355R', 'SPOT-30355R', -21.7311, 165.30062, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 20, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-30355R&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (134, 'SPOT-0299', 'SPOT-0299', -18.22757, 177.77305, 'FMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0299&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 2);
INSERT INTO public.station VALUES (135, 'SPOT-0596', 'SPOT-0596', -19.06755, 177.98447, 'FMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0596&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 2);
INSERT INTO public.station VALUES (136, 'SPOT-0607', 'SPOT-0607', -18.95167, 178.37548, 'FMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0607&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 2);
INSERT INTO public.station VALUES (4, 'This Returns Waves data', 'SPOT-31071C', -19.06193, -169.98748, 'SPC', 'SPC', true, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', 'instrument', 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-31071C&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (138, 'SPOT-0301', 'SPOT-0301', 1.33658, 173.01658, 'KMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 6, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0301&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 3);
INSERT INTO public.station VALUES (139, 'SPOT-0300', 'SPOT-0300', 1.42755, 172.91135, 'KMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 6, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0300&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 3);
INSERT INTO public.station VALUES (140, 'SPOT-1930', 'SPOT-1930', 1.36343, 173.08808, 'KMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 6, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1930&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 3);
INSERT INTO public.station VALUES (141, 'SPOT-1943', 'SPOT-1943', -5.49172, 159.69458, 'KMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 6, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1943&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 3);
INSERT INTO public.station VALUES (142, 'SPOT-1906', 'SPOT-1906', -13.81498, -171.78053, 'SamoaMet', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 12, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1906&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 4);
INSERT INTO public.station VALUES (152, 'SPOT-1905', 'SPOT-1905', -13.64255, -172.04037, 'SamoaMet', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 12, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1905&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 4);
INSERT INTO public.station VALUES (153, 'SPOT-1611', 'SPOT-1611', -13.81497, -171.78047, 'SamoaMet', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 12, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1611&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 4);
INSERT INTO public.station VALUES (154, 'SPOT-1951', 'SPOT-1951', -21.24395, -175.1372, 'TongaMet', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 3, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1951&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 5);
INSERT INTO public.station VALUES (155, 'SPOT-1901', 'SPOT-1901', -26.78888, -169.9395, 'TongaMet', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 3, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1901&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 5);
INSERT INTO public.station VALUES (156, 'SPOT-1612', 'SPOT-1612', -23.02458, -175.02327, 'TongaMet', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 3, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1612&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 5);
INSERT INTO public.station VALUES (157, 'SPOT-30032R', 'SPOT-30032R', -21.12362, -175.19375, 'TongaMet', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 3, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-30032R&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 5);
INSERT INTO public.station VALUES (158, 'SPOT-0302', 'SPOT-0302', -6.29783, 176.3046, 'TMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 4, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0302&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 6);
INSERT INTO public.station VALUES (159, 'SPOT-0303', 'SPOT-0303', -8.591, 179.05518, 'TMS', NULL, true, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 4, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0303&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 6);
INSERT INTO public.station VALUES (160, 'SPOT-1411', 'SPOT-1411', -8.59382, 179.05637, 'TMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 4, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-1411&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 6);
INSERT INTO public.station VALUES (166, 'SPOT-31153C', 'SPOT-31153C', -18.9747, -169.9024667, 'NMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 9, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-31153C&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 7);
INSERT INTO public.station VALUES (167, 'SPOT-31071C', 'SPOT-31071C', -19.0662333, -169.98535, 'NMS', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 9, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-31071C&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 7);
INSERT INTO public.station VALUES (168, 'SPOT-31091C', 'SPOT-31091C', -19.05455, -169.9315, 'NMS', NULL, true, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 9, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-31091C&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 7);
INSERT INTO public.station VALUES (170, 'SPOT-0285', 'SPOT-0285', -19.1278, 177.95632, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 2, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0285&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (171, 'SPOT-0433', 'SPOT-0433', -22.57357, 166.45005, 'SPC', NULL, false, 'significantWaveHeight,peakPeriod,meanPeriod,peakDirection,peakDirectionalSpread,meanDirection,meanDirectionalSpread,timestamp,latitude,longitude,processing_source', 'sig_wave_height_m,peak_wave_period_s,mean_wave_period_s,peak_wave_direction_deg,peak_dir_spread_deg,mean_wave_direction_deg,mean_dir_spread_deg,obs_time_utc,lat_deg,lon_deg,data_source', NULL, 1, 1, 1, 20, 'https://wavefleet.spoondriftspotter.co/api/wave-data?spotterId=SPOT-0433&token=REPALCE_TOKEN_STRING&includeWaves=true&includeTrack=true&includeDirectionalMoments=true&limit=500', 1);
INSERT INTO public.station VALUES (187, ' Mendocino - 150 NM West of  Mendocino Bay, CA ', '46411', 39.34, -127.04, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (188, ' NORTHWEST APIA - 370 NM NW of Apia, Samoa ', '51425', -9.51, -176.26, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (189, ' SOUTHEAST SAIPAN - 540NM ESE of Saipan ', '52402', 11.93, 153.88, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (190, ' SOUTH PHILIPPINE SEA -725 NM West of Agana, Guam ', '52405', 12.99, 132.23, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (191, ' NZC - Offshore Gisborne Hikurangi ', '5401000', -38.2, -179.8, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (192, ' NZE - Offshore East Cape Kermadec ', '5401001', -36.05, -177.71, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (193, ' NZF - Offshore Raoul Island Kermadec ', '5401002', -29.68, -175.01, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (194, ' NZG - Offshore Tongatapu Tonga ', '5401003', -23.35, -173.4, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (195, ' NZH - Offshore Niue Tonga      ', '5401004', -20.09, -171.86, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (196, ' NZI - Offshore Samoa Tonga     ', '5401005', -16.89, -171.19, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (197, ' NZA - Offshore Wellington Hikurangi ', '5501002', -42.37, 176.91, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (198, ' NZD - Offshore Bay of Plenty Kermadec ', '5501004', -36.1, 178.6, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (199, ' NZJ - Offshore Norfolk Island New Hebrides ', '5501005', -26.67, 163.96, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (200, ' NZK - Offshore New Caledonia New Hebrides ', '5501006', -24.31, 169.5, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (202, ' Coral Sea 1     -     1285km ENE of Townsville ', '55012', -15.66, 158.45, 'Australian Bureau of Meteorology', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (201, ' NZL - Offshore Vanuatu New Hebrides ', '5501007', -19.31, 166.78, 'New Zealand National Emergency Management Agency by Te Pu Ao GNS Science and NIWA Taihoro Nukurangi', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (172, ' KURIL ISLANDS - 209NM SE of Kuril Is.  ', '21419', 44.4, 155.65, ' NDBC           ', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (173, ' 180 NM  West of Caldera, Chile ', '32402', -26.74, -73.98, 'Hydrographic and Oceanographic Service of the Chilean Navy (SHOA)', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (174, ' 120 NM NW of Valparaiso        ', '32404', -32.13, -73.8, 'Cooperative Effort DART 4G', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (175, ' NORTHWEST LIMA - 1000 NM WNW of Lima, Peru ', '32413', -7.43, -93.46, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (176, ' 119NM NW of Concepcion, Chile  ', '34420', -35.76, -75.24, 'Cooperative Effort DART 4G', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (177, ' NORTH SANTO DOMINGO - 328NM NNE of Santo Domingo, DO ', '41420', 23.43, -67.39, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (178, ' NORTH ST THOMAS - 300 NM North of St Thomas, Virgin Is ', '41421', 23.41, -63.89, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (179, ' SOUTHWEST BERMUDA - 200 NM SSW of Hamilton, Bermuda ', '41425', 28.64, -65.77, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (180, ' SOUTH PUERTO RICO - 230 NM Southwest of San Juan, PR ', '42407', 15.28, -68.19, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (181, ' GULF OF AMERICA - 247 NM South of New Orleans, LA ', '42409', 25.8, -89.29, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (182, ' SOUTHWEST MANZANILLO - 240 NM SW of Manzanillo, MX ', '43412', 16.02, -107, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (183, ' SOUTH ACAPULCO - 360NM South of Acapulco, MX ', '43413', 10.93, -100.01, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (184, ' SOUTHEAST BLOCK CANYON - 130 NM SE of Fire Island, NY ', '44402', 39.31, -70.72, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (185, ' SABLE ISLAND BANK - 437 NM E of Boston, MA ', '44403', 41.93, -61.66, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (186, ' NEWPORT - 210NM West of Coos Bay, OR ', '46407', 42.71, -128.89, 'NDBC', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (203, ' Coral Sea 2     -     870km NE of Townsville ', '55023', -14.71, 153.54, 'Australian Bureau of Meteorology', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);
INSERT INTO public.station VALUES (204, ' Indian Ocean 2     -     630km NNE of Dampier ', '56003', -15.02, 118.07, 'Australian Bureau of Meteorology', NULL, true, 'time,m,lon_deg,lat_deg', 'time,water column HEIGHT,lon_deg,lat_deg', NULL, 3, 3, 1, NULL, 'https://www.ndbc.noaa.gov/dart_data.php?station=STATION_ID&startmonth=START_MONTH&startday=START_DAY&startyear=START_YEAR&endmonth=END_MONTH&endday=END_DAY&endyear=END_YEAR', NULL);


--
-- TOC entry 4902 (class 0 OID 16401)
-- Dependencies: 220
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.status VALUES (1, 'active');
INSERT INTO public.status VALUES (2, 'inactive');


--
-- TOC entry 4908 (class 0 OID 16490)
-- Dependencies: 226
-- Data for Name: token; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.token VALUES (1, 'c3abab55e2e549f02fdb683bd936c7', 'SPC');
INSERT INTO public.token VALUES (2, 'b9f2c081116e70f44152dd9aa45dcb', 'FMS');
INSERT INTO public.token VALUES (3, 'e62e5e58efac587d2c7eb4a1d938b0', 'KMS');
INSERT INTO public.token VALUES (4, 'e5c7ab12898f4414c0acf817b4bbde', 'SamoaMet');
INSERT INTO public.token VALUES (5, '743acb9023dec1ef847d5651596352', 'TongaMet');
INSERT INTO public.token VALUES (6, '99a920305541f1c38db611ebab95ba', 'TMS');
INSERT INTO public.token VALUES (7, '2a348598f294c6b0ce5f7e41e5c0f5', 'NMS');


--
-- TOC entry 4900 (class 0 OID 16390)
-- Dependencies: 218
-- Data for Name: type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.type VALUES (1, 'buoy');
INSERT INTO public.type VALUES (2, 'weather_station');
INSERT INTO public.type VALUES (3, 'dart');


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 221
-- Name: access_method_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_method_id_seq', 3, true);


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 223
-- Name: station_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.station_id_seq', 204, true);


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 219
-- Name: status_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.status_id_seq', 2, true);


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 225
-- Name: token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.token_id_seq', 7, true);


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 217
-- Name: type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.type_id_seq', 3, true);


--
-- TOC entry 4729 (class 2606 OID 16419)
-- Name: access_method access_method_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_method
    ADD CONSTRAINT access_method_pkey PRIMARY KEY (id);


--
-- TOC entry 4744 (class 2606 OID 16430)
-- Name: station station_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_pkey PRIMARY KEY (id);


--
-- TOC entry 4727 (class 2606 OID 16408)
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (id);


--
-- TOC entry 4747 (class 2606 OID 16497)
-- Name: token token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (id);


--
-- TOC entry 4749 (class 2606 OID 16499)
-- Name: token token_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT token_token_key UNIQUE (token);


--
-- TOC entry 4723 (class 2606 OID 16397)
-- Name: type type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.type
    ADD CONSTRAINT type_pkey PRIMARY KEY (id);


--
-- TOC entry 4732 (class 1259 OID 16505)
-- Name: idx_station_token_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_station_token_id ON public.station USING btree (token_id);


--
-- TOC entry 4745 (class 1259 OID 16506)
-- Name: idx_token_token; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_token_token ON public.token USING btree (token);


--
-- TOC entry 4730 (class 1259 OID 16421)
-- Name: ix_access_method_function; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_access_method_function ON public.access_method USING btree (function);


--
-- TOC entry 4731 (class 1259 OID 16420)
-- Name: ix_access_method_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_access_method_id ON public.access_method USING btree (id);


--
-- TOC entry 4733 (class 1259 OID 16452)
-- Name: ix_station_description; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_description ON public.station USING btree (description);


--
-- TOC entry 4734 (class 1259 OID 16449)
-- Name: ix_station_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_id ON public.station USING btree (id);


--
-- TOC entry 4735 (class 1259 OID 16448)
-- Name: ix_station_latitude; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_latitude ON public.station USING btree (latitude);


--
-- TOC entry 4736 (class 1259 OID 16450)
-- Name: ix_station_longitude; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_longitude ON public.station USING btree (longitude);


--
-- TOC entry 4737 (class 1259 OID 16447)
-- Name: ix_station_maintainer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_maintainer ON public.station USING btree (maintainer);


--
-- TOC entry 4738 (class 1259 OID 16454)
-- Name: ix_station_owner; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_owner ON public.station USING btree (owner);


--
-- TOC entry 4739 (class 1259 OID 16446)
-- Name: ix_station_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_project ON public.station USING btree (project);


--
-- TOC entry 4740 (class 1259 OID 16455)
-- Name: ix_station_station_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_station_id ON public.station USING btree (station_id);


--
-- TOC entry 4741 (class 1259 OID 16451)
-- Name: ix_station_variable_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_variable_id ON public.station USING btree (variable_id);


--
-- TOC entry 4742 (class 1259 OID 16453)
-- Name: ix_station_variable_label; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_station_variable_label ON public.station USING btree (variable_label);


--
-- TOC entry 4724 (class 1259 OID 16409)
-- Name: ix_status_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_status_id ON public.status USING btree (id);


--
-- TOC entry 4725 (class 1259 OID 16410)
-- Name: ix_status_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_status_value ON public.status USING btree (value);


--
-- TOC entry 4720 (class 1259 OID 16399)
-- Name: ix_type_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_type_id ON public.type USING btree (id);


--
-- TOC entry 4721 (class 1259 OID 16398)
-- Name: ix_type_value; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_type_value ON public.type USING btree (value);


--
-- TOC entry 4750 (class 2606 OID 16436)
-- Name: station station_access_method_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_access_method_id_fkey FOREIGN KEY (access_method_id) REFERENCES public.access_method(id);


--
-- TOC entry 4751 (class 2606 OID 16441)
-- Name: station station_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.status(id);


--
-- TOC entry 4752 (class 2606 OID 16500)
-- Name: station station_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.token(id);


--
-- TOC entry 4753 (class 2606 OID 16431)
-- Name: station station_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.station
    ADD CONSTRAINT station_type_id_fkey FOREIGN KEY (type_id) REFERENCES public.type(id);


-- Completed on 2025-07-10 14:59:42

--
-- PostgreSQL database dump complete
--

