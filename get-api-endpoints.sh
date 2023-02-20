#!/usr/bin/env bash
echo "[!] Getting api endpoint"
BookingNonProdAccountProfile=blog-bookingnonprd
AirmilesNonProdAccountProfile=blog-airmilesnonprd
region=us-east-1

bookingAPI=$(aws cloudformation describe-stacks --stack-name booking-lambda --profile $BookingNonProdAccountProfile --region $region --query 'Stacks[0].Outputs[?OutputKey==`BookingAPI`].OutputValue' --output text)
echo -e "Booking API endpoint is: $bookingAPI"

airmilesAPI=$(aws cloudformation describe-stacks --stack-name airmiles-lambda --profile $AirmilesNonProdAccountProfile --region $region --query 'Stacks[0].Outputs[?OutputKey==`AirmileAPI`].OutputValue' --output text)
echo -e "Airmiles API endpoint is: $airmilesAPI"
