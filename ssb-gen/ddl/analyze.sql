use ssb_${SCALE}_orc;

analyze table customer compute statistics for columns;
analyze table dates compute statistics for columns;
analyze table part compute statistics for columns;
analyze table supplier compute statistics for columns;
analyze table lineorder partition(lo_orderdate) compute statistics for columns;
