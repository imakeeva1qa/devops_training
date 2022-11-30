pipeline:
1. 
2. aws ecr get-login-password \
   --region eu-west-1 \
   | docker login \
   --username AWS \
   --password-stdin 903549323823.dkr.ecr.eu-west-1.amazonaws.com
3. docker build -t jenkins-builds .
4. docker tag jenkins-builds:latest 903549323823.dkr.ecr.eu-west-1.amazonaws.com/jenkins-builds:latest
5. docker push 903549323823.dkr.ecr.eu-west-1.amazonaws.com/jenkins-builds:latest
6. docker rmi -f $(docker images -q) 
deploy
7. create beanstalk + add iam policy to jenkins
7. create .env file
8. docker compose up -d

   environment {
   ENV        = 'staging'
   REGION     = 'eu-north-1'
   REPOSITORY = '903549323823.dkr.ecr.eu-north-1.amazonaws.com'
   APP_NAME   = 'fast-api'
   }