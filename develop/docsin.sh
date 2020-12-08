#!/bin/sh

# 工作目录
export DOCSIN_WORKER_DIR=$(cd $(dirname $0); pwd)

if [ -f "${DOCSIN_WORKER_DIR}/config" ];then
    source ${DOCSIN_WORKER_DIR}/config
fi

# 应用名
DOCSIN_APP_NAME=$1

# 操作
DOCSIN_OPERATION=$2

# 启动应用
docSinStart() {
    # 项目软连接
    if [ ! -n "$DOCSIN_YAML_FILE" ] ;then
        DOCSIN_PROJECT_PATH="${HOME}/projects/"
    fi
    if [ ! -d "${DOCSIN_WORKER_DIR}/projects/" ];then
        if [ -d "$DOCSIN_PROJECT_PATH" ]; then
            ln -s ${DOCSIN_PROJECT_PATH} ${DOCSIN_WORKER_DIR}/projects
        else 
            mkdir ${DOCSIN_WORKER_DIR}/projects
        fi
    fi

    # 启动命令
    docker-compose -f "${DOCSIN_YAML_FILE}" -p ${DOCSIN_APP_NAME} up -d
}

# 停止应用
docSinStop() {
    docker-compose -f "${DOCSIN_YAML_FILE}" -p ${DOCSIN_APP_NAME} stop
}

# 停止并清理容器
docSinClear() {
    docker-compose -f "${DOCSIN_YAML_FILE}"  -p ${DOCSIN_APP_NAME} down
}

# 获取yaml文件
docSinYaml() {
    if [ ! -n "$DOCSIN_YAML_FILE" ] ;then
        if [ ! -f "${DOCSIN_WORKER_DIR}/yaml/${DOCSIN_APP_NAME}/docker-compose.yml" ];then
            if [ ! -f "${DOCSIN_WORKER_DIR}/yaml/example/${DOCSIN_APP_NAME}/docker-compose.yml" ];then
                echo "Has not [${DOCSIN_APP_NAME}] yaml!"
                exit 1
            fi

            if [ ! -d "${DOCSIN_WORKER_DIR}/yaml/${DOCSIN_APP_NAME}/" ] ;then
                mkdir ${DOCSIN_WORKER_DIR}/yaml/${DOCSIN_APP_NAME}
            fi

            cp ${DOCSIN_WORKER_DIR}/yaml/example/${DOCSIN_APP_NAME}/docker-compose.yml ${DOCSIN_WORKER_DIR}/yaml/${DOCSIN_APP_NAME}/docker-compose.yml
        fi
        DOCSIN_YAML_FILE="${DOCSIN_WORKER_DIR}/yaml/${DOCSIN_APP_NAME}/docker-compose.yml"
    fi
}

if [ ! -n "$DOCSIN_APP_NAME" ] ;then
    echo "What's your app name?"
    exit 1
fi

# 获取yaml文件
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
