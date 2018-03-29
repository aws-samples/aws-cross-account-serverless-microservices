#!/usr/bin/env python

# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with
# the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions
# and limitations under the License.


from __future__ import print_function
import boto3
import json
import os
import random
import string

print('Loading function')
BOOKING_SNS_ARN = os.environ['BOOKING_SNS_ARN']
BOOKING_TABLE_NAME = os.environ['BOOKING_TABLE_NAME']
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(BOOKING_TABLE_NAME)
sns = boto3.resource('sns')
topic = sns.Topic(BOOKING_SNS_ARN)
print("DynamoDB table name: " + BOOKING_TABLE_NAME)
print("SNS Topic: " + BOOKING_SNS_ARN)


def randomString(length):
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=length))


# triggered by API Gateway on receiving POST event from web application
def handler(event, context):
    print("From API G/W: " + str(event))
    body = json.loads(event['body'])
    first_name = body['first_name']
    last_name = body['last_name']
    from_airport = body['from_airport']
    to_airport = body['to_airport']
    departure_date = body['departure_date']
    return_date = body['return_date']
    age_group = body['age_group']
    booking_class = body['booking_class']
    booking_number = randomString(8);

    # insert into DynamoDB
    response = table.put_item(
        Item={
            "booking_number": booking_number,
            "age_group": age_group,
            "first_name": first_name,
            "last_name": last_name,
            "from_airport": from_airport,
            "to_airport": to_airport,
            "departure_date": departure_date,
            "return_date": return_date,
            "booking_class": booking_class

        }
    )
    print("PutItem succeeded. Response is: " + str(response))

    sns_message = {
        'booking_number': booking_number,
        'from_airport': from_airport,
        'to_airport': to_airport,
        'departure_date': departure_date
    }
    response = topic.publish(
        Message = json.dumps({'default': json.dumps(sns_message)}),
        MessageStructure = 'json'
    )

    return {
        'statusCode': 200,
        'body': json.dumps(sns_message),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
    }
