pipeline {
    agent { label 'jenkins-agent' }
    environment {
        AWS_REGION = "us-east-1"
        REPO_NAME = "backend-ecommerce-platform"
        AWS_ACCOUNT_ID = $(aws sts get-caller-identity --query Account --output text)
        IMAGE_NAME = $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME
        IMAGE_TAG = "build -${BUILD_NUMBER}"
        FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"
        DEPLOYED = "false"
    }

    parameters {
        choice(name: 'DEPLOYING_ENVIRONMENT', choices: ['development', 'staging', 'production'])
        string(name: 'VERSION', defaultValue: 'v1.0.0')
        booleanParam(name: 'RELEASE', defaultValue: false)
    }

    stages {

        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        
        stage("Static Code Quality & Analysis") {
            parallel {
                stage("Lint") {
                    steps {
                        sh "docker run --rm ${FULL_IMAGE} flake8"
                    }
                }

                stage("Unit tests") {
                    steps {
                        sh "docker run --rm ${FULL_IMAGE} pytest"
                    }
                }
            }
        }

        
        stage("Build Image") {
            steps {
                sh '''
                AWS_ACCOUNT_ID = $(aws sts get-caller-identity --query Account --output text)
                IMAGE_NAME = $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME
                IMAGE_TAG = "build -${BUILD_NUMBER}"
                FULL_IMAGE = "${IMAGE_NAME}:${IMAGE_TAG}"

                docker build -t ${FULL_IMAGE} app/
                '''
            }
            
        }
        

        
        stage("Image Security Scan") {
            steps {
                sh '''
                    trivvy image \
                    --severity CRITICAL \
                    --exit-code 1 \
                    ${FULL_IMAGE}
                    '''
            }
        }

        
        stage("Report High Vulnerabilities") {
            steps {
                sh '''
                    trivvy image \
                    --severity HIGH,MEDIUM \
                    --exit-code 0 \
                    ${FULL_IMAGE}
                    '''
            }
        }

        
        
        stage("Tag Image") {
            when {
                expression { params.RELEASE == true }
            }
            steps {
                sh "docker tag ${FULL_IMAGE} ${IMAGE_NAME}:${params.VERSION}"
            }
        }

        
        
        stage("Push Image to Amazon ECR") {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    docker push ${FULL_IMAGE}
                    docker push ${IMAGE_NAME}:${params.VERSION}
                    '''
                
            }
        }

        
        stage("Set Dev Context") {
            steps {
                script {
                    env.DEPLOYMENT_ENVIRONMENT = 'development'
                }
            }
        }


        stage("Deploy to Dev Environment") {
            steps {
                sh '''

                CLUSTER_NAME=${DEPLOYMENT_ENVIRONMENT}-cluster
                SERVICE_NAME=${DEPLOYMENT_ENVIRONMENT}-service
                ALB_NAME=${DEPLOYMENT_ENVIRONMENT}-alb

                set -e

                aws ecs update-service \
                --cluster $CLUSTER_NAME \
                --service $SERVICE_NAME \
                --force-new-deployment


                aws ecs wait services-stable \
                --cluster $CLUSTER_NAME \
                --services $SERVICE_NAME

                ALB_DNS=$(aws elbv2 describe-load-balancers \
                --names $ALB_NAME \
                --query "LoadBalancers[0].DNSName" \
                --output text)


                for a in {seq 1 15}; do
                    curl -f http://$ALB_DNS/health && exit 0
                    echo "Health check failed, Retrying...."
                    sleep 5
                done

                echo "Timed out waiting for Dev service to become Healthy."
                exit 1
                '''
            }
        }


        stage("Set Staging Context") {
            steps {
                script {
                    env.DEPLOYMENT_ENVIRONMENT = 'staging'
                }
            }
        }


        stage("Deploy to Staging Environment") {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                input message: "Approve deployment to Staging?"

               sh '''
                
                CLUSTER_NAME=${DEPLOYMENT_ENVIRONMENT}-cluster
                SERVICE_NAME=${DEPLOYMENT_ENVIRONMENT}-service
                ALB_NAME=${DEPLOYMENT_ENVIRONMENT}-alb

                set -e
                aws ecs update-service \
                --cluster $CLUSTER_NAME \
                --service $SERVICE_NAME \
                --force-new-deployment


                aws ecs wait services-stable \
                --cluster $CLUSTER_NAME \
                --services $SERVICE_NAME

                ALB_DNS=$(aws elbv2 describe-load-balancers \
                --names $ALB_NAME \
                --query "LoadBalancers[0].DNSName" \
                --output text)


                for a in {seq 1 15}; do
                    curl -f http://$ALB_DNS/health && exit 0
                    echo "Health check failed, Retrying...."
                    sleep 5
                done

                echo "Timed out waiting for Staging service to become Healthy."
                exit 1
                '''
            }
        }



        stage("Set Prod Context") {
            steps {
                script {
                    env.DEPLOYMENT_ENVIRONMENT = 'production'
                }
            }
        }


        stage("Deploy Production Environment") {
            when {
                expression { currentBuild.currentResult == 'SUCCESS' }
            }
            steps {
                input message: "Approve deployment to Production?"

               sh '''
                
                CLUSTER_NAME=${DEPLOYMENT_ENVIRONMENT}-cluster
                SERVICE_NAME=${DEPLOYMENT_ENVIRONMENT}-service
                ALB_NAME=${DEPLOYMENT_ENVIRONMENT}-alb

                set -e
                aws ecs update-service \
                --cluster $CLUSTER_NAME \
                --service $SERVICE_NAME \
                --force-new-deployment


                aws ecs wait services-stable \
                --cluster $CLUSTER_NAME \
                --services $SERVICE_NAME

                ALB_DNS=$(aws elbv2 describe-load-balancers \
                --names $ALB_NAME \
                --query "LoadBalancers[0].DNSName" \
                --output text)


                for a in {seq 1 15}; do
                    curl -f http://$ALB_DNS/health && exit 0
                    echo "Health check failed, Retrying...."
                    sleep 5
                done

                echo "Timed out waiting for Production service to become Healthy."
                exit 1
                '''
            }
                
        }

        stage("Production Smoke Test") {
            steps {
                sh """

                ALB_NAME=${DEPLOYMENT_ENVIRONMENT}-alb

                ALB_DNS=$(aws elbv2 describe-load-balancers \
                --names $ALB_NAME \
                --query "LoadBalancers[0].DNSName" \
                --output text)

                for a in \${seq 1 15}; do
                    if curl -f http://$ALB_DNS/products | grep -q "id"; then
                        success=true
                        break
                    fi
                    echo "Smoke tests for products endpoint failed, Retrying..."
                    sleep 5
                done

                    if [ "\$success" = false ]; then
                         echo "Timed out waiting for products endpoint to become healthy."
                        exit 1
                    fi

                echo "-------------------------------------"

                for a in \${seq 1 15}; do
                    curl -f http://$ALB_DNS/users | grep -q "email"; then
                        success=true
                        break
                    fi
                    echo "Smoke tests for users endpoint failed, Retrying..."
                    sleep 5
                done

                    if ["\$success" = false ]; then
                        echo "Timed out waiting for users endpoint to become healthy."
                        exit 1
                    fi

                echo "-------------------------------------"
                echo "Smoke tests passed Successfully!"
                """
            }
        }


        stage("Synthetic Tests") {
            steps {
                sh """

                ALB_NAME=${DEPLOYMENT_ENVIRONMENT}-alb

                ALB_DNS=$(aws elbv2 describe-load-balancers \
                --names $ALB_NAME \
                --query "LoadBalancers[0].DNSName" \
                --output text)


                TOKEN=$(curl -s -X POST http://$ALB_DNS/auth/login \
                -H "Content-Type: application/json" \
                -d '{"email": "user@testing.com", "password": "test"}' | jq -r '.access_token')

                if [ -z "$TOKEN" ] || [ "$TOKEN" = "null" ]; then
                    echo "Synthetic Test failed."
                    exit 1
                fi
                """
            }
        }


        stage("Record Last Deployed Version") {
            stepd {
                sh '''
                echo ${IMAGE_TAG} > latest_version.txt
                aws s3 cp latest_version.txt s3://2026-ecomm-back-app/$DEPLOYMENT_ENVIRONMENT/latest-version.txt
                '''
            }
        }
    }




    post {
        failure {
            script {
                if (env.DEPLOYED == "true") {
                    echo "Deployment Failed. Rolling back to previous version...."

                    sh """
                    LATEST_VERSION=$(aws s3 cp s3://2026-ecomm-back-app/$DEPLOYMENT_ENVIRONMENT/latest-version.txt - | tr -d '\\n')
                    FULL_IMAGE=$IMAGE_NAME:$LATEST_VERSION

                    echo "Rolling back to $FULL_IMAGE"

                    CLUSTER_NAME=${DEPLOYMENT_ENVIRONMENT}-cluster
                    SERVICE_NAME=${DEPLOYMENT_ENVIRONMENT}-service

                    TASK_DEFINITION_ARN=$(aws ecs describe-services \
                        --cluster $CLUSTER_NAME \
                        --services $SERVICE_NAME \
                        --query "services[0].taskDefinition" \
                        --output text)

                    aws ecs describe-task-definition \
                        --task-definition \$TASK_DEFINITION_ARN \
                        --query "taskDefinition" \
                        --output json \
                    | jq --arg IMAGE "\$FULL_IMAGE" '.containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn,.status,.registeredBy,.registeredAt,.revision,.compatibilities,.requiresAttributes)' \
                    | aws ecs register-task-definition \
                        --cli-input-json file://-


                    aws ecs update-service \
                        --cluster $CLUSTER_NAME \
                        --service $SERVICE_NAME \
                        --task-definition ${DEPLOYMENT_ENVIRONMENT}-ecomm-app-task

                    aws ecs wait services-stable \
                        --cluster $CLUSTER_NAME \
                        --services $SERVICE_NAME

                        """
                }
            
            }
        }
    }

       
}

