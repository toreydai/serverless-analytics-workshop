# Serverless Analytics Workshop
![image](https://github.com/toreydai/serverless-analytics-workshop/blob/main/workshop_arch.png)

实验步骤说明：
### 1、	配置本地计算机
a)	Amazon CLI；
<br>b)	IAM权限；
<br>c)	Python3.6
### 2、	配置基础环境
a)	网络配置；
<br>b)	IAM权限；
<br>c)	RDS MySQL实例1台；
<br>d)	Elasticsearch实例1台；
<br>e)	跳板机EC2实例1台；
<br>f)	S3存储桶1个；
<br>g)	Superset EC2实例1台。
### 3、	准备数据源
a)	下载纽约出租车公开数据集；
<br>b)	将数据集CSV分别导入MySQL，Elasticsearch和S3。
### 4、	数据导出
a)	使用Glue ETL作业将MySQL数据导出；
<br>b)	使用Logstash OSS将Elasticsearch数据导出。
### 5、	使用Glue进行ETL
a)	Glue Data Catalog中创建数据库；
<br>b)	使用爬网程序从S3爬取数据到Glue；
<br>c)	使用Glue Studio创建ETL作业，分别处理3类数据。
### 6、	在Athena中进行查询
a)	在Athena中创建基于S3的外表；
<br>该表汇聚了3类数据源，因此可以在同一个SQL语句中运行查询。
<br>b)	运行SQL，查询Glue爬取后的表。
### 7、	Superset可视化
a)	将Superset连接到Athena；
<br>b)	在Superset中创建图表：
<br>2021年1月，纽约出租车每日乘客总数
![image](https://github.com/toreydai/serverless-analytics-workshop/blob/main/superset_001.png)
<br>2021年1月，纽约出租车平均每单行程距离
![image](https://github.com/toreydai/serverless-analytics-workshop/blob/main/superset_002.png)
### 8、	清理环境
