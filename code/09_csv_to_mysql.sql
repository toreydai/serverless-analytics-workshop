create database camp;
use camp;
show tables;

CREATE TABLE yellow_tripdata(
  VendorID int, 
  tpep_pickup_datetime char(20),
  tpep_dropoff_datetime char(20),
  passenger_count int,
  trip_distance float(6,2),
  RatecodeID int,
  store_and_fwd_flag char(10),
  PULocationID int,
  DOLocationID int,
  payment_type int,
  fare_amount float(6,1),
  extra float(6,1),
  mta_tax float(6,1),
  tip_amount float(6,2),
  tolls_amount float(6,1),
  improvement_surcharge float(6,1),
  total_amount float(6,2),
  congestion_surcharge float(6,1)
  ) DEFAULT CHARACTER SET utf8mb4;

load data --local-infile=1 local infile "/home/ubuntu/yellow_tripdata_2021-01.csv" into table yellow_tripdata fields terminated by ',';

select count(*) from yello_tripdata;