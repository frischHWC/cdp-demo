CREATE DATABASE IF NOT EXISTS fake_data;
CREATE TABLE IF NOT EXISTS fake_data.fake_full_data AS SELECT * FROM random_datagen.full_rd WHERE recording_time > 1617764585 ;