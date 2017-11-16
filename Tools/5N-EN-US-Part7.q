DROP TABLE raw_ngrams;
DROP TABLE sequence_ngrams;

CREATE EXTERNAL TABLE raw_ngrams (
 gram string,
 year int,
 occurrences bigint,
 pages bigint,
 books bigint
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';

CREATE EXTERNAL TABLE sequence_ngrams (
 gram string
)
STORED AS SEQUENCEFILE;

LOAD DATA LOCAL INPATH '/media/hive/Data/5N-EN-US-Part7/' OVERWRITE INTO TABLE raw_ngrams;

SET hive.exec.compress.output=true;
SET io.seqfile.compression.type=BLOCK;
SET mapred.output.compress=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec;
SET io.compression.codecs=org.apache.hadoop.io.compress.GzipCodec;
SET mapred.min.split.size=134217728;
SET mapred.reduce.tasks = 2;
INSERT OVERWRITE TABLE sequence_ngrams SELECT gram FROM raw_ngrams group by gram;
INSERT OVERWRITE LOCAL DIRECTORY '/media/hive/Data/US-Output7' SELECT * FROM sequence_ngrams;
