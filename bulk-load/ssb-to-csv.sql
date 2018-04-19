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
  lo_discount STRING,
  lo_quantity STRING,
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

set mapred.reduce.tasks = 10;
INSERT OVERWRITE TABLE ssb_druid_out
SELECT
  cast(CONCAT(d_year,'-',d_monthnuminyear,'-',d_daynuminmonth) as timestamp) as `__time`,
  cast(c_city as STRING) c_city,
  cast(c_nation as STRING) c_nation,
  cast(c_region as STRING) c_region,
  cast(d_weeknuminyear as STRING) d_weeknuminyear,
  cast(d_year as STRING) d_year,
  cast(d_yearmonth as STRING) d_yearmonth,
  cast(d_yearmonthnum as STRING) d_yearmonthnum,
  cast(lo_discount as STRING) lo_discount,
  cast(lo_quantity as STRING) lo_quantity,
  cast(p_brand1 as STRING) p_brand1,
  cast(p_category as STRING) p_category,
  cast(p_mfgr as STRING) p_mfgr,
  cast(s_city as STRING) s_city,
  cast(s_nation as STRING) s_nation,
  cast(s_region as STRING) s_region,
  lo_revenue,
  lo_extendedprice * lo_discount discounted_price,
  lo_revenue - lo_supplycost net_revenue
FROM
  ${SOURCE}.customer, ${SOURCE}.dates, ${SOURCE}.lineorder,
  ${SOURCE}.part, ${SOURCE}.supplier
where
  lo_orderdate = d_datekey and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey and lo_custkey = c_custkey;
