# onos
1. 这个是为了目前使用BUCK安装onos使用的脚本，脚本中使用的是下载ONOS1.10版本
2. onos1.8和1.7在导入artificates会出错，目测是因为采用maven构建和buck构建的交接点，有的文件不完善导致的，因为那个导入脚本和1.8以后的脚本内容完全不一样
3. source_onos.sh是添加onos的环境变量的，需要在每次执行前source该文件，或者将文件内容写到.profile,或者/etc/profile，就可以在linux中自动添加改变量无需做任何更改，需要注意onos文件夹的路径
4. 关于安装脚本有如下几个函数install_backup(安装一些基本的软件，设置ubuntu源列表),install_mk(安装maven和karaf使用，buck中如果使用maven开发需要安装maven不需要karaf)，install_java(安装java配置环境)，download_onos(下载onos源码),configure_setting(添加onos所需要的环境变量),set_env(之前采用maven安装时所需要的追加文件内容，在该安装过程中不需要),install_onos(onos利用buck进行安装),start_onos(安装完成后可以执行开启onos)
5. 注：安装时可以将最后的#挨个移除依次安装，也可以取消注解一次安装，只需要install_backup,install_java,download_onos,configure_setting,install_onos这几个函数即可，install_mk需要去除karaf下载安装maven就好，onos的版本号可以download_onos中修改对应的版本号（不要采用1.7和1.8，在后面使用onos_publish_local脚本会报错，无法实现开发）
