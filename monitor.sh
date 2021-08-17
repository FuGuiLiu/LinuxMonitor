# 非专业人士请勿修改以免造成配置失败
# Linux一键执行脚本 上传到服务器上 先给它权限然后再执行

# <<< 变量
# jdk路径
jdkPath=/usr/local/bin/java/jdk1.8.0_301

#JDK源码路径
javaFile="/usr/local/bin/java/jdk-8u301-linux-x64.tar.gz"

#服务器监控包路径
jarFile="/usr/local/bin/java/monitor/monitor.jar"

#判断 monitor 这个Java程序是否执行
COUNT=$(ps -ef|grep /usr/local/bin/java/monitor/monitor.jar | grep -v grep | wc -l)

# 命令类型
commandType=""

# 变量>>>


# check root 检查权限
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${plain} 必须使用root用户运行此脚本！\n" && exit 1

# check os 检查系统版本
if [[ -f /etc/redhat-release ]]; then
    release="centos"
    commandType=yum
    yum update -y
    yum install -y wget
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
    commandType=apt-get
    apt-get update -y
    apt-get install -y wget
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
    commandType=apt-get
    apt-get update -y
    apt-get install -y wget
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    commandType=yum
    yum update -y
    yum install -y wget
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
    commandType=apt-get
    apt-get update -y
    apt-get install -y wget
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
    commandType=apt-get
    apt-get update -y
    apt-get install -y wget
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
    commandType=yum
    yum update -y
    yum install -y wget
else
    echo -e "${red}未检测到系统版本，请联系脚本作者！${plain}\n" && exit 1
fi

# 当前系统版本
echo "当前系统版本:$release"


#判断文件是否存在
if [ ! -f "$javaFile" ]; then
	wget https://www.dropbox.com/s/tkgsj7k7yjidbw5/jdk-8u301-linux-x64.tar.gz -P /usr/local/bin/java
fi

# 判断解压命令是否存在
if command -v tar > /dev/null 2>&1; then
	$commandType update -y && $commandType install -y tar
	tar -zxvf /usr/local/bin/java/jdk-8u301-linux-x64.tar.gz -C /usr/local/bin/java
else
  # 解压文件
	tar -zxvf /usr/local/bin/java/jdk-8u301-linux-x64.tar.gz -C /usr/local/bin/java
fi

#刷新环境变量
source /etc/profile
# 配置jdk环境变量
java -version

if [ $? -eq 0 ]; then
  echo -e "${yellow}============================================================${plain}"
  echo -e "${green}JDK1.8安装成功${plain}"
  echo -e "${yellow}============================================================${plain}"
else
  echo "export JAVA_HOME=$jdkPath" >> /etc/profile
	echo "export JRE_HOME=\${JAVA_HOME}/jre" >> /etc/profile
	echo "export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib" >> /etc/profile
	echo "export PATH=\${JAVA_HOME}/bin:\$PATH" >> /etc/profile
fi

#刷新环境变量
source /etc/profile


if [ $COUNT -eq 0 ]; then
	read -p "请输入服务器端口号(1-65536):(默认为8080)" serverPort

echo $serverPort

if [ !  $serverPort ]; then  
echo "输入为空"
  serverPort=8080  
fi  

until
	[ $serverPort -gt 1 -a $serverPort -lt 65536 ]
do
	echo "无效的端口号输入,能不能好好输入"
	read -p "请输入服务器端口号(1-65536):(默认为8080)" serverPort
done

# 下载监控服务器

if [ ! -f "$jarFile" ];then
	      wget https://www.dropbox.com/s/cahkzd9k78embix/monitor.jar -P /usr/local/bin/java/monitor
fi

#如果有程序正在运行则提示并退出
        if [ ! -n $serverPort ]; then
        nohup java -jar /usr/local/bin/java/monitor/monitor.jar --server.port=1222 > /usr/local/bin/java/monitor/system.log 2>&1 &
else
        nohup java -jar /usr/local/bin/java/monitor/monitor.jar --server.port=$serverPort > /usr/local/bin/java/monitor/system.log 2>&1 &
fi

echo "服务器启动成功请访问  当前服务器IP地址加上端口号/server.html进行查询  例如 127.0.0.1:$serverPort/server.html"

else
        echo "java程序正在运行,请务开启多个程序"
fi