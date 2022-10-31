import logging
import boto3
from botocore.exceptions import ClientError

def publish_message(message, sns_topic):

    # If SNS topic ARN was not specified
    if sns_topic is None:
        return False

    sns_client = boto3.client('sns')

    try:
        response = sns_client.publish(
            TopicArn=sns_topic,
            Message=message,
            Subject='Github backup failed',
        )['MessageId']
    except ClientError as e:
        logging.error(e)
        return False
    return True
