-- set hive.druid.metadata.username=${DRUID_META_USERNAME};
-- set hive.druid.metadata.password=${DRUID_META_PASSWORD};
-- set hive.druid.metadata.uri=jdbc:mysql://${DRUID_META_HOST}/druid;
set hive.druid.indexer.partition.size.max=1000000;
set hive.druid.indexer.memory.rownum.max=100000;
-- set hive.druid.broker.address.default=${DRUID_BROKER_HOST}:8082;
-- set hive.druid.coordinator.address.default=${DRUID_COORD_HOST}:8081;
-- set hive.druid.storage.storageDirectory=/apps/hive/warehouse;
-- set hive.tez.container.size=1024;
set hive.druid.passiveWaitTimeMs=180000;

use ${SOURCE};

DROP TABLE IF EXISTS ${SOURCE}.consolidated;

CREATE TABLE ${SOURCE}.consolidated (
  `__time` TIMESTAMP,
  `_month` STRING,
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
CLUSTERED BY (`_month`) SORTED BY (`__time` asc) INTO 10 BUCKETS
STORED AS ORC;

INSERT OVERWRITE TABLE ${SOURCE}.consolidated
SELECT
  cast(CONCAT(d_year,'-',d_monthnuminyear,'-',d_daynuminmonth) as timestamp) as `__time`,
  cast(CONCAT(d_year,'-',d_monthnuminyear) as STRING) as `_month`,
  cast(c_city as STRING) c_city,
  cast(c_nation as STRING) c_nation,
  cast(c_region as STRING) c_region,
  cast(d_weeknuminyear as STRING) d_weeknuminyear,
  cast(d_year as STRING) d_year,
  cast(d_yearmonth as STRING) d_yearmonth,
  cast(d_yearmonthnum as STRING) d_yearmonthnum,
  cast(lo_discount as FLOAT) lo_discount,
  cast(lo_quantity as FLOAT) lo_quantity,
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

