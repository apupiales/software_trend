DROP TABLE us_ngrams;
DROP TABLE us_sequence;
DROP TABLE book;
DROP TABLE book_ngrams;
DROP TABLE total_match_result;
DROP TABLE total_NMatchL_result;
DROP TABLE total_NMatchB_result;
DROP TABLE total_CountL_result;
DROP TABLE total_CountB_result;

CREATE EXTERNAL TABLE us_ngrams (
 gram string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';

CREATE EXTERNAL TABLE us_sequence (
 gram string
)
STORED AS SEQUENCEFILE;

CREATE EXTERNAL TABLE book_ngrams (
 gram string,
 freq int
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\n';

CREATE EXTERNAL TABLE book (
 gram string,
 freq int
)
STORED AS SEQUENCEFILE;

LOAD DATA LOCAL INPATH '/media/hive/Data/5Gram-summary/US/all/' OVERWRITE INTO TABLE us_ngrams;
LOAD DATA LOCAL INPATH '/media/hive/Data/tools/part-r-00000' OVERWRITE INTO TABLE book_ngrams;

SET hive.exec.compress.output=true;
SET io.seqfile.compression.type=BLOCK;
SET mapred.output.compress=true;
SET mapred.output.compression.codec=org.apache.hadoop.io.compress.GzipCodec;
SET io.compression.codecs=org.apache.hadoop.io.compress.GzipCodec;
SET mapred.min.split.size=134217728;
SET mapred.reduce.tasks = 2;

INSERT OVERWRITE TABLE us_sequence SELECT gram FROM us_ngrams group by gram;
INSERT OVERWRITE TABLE book SELECT gram, freq FROM book_ngrams group by gram, freq;

CREATE EXTERNAL TABLE total_match_result (
 language string,
 totalMatch int
);

CREATE EXTERNAL TABLE total_NMatchL_result (
 language string,
 totalNMatchL int
);

CREATE EXTERNAL TABLE total_NMatchB_result (
 language string,
 totalNMatchB int
);

CREATE EXTERNAL TABLE total_CountL_result (
 language string,
 totalCountL int
);

CREATE EXTERNAL TABLE total_CountB_result (
 language string,
 totalCountB int
);

CREATE EXTERNAL TABLE similarity_result (
 language string,
 totalMatch int,
 totalNMatchL int,
 totalNMatchB int,
 totalCountL int,
 totalCountB int,
 jaccardCoef int,
 jaccardDist int
);

INSERT TABLE total_match_result (SELECT 'American', COUNT(1) FROM us_sequence bs INNER JOIN book b ON (b.gram = bs.gram));

INSERT TABLE total_NMatchL_result (SELECT 'American', SUM(CASE WHEN b.freq IS NULL then 1 else 0 end ) FROM us_sequence bs LEFT OUTER JOIN book b ON (bs.gram = b.gram));

INSERT TABLE total_NMatchB_result (SELECT 'American', SUM(CASE WHEN b.freq IS NOT NULL then 1 else 0 end ) FROM us_sequence bs LEFT OUTER JOIN book b ON (bs.gram = b.gram));

INSERT TABLE total_CountL_result (SELECT 'American', COUNT(1) FROM us_sequence);

INSERT TABLE total_CountB_result (SELECT 'American', COUNT(1) FROM book);
