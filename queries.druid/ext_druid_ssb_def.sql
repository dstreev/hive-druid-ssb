
CREATE DATABASE IF NOT EXISTS druid_ssb;
USE druid_ssb;

DROP TABLE IF EXISTS ssb_druid_${SCALE};
CREATE EXTERNAL TABLE IF NOT EXISTS ssb_druid_${SCALE}
STORED BY 'org.apache.hadoop.hive.druid.DruidStorageHandler'
TBLPROPERTIES (
  "druid.datasource" = "ssb_druid_${SCALE}");
