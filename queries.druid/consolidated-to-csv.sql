use ssb_${SCALE}_raw;

drop table if exists ssb_druid_out;

create external table ssb_druid_out (
  `__time` TIMESTAMP,
  c_city STRING,
  c_nation STRING,
  c_region STRING,
  d_weeknuminyear STRING,
  d_year STRING,
  d_yearmonth STRING,
  d_yearmonthnum STRING,
  lo_discount FLOAT,
  lo_quantity FLOAT,
  p_brand1 STRING,
  p_category STRING,
  p_mfgr STRING,
  s_city STRING,
  s_nation STRING,
  s_region STRING,
  lo_revenue double,
  discounted_price double,
  net_revenue double
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
STORED AS TEXTFILE;

INSERT OVERWRITE TABLE ssb_druid_out
SELECT
  `__time` ,
  c_city ,
  c_nation ,
  c_region ,
  d_weeknuminyear ,
  d_year ,
  d_yearmonth ,
  d_yearmonthnum ,
  lo_discount ,
  lo_quantity ,
  p_brand1 ,
  p_category ,
  p_mfgr ,
  s_city ,
  s_nation ,
  s_region ,
  lo_revenue ,
  discounted_price ,
  net_revenue
FROM
  ${SOURCE}.consolidated;