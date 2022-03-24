CREATE DATABASE cashback_db;

CREATE USER cashback_usr WITH ENCRYPTED PASSWORD 'cashback_pwd';
GRANT ALL PRIVILEGES ON DATABASE cashback_db TO cashback_usr;

ALTER ROLE cashback_usr SUPERUSER CREATEROLE;

\connect cashback_db

CREATE TABLE IF NOT EXISTS public.customer
(
    customer_id numeric NOT NULL,
    status text[] COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT customer_pkey PRIMARY KEY (customer_id)
);

COMMENT ON TABLE public.customer
    IS 'Contains information about the customer involved in a cashback transaction';

COMMENT ON COLUMN public.customer.status
    IS 'Customer category, status: silver,gold,diamond';

CREATE TABLE IF NOT EXISTS public.customer_cashback
(
    customer_cashback_id numeric NOT NULL,
    customer_id numeric,
    current_available_amount numeric NOT NULL DEFAULT 0,
    CONSTRAINT customer_cashback_pkey PRIMARY KEY (customer_cashback_id)
);

COMMENT ON TABLE public.customer_cashback
    IS 'Contains information about the cashback wallet of a customer';

COMMENT ON COLUMN public.customer_cashback.current_available_amount
    IS 'Current value of accumulated cashback';

CREATE TABLE IF NOT EXISTS public.expense
(
    expense_id numeric NOT NULL,
    customer_id numeric NOT NULL,
    cost numeric(5, 0) NOT NULL,
    date timestamp without time zone NOT NULL,
    customer_cashback_id numeric NOT NULL,
    CONSTRAINT expense_pkey PRIMARY KEY (expense_id)
);

COMMENT ON TABLE public.expense
    IS 'Detailed expense information relative to a items elligible for cashback that are acquired by a customers ';

ALTER TABLE IF EXISTS public.customer_cashback
    ADD CONSTRAINT customer_fkey FOREIGN KEY (customer_id)
    REFERENCES public.customer (customer_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.expense
    ADD CONSTRAINT customer_cashback_fkey FOREIGN KEY (customer_cashback_id)
    REFERENCES public.customer_cashback (customer_cashback_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.expense
    ADD CONSTRAINT customer_id_fkey FOREIGN KEY (customer_id)
    REFERENCES public.customer (customer_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

