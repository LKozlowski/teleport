write_confd_file() {
    cat << EOF > ${TELEPORT_CONFD_DIR?}/conf
TELEPORT_ROLE=agent
EC2_REGION=us-west-2
TELEPORT_AGENT_DB_DESCRIPTION="Production PostgreSQL database"
TELEPORT_AGENT_DB_ENABLED=true
TELEPORT_AGENT_DB_LABELS="env: prod|another: test|third: variable-env"
TELEPORT_AGENT_DB_NAME=postgres-production
TELEPORT_AGENT_DB_PROTOCOL=postgres
TELEPORT_AGENT_DB_REDSHIFT_CLUSTER_ID=redshift-cluster-id
TELEPORT_AGENT_DB_URI=postgres-prod123.rds.us-west-2.amazonaws.com:5432
TELEPORT_JOIN_TOKEN=example-auth-token-for-tests
TELEPORT_PROXY_SERVER_LB=gus-tftestkube4-proxy-bc9ba568645c3d80.elb.us-east-1.amazonaws.com
EOF
}

load fixtures/common

@test "[${TEST_SUITE?}] config file was generated without error" {
    [ ${GENERATE_EXIT_CODE?} -eq 0 ]
}

@test "[${TEST_SUITE?}] db_service.databases.aws.redshift.cluster_id is set correctly" {
    load ${TELEPORT_CONFD_DIR?}/conf
    echo "${DB_DATABASES_BLOCK?}"
    echo "${DB_DATABASES_BLOCK?}" | grep -E -A3 "^    aws:" | grep -E -A1 "^      redshift:" | grep -E "^        cluster_id: \"${TELEPORT_AGENT_DB_REDSHIFT_CLUSTER_ID}\""
}