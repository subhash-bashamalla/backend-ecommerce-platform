import boto3

ecs = boto3.client("ecs")


def lambda_handler(event, context):

    action = event.get("action", "stop")

    clusters = ecs.list_clusters()["clusterArns"]

    for cluster_arn in clusters:

        services = ecs.list_services(
            cluster=cluster_arn
        )["serviceArns"]

        if not services:
            continue

        described = ecs.describe_services(
            cluster=cluster_arn,
            services=services
        )["services"]

        for service in described:

            tags_response = ecs.list_tags_for_resource(
                resourceArn=service["serviceArn"]
            )

            tags = {
                tag["key"]: tag["value"]
                for tag in tags_response["tags"]
            }

            if tags.get("AutoShutdown") != "true":
                continue

            desired = 0 if action == "stop" else 1

            ecs.update_service(
                cluster=cluster_arn,
                service=service["serviceName"],
                desiredCount=desired
            )

            print(
                f"Updated {service['serviceName']} to {desired}"
            )

    return {
        "statusCode": 200
    }