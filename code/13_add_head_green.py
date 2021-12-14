import pandas as pd
import numpy as np

data=pd.read_csv(r'/home/ubuntu/export_green_tripdata.csv',header=None,names=[
  'VendorID',
  'pickup_datetime',
  'dropoff_datetime',
  'store_and_fwd_flag',
  'RatecodeID',
  'PULocationID',
  'DOLocationID',
  'passenger_count',
  'trip_distance',
  'fare_amount',
  'extra',
  'mta_tax',
  'tip_amount',
  'tolls_amount',
  'ehail_fee',
  'improvement_surcharge',
  'total_amount',
  'payment_type',
  'trip_type',
  'congestion_surcharge'])
data.to_csv('/home/ubuntu/head_green_tripdata.csv',index=False)