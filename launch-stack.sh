#!/bin/bash
# sudo chmod +x *.sh
# ./launch-stack.sh

aws s3api list-buckets --query 'Buckets[?starts_with(Name, `pmd-codebuild-`) == `true`].[Name]' --output text | xargs -I {} aws s3 rb s3://{} --force

aws cloudformation delete-stack --stack-name pmd-codebuild-postman

aws cloudformation wait stack-delete-complete --stack-name pmd-codebuild-postman

aws s3 mb s3://pmd-codebuild-$(aws sts get-caller-identity --output text --query 'Account')

# aws cloudformation create-stack --stack-name pmd-codebuild-postman --capabilities CAPABILITY_NAMED_IAM --disable-rollback --template-body file://pipeline-cb.yml

aws cloudformation create-stack --stack-name petstore-api-pipeline --template-body file://./pipeline-cb.yml --parameters ParameterKey=BucketRoot,ParameterValue=pmd-codebuild-$(aws sts get-caller-identity --output text --query 'Account') --capabilities CAPABILITY_NAMED_IAM