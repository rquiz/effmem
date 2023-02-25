"""
create.sql; load an empty postgres db
"""
-- CREATE USER myuser WITH PASSWORD 'mypassword';
-- CREATE DATABASE mydb;
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;

\c mydb;

CREATE SCHEMA myschema;
GRANT ALL PRIVILEGES ON SCHEMA myschema TO myuser;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

INSERT INTO users (name, email) VALUES ('first', 'person@mail.go');

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

INSERT INTO roles (name) VALUES ('admin');
INSERT INTO roles (name) VALUES ('author');
INSERT INTO roles (name) VALUES ('viewer');
