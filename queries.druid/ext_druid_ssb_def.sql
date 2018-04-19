
CREATE DATABASE IF NOT EXISTS druid_ssb_${SCALE};
USE druid_ssb_${SCALE};

DROP TABLE IF EXISTS ssb_druid;
CREATE EXTERNAL TABLE IF NOT EXISTS ssb_druid
STORED BY 'org.apache.hadoop.hive.druid.DruidStorageHandler'
TBLPROPERTIES (
  "druid.datasource" = "ssb_druid_${SCALE}");
