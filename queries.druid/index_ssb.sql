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

CREATE DATABASE IF NOT EXISTS druid_ssb_${SCALE}_${TYPE};
USE druid_ssb_${SCALE}_${TYPE};

CREATE TABLE ssb_druid (
  `__time` timestamp,
  c_city ,
  c_nation ,
  c_region ,
  d_weeknumuninyear ,
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
  lo_revenue double,
  discounted_price double,
  net_revenue double
)
STORED BY 'org.apache.hadoop.hive.druid.DruidStorageHandler'
TBLPROPERTIES (
  "druid.segment.granularity" = "MONTH",
  "druid.query.granularity" = "DAY");

DROP TABLE IF EXISTS ${SOURCE}.consolidated;

CREATE TABLE ${SOURCE}.consolidated (
  `__time` TIMESTAMP,
  `_month` ,
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
  lo_revenue double,
  discounted_price double,
  net_revenue double
)
CLUSTERED BY (`_month`) SORTED BY (`__time` asc) INTO 10 BUCKETS
STORED AS ORC;

INSERT OVERWRITE TABLE ${SOURCE}.consolidated
SELECT
  cast(CONCAT(d_year,'-',d_monthnuminyear,'-',d_daynuminmonth) as timestamp) as `__time`,
  cast(CONCAT(d_year,'-',d_monthnuminyear)) as `_month`,
  cast(c_city as ) c_city,
  cast(c_nation as ) c_nation,
  cast(c_region as ) c_region,
  cast(d_weeknuminyear as ) d_weeknuminyear,
  cast(d_year as ) d_year,
  cast(d_yearmonth as ) d_yearmonth,
  cast(d_yearmonthnum as ) d_yearmonthnum,
  cast(lo_discount as ) lo_discount,
  cast(lo_quantity as ) lo_quantity,
  cast(p_brand1 as ) p_brand1,
  cast(p_category as ) p_category,
  cast(p_mfgr as ) p_mfgr,
  cast(s_city as ) s_city,
  cast(s_nation as ) s_nation,
  cast(s_region as ) s_region,
  lo_revenue,
  lo_extendedprice * lo_discount discounted_price,
  lo_revenue - lo_supplycost net_revenue
FROM
  ${SOURCE}.customer, ${SOURCE}.dates, ${SOURCE}.lineorder,
  ${SOURCE}.part, ${SOURCE}.supplier
where
  lo_orderdate = d_datekey and lo_partkey = p_partkey
  and lo_suppkey = s_suppkey and lo_custkey = c_custkey;

INSERT OVERWRITE TABLE ssb_druid
SELECT
`__time`,
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
