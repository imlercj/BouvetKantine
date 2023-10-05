
CREATE TABLE  passings (
   time        TIMESTAMPTZ       NOT NULL,
   direction   TEXT              NOT NULL,
   sensor_name TEXT              NOT NULL,
   last_5min_sum INTEGER         NULL,
);

CREATE TABLE  passings_5min (
   time        TIMESTAMPTZ       NOT NULL,
   direction   TEXT              NOT NULL,
   sensor_name TEXT              NOT NULL,
   visits      INTEGER[]         NULL,
);

CREATE TABLE menu (
   date        DATE              NOT NULL,
   maincourse TEXT              NOT NULL,
   soup        TEXT              NULL,
   weeknumber INTEGER           NULL,
   dayofweek TEXT              NULL,
   updatedat  DATE              NULL,
);




SELECT create_hypertable('passings_5min', 'time');

-- Need this to be able to pase it into the SQL editor and run it
CREATE TABLE  passings(time TIMESTAMPTZ NOT NULL, direction TEXT NOT NULL, sensor_name TEXT NOT NULL, last_5min_sum INTEGER NULL);

SELECT create_hypertable('passings', 'time');

CREATE TABLE menu (date DATE NOT NULL, maincourse TEXT NOT NULL, soup TEXT NULL, weeknumber INTEGER NULL, dayofweek TEXT NULL, updatedat DATE NULL);

CREATE UNIQUE INDEX menu_unique_entry_idx
ON menu (date, updatedat, maincourse, soup);

grant all privileges on schema public to "KantinePostgres";

grant all privileges on table passings to "KantinePostgres";