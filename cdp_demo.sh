#!/bin/bash

echo "*********************"
echo " CDP-DEMO Started "
echo "*********************"

# Required variables
export CLUSTER_NAME=""
export CM_HOST=""
export EDGE_HOST=""
export SSH_KEY=""
export SSH_PASSWORD=""

# Auth to Services
export CM_USER="admin"
export CM_PASSWORD="admin"
export RANGER_USER="admin"
export RANGER_PASSWORD="Cloudera1234"
export KERBEROS="true"
export KERBEROS_USER="francois"
export KERBEROS_REALM="FRISCH.COM"
export KERBEROS_USER_KEYTAB="/home/francois/francois.keytab"

# FreeIPA
export IPA_USE="true"
export IPA_USER="admin"
export IPA_PASSWORD="Cloudera1234"
export IPA_SERVER=""

# DEBUG
export DEBUG=false
export LOG_DIR="/tmp/cdp_demo_logs/"$(date +%m-%d-%Y-%H-%M-%S)

# Steps to Process
export USER_CREATION="true"
export AUTO_CONFIGURATION="false"
export RANGER_POLICIES="true"
export PREPARE_DEPLOYMENTS="true"
export DATA_GENERATION="true"
export PROJECTS_DEPLOYMENT="true"

# Deployments settings
export TARGET_DIR="/root/cdp-demo"

# Data Load specific (for testing purposes mainly)
export JAVA_HOME_PATH="/usr/lib/jvm/java-11/"
export DATAGEN_USER="admin"
export DATAGEN_PASSWORD="admin"

# Users Creation Settings
export CREATE_HDFS_PATHS="true"
export CREATE_KEYTABS="true"

function usage()
{
    echo "This script prepare an existing cluster for demo by creating users, policies, generates data and deploy projects"
    echo ""
    echo "Usage is the following : "
    echo ""
    echo "./cdp_demo.sh"
    echo "  -h --help"
    echo ""
    echo "  --cluster-name=$CLUSTER_NAME Required as it will be the name of the cluster to interact with (Default) "
    echo "  --cm-host=$CM_HOST : Required to interact with components in the cluster (Default) "
    echo "  --edge-host=$EDGE_HOST : Required to launch data generation from this node (Default) "
    echo "  --ssh-key=$SSH_KEY : Required to interact with an host (cm in fact) or provide a password (Default) "
    echo "  --ssh-password=$SSH_PASSWORD : Required to interact with an host (cm in fact) or provide a ssh-key (Default) "
    echo ""
    echo "  --cm-user=$CM_USER (Default) $CM_USER "
    echo "  --cm-password=$CM_PASSWORD (Default) $CM_PASSWORD "
    echo "  --ranger-user=$RANGER_USER (Default) $RANGER_USER "
    echo "  --ranger-password=$RANGER_PASSWORD (Default) $RANGER_PASSWORD "
    echo "  --kerberos=$KERBEROS (Default) $KERBEROS "
    echo "  --kerberos-user=$KERBEROS_USER (Default) $KERBEROS_USER "
    echo "  --kerberos-realm=$KERBEROS_REALM (Default) $KERBEROS_REALM "
    echo "  --kerberos-user-keytab=$KERBEROS_USER_KEYTAB (Default) $KERBEROS_USER_KEYTAB "
    echo ""
    echo "  --use-ipa=$IPA_USE (Default) $IPA_USE "
    echo "  --ipa-user=$IPA_USER (Default) $IPA_USER "
    echo "  --ipa-password=$IPA_PASSWORD (Default) $IPA_PASSWORD "
    echo "  --ipa-server=$IPA_SERVER (Default) $IPA_SERVER "
    echo ""
    echo "  --debug=$DEBUG (Default) $DEBUG "
    echo "  --log-dir=$LOG_DIR (Default) $LOG_DIR "
    echo ""
    echo "  --user-creation=$USER_CREATION (Default) $USER_CREATION "
    echo "  --auto-configuration=$AUTO_CONFIGURATION (Default) $AUTO_CONFIGURATION "
    echo "  --ranger-policies=$RANGER_POLICIES (Default) $RANGER_POLICIES "
    echo "  --prepare-deployments=$PREPARE_DEPLOYMENTS (Default) $PREPARE_DEPLOYMENTS "
    echo "  --data-generation=$DATA_GENERATION (Default) $DATA_GENERATION "
    echo "  --projects-deployment=$PROJECTS_DEPLOYMENT (Default) $PROJECTS_DEPLOYMENT "
    echo ""
    echo "  --target-dir=$TARGET_DIR (Default) $TARGET_DIR"
    echo ""
    echo "  --java-home=$JAVA_HOME_PATH (Default) $JAVA_HOME_PATH"
    echo "  --datagen-user=$DATAGEN_USER (Default) $DATAGEN_USER "
    echo "  --datagen-password=$DATAGEN_PASSWORD (Default) $DATAGEN_PASSWORD "
    echo ""
    echo "  --create-keytabs=$CREATE_KEYTABS (Default) $CREATE_KEYTABS "
    echo "  --create-hdfs-paths=$CREATE_HDFS_PATHS (Default) $CREATE_HDFS_PATHS "
    echo ""
}


while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
        -h | --help)
            usage
            exit
            ;;
        --cluster-name)
            CLUSTER_NAME=$VALUE
            ;;
        --cm-host)
            CM_HOST=$VALUE
            ;;
        --edge-host)
            EDGE_HOST=$VALUE
            ;;
        --ssh-key)
            SSH_KEY=$VALUE
            ;;
        --ssh-password)
            SSH_PASSWORD=$VALUE
            ;;
        --cm-user)
            CM_USER=$VALUE
            ;;
        --cm-password)
            CM_PASSWORD=$VALUE
            ;;
        --ranger-user)
            RANGER_USER=$VALUE
            ;;
        --ranger-password)
            RANGER_PASSWORD=$VALUE
            ;;
        --kerberos)
            KERBEROS=$VALUE
            ;;
        --kerberos-user)
            KERBEROS_USER=$VALUE
            ;;
        --kerberos-realm)
            KERBEROS_REALM=$VALUE
            ;;
        --kerberos-user-keytab)
            KERBEROS_USER_KEYTAB=$VALUE
            ;;
        --use-ipa)
            IPA_USE=$VALUE
            ;;
        --ipa-user)
            IPA_USER=$VALUE
            ;;
        --ipa-password)
            IPA_PASSWORD=$VALUE
            ;;
        --ipa-server)
            IPA_SERVER=$VALUE
            ;;
        --debug)
            DEBUG=$VALUE
            ;;
        --log-dir)
            LOG_DIR=$VALUE
            ;;
        --user-creation)
            USER_CREATION=$VALUE
            ;;
        --auto-configuration)
            AUTO_CONFIGURATION=$VALUE
            ;;
        --ranger-policies)
            RANGER_POLICIES=$VALUE
            ;;
        --prepare-deployments)
            PREPARE_DEPLOYMENTS=$VALUE
            ;;
        --data-generation)
            DATA_GENERATION=$VALUE
            ;;
        --projects-deployment)
            PROJECTS_DEPLOYMENT=$VALUE
            ;;
        --target-dir)
            TARGET_DIR=$VALUE
            ;;
        --java-home)
            JAVA_HOME_PATH=$VALUE
            ;;
        --datagen-user)   
            DATAGEN_USER=$VALUE
            ;; 
        --datagen-password)   
            DATAGEN_PASSWORD=$VALUE
            ;; 
        --create-keytabs)   
            CREATE_KEYTABS=$VALUE
            ;;
        --create-hdfs-paths)   
            CREATE_HDFS_PATHS=$VALUE
            ;;    
        *)
            ;;
    esac
    shift
done

#### Setup files to launch playbooks ###
HOSTS_TEMP=$(mktemp)

# From CM get all hosts and inject them into the hosts file
echo "[cluster]" >> ${HOSTS_TEMP} 
curl -s -L -k -X GET -u ${CM_USER}:${CM_PASSWORD} http://${CM_HOST}:7180/api/v40/hosts \
 | jq -r '.items[] | .hostname' >> ${HOSTS_TEMP} 

if [ "${IPA_SERVER}" != '' ]
then
echo "
[ipa_server]
${IPA_SERVER}
" >> ${HOSTS_TEMP}
fi

echo "
[cloudera_manager]
${CM_HOST}

[edge]
${EDGE_HOST}

[all:vars]
ansible_connection=ssh
ansible_user=root
" >> ${HOSTS_TEMP}

if [ "${SSH_KEY}" != "" ]
then
    echo "ansible_ssh_private_key_file=${SSH_KEY}" >> ${HOSTS_TEMP}
else
    echo "ansible_ssh_pass=${PASSWORD}" >> ${HOSTS_TEMP}
fi

EXTRA_VARS_TEMP=$(mktemp)

envsubst < extra-vars.yml > ${EXTRA_VARS_TEMP}

if [ "${DEBUG}" == "true" ]
then
    echo "HOSTS File content: " 
    cat ${HOSTS_TEMP}
    echo ""
    echo "EXTRA_VARS file content: "
    cat ${EXTRA_VARS_TEMP}
    echo ""
fi

# Creation of log dir
mkdir -p ${LOG_DIR}

##### Launch Each part independently and fail if one of the part fails ####

if [ "${USER_CREATION}" = "true" ] 
then
    echo "############ Create Users ############"
    if [ "${DEBUG}" = "true" ]
    then
        echo " Command launched: ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/users.yml playbooks/user_creation.yml  "
        echo " Follow advancement at: ${LOG_DIR}/user_creation.log "
    fi
    ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/users.yml playbooks/user_creation.yml 2>&1 > ${LOG_DIR}/user_creation.log
    OUTPUT=$(tail -20 ${LOG_DIR}/user_creation.log | grep -A20 RECAP | grep -v "failed=0" | wc -l | xargs)
    if [ "${OUTPUT}" == "2" ]
    then
      echo " SUCCESS: Users Successfully created "
    else
      echo " FAILURE: Could not create users " 
      echo " See details in file: ${LOG_DIR}/user_creation.log "
      exit 1
    fi
fi

if [ "${RANGER_POLICIES}" = "true" ] 
then
    echo "############ Set Ranger Policies ############"
    if [ "${DEBUG}" = "true" ]
    then
        echo " Command launched: ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/ranger.yml playbooks/ranger_policies.yml  "
        echo " Follow advancement at: ${LOG_DIR}/ranger_policies.log "
    fi
    ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/ranger.yml playbooks/ranger_policies.yml 2>&1 > ${LOG_DIR}/ranger_policies.log
    OUTPUT=$(tail -20 ${LOG_DIR}/ranger_policies.log | grep -A20 RECAP | grep -v "failed=0" | wc -l | xargs)
    if [ "${OUTPUT}" == "2" ]
    then
      echo " SUCCESS: Ranger Policies successfully set "
    else
      echo " FAILURE: Could not set Ranger Policies " 
      echo " See details in file: ${LOG_DIR}/ranger_policies.log "
      exit 1
    fi
fi

if [ "${DATA_GENERATION}" = "true" ] 
then
    echo "############ Generates Data ############"
    if [ "${DEBUG}" = "true" ]
    then
        echo " Command launched: ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/data_gen.yml playbooks/data_generation.yml  "
        echo " Follow advancement at: ${LOG_DIR}/data_generation.log "
    fi
    ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/data_gen.yml playbooks/data_generation.yml 2>&1 >> ${LOG_DIR}/data_generation.log
    OUTPUT=$(tail -20 ${LOG_DIR}/data_generation.log | grep -A20 RECAP | grep -v "failed=0" | wc -l | xargs)
    if [ "${OUTPUT}" == "2" ]
    then
      echo " SUCCESS: Generation of data went succesfully "
    else
      echo " FAILURE: Could not generate data " 
      echo " See details in file: ${LOG_DIR}/data_generation.log "
      exit 1
    fi
fi


if [ "${PROJECTS_DEPLOYMENT}" = "true" ] 
then
    echo "############ Deploy Other Projects ############"
    if [ "${DEBUG}" = "true" ]
    then
        echo " Command launched: ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/projects.yml playbooks/projects_deployment.yml  "
        echo " Follow advancement at: ${LOG_DIR}/projects_deployment.log "
    fi
    ansible-playbook -i ${HOSTS_TEMP} -e @${EXTRA_VARS_TEMP} -e @group_vars/all/projects.yml playbooks/projects_deployment.yml 2>&1 > ${LOG_DIR}/projects_deployment.log
    OUTPUT=$(tail -20 ${LOG_DIR}/projects_deployment.log | grep -A20 RECAP | grep -v "failed=0" | wc -l | xargs)
    if [ "${OUTPUT}" == "2" ]
    then
      echo " SUCCESS: Deployment of other projects "
    else
      echo " FAILURE: Could not deploy other projects " 
      echo " See details in file: ${LOG_DIR}/projects_deployment.log "
      exit 1
    fi
fi


# Clean files

rm -rf ${HOSTS_TEMP}
rm -rf ${EXTRA_VARS_TEMP}


echo "*********************"
echo " CDP-DEMO Finished "
echo "*********************"