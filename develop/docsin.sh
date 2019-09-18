#!/bin/sh

DOCSIN_WORK_DIR=$(cd $(dirname $0); pwd)

if [ -f "${DOCSIN_WORK_DIR}/config" ];then
    source ${DOCSIN_WORK_DIR}/config
fi

DOCSIN_APP_NAME=$1

DOCSIN_OPERATION=$2

# Create and start containers
docSinStart() {
    # 项目软连接
    if [ ! -n "$DOCSIN_YAML_FILE" ] ;then
        DOCSIN_PROJECT_PATH="${HOME}/projects/"
    fi
    if [ ! -d "${DOCSIN_WORK_DIR}/projects/" ];then
        if [ -d "$DOCSIN_PROJECT_PATH" ]; then
            ln -s ${DOCSIN_PROJECT_PATH} ${DOCSIN_WORK_DIR}/projects
        else 
            mkdir ${DOCSIN_WORK_DIR}/projects
        fi
    fi
    docker-compose -f "${DOCSIN_YAML_FILE}" -p ${DOCSIN_APP_NAME} up -d
}

# Stop services
docSinStop() {
    docker-compose -f "${DOCSIN_YAML_FILE}" -p ${DOCSIN_APP_NAME} stop
}

# Stop and remove containers, networks, images, and volumes
docSinClear() {
    docker-compose -f "${DOCSIN_YAML_FILE}"  -p ${DOCSIN_APP_NAME} down
}

# get yaml file
docSinYaml() {
    if [ ! -n "$DOCSIN_YAML_FILE" ] ;then
        if [ ! -f "${DOCSIN_WORK_DIR}/yaml/${DOCSIN_APP_NAME}.yml" ];then
            if [ ! -f "${DOCSIN_WORK_DIR}/yaml/example/${DOCSIN_APP_NAME}.yml" ];then
                echo "Has not [${DOCSIN_APP_NAME}.yml]!"
                exit 1
            fi
            cp ${DOCSIN_WORK_DIR}/yaml/example/${DOCSIN_APP_NAME}.yml ${DOCSIN_WORK_DIR}/yaml/${DOCSIN_APP_NAME}.yml
        fi
        DOCSIN_YAML_FILE="${DOCSIN_WORK_DIR}/yaml/${DOCSIN_APP_NAME}.yml"
    fi
}

if [ ! -n "$DOCSIN_APP_NAME" ] ;then
    echo "What's your app name?"
    exit 1
fi

docSinYaml

if [ "$DOCSIN_OPERATION" == "start" ]; then
    docSinStart
elif [ "$DOCSIN_OPERATION" == "stop" ]; then
    docSinStop
elif [ "$DOCSIN_OPERATION" == "clear" ]; then
    docSinClear
else
    echo "What's your operation?";
fi
exit 0
