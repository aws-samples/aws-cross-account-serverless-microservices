#!/usr/bin/env bash
#ToolsAccount=123456789012
#ToolsAccountProfile=blog-tools
#BookingNonProdAccount=123456789012
#BookingNonProdAccountProfile=blog-bookingnonprd
#AirmilesNonProdAccount=123456789012
#AirmilesNonProdAccountProfile=blog-airmilesnonprd
#WebNonProdAccount=123456789012
#WebNonProdAccountProfile=blog-tools
#
##select a region
#region=us-east-1
#AirmilesProject=airmiles
#BookingProject=booking
#WebProject=webui
#
##select unique bucket names
#S3WebsiteBucketName=your-website-bucket
#S3TmpBucketName=your-blog-bucket

#replace the AWS account numbers and profiles below to match your own accounts and profiles
ToolsAccount=295744685835
ToolsAccountProfile=blog-tools
BookingNonProdAccount=570833937993
BookingNonProdAccountProfile=blog-bookingnonprd
AirmilesNonProdAccount=506709822501
AirmilesNonProdAccountProfile=blog-airmilesnonprd
WebNonProdAccount=295744685835
WebNonProdAccountProfile=blog-tools

#select a region
region=us-east-1
AirmilesProject=airmiles
BookingProject=booking
WebProject=webui

#select unique bucket names
S3WebsiteBucketName=mcdg-website-s3bucket
S3TmpBucketName=mcdg-blog-s3bucket

#delete the S3 bucket holding the website content
echo -e "deleting the S3 bucket $S3WebsiteBucketName"
aws s3 rb s3://$S3WebsiteBucketName --profile $ToolsAccountProfile --region $region --force

#delete the WebUI stack created by pipeline in WebUI account
echo -e "deleting the WebUI stack in WebUI account"
aws cloudformation delete-stack --stack-name webui-s3-website-bucket --profile $WebNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name webui-s3-website-bucket --profile $WebNonProdAccountProfile --region $region

#lambda stack created by pipeline in airmiles account
echo -e "deleting lambda stack in airmiles account"
aws cloudformation delete-stack --stack-name ${AirmilesProject}-lambda --profile $AirmilesNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${AirmilesProject}-lambda --profile $AirmilesNonProdAccountProfile --region $region

# lambda stack created by pipeline in booking account
echo -e "deleting lambda stack in booking account"
aws cloudformation delete-stack --stack-name ${BookingProject}-lambda --profile $BookingNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${BookingProject}-lambda --profile $BookingNonProdAccountProfile --region $region

#pipeline for airmiles microservice
echo -e "deleting pipeline in tools account for airmiles microservice"
aws cloudformation delete-stack --stack-name ${AirmilesProject}-pipeline --profile $ToolsAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${AirmilesProject}-pipeline --profile $ToolsAccountProfile --region $region

#pipeline for booking microservice
echo -e "deleting pipeline in tools account for booking microservice"
aws cloudformation delete-stack --stack-name ${BookingProject}-pipeline --profile $ToolsAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${BookingProject}-pipeline --profile $ToolsAccountProfile --region $region

#pipeline for WebUI
echo -e "deleting pipeline in tools account for WebUI"
aws cloudformation delete-stack --stack-name ${WebProject}-pipeline --profile $ToolsAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${WebProject}-pipeline --profile $ToolsAccountProfile --region $region

#custom resource to airmiles account
echo -e "deleting custom resource stack in airmiles account"
aws cloudformation delete-stack --stack-name ${AirmilesProject}-custom --profile $AirmilesNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${AirmilesProject}-custom --profile $AirmilesNonProdAccountProfile --region $region

# custom resource to booking account
echo -e "deleting custom resource stack in booking account"
aws cloudformation delete-stack --stack-name ${BookingProject}-custom --profile $BookingNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${BookingProject}-custom --profile $BookingNonProdAccountProfile --region $region

#cross account roles for airmiles
echo -e "deleting cross-account roles in airmiles account"
aws cloudformation delete-stack --stack-name ${AirmilesProject}-toolsacct-codepipeline-cloudformation-role --profile $AirmilesNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${AirmilesProject}-toolsacct-codepipeline-cloudformation-role --profile $AirmilesNonProdAccountProfile --region $region

#cross account roles for booking
echo -e "deleting cross-account roles in booking account"
aws cloudformation delete-stack --stack-name ${BookingProject}-toolsacct-codepipeline-cloudformation-role --profile $BookingNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${BookingProject}-toolsacct-codepipeline-cloudformation-role --profile $BookingNonProdAccountProfile --region $region

#cross account roles for WebUI
echo -e "deleting cross-account roles in WebUI account"
aws cloudformation delete-stack --stack-name ${WebProject}-toolsacct-codepipeline-cloudformation-role --profile $WebNonProdAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${WebProject}-toolsacct-codepipeline-cloudformation-role --profile $WebNonProdAccountProfile --region $region

#pre requisites for airmiles
echo -e "deleting pre-reqs stack for airmiles"
aws cloudformation delete-stack --stack-name ${AirmilesProject}-pre-reqs --profile $ToolsAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${AirmilesProject}-pre-reqs --profile $ToolsAccountProfile --region $region

#pre requisites for booking
echo -e "deleting pre-reqs stack for booking"
aws cloudformation delete-stack --stack-name ${BookingProject}-pre-reqs --profile $ToolsAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${BookingProject}-pre-reqs --profile $ToolsAccountProfile --region $region

#pre requisites for WebUI
echo -e "deleting pre-reqs stack for WebUI"
aws cloudformation delete-stack --stack-name ${WebProject}-pre-reqs --profile $ToolsAccountProfile --region $region
aws cloudformation wait stack-delete-complete --stack-name ${WebProject}-pre-reqs --profile $ToolsAccountProfile --region $region

#delete the temporary S3 bucket
echo -e "deleting the S3 bucket $S3TmpBucketName"
aws s3 rb s3://$S3TmpBucketName --profile $ToolsAccountProfile --region $region --force