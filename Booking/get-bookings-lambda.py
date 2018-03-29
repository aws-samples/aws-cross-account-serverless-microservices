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
import os
import json

print('Loading function')
BOOKING_TABLE_NAME = os.environ['BOOKING_TABLE_NAME']
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(BOOKING_TABLE_NAME)
print("DynamoDB table name: " + BOOKING_TABLE_NAME)


# triggered by API Gateway on receiving GET event from web application
def handler(event, context):
    print("From API G/W: " + str(event))

    # scan DynamoDB
    response = table.scan(
        Select='ALL_ATTRIBUTES'
    )
    print("Scan succeeded. Response is: " + str(response))

    return {
        'statusCode': 200,
        'body': json.dumps(response['Items']) if 'Items' in response else json.dumps({}),
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
    }
