-- 1、在Athena中创建基于S3路径的外表
CREATE EXTERNAL TABLE IF NOT EXISTS TotalData(
VendorID int,
pickup_datetime timestamp,
dropoff_datetime timestamp,
store_and_fwd_flag string,
RatecodeID int,
PULocationID int,
DOLocationID int,
passenger_count int,
trip_distance double,
fare_amount double,
extra double,
mta_tax double,
tip_amount double,
tolls_amount double,
improvement_surcharge double,
total_amount double,
payment_type int,
congestion_surcharge double,
type string
)
STORED AS PARQUET LOCATION 's3://nwcd-camp-bucket/parquet-data/total/'
TBLPROPERTIES ('classification'='parquet') 

-- 2、查看3类数据分别有多少条
select type,count(*) from totaldata group by type;

-- 3、从表中获取10条type=green的数据进行查看
select * from totaldata where type='green' limit 10;

-- 4、获取接到乘客时间最早的10条数据
select * from totaldata order by pickup_datetime limit 10;

-- 5、查询24小时中，每个小时的平均车费
SELECT EXTRACT (HOUR FROM pickup_datetime) AS hour, avg(fare_amount) AS average_fare FROM totaldata GROUP BY 1 ORDER BY 1;

-- 6、查询平均距离和平均每英里车费
SELECT type,
            avg(trip_distance) AS avgDist,
            avg(total_amount/trip_distance) AS avgCostPerMile
FROM totaldata
WHERE trip_distance > 0
AND total_amount > 0
GROUP BY type