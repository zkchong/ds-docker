---
jupyter:
  jupytext:
    formats: ipynb,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.4
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

# Description
This notebook test the configuration to start Pyspark 3.x.

```python
import os
```

```python
from pyspark.sql import SparkSession
import configparser, os
```

```python
def init_spark(core=3, memory='4g'):
    # Init spark
    spark = (SparkSession.builder
             .config('spark.master', 'local[%d]' % core) # Use 3 cores -- leave one core for others.
             .config('spark.driver.memory', memory)
             .config('spark.jars.packages', 'org.apache.hadoop:hadoop-aws:3.1.2')
             .appName("Standard Pyspark").getOrCreate()
            )
    # Setup credentials.
    # Assume the credientials is locasted at ~/.aws 
    aws_profile = 'default'
    config = configparser.ConfigParser()
    config.read(os.path.expanduser("~/.aws/credentials"))
    access_id = config.get(aws_profile, "aws_access_key_id")
    access_key = config.get(aws_profile, "aws_secret_access_key")
    
    # Authenticate Hadoop (s3)
    hadoop_conf = spark.sparkContext._jsc.hadoopConfiguration()
    hadoop_conf.set("fs.s3a.aws.credentials.provider", "org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider")
    hadoop_conf.set("fs.s3a.access.key", access_id)
    hadoop_conf.set("fs.s3a.secret.key", access_key)
    
    return spark
```

```python
spark = init_spark()
```

```python
spark
```

```python
business_tab = spark.read.parquet('s3a://adc-ds-lms/aspirasi/prod/lms/adc_lms/latest_data/business_tab.parquet/')

```

```python
business_tab.select('bt_state').show(3)
```

```python

```
