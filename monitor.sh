# 非专业人士请勿修改以免造成配置失败
# Linux一键执行脚本 上传到服务器上 先给它权限然后再执行

# <<< 变量
#颜色定义
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
cn='\033[0m'

# jdk路径
jdkPath=/usr/local/bin/java/jdk1.8.0_301

#JDK源码路径
javaFile="/usr/local/bin/java/jdk-8u301-linux-x64.tar.gz"

#服务器监控包路径
jarFile="/usr/local/bin/java/monitor/monitor.jar"

#判断 monitor 这个Java程序是否执行
count=$(ps -ef|grep /usr/local/bin/java/monitor/monitor.jar | grep -v grep | wc -l)

# 获取当前Java进程的PID
pid=$(ps -ef | grep -v 'grep' | grep $jarFile | awk '{print $2}')

# 命令类型
commandType=""

# 变量>>>

# check root 检查权限
[[ $EUID -ne 0 ]] && echo -e "${red}错误：${cn} 必须使用root用户运行此脚本！\n" && exit 1


# 选择安装和卸载
echo -e "${blue}安装或卸载监控程序${cn}"
echo -e "$blue----------------------------------------------$cn"
echo -e "$blue| 1.   monitor install      - 安装 监控程序  |$cn"
echo -e "$blue| 2.   monitor uninstall    - 卸载 监控程序  |$cn"
echo -e "$blue----------------------------------------------$cn"

#读取用户输入
read -p "请选择(1-2)" chooseNumber

until
	[ $chooseNumber -gt 0 -a $chooseNumber -lt 3 ]
do
	read -p -e "请选择(1-2)" chooseNumber
done

if [ $chooseNumber -eq 1 ]; then

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
    echo -e "${red}未检测到系统版本，请联系脚本作者！${cn}\n" && exit 1
fi

# 当前系统版本
echo -e "${blue}当前系统版本${cn}:$release"


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
  echo -e "${yellow}============================================================${cn}"
  echo -e "${green}JDK已安装成功${cn}"
  echo -e "${yellow}============================================================${cn}"
else
  echo "export JAVA_HOME=$jdkPath" >> /etc/profile
	echo "export JRE_HOME=\${JAVA_HOME}/jre" >> /etc/profile
	echo "export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib" >> /etc/profile
	echo "export PATH=\${JAVA_HOME}/bin:\$PATH" >> /etc/profile
fi

#刷新环境变量
source /etc/profile


if [ $count -eq 0 ]; then
	read -p "请输入服务器端口号(1-65536):(默认为8080)" serverPort

echo -e $serverPort

if [ !  $serverPort ]; then  
echo -e "${red}输入为空${cn}"
  serverPort=8080
fi  

until
	[ $serverPort -gt 1 -a $serverPort -lt 65536 ]
do
	echo -e "${red}无效的端口号输入,请重新输入${cn}"
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

echo -e "${blue}服务器启动成功请访问  当前服务器IP地址加上端口号/server.html进行查询  例如 127.0.0.1:$serverPort/server.html${cn}"

else
        echo -e "${red}java程序正在运行,请务开启多个程序${cn}"
fi

else
    source /etc/profile
    #检测jdk是否安装
    echo -e "${red}卸载中...${cn}"
    java -version
    if [ $? -eq 0 ]; then
      echo -e "${yellow}============================================================${cn}"
      echo -e "${green}检测到JDK已安装,准备卸载${cn}"
      echo -e "${yellow}============================================================${cn}"

      #移除所有的安装包
      rm -rf /usr/local/bin/java/

      #刷新环境变量
      source /etc/profile

      java -version
    if [ $? -eq 0 ]; then
        echo -e "${red}删除失败,请联系脚本作者${cn}"
        exit 1
      else
        echo -e "${blue}删除成功${cn}"

        ### 删除程序
        echo -e "${blue}当前监控服务进程PID为:$pid${cn}"
        kill -9 $pid
      fi
else
      echo -e "${yellow}============================================================${cn}"
      echo -e "${green}jdk未安装,无需进行安装${cn}"
      echo -e "${yellow}============================================================${cn}"
      exit 1
fi

fi