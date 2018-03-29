#!/usr/bin/env bash
BookingNonProdAccountProfile=blog-bookingnonprd
AirmilesNonProdAccountProfile=blog-airmilesnonprd
region=us-east-1

bookingAPI=$(aws cloudformation describe-stacks --stack-name booking-lambda --profile $BookingNonProdAccountProfile --region $region --query 'Stacks[0].Outputs[?OutputKey==`BookingAPI`].OutputValue' --output text)
echo -e "Booking API endpoint is: $bookingAPI"

airmilesAPI=$(aws cloudformation describe-stacks --stack-name airmiles-lambda --profile $AirmilesNonProdAccountProfile --region $region --query 'Stacks[0].Outputs[?OutputKey==`AirmileAPI`].OutputValue' --output text)
echo -e "Airmiles API endpoint is: $airmilesAPI"

echo updating the WebUI config with the API endpoints
cp src/widgets/axios.js.template src/widgets/axios.js
sed -i -e "s%BOOKING_URL%$bookingAPI%" src/widgets/axios.js
sed -i -e "s%AIRMILES_URL%$airmilesAPI%" src/widgets/axios.js
