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
import math

print('Loading function')
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ['TABLE_NAME']
print("DynamoDB table name: " + TABLE_NAME)


# triggered by SNS containing airline booking record, puts record into DynamoDB
def handler(event, context):
    message = event['Records'][0]['Sns']['Message']
    print("From SNS: " + message)
    for record in event['Records']:
        if 'aws:sns' == record['EventSource'] and record['Sns']['Message']:
            json_msg = json.loads(record['Sns']['Message'])
            booking_number = str(json_msg['booking_number'])
            from_airport = json_msg['from_airport']
            to_airport = json_msg['to_airport']
            departure_date = json_msg['departure_date']
            airmiles = random.randint(50, 1000) 
            print("got booking info from sns: " + str(booking_number) + from_airport + to_airport + departure_date + str(airmiles))

        # insert into DynamoDB
        table = dynamodb.Table(TABLE_NAME)

        response = table.put_item(
            Item={
                'booking_number': booking_number,
                'from_airport': from_airport,
                'to_airport': to_airport,
                'departure_date': departure_date,
                'airmiles': str(int(math.floor(airmiles)))
            }
        )
        print("PutItem succeeded. Response is: " + str(response))

    return message
