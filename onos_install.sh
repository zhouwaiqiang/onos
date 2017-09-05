#!/bin/bash
function install_backup {
    echo "this will backup the sourcelist"
    #sudo mv /etc/apt/sources.list /etc/apt/sources.listbak
    #sudo cp sources.list /etc/apt
    echo "update the sources"
    sudo apt-get update
    sudo apt-get install git -y
    sudo apt-get install curl -y
    sudo apt-get install zip -y
    echo "the code is $?"
}

function install_mk {
    echo "start to install maven and karaf"
    echo "The path is:$cur_path"
    cd $cur_path
    file_name1="Downloads"
    file_name2="Applications"
    if [ -e $file_name1 ]
    then
	echo "Downloads dir is exists"
    else
	mkdir $file_name1
	echo "create Downloads directory"
    fi
    if [ -e $file_name2 ]
    then
	echo "Applications dir is exists"
    else
	mkdir $file_name2
	echo "create Applicationss directory"
    fi
    cd $file_name1
    echo "The path is:$(pwd)"
    file_name3="apache-karaf-3.0.5.tar.gz"
    file_name4="apache-maven-3.3.9-bin.tar.gz"
    if [ -e $file_name3 ]
    then
	echo "File apache is existed"
    else
	echo "Now we will begin to download karaf"
        #wget "http://archive.apache.org/dist/karaf/3.0.5/apache-karaf-3.0.5.tar.gz"
    fi
    if [ -e $file_name4 ]
    then
	echo "File maven is existed"
    else
	echo "Now we begin to download the maven"
        wget "http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz"
    fi
    cd $cur_path/Downloads
    #tar -zxvf apache-karaf-3.0.5.tar.gz -C $cur_path/Applications/
    tar -zxvf apache-maven-3.3.9-bin.tar.gz -C $cur_path/Applications/
    
}

function install_java {
    cd $cur_path
    echo "The path is:$(pwd)"
    sudo apt-get install software-properties-common -y
    if [ $? -eq 0 ]
    then
	echo "Success"
    else
	echo "failed"
	exit 0
    fi
    sudo add-apt-repository ppa:webupd8team/java -y
    if [ $? -eq 0 ]
    then
	echo "Success"
    else
	echo "failed"
	exit 0
    fi
    sudo apt-get update
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
    if [ $? -eq 0 ]
    then
	echo "Success"
    else
	echo "failed"
	exit 0
    fi
    sudo apt-get install oracle-java8-installer oracle-java8-set-default -y
    if [ $? -eq 0 ]
    then
	echo "Success"
    fi
}

function download_onos {
    cd $cur_path
    echo "The path is:$(pwd)"
    file_name5="onos"
    if [ -e $file_name5 ]
    then
	echo "onos flie exists"
    else
        #需要翻墙下载
        git clone https://gerrit.onosproject.org/onos -b onos-1.10
        #git clone -b onos-1.8 'https://github.com/opennetworkinglab/onos.git' 
        if [ $? -eq 0 ]
        then
            echo "Success"
        else
            echo "failed"
            exit 0
        fi
    fi
}

#添加onos环境变量
function configure_setting {
    cd $cur_path
    export ONOS_ROOT=~/onos
    source $ONOS_ROOT/tools/dev/bash_profile
}

#设置编译前追加版本号到apache.karaf.features.cfg中
function set_env {
    cd $cur_path
    file_name7="$cur_path/Applications/apache-karaf-3.0.5/etc/org.apache.karaf.features.cfg"
    if [ -e $file_name7 ]
    then
	sed -i '/^featuresRepositories/s/$/,mvn:org.onosproject\/onos-features\/1.8.10-SNAPSHOT\/xml\/features/' $file_name7 
	echo "features add successfully"
    else
	echo "org.apache.karaf.features.cfg is not existed"
    fi
}

function install_onos {
    cd $cur_path/onos
    echo "*************************"
    echo "now begin to install onos"
    echo "*************************"
    tools/build/onos-buck build onos --show-output
    if [ $? -eq 0 ]
    then
	echo "ONOS created success,now you can start your onos"
    else
	echo "build failure"
#	exit 0
    fi
}

function start_onos {
	#首先souce环境变量ONOS_ROOT
	#再cd到onos目录下
	#这样就可以直接在本机上运行ONOS
	tools/build/onos-buck run onos-local -- clean debug
	#如果要使用CLI控制台，则用如下命令打开
	tools/test/bin/onos localhost
	#进入控制台，需要激活openflow和fwd实现基本的二层通信
	#app activate org.onosproject.openflow
	#app activate org.onosproject.fwd
}

cur_path=$(pwd)
cd $cur_path
#install_backup
install_mk
#install_java
#download_onos
#configure_setting
#set_env
#install_onos
