CREATE SEQUENCE user_role_id_seq;
CREATE TABLE user_role
(
    id integer NOT NULL DEFAULT nextval('user_role_id_seq') PRIMARY KEY,
    role_name text,
    create_time timestamp DEFAULT now()
)

CREATE SEQUENCE users_id_seq;
CREATE TABLE users
(
    id integer NOT NULL DEFAULT nextval('users_id_seq') PRIMARY KEY,
    user_name text,
    role int references user_role(id), 
    create_time timestamp default now()
)

CREATE SEQUENCE refresh_sessions_id_seq;
CREATE TABLE refresh_sessions
(
    id integer NOT NULL DEFAULT nextval('refresh_sessions_id_seq') PRIMARY KEY,
    user_name text,
    refresh_uuid text,
    user_agent text,
    host text,
    expires_in bigint,
    create_time timestamp
)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--Question
CREATE SEQUENCE question_id_seq;
CREATE TABLE public.question
(
	id integer NOT NULL DEFAULT nextval('question_id_seq') PRIMARY KEY,
	type_id integer references question_type(id),
	status text references question_status(status),
	subject_id integer references subject(id),
	user_create integer references users(id),
	user_moderate integer references users(id),
	create_date timestamp default now()::date,
	moderate_date timestamp default now()::date
)

CREATE TABLE public.question_status
(
	status text NOT NULL
)


CREATE SEQUENCE question_type_id_seq;
CREATE TABLE public.question_type
(
	id integer NOT NULL DEFAULT nextval('question_type_id_seq') PRIMARY KEY,
	name text NOT NULL
)

CREATE TABLE public.question_connect
(
	question_id references question(id) on delete cascade,
	question text NOT NULL,

)

CREATE TABLE public.question_text
(
	question_id references question(id) on delete cascade,
	question text NOT NULL,
	
)

CREATE TABLE public.question_choise
(
	question_id integer references question(id) on delete cascade,
	question_text text NOT NULL,
	question_code text,
	variant jsonb
)

CREATE TABLE public.answer
(
	question_id integer references question(id) on delete cascade,
	answer jsonb
)

--///////////////////////////////////////////////////////////////////////////////////////////////////////////////
--Subject
CREATE EXTENSION ltree;

CREATE SEQUENCE subject_id_seq;
CREATE TABLE public.subject
(
    id integer NOT NULL DEFAULT nextval('subject_id_seq') PRIMARY KEY,
    comment text,
    date_create timestamp NOT NULL DEFAULT now()::date,
    description text,
    last_time_update timestamp default now()::date,
    name text NOT NULL,
    type text,
    active bool DEFAULT true,
    parent_id integer references subject,
    parent_path LTREE
)

CREATE INDEX subject_parent_path_idx ON subject USING GIST(parent_path);
CREATE INDEX subject_parent_id_idx ON subject(parent_id);


--/////////////////////////////////////////////////////////////////////////////////////////////////////////////
--Test
CREATE SEQUENCE test_id_seq;
CREATE TABLE public.test
(
	id integer NOT NULL DEFAULT nextval('subject_id_seq') PRIMARY KEY,
	title text NOT NULL,
	description text
	user_id references user(id)
	date_create timestamp NOT NULL,
)

CREATE TABLE public.test_question
(
	test_id references test(id) on delete cascade,
	question_id references question(id) on delete cascade
)
