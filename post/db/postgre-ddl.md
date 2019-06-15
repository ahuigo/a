---
title: FUNCTION
date: 2018-09-27
---
# shell
    psql DBNAME USERNAME
    psql -U user_name -d database_name -h 127.0.0.1 -W
    psql -U user_name database_name -h 127.0.0.1 -W
        \W prompt enter password(可省略)

Non interactive password:

1. vim ~/.pgpass:
    `hostname:port:database:username:password`
2. PGPASSWORD=pass1234 psql -U MyUsername myDatabaseName
3. URI: https://www.postgresql.org/docs/current/static/libpq-connect.html#LIBPQ-CONNSTRING


    psql postgresql://
    psql postgresql://localhost
    psql postgresql://localhost:5433
    psql postgresql://localhost/mydb
    psql postgresql://user@localhost
    psql postgresql://user:secret@localhost
    psql postgresql://other@localhost/otherdb?connect_timeout=10&application_name=myapp
    psql postgresql://host1:123,host2:456/somedb?target_session_attrs=any&application_name=myapp

.pgpass config(recommend):

    1) Create .pgpass file with content
        host:5432:somedb:someuser:somepass

    2) set the permissions using command
        sudo chmod 600 .pgpass

    3) Set the file owner as the same user using which you logged in(实际不需要) :
        sudo chown login_username:login_username .pgpass

    4) Set PGPASSFILE environment variable :
        export PGPASSFILE='/home/user/.pgpass'

    Now check by connecting to database :
        psql -h host -U someuser somedb



# FUNCTION
pg update /delete 都不支持limit, 建议用array 而不是IN:

    DELETE FROM logtable 
        WHERE id = any (array(SELECT id FROM logtable ORDER BY timestamp LIMIT 10));

或者用

    CREATE or replace FUNCTION  update_status() returns character varying as $$
    declare
    match_ret record;
    begin
        SELECT * INTO match_ret FROM product_child WHERE product_status = 2 LIMIT 1 for update ;
        UPDATE product_child SET status_code = '1' where child_code = match_ret.child_code ;

        return match_ret.child_code ;
        commit;
    end ;
    $$ LANGUAGE plpgsql;

# import export

## export sql

    $ pg_dump -U username dbname > dbexport.pgsql
    $ psql -U username dbname < dbexport.pgsql

table:

    \copy my_table to 'my_table.csv' csv;
    \copy my_table FROM 'my_table.csv' DELIMITER ',' CSV;

table with bash:

    $ pg_dump \
    -h localhost \
    -p 5432 \
    -U user -W \
    --table="table-name" --data-only --column-inserts database-name > table.sql

    $ psql \
    -h localhost \
    -p 5432 \
    -U user \
    database-name \
    -f table.sql

## export csv

    \COPY products_273 TO '/tmp/products_199.csv' WITH (FORMAT CSV, HEADER);

    COPY persons TO 'C:\tmp\persons_db.csv' DELIMITER ',' CSV HEADER;

    COPY persons(first_name,last_name,email) TO 'C:\tmp\persons_partial_db.csv' DELIMITER ',' CSV HEADER;

    \copy (Select * From foo) To '/tmp/test.csv' With CSV
    \copy (select * from my_table limit 10) TO '~/Downloads/export.csv' CSV HEADER

# crud
## database

    $ createdb test1
    > CREATE DATABASE yuzhi100 OWNER myuser;
    > drop database yunzhi100

    \l
        list all databases
    \c database_name
        \connect database_name
    SELECT current_database();


## table

### show table

### create

    $ psql -f init.sql
    CREATE TABLE playground (
        id serial PRIMARY KEY,
        uid int UNIQUE,
        name varchar (50) NOT NULL,
        location varchar(25) check (location in ('north', 'south', 'west', 'east',  'northwest')),
        install_date date
    );

describe table and sequence:

    \d
    \dt # with table_squence
    \dt [<table>]

show create table:

    pg_dump -st tablename dbname

### drop

    drop TABLE [IF EXISTS ] xxx

## Alter
ALTER TABLE table_name `<action>`:

    column:
        ADD COLUMN column_name VARCHAR;
        DROP COLUMN column_name;
        ALTER COLUMN location TYPE VARCHAR,
            ALTER COLUMN asset_no TYPE INT USING asset_no::integer;
            ALTER COLUMN column_name [SET DEFAULT value | DROP DEFAULT]
            ALTER COLUMN column_name [SET NOT NULL| DROP NOT NULL]
        RENAME COLUMN column_name TO new_column_name;

    check:
        ADD CHECK (target IN ('_self', '_blank', '_parent', '_top'));
    tablename:
        RENAME TO new_table_name;
    constraint:
        ADD CONSTRAINT constraint_name constraint_definition