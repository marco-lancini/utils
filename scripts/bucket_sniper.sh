#!/bin/bash
RESULT=2
until [  $RESULT -eq 0 ]; do
    aws s3 mb s3://example.com --region eu-west-1
    RESULT=$?
    sleep 5
done
echo "Bucket created!"
