#!/bin/bash

set -xe

AWS_CLI="/usr/local/bin/aws"
export TF_VAR_environment="prod"
export TF_VAR_cluster="prod"


  if [[ -n ${TF_VAR_environment} && -n  ${TF_VAR_cluster} ]]; then

    AWS_CLUSTER_JSON=`${AWS_CLI} ecs describe-clusters --clusters ${TF_VAR_cluster}`

    if [[ `jq '.clusters | length' <<< ${AWS_CLUSTER_JSON}` -gt 0 ]]; then

      TF_VAR_web_lb_tg_arn=$(${AWS_CLI} elbv2 describe-target-groups | jq .TargetGroups[].TargetGroupArn | grep ${TF_VAR_environment}-web-lb | head -n +1 | sed -e "s/^\"//" -e "s/\"$//")
      TF_VAR_secret_manager_arn=$(${AWS_CLI} secretsmanager  list-secrets  | jq .SecretList[].ARN | grep ${TF_VAR_environment}_${TF_VAR_cluster}_rds | head -n +1 | sed -e "s/^\"//" -e "s/\"$//")

    fi

    [[ ${TF_VAR_web_lb_tg_arn} != "null" && -n ${TF_VAR_web_lb_tg_arn} ]] && export TF_VAR_web_lb_tg_arn || exit 1
    [[ ${TF_VAR_secret_manager_arn} != "null" && -n ${TF_VAR_secret_manager_arn} ]] && export TF_VAR_secret_manager_arn  || exit 1
  else 
    echo -e "Cluster ${TF_VAR_cluster} does not exist"
    exit 1
  fi
