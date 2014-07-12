--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
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


SET search_path = public, pg_catalog;

--
-- Name: posts_after_delete_row_tr(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION posts_after_delete_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
    UPDATE topics SET posts_count = posts_count - 1 WHERE id = OLD.topic_id;
    IF (OLD.remote_id IS NOT NULL AND OLD.remote_id =
        (SELECT last_post_remote_id FROM topics WHERE id = OLD.topic_id)) OR
         OLD.remote_created_at =
          (SELECT last_post_remote_created_at
           FROM topics WHERE id = OLD.topic_id) THEN
      UPDATE topics
      SET last_post_remote_created_at = last_posts.remote_created_at,
          last_post_remote_id = last_posts.remote_id
      FROM (
        SELECT max(remote_created_at) AS remote_created_at,
               max(remote_id) AS remote_id
        FROM posts
        WHERE topic_id = OLD.topic_id
      ) AS last_posts
      WHERE id = OLD.topic_id;
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: posts_after_insert_row_tr(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION posts_after_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE topics SET posts_count = posts_count + 1 WHERE id = NEW.topic_id;
    UPDATE topics SET last_post_remote_created_at = NEW.remote_created_at,
                      last_post_remote_id = NEW.remote_id
    WHERE id = NEW.topic_id;
    UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
    RETURN NULL;
END;
$$;


--
-- Name: topics_after_delete_row_tr(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION topics_after_delete_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id;
    RETURN NULL;
END;
$$;


--
-- Name: topics_after_insert_row_tr(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION topics_after_insert_row_tr() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
    RETURN NULL;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    body text NOT NULL,
    topic_id integer NOT NULL,
    user_id integer,
    remote_created_at timestamp without time zone NOT NULL,
    remote_id integer,
    CONSTRAINT remote_id_not_null_post_legacy CHECK (((remote_created_at <= '2013-02-03 13:14:30'::timestamp without time zone) OR (remote_id IS NOT NULL)))
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE topics (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    user_id integer,
    remote_id integer NOT NULL,
    posts_count integer DEFAULT 0 NOT NULL,
    last_post_remote_created_at timestamp without time zone,
    last_post_remote_id integer,
    remote_created_at timestamp without time zone NOT NULL
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: user_posts_by_hour; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW user_posts_by_hour AS
 SELECT posts.user_id,
    date_trunc('hour'::text, posts.remote_created_at) AS hour,
    count(*) AS posts_count
   FROM posts
  GROUP BY posts.user_id, date_trunc('hour'::text, posts.remote_created_at)
  WITH NO DATA;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    remote_id integer NOT NULL,
    posts_count integer DEFAULT 0 NOT NULL,
    topics_count integer DEFAULT 0 NOT NULL,
    avatar_file_name character varying(255),
    avatar_content_type character varying(255),
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone
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

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_posts_on_remote_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_remote_created_at ON posts USING btree (remote_created_at);


--
-- Name: index_posts_on_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_posts_on_remote_id ON posts USING btree (remote_id);


--
-- Name: index_posts_on_topic_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_topic_id ON posts USING btree (topic_id);


--
-- Name: index_posts_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_user_id ON posts USING btree (user_id);


--
-- Name: index_topics_on_last_post_remote_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_last_post_remote_created_at ON topics USING btree (last_post_remote_created_at);


--
-- Name: index_topics_on_last_post_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_last_post_remote_id ON topics USING btree (last_post_remote_id);


--
-- Name: index_topics_on_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_topics_on_remote_id ON topics USING btree (remote_id);


--
-- Name: index_topics_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_topics_on_user_id ON topics USING btree (user_id);


--
-- Name: index_user_posts_by_hour_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_posts_by_hour_on_user_id ON user_posts_by_hour USING btree (user_id);


--
-- Name: index_users_on_remote_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_remote_id ON users USING btree (remote_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: posts_after_delete_row_tr; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER posts_after_delete_row_tr AFTER DELETE ON posts FOR EACH ROW EXECUTE PROCEDURE posts_after_delete_row_tr();


--
-- Name: posts_after_insert_row_tr; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER posts_after_insert_row_tr AFTER INSERT ON posts FOR EACH ROW EXECUTE PROCEDURE posts_after_insert_row_tr();


--
-- Name: topics_after_delete_row_tr; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER topics_after_delete_row_tr AFTER DELETE ON topics FOR EACH ROW EXECUTE PROCEDURE topics_after_delete_row_tr();


--
-- Name: topics_after_insert_row_tr; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER topics_after_insert_row_tr AFTER INSERT ON topics FOR EACH ROW EXECUTE PROCEDURE topics_after_insert_row_tr();


--
-- Name: posts_topic_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_topic_id_fk FOREIGN KEY (topic_id) REFERENCES topics(id);


--
-- Name: posts_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: topics_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20140609205518');

INSERT INTO schema_migrations (version) VALUES ('20140701124753');

INSERT INTO schema_migrations (version) VALUES ('20140704091318');

INSERT INTO schema_migrations (version) VALUES ('20140712092031');

