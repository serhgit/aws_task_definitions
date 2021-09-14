pipeline {
    agent any
    stages {
        stage('Verify required AWS components') {
            steps {
                milestone(1)
                 withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "AWS IAM Admin",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
			script {
                        env.vars = sh (script: '''
                                set -xe

                                AWS_CLI="/usr/local/bin/aws --region=\"us-east-1\""
                                export TF_VAR_environment=${ENVIRONMENT}
                                export TF_VAR_cluster=${ENVIRONMENT}


                                if [[ -n ${TF_VAR_environment} && -n  ${TF_VAR_cluster} ]]; then

                                        AWS_CLUSTER_JSON=`${AWS_CLI} ecs describe-clusters --clusters ${TF_VAR_cluster}`

                                                if [[ `jq '.clusters | length' <<< ${AWS_CLUSTER_JSON}` -gt 0 ]]; then

                                                        TF_VAR_web_lb_tg_arn=$(${AWS_CLI} elbv2 describe-target-groups | jq .TargetGroups[].TargetGroupArn | grep ${TF_VAR_environment}-web-lb | head -n +1 | sed -e \"s/^\\\"//\" -e \"s/\\\"$//\" )
                                                        TF_VAR_secret_manager_arn=$(${AWS_CLI} secretsmanager  list-secrets  | jq .SecretList[].ARN | grep ${TF_VAR_environment}_${TF_VAR_cluster}_rds | head -n +1 | sed -e \"s/^\\\"//\" -e \"s/\\\"$//\" )

                                                fi

                                                [[ ${TF_VAR_web_lb_tg_arn} != "null" && -n ${TF_VAR_web_lb_tg_arn} ]] && export TF_VAR_web_lb_tg_arn || exit 1
                                                [[ ${TF_VAR_secret_manager_arn} != "null" && -n ${TF_VAR_secret_manager_arn} ]] && export TF_VAR_secret_manager_arn  || exit 1
                                else
                                        echo -e "Cluster ${TF_VAR_cluster} does not exist"
                                        exit 1
                                fi
				echo -en "${TF_VAR_web_lb_tg_arn} ${TF_VAR_secret_manager_arn}"
                        ''',returnStdout: true).trim()
			echo "${env.vars}"
			env.TF_VAR_web_lb_tg_arn = sh (script: 'echo -en ${vars} | awk \'{printf $1}\'', returnStdout: true)
                        env.TF_VAR_secret_manager_arn =  sh (script: 'echo -en ${vars} | awk \'{printf $2}\'', returnStdout: true)
			echo "${env.TF_VAR_web_lb_tg_arn}"
			echo "${env.TF_VAR_secret_manager_arn}"
			}
                }
            }
        }

        stage('Plan') {
                steps {
                        milestone(2)
                        sh 'rm -rf ${APP_NAME} && git clone --branch ${ENVIRONMENT} https://github.com/serhgit/${APP_NAME}'
                        withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: "AWS IAM Admin",
                                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                            sh '''
                                terraform init -reconfigure -backend-config="key=${ENVIRONMENT}/task_definitions/terraform.tfstate" -backend-config="region=us-east-1"
                                terraform plan -var-file="./${APP_NAME}/task_definition.tfvars" -var="secret_manager_arn=arn:${TF_VAR_secret_manager_arn}" -var="web_lb_tg_arn=${TF_VAR_web_lb_tg_arn}"
                                '''
                        }
                }
        }

        stage('Create ECR and task definitions'){
            steps {
                input "Can we proceed with ECR creation and task definition creation ?"
                milestone(3)
                withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "AWS IAM Admin",
                        accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                        secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                        ]]) {
                        sh 'terraform apply -auto-approve -var-file="./${APP_NAME}/task_definition.tfvars"'
                }

            }
        }

    }
}

