#! /bin/bash  -x 

# lua ruby 
# mysql nginx redis  postgresql 
# zookeeper  activemq  kafka 

MYSQL=mysql.service  #  sudo mysql |  mysql -h localhost -u wangyulong -P 3306 -p'wang510510,' 
POSTGRE=postgresql.service   # sudo -u -i postgres psql 
REDIS=redis-server.service  # sudo redis-cli 
NGINX=nginx.service  # sudo nginx 

mysql_client() {
    echo "connect mysql cient. 1 check mysql service, 2 start mysql client"
    if [[ $(is_active ${MYSQL}) ]]; then 
        echo "mysql is running..."
    else 
        start_service ${MYSQL}
    fi 

    mysql -h localhost -u wangyulong -P 3306 -p'wang510510,'
}

postgre_client() {
    echo "connect to postgresql service" 
    sudo -u -i postgres psql 
}





service_pid() { # running pid   判断是否正在运行, 运行中会有运行中的pid = process id
    pgrep -f ${1} # 2> /dev/null
}

running() {
    rpid "$1" &> /dev/null
}

rpid() {
    pgrep -f "$1" 2> /dev/null
}

is_active() {

    # for test function 
    echo $(service_pid ${1} )
    echo $(running ${1} )
    echo $(rpid ${1} )
    echo "======================================="

    active_status=$(systemctl is-active ${1}) 
    status=1 
    #  active   inactive 
    case ${active_status} in 
        active)
            echo "the ${1} is active"
            status=0
            ;;
        inactive)
            echo "the ${1} is not active"
            status=1
            ;;
        *)
            echo "ERROR : ${active_status}" 
            exit 1 
    esac
    return ${status} 
}

start_service() { # start_service <service_name>

    echo "prog name : ${1}"

    check_active=$(is_active ${1})    

    if [[ ${check_active} ]]; then 
        echo "service is running, do nothing"
        return 
    else 
        echo "prepare start service ${1}"
        systemctl start ${1} 
    fi 
} 

stop_service() { # stop_service <service_name>

    check_active=$(is_active ${1})

    if [[ ${check_active} ]]; then 
        systemctl stop ${1} 
        return 
    else 
        echo "service ${1} is not running, do nothing" 
        return 
    fi 
}

status_service() {  # status_service <service_name>

    test=$(is_active ${1})

    if [[ ${test} ]]; then 
        printf "is active"
    else 
        printf "is not active, inactive"
    fi 

    status_message=$(sudo systemctl status ${1}) 
    echo "service ${1} running message..."
    echo "${status_message}" 
    
}

usage() {
    printf "this is service manager tool, please use it like : serviceManager <service_name> <[start | stop | status]>\n" 
    return 
}

service_manager() { 
    echo "base prog path : ${0}"

    if [[ $# -lt 2 ]]; then 
        echo "please use right command" 
        usage 
        exit 1 
    fi 

    echo "params : $*"

    local service_name=${MYSQL}
    
    case ${1} in 
        mysql)
            service_name=${MYSQL}
            ;;
        postgre*)
            service_name=${POSTGRE}
            ;;
        redis)
            service_name=${REDIS}
            ;;
        nginx)
            service_name=${NGINX}
            ;;
        *)
            echo "program name is invalid !!! please select [mysql | postgre | redis | nginx]" 
            echo "service name : ${1}, and service command : ${2}" 

            usage 
            exit 1 
            ;;
    esac 
    
    case ${2} in 
        start)
            start_service ${service_name} ${2} 
            ;;
        stop)
            stop_service ${service_name} ${2} 
            ;;
        status)
            status_service ${service_name} ${2}  
            ;;
        *)
            echo "ERROR : invalid command !" 
            echo "service name : ${1}, and service command : ${2}" 

            usage 
            exit 1 
            ;;
    esac 
}


service_manager $@ 























