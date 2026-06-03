import json
import boto3
import secrets
import string

rds = boto3.client("rds")
secrets_manager = boto3.client("secretsmanager")


def generate_password():

    alphabet = (
        string.ascii_letters +
        string.digits +
        "!@#$%^&*"
    )

    return "".join(
        secrets.choice(alphabet)
        for _ in range(32)
    )


def lambda_handler(event, context):

    secret_arn = event["secret_arn"]
    db_identifier = event["db_identifier"]

    current_secret = secrets_manager.get_secret_value(
        SecretId=secret_arn
    )

    secret_data = json.loads(
        current_secret["SecretString"]
    )

    new_password = generate_password()

    rds.modify_db_instance(
        DBInstanceIdentifier=db_identifier,
        MasterUserPassword=new_password,
        ApplyImmediately=True
    )

    secret_data["password"] = new_password

    secrets_manager.put_secret_value(
        SecretId=secret_arn,
        SecretString=json.dumps(secret_data)
    )

    return {
        "statusCode": 200
    }