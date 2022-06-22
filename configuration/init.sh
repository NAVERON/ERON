#! /bin/bash -x 

# AUTHOR WangYuLong/ERON 

CUR_DIR=$(realpath ./) 
echo "current dir is ${CUR_DIR}, please confirm running dir !" 

TMP_DIR="${HOME}/init_builder_tmp" 
CUSTOME_BIN_DIR="${HOME}/bin" 
CUSTOME_OTHER_ENV_DIR="${CUSTOME_BIN_DIR}/env" 

BASHRC_FILE="${HOME}/.bashrc" 
PROFILE_FILE="${HOME}/.profile" 
BASH_ALIASES_FILE="${HOME}/.bash_aliases" 

# all the first thing is install python3 pip3 git java8 java11/java17 environment 
# Obsidian-0.12.15 
# pandas 
# balenaEtcher-1.7.0-x64 

basic_tools_check () {

    # required dev env packages 
    sudo apt install -y build-essential net-tools 

    rsync --version 
    if [ $? -eq 0 ]; then 
        echo "rsync is Installed, usage : rsync -P source target ..." 
    else 
        echo "rsync is not installed ! installing..." 
        sudo apt install -y rsync 
    fi 

    wget --version 
    if [ $? -eq 0 ]; then 
        echo "wget is Installed, usage : wget -O filename url ..." 
    else 
        echo "wget is not installed ! installing..." 
        sudo apt install -y wget # wget2 install later 
    fi 

    tar --version 
    if [ $? -eq 0 ]; then 
        echo "tar is Installed, usage : tar --help for example -> \ntar -cf archive.tar foo bar | tar -xf archive.tar ..." 
    else 
        echo "tar is not installed ! installing..." 
        sudo apt install -y tar 
    fi 

    zip --version 
    if [ $? -eq 0 ]; then 
        echo "zip is installed, next must check unzip !!!" 
    else 
        echo "zip is not installed ! installing..." 
        sudo apt install -y zip 
    fi 

    unzip --version 
    if [ $? -eq 0 ]; then 
        echo "unzip is installed !" 
    else 
        echo "unzip is not installed ! installing..." 
        sudo apt install -y unzip 
    fi 

}

# repo and others dirs, just copy files and put it right position 
files_copy_and_check () { 

    echo "Folders check and creating ..." 
    # check folder is exists 
    if [ ! -d "${CUSTOME_BIN_DIR}" ]; then 
        echo "~/bin for bin tools, ~/bin/env for other dev bins, creating ..." 
        mkdir -p "${CUSTOME_OTHER_ENV_DIR}" 
    fi 

    # create tmp folder for download files 
    if [ ! -f "${TMP_DIR}" ]; then 
        echo "create a tmp folder for env builder ......" 

        mkdir -p "${TMP_DIR}" 
    fi 
    
    # ============================================================================

    echo "Copy Files ..." 
    # google repo config, jq(json query tool) and pandas vpn 
    # rsync -P cmdTools/* "${CUSTOME_BIN_DIR}" 
    # rsync -P shellScript/* "${CUSTOME_BIN_DIR}" 
    
    # create bash_aliases 
    if [ ! -f "${BASH_ALIASES_FILE}" ]; then 
        touch "${BASH_ALIASES_FILE}" 
    fi 

    # .bashrc 
    if [ ! -f "${BASHRC_FILE}" ]; then 
        touch "${BASHRC_FILE}" 
    fi 

    # .profile 
    if [ ! -f "${PROFILE_FILE}" ]; then 
        touch "${PROFILE_FILE}" 
    fi 

}

# git config 
git_config () {
    # https://git-scm.com/ for windows 

    git --version 
    if [ $? -eq 0 ]; then 
        echo "Git is Installed ~" 
    else 
        echo "Git is not installed ! installing..." 
        sudo apt install -y git 
    fi 

}

# vim config 
vim_config () { 
    
    if [ ! -d "~/.vim" ]; then 
        echo "~/.vim for vim editor configs, creating ..." 
        mkdir -p ~/.vim 
        mkdir -p ~/.vim/colors 
        mkdir -p ~/.vim/bundle  # not must 
    fi 

    # check vim is installed ? 
    vim --version 
    if [ $? -eq 0 ]; then 
        echo "Vim is Installed ~" 
    else 
        echo "Vim is not installed ! installing..." 
        sudo apt install -y vim 
        # or install neovim with command : sudo apt install -y neovim 
    fi 

    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 
    # mkdir ~/.vim/colors 
    rsync -P vim/molokai.vim ~/.vim/colors/ 
    rsync -P vim/.vimrc ~/.vimrc 

}

java_config () {
    # java basic configuration 
    java --version 
    if [ $? -eq 0 ]; then 
        echo "Java is Installed ~" 
    else 
        echo "Java is not installed ! installing..." 

        read -p "Please input Java version 8? 17? or other jdk version ?\n" jdk_version 
        jdk_version="${jdk_version:-17}" 
        sudo apt install -y "openjdk-${jdk_version}-jdk openjdk-${jdk_version}-source openjdk-${jdk_version}-doc" 
    fi 

}

ant_config () {
    # ant java build tool https://ant.apache.org/ 
    ant -version 
    if [ $? -eq 0 ]; then 
        echo "apache ant is installed !" 
    else 
        echo "can not found ant, downloading and into bin PATH..." 

        apache_ant_file="apache_ant_bin_1.10.12.tar.gz" 
        wget -O "${TMP_DIR}/${apache_ant_file}" https://dlcdn.apache.org//ant/binaries/apache-ant-1.10.12-bin.tar.gz 

        tar -xf "${TMP_DIR}/${apache_ant_file}" -C "${CUSTOME_BIN_DIR}" 

        # may be should config Path 
        # export PATH="${CUSTOME_BIN_DIR}/ant_bin_xxx/bin:${PATH}" 
        # issue : can not get the real folder name and director structure/tree 

    fi 

}

maven_config () {

    mvn --version 
    if [ $? -eq 0 ]; then 
        echo "maven dev env ok, skip..." 
    else 
        echo "mvn path not config, downloading and config PATH ..." 

        # maven compile tool install process 
        maven_bin_file="maven_385_bin.tar.gz" 

        wget -O "${TMP_DIR}/${maven_bin_file}" https://dlcdn.apache.org/maven/maven-3/3.8.5/binaries/apache-maven-3.8.5-bin.tar.gz 
        # untar to bin folder 
        tar -xf "${TMP_DIR}/${maven_bin_file}" -C "${CUSTOME_BIN_DIR}" 

        # maven bin -> PATH 
    fi 

}

gradle_config () {

    gradle --version 
    if [ $? -eq 0 ]; then 
        echo "gradle dev env OK, skip --" 
    else 

        echo "gradle env not found, will download gradle bin and put it in ${CUSTOME_BIN_DIR}, please config PATH ..." 

        # gradle configuration 
        gradle_version="7.4.2" 
        read -p "Please input Gradle version (default = 7.4.2) ?\n" gradle_version 
        gradle_version="${gradle_version:-7.4.2}"

        gradle_bin_file="gradle_742_bin.zip" 
        wget -O "${TMP_DIR}/${gradle_bin_file}" https://services.gradle.org/distributions/gradle-${gradle_version}-bin.zip 

        unzip "${TMP_DIR}/${gradle_bin_file}" -d "${CUSTOME_BIN_DIR}" 

        # gradle bin -> PATH 
    fi 

}

go_config () {

    go version 
    if [ $? -eq 0 ]; then 
        echo "we had go ! nothing to do --" 
    else 
        echo "go env not atached, will download go bin and config ~"

        # go program language env 
        golang_bin_file="golang_1.18_bin.tar.gz" 
        wget -O "${TMP_DIR}/${golang_bin_file}" https://golang.google.cn/dl/go1.18.linux-amd64.tar.gz 

        tar -xf "${TMP_DIR}/${golang_bin_file}" -C "${CUSTOME_BIN_DIR}" 
    fi 

}

kotlin_config () {
    # kotlin compile tools config 
    # kotlin github page => kotlin tools for commandline compile 
    kotlinc-native -version 
    if [ $? -eq 0 ]; then 
        echo "kotlin compiler in PATH, all right." 
    else 
        echo "kotlin compiler tools will put it in ${CUSTOME_BIN_DIR}, please check later..." 

        kotlin_compile_bin_file="kotlinc_bin_1.6.20.tar.gz" 
        wget -O "${TMP_DIR}/${kotlin_compile_bin_file}" https://github.com/JetBrains/kotlin/releases/download/v1.6.20/kotlin-native-linux-x86_64-1.6.20.tar.gz 

        tar -xf "${TMP_DIR}/${kotlin_compile_bin_file}" -C "${CUSTOME_BIN_DIR}" 

    fi 


}

kotlin_interactive_config () {
    # kotlin interactive tools config 
    echo "dont't install ki now, if need, get it from https://github.com/Kotlin/kotlin-interactive-shell ..." 
}

julia_config () {
    # julia, a new program language env, for  science 
    julia --version 
    if [ $? -eq 0 ]; then 
        echo "julia exist ! do nothing--" 
    else 
        echo "will download julia bin and get julia env..." 

        julia_bin_file="julia_bin_1.6.6.tar.gz" 
        wget -O "${TMP_DIR}/${julia_bin_file}" https://julialang-s3.julialang.org/bin/linux/x64/1.6/julia-1.6.6-linux-x86_64.tar.gz 

        tar -xf "${TMP_DIR}/${julia_bin_file}" -C "${CUSTOME_BIN_DIR}" 
    fi 



}

rust_config () {
    # https://www.rust-lang.org/  rust 
    # cargo -> rust pacage manager 

    rustc --version  # or cargo --version 
    if [ $? -eq 0 ]; then 
        echo "Rust is Installed ~" 
    else 
        echo "Rust is not installed ! installing..." 

        # should in home folder !!!!!!!!!!!!!!!!!!!
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
    fi 

    # check rustc  and more usage tutorials 
    # https://www.rust-lang.org/learn/get-started 

}

lua_config () {
    # lua program env 

    lua -v 
    if [ $? -eq 0 ]; then 
        echo "found lua installed ! " 
    else 
        echo "download lua and config PATH ..." 

        lua_bin_file="lua_bin_5.4.4.tar.gz" 
        wget -O "${TMP_DIR}/${lua_bin_file}" http://www.lua.org/ftp/lua-5.4.4.tar.gz 
        
        tar -xf "${TMP_DIR}/${lua_bin_file}" -C "${CUSTOME_BIN_DIR}" 

        # need config PATH 
    fi 

}

nodejs_config () {
    # nodejs 
    node --version 
    if [ $? -eq 0 ]; then 
        echo "nodejs hadget echo : $?" 
    else 
        echo "nodejs shold download and config PATH, nodejs used for js server ~~~" 

        node_bin_file="node_bin_16.14.2.tar.xz" 
        wget -O "${TMP_DIR}/${node_bin_file}" https://nodejs.org/dist/v16.14.2/node-v16.14.2-linux-x64.tar.xz 

        tar -xf "${TMP_DIR}/${node_bin_file}" -C "${CUSTOME_BIN_DIR}" 
    fi 

}

mysql_config () {
    # mysql database config 
    mysql --version 
    if [ $? -eq 0 ]; then 
        echo "mysql is installed !"
    else 

        # mysql or mariadb ? https://mariadb.org/ 
        read -p "are u really want install mysql ? y/n\n" is_want_mysql 
        is_want_mysql="${is_want_mysql:-n}" # default no 
        echo "recheck input, is want have mysql ? ${is_want_mysql}" 

        if [ "${is_want_mysql}" == "y" ]; then 
            echo "mysql canbe installed, installing..." 
            sudo apt install -y mysql-server 
        else 
            echo "mysql skiped, install later/manually......" 
            echo "maybe mariadb is better choise ? !" 
        fi 

    fi 
    
}

postgresql_config () {
    # postgresql database install and config 
    psql --version 
    if [ $? -eq 0 ]; then 
        echo "postgresql had installed" 
    else 
        echo "posgresql not found, install postgresql..." 
        sudo apt install postgresql postgresql-contrib 
    fi 

}

redis_config () {
    # redis config 
    
    # here install direct from package manager 
    # other way is installed from source : https://redis.io/docs/getting-started/installation/install-redis-from-source/ 
    redis-server --version 
    if [ $? -eq 0 ]; then 
        echo "redis server exist already !" 
    then 

        read -p "build from source or install directly (select source need u install manually~) ? y=source/n=directly\n" from_source 
        from_source="${from_source:-n}" # default no 
        echo "recheck input, is want have mysql ? ${from_source}" 

        if [ "${from_source}" == "y" ]; then 
            echo "please reference : https://redis.io/docs/getting-started/installation/install-redis-from-source/" 
            
            redis_source_file="redis_bin_stable.tar.gz" 
            whet -O "${TMP_DIR}/${redis_source_file}" https://download.redis.io/redis-stable.tar.gz 
            tar -xf "${TMP_DIR}/${redis_source_file}" -C "${CUSTOME_OTHER_ENV_DIR}" 
        else 
            echo "redis not found ! installing..." 
            sudo apt install redis 
        fi 

    fi 

}

activeMQ_config () {
    # message queue activeMQ install and config 
    echo "skip active Message Queue install process... \nor if u want, please download from [https://activemq.apache.org/] !" 
}

zookeeper_config () {
    # zookeeper basic config  https://zookeeper.apache.org/ 

    zookeeper_bin_file="zookeeper_bin_3.8.0.tar.gz" 
    wget -O "${TMP_DIR}/${zookeeper_bin_file}" https://dlcdn.apache.org/zookeeper/zookeeper-3.8.0/apache-zookeeper-3.8.0-bin.tar.gz 

    tar -xf "${TMP_DIR}/${zookeeper_bin_file}" -C "${CUSTOME_OTHER_ENV_DIR}" 

    # usage offical doc : https://zookeeper.apache.org/doc/current/index.html 
}

kafka_config () {
    # kafka config  https://kafka.apache.org/ 
    kafka_bin_file="kafka_bin_2.12_310.tgz" 
    wget -O "${TMP_DIR}/${kafka_bin_file}" https://dlcdn.apache.org/kafka/3.1.0/kafka_2.12-3.1.0.tgz 

    tar -xf "${TMP_DIR}/${kafka_bin_file}" -C "${CUSTOME_OTHER_ENV_DIR}" 

}

nginx_config () {
    # if necessary, install nginx by apt-get 
    echo "skiped nginx install procedure... not must" 
}

main () { 
    basic_tools_check 
    files_copy_and_check 

    git_config 
    vim_config 
    java_config 
    ant_config 
    maven_config 
    gradle_config 
    go_config 
    kotlin_config 
    kotlin_interactive_config 
    julia_config 
    lua_config 
    nodejs_config 
    mysql_config 
    postgresql_config 
    redis_config 
    activeMQ_config 
    zookeeper_config 
    kafka_config 
    nginx_config 
    
}


main 




