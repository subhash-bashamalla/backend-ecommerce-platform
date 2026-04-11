# ecommerce-backend-platform - Architecture #

# Components:
 - API Service (Fast API, stateless, ECS/Fargate)

        This is our main backend server where user traffic will be served.


 - Application Load Balancer (http ingress)

        This balances the load (the traffic coming into our application)


 - PostgreSQL Database (RDS, Stateful)

        This is our Database where our application data will live. The data like usernames, passwords, history of user accounts, etc.



 - Secrets Store (AWS Secrets Manager)

         This is where we will store our Secrets (the credentials which are used in authentication of different services which we will be using in and for this application)



 - Networking (VPC, Security Groups, Subnets)

        Networking involves the connectivity of different components of our application. We will use different Networking concepts and services to connect and block access/permissions/policies between services and also manage access of our application.



 - Redis Cache (Elasticache, non-critical)

        We use Redis Cache to save the users frequently used data so that we can make our application faster. Basically Cache helps in faster load times as the most used or frequently used/visted data will be stored in the cache and it will be loaded faster than for example, the data that lives in the database.


 - Identity & Access Management (IAM Roles)

        IAM Roles in AWS helps us to assign roles and give specific permission to users and also we can use policies attached to that roles to give/restrict access/permissions to people/services.



 - Observability (CloudWatch Logs & Metrics)

        CloudWatch is an AWS service which helps us to record logs/metrics that we can use for observability.


