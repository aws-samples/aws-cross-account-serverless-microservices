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

print('Loading function')
dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.environ['TABLE_NAME']
print("DynamoDB table name: " + TABLE_NAME)


# responds to GET request from API Gateway. Returns the airmiles associated with a single booking id
def handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))

    # get booking id
    booking_number = event['pathParameters']['bookingid']
    print("booking_number: " + str(booking_number))

    table = dynamodb.Table(TABLE_NAME)
    response = table.get_item(
        Key={
            "booking_number": booking_number
        }
    )

    print("GetItem data: " + str(response))
    item = response["Item"] if ("Item" in response) else {}
    return {
        'statusCode': response['ResponseMetadata']['HTTPStatusCode'],
        'headers': {'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*'},
        'body': json.dumps({"data": item})
    }
