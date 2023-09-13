
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


SELECT create_hypertable('passings', 'time');


SELECT create_hypertable('passings_5min', 'time');