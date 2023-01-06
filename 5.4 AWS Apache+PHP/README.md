# Cloudformation Apache+PHP+Wordpress+NodeJS+Gatsby

Upload /cloudformation/cf.yaml to Cloudformation service to create a stack or use aws cloudformation CLI.

The Stack creates:  
1. EC2 instance with provisioned stack Apache, NodeJS, PHP, Wordpress (/app1), Gatsby (hello world - /app2)
2. ALB in the default subnets forwarding to the EC2 on port 80
3. Security and target groups and alb listener

## OUTPUTS:
Stack initiation  

![](images/1-stack.png)

Output with public IP address  

![](images/2-output.png)

Output without public IP address  

![](images/3-output.png)

Wordpress  

![](images/4-wordpress.png)

Gatsby  

![](images/5-gatsby.png)
