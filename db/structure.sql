--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    full_name character varying(255),
    address1 character varying(255),
    address2 character varying(255),
    city character varying(255),
    province character varying(255),
    postal_code character varying(255),
    country character varying(255),
    type character varying(255),
    addressable_id integer,
    addressable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: articles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE articles (
    id integer NOT NULL,
    title character varying(255),
    slug character varying(255),
    visible boolean DEFAULT true,
    content text,
    meta_tag text,
    author_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: articles_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE articles_tags (
    article_id integer,
    tag_id integer
);


--
-- Name: audit_trails; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE audit_trails (
    id integer NOT NULL,
    success boolean DEFAULT true,
    message text,
    auditable_id integer,
    auditable_type character varying(255),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audit_trails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE audit_trails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_trails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE audit_trails_id_seq OWNED BY audit_trails.id;


--
-- Name: audit_years; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE audit_years (
    id integer NOT NULL,
    year integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audit_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE audit_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE audit_years_id_seq OWNED BY audit_years.id;


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE carts (
    id integer NOT NULL,
    subtotal numeric(11,2),
    tax_name character varying(255),
    tax_rate numeric(11,2),
    shipping numeric(11,2),
    total numeric(11,2),
    coupon_code character varying(255),
    coupon_amount numeric(11,2),
    coupon_percentage boolean,
    email character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: carts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE carts_id_seq OWNED BY carts.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories_products (
    category_id integer,
    product_id integer
);


--
-- Name: collection_products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collection_products (
    id integer NOT NULL,
    collection_id integer,
    product_id integer,
    "position" integer
);


--
-- Name: collection_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collection_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collection_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collection_products_id_seq OWNED BY collection_products.id;


--
-- Name: collections; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE collections (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    visible boolean DEFAULT true,
    description text,
    meta_tag text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: collections_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE collections_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: collections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE collections_id_seq OWNED BY collections.id;


--
-- Name: coupons; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE coupons (
    id integer NOT NULL,
    code character varying(255),
    amount numeric(11,2),
    percentage boolean DEFAULT true,
    active boolean DEFAULT true,
    orders_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: coupons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE coupons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: coupons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE coupons_id_seq OWNED BY coupons.id;


--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(40),
    created_at timestamp without time zone
);


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: line_items; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE line_items (
    id integer NOT NULL,
    variant_id integer,
    quantity integer DEFAULT 1,
    price numeric(11,2),
    cart_id integer,
    order_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: line_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE line_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE line_items_id_seq OWNED BY line_items.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE orders (
    id integer NOT NULL,
    code character varying(255),
    client_id integer,
    subtotal numeric(11,2),
    tax_name character varying(255),
    tax_rate numeric(11,2),
    shipping_method character varying(255),
    shipping_price numeric(11,2),
    total numeric(11,2),
    coupon_code character varying(255),
    coupon_amount numeric(11,2),
    coupon_percentage boolean,
    remote_ip character varying(255),
    shipped_at timestamp without time zone,
    stripe_card_token character varying(255),
    currency character varying(255),
    card_type character varying(255),
    last4 character varying(255),
    state character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ip_address character varying(255)
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE orders_id_seq OWNED BY orders.id;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pages (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    visible boolean DEFAULT true,
    klass character varying(255),
    content text,
    meta_tag text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pages_id_seq OWNED BY pages.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_id integer,
    searchable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: pictures; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE pictures (
    id integer NOT NULL,
    picturable_id integer,
    picturable_type character varying(255),
    upload_file_name character varying(255),
    upload_content_type character varying(255),
    upload_file_size integer,
    upload_updated_at timestamp without time zone,
    "position" integer,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pictures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pictures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pictures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pictures_id_seq OWNED BY pictures.id;


--
-- Name: product_options; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_options (
    id integer NOT NULL,
    product_id integer,
    name character varying(255),
    "values" character varying(255),
    "position" integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_options_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_options_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_options_id_seq OWNED BY product_options.id;


--
-- Name: product_relationships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_relationships (
    id integer NOT NULL,
    product_id integer,
    other_product_id integer,
    type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_relationships_id_seq OWNED BY product_relationships.id;


--
-- Name: product_reviews; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_reviews (
    id integer NOT NULL,
    message text,
    rating integer DEFAULT 5,
    username character varying(255),
    user_id integer,
    product_id integer,
    approved boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_reviews_id_seq OWNED BY product_reviews.id;


--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE product_variants (
    id integer NOT NULL,
    options hstore,
    price numeric(11,2),
    reduced_price numeric(11,2),
    in_stock integer DEFAULT 0,
    product_id integer,
    orders_count integer DEFAULT 0,
    active boolean DEFAULT true,
    master boolean DEFAULT false,
    sku character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    cost_price numeric(11,2)
);


--
-- Name: product_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE product_variants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE product_variants_id_seq OWNED BY product_variants.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    name character varying(255),
    slug character varying(255),
    description text,
    visible boolean DEFAULT true,
    featured boolean DEFAULT false,
    supplier_id integer,
    meta_tag text,
    orders_count integer DEFAULT 0,
    active boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    product_variants_count integer DEFAULT 0 NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: products_suppliers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE products_suppliers (
    product_id integer,
    supplier_id integer
);


--
-- Name: region_taxes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE region_taxes (
    id integer NOT NULL,
    tax_id integer,
    province character varying(255),
    name character varying(255),
    rate numeric(4,2) DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: region_taxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE region_taxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: region_taxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE region_taxes_id_seq OWNED BY region_taxes.id;


--
-- Name: reseller_requests; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE reseller_requests (
    id integer NOT NULL,
    user_id integer,
    approved boolean DEFAULT false,
    business_name character varying(255),
    country character varying(255),
    city character varying(255),
    who_are_you text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: reseller_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reseller_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reseller_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reseller_requests_id_seq OWNED BY reseller_requests.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE settings (
    id integer NOT NULL,
    var character varying(255) NOT NULL,
    value text,
    thing_id integer,
    thing_type character varying(30),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE settings_id_seq OWNED BY settings.id;


--
-- Name: shipping_countries; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shipping_countries (
    id integer NOT NULL,
    country character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: shipping_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shipping_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shipping_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shipping_countries_id_seq OWNED BY shipping_countries.id;


--
-- Name: shipping_rates; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE shipping_rates (
    id integer NOT NULL,
    shipping_country_id integer,
    name character varying(255),
    criteria character varying(255) DEFAULT 'price-based'::character varying,
    min_criteria numeric(6,2),
    max_criteria numeric(6,2),
    price numeric(11,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: shipping_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE shipping_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shipping_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE shipping_rates_id_seq OWNED BY shipping_rates.id;


--
-- Name: stocks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stocks (
    id integer NOT NULL,
    in_stock integer DEFAULT 0,
    product_id integer,
    product_variant_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stocks_id_seq OWNED BY stocks.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE suppliers (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE suppliers_id_seq OWNED BY suppliers.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: taxes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxes (
    id integer NOT NULL,
    shipping_country_id integer,
    name character varying(255),
    rate numeric(4,2) DEFAULT 0,
    region_taxes_count integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: taxes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxes_id_seq OWNED BY taxes.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    active boolean DEFAULT true,
    admin boolean DEFAULT false,
    reseller boolean DEFAULT false,
    localization character varying(255) DEFAULT 'en'::character varying,
    crypted_password character varying(255),
    salt character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    remember_me_token character varying(255) DEFAULT NULL::character varying,
    remember_me_token_expires_at timestamp without time zone,
    reset_password_token character varying(255) DEFAULT NULL::character varying,
    reset_password_token_expires_at timestamp without time zone,
    reset_password_email_sent_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit_trails ALTER COLUMN id SET DEFAULT nextval('audit_trails_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY audit_years ALTER COLUMN id SET DEFAULT nextval('audit_years_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY carts ALTER COLUMN id SET DEFAULT nextval('carts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collection_products ALTER COLUMN id SET DEFAULT nextval('collection_products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY collections ALTER COLUMN id SET DEFAULT nextval('collections_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY coupons ALTER COLUMN id SET DEFAULT nextval('coupons_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY line_items ALTER COLUMN id SET DEFAULT nextval('line_items_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY orders ALTER COLUMN id SET DEFAULT nextval('orders_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pages ALTER COLUMN id SET DEFAULT nextval('pages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pictures ALTER COLUMN id SET DEFAULT nextval('pictures_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_options ALTER COLUMN id SET DEFAULT nextval('product_options_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_relationships ALTER COLUMN id SET DEFAULT nextval('product_relationships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_reviews ALTER COLUMN id SET DEFAULT nextval('product_reviews_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY product_variants ALTER COLUMN id SET DEFAULT nextval('product_variants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY region_taxes ALTER COLUMN id SET DEFAULT nextval('region_taxes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reseller_requests ALTER COLUMN id SET DEFAULT nextval('reseller_requests_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shipping_countries ALTER COLUMN id SET DEFAULT nextval('shipping_countries_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY shipping_rates ALTER COLUMN id SET DEFAULT nextval('shipping_rates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stocks ALTER COLUMN id SET DEFAULT nextval('stocks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY suppliers ALTER COLUMN id SET DEFAULT nextval('suppliers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxes ALTER COLUMN id SET DEFAULT nextval('taxes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: audit_trails_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit_trails
    ADD CONSTRAINT audit_trails_pkey PRIMARY KEY (id);


--
-- Name: audit_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY audit_years
    ADD CONSTRAINT audit_years_pkey PRIMARY KEY (id);


--
-- Name: carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: collection_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collection_products
    ADD CONSTRAINT collection_products_pkey PRIMARY KEY (id);


--
-- Name: collections_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY collections
    ADD CONSTRAINT collections_pkey PRIMARY KEY (id);


--
-- Name: coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: line_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY line_items
    ADD CONSTRAINT line_items_pkey PRIMARY KEY (id);


--
-- Name: orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: pictures_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY pictures
    ADD CONSTRAINT pictures_pkey PRIMARY KEY (id);


--
-- Name: product_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_options
    ADD CONSTRAINT product_options_pkey PRIMARY KEY (id);


--
-- Name: product_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_relationships
    ADD CONSTRAINT product_relationships_pkey PRIMARY KEY (id);


--
-- Name: product_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_reviews
    ADD CONSTRAINT product_reviews_pkey PRIMARY KEY (id);


--
-- Name: product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY product_variants
    ADD CONSTRAINT product_variants_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: region_taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY region_taxes
    ADD CONSTRAINT region_taxes_pkey PRIMARY KEY (id);


--
-- Name: reseller_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY reseller_requests
    ADD CONSTRAINT reseller_requests_pkey PRIMARY KEY (id);


--
-- Name: settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: shipping_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shipping_countries
    ADD CONSTRAINT shipping_countries_pkey PRIMARY KEY (id);


--
-- Name: shipping_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY shipping_rates
    ADD CONSTRAINT shipping_rates_pkey PRIMARY KEY (id);


--
-- Name: stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stocks
    ADD CONSTRAINT stocks_pkey PRIMARY KEY (id);


--
-- Name: suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: taxes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxes
    ADD CONSTRAINT taxes_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_addresses_on_addressable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_addressable_id ON addresses USING btree (addressable_id);


--
-- Name: index_addresses_on_addressable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_addressable_type ON addresses USING btree (addressable_type);


--
-- Name: index_addresses_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_type ON addresses USING btree (type);


--
-- Name: index_articles_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_articles_on_slug ON articles USING btree (slug);


--
-- Name: index_articles_tags_on_article_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_articles_tags_on_article_id ON articles_tags USING btree (article_id);


--
-- Name: index_articles_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_articles_tags_on_tag_id ON articles_tags USING btree (tag_id);


--
-- Name: index_categories_products_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_products_on_category_id ON categories_products USING btree (category_id);


--
-- Name: index_categories_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_categories_products_on_product_id ON categories_products USING btree (product_id);


--
-- Name: index_collection_products_on_collection_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_products_on_collection_id ON collection_products USING btree (collection_id);


--
-- Name: index_collection_products_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_collection_products_on_product_id ON collection_products USING btree (product_id);


--
-- Name: index_coupons_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_coupons_on_code ON coupons USING btree (code);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_line_items_on_cart_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_line_items_on_cart_id ON line_items USING btree (cart_id);


--
-- Name: index_line_items_on_order_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_line_items_on_order_id ON line_items USING btree (order_id);


--
-- Name: index_line_items_on_variant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_line_items_on_variant_id ON line_items USING btree (variant_id);


--
-- Name: index_orders_on_client_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_orders_on_client_id ON orders USING btree (client_id);


--
-- Name: index_pages_on_slug; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_pages_on_slug ON pages USING btree (slug);


--
-- Name: index_product_variants_on_options; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_variants_on_options ON product_variants USING gist (options);


--
-- Name: index_product_variants_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_product_variants_on_product_id ON product_variants USING btree (product_id);


--
-- Name: index_products_suppliers_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_suppliers_on_product_id ON products_suppliers USING btree (product_id);


--
-- Name: index_products_suppliers_on_supplier_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_products_suppliers_on_supplier_id ON products_suppliers USING btree (supplier_id);


--
-- Name: index_region_taxes_on_tax_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_region_taxes_on_tax_id ON region_taxes USING btree (tax_id);


--
-- Name: index_settings_on_thing_type_and_thing_id_and_var; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);


--
-- Name: index_shipping_rates_on_shipping_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_shipping_rates_on_shipping_country_id ON shipping_rates USING btree (shipping_country_id);


--
-- Name: index_stocks_on_product_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stocks_on_product_id ON stocks USING btree (product_id);


--
-- Name: index_stocks_on_product_variant_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stocks_on_product_variant_id ON stocks USING btree (product_variant_id);


--
-- Name: index_taxes_on_shipping_country_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxes_on_shipping_country_id ON taxes USING btree (shipping_country_id);


--
-- Name: index_users_on_remember_me_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_remember_me_token ON users USING btree (remember_me_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20130306043155');

INSERT INTO schema_migrations (version) VALUES ('20130306043156');

INSERT INTO schema_migrations (version) VALUES ('20130306043157');

INSERT INTO schema_migrations (version) VALUES ('20130318165102');

INSERT INTO schema_migrations (version) VALUES ('20130318170407');

INSERT INTO schema_migrations (version) VALUES ('20130318204927');

INSERT INTO schema_migrations (version) VALUES ('20130318205557');

INSERT INTO schema_migrations (version) VALUES ('20130318210503');

INSERT INTO schema_migrations (version) VALUES ('20130318211417');

INSERT INTO schema_migrations (version) VALUES ('20130318212540');

INSERT INTO schema_migrations (version) VALUES ('20130318215258');

INSERT INTO schema_migrations (version) VALUES ('20130318225743');

INSERT INTO schema_migrations (version) VALUES ('20130318225928');

INSERT INTO schema_migrations (version) VALUES ('20130323151959');

INSERT INTO schema_migrations (version) VALUES ('20130323152959');

INSERT INTO schema_migrations (version) VALUES ('20130323203604');

INSERT INTO schema_migrations (version) VALUES ('20130323232534');

INSERT INTO schema_migrations (version) VALUES ('20130323233148');

INSERT INTO schema_migrations (version) VALUES ('20130324150219');

INSERT INTO schema_migrations (version) VALUES ('20130325044753');

INSERT INTO schema_migrations (version) VALUES ('20130401215939');

INSERT INTO schema_migrations (version) VALUES ('20130403054616');

INSERT INTO schema_migrations (version) VALUES ('20130405161714');

INSERT INTO schema_migrations (version) VALUES ('20130411041746');

INSERT INTO schema_migrations (version) VALUES ('20130411042511');

INSERT INTO schema_migrations (version) VALUES ('20130411051352');

INSERT INTO schema_migrations (version) VALUES ('20130412092056');

INSERT INTO schema_migrations (version) VALUES ('20130418044639');

INSERT INTO schema_migrations (version) VALUES ('20130418143107');

INSERT INTO schema_migrations (version) VALUES ('20130423133531');

INSERT INTO schema_migrations (version) VALUES ('20130424085047');

INSERT INTO schema_migrations (version) VALUES ('20130424085434');

INSERT INTO schema_migrations (version) VALUES ('20130426050932');

INSERT INTO schema_migrations (version) VALUES ('20130426051112');

INSERT INTO schema_migrations (version) VALUES ('20130501044513');

INSERT INTO schema_migrations (version) VALUES ('20130604105050');

INSERT INTO schema_migrations (version) VALUES ('20130605102011');

INSERT INTO schema_migrations (version) VALUES ('20130817222505');

INSERT INTO schema_migrations (version) VALUES ('20130819135215');

INSERT INTO schema_migrations (version) VALUES ('20130822032641');

INSERT INTO schema_migrations (version) VALUES ('20130912195900');