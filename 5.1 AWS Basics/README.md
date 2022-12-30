# AWS BASICS

Some points implemented via terraform (1-5, 10)

1. VPC with 2 public, 1 private subnets (1 more private added later on), multi AZ (2).
2. Security Group (http, https, ssh)
3. Key Pair
4. EC2 (2 instances with a dummy website)
5. ELB (ALB in public subnets to point to EC2s)
Target group is reached by the Load Balancer:  

![](images/working_app_2ips_1.png)  

![](images/working_app_2ips_2.png)  

![](images/working_target_group.png)

Repointing web-sg:  

![](images/repointing_web_sg.png)

Disabling Instance:  
![](images/disabled_instance_target_group.png)

Inaccessible directly:  

![](images/inaccessible_directly.png)

6. RDS
Added another private subnet.  
Created db Subnet Group with private subnets.

![](images/rds_summary.png)

Added SG inbound rule 5432 -> source: web-sg

![](images/rds_sg_rule.png)

![](images/rds_connection.png)

![](images/rds_connection_1.png)

7. Elasticache
   Created subnet groups
   Created SG inbound rule 6379
   Created SG inbound rule 11211
* Redis

![](images/redis_connection.png)

![](images/redis_connection_1.png)

![](images/redis_summary.png)

* Memcached  

![](images/memcached_connection.png)

![](images/memcached_connection_1.png)

![](images/memcached_summary.png)

8. Cloudfront Distribution

![](images/cloudfront_file.png)

![](images/cloudfront_image.png)

![](images/cloudfront_summary.png)

S3 rule:  

![](images/s3_rule.png)

```bash
# create files:
echo "DUMMYDUMMYDUMMY" > dummy{0001..0100}.c
```

9. Implemented using IAM role for S3 and _terraform/scripts/s3.sh_.

![](images/s3_sh_script.png)

![](images/s3_sh_script_1.png)

10. Implemented using ALB, see _terraform/asg+elb_. Autoscaling implements using cloudwatch_alarms.

![](images/autoscaling_browser.png)

![](images/autoscaling_log.png)
