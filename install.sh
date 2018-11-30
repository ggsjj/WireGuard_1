#!/bin/bash


#debian8更新内核
update_debian8_kernel(){
#下载内核
wget http://security-cdn.debian.org/pool/updates/main/l/linux/linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb
#安装内核
dpkg -i linux-image-3.16.0-4*.deb
#debian 8 删除内核
del=$(uname -r)
apt-get -y remove linux-image-$del
#更新 grub 系统引导文件并重启系统。
update-grub
rm -rf linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb
     read -p "需要重启VPS，再次执行脚本选择安装wireguard，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then
		echo "${Info} VPS 重启中..."
		reboot
	fi

}

#debian8安装wireguard
wireguard_debian8_install(){
echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
echo -e 'Package: *\nPin: release a=unstable\nPin-Priority: 150' > /etc/apt/preferences.d/limit-unstable
apt update
apt install linux-headers-$(uname -r) -y
apt install wireguard resolvconf -y
add-apt-repository ppa:wireguard/wireguard
rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))  
}
port=$(rand 1000 60000)
apt-get update -y && apt-get install curl -y
serverip=$(curl icanhazip.com)
mkdir /etc/wireguard
cd /etc/wireguard
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey | wg pubkey > cpublickey
port=$(rand 10000 60000)
echo "[Interface]
# 服务器的私匙，对应客户端配置中的公匙（自动读取上面刚刚生成的密匙内容）
PrivateKey = $(cat sprivatekey)
# 本机的内网IP地址，一般默认即可，除非和你服务器或客户端设备本地网段冲突
Address = 10.0.0.1/24 
# 运行 WireGuard 时要执行的 iptables 防火墙规则，用于打开NAT转发之类的。
# 如果你的服务器主网卡名称不是 eth0 ，那么请修改下面防火墙规则中最后的 eth0 为你的主网卡名称。
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# 停止 WireGuard 时要执行的 iptables 防火墙规则，用于关闭NAT转发之类的。
# 如果你的服务器主网卡名称不是 eth0 ，那么请修改下面防火墙规则中最后的 eth0 为你的主网卡名称。
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
# 服务端监听端口，可以自行修改
ListenPort = $port
# 服务端请求域名解析 DNS
DNS = 8.8.8.8
# 保持默认
MTU = 1420
# [Peer] 代表客户端配置，每增加一段 [Peer] 就是增加一个客户端账号，具体我稍后会写多用户教程。
[Peer]
# 该客户端账号的公匙，对应客户端配置中的私匙（自动读取上面刚刚生成的密匙内容）
PublicKey = $(cat cpublickey)
# 该客户端账号的内网IP地址
AllowedIPs = 10.0.0.2/32"|sed '/^#/d;/^\s*$/d' > wg0.conf
wg
echo "[Interface]
# 客户端的私匙，对应服务器配置中的客户端公匙（自动读取上面刚刚生成的密匙内容）
PrivateKey = $(cat cprivatekey)
# 客户端的内网IP地址
Address = 10.0.0.2/24
# 解析域名用的DNS
DNS = 8.8.8.8
# 保持默认
MTU = 1420
[Peer]
# 服务器的公匙，对应服务器的私匙（自动读取上面刚刚生成的密匙内容）
PublicKey = $(cat spublickey)
# 服务器地址和端口，下面的 X.X.X.X 记得更换为你的服务器公网IP，端口请填写服务端配置时的监听端口
Endpoint = $serverip:$port
# 因为是客户端，所以这个设置为全部IP段即可
AllowedIPs = 0.0.0.0/0, ::0/0
# 保持连接，如果客户端或服务端是 NAT 网络(比如国内大多数家庭宽带没有公网IP，都是NAT)，那么就需要添加这个参数定时链接服务端(单位：秒)，如果你的服务器和你本地都不是 NAT 网络，那么建议不使用该参数（设置为0，或客户端配置文件中删除这行）
PersistentKeepalive = 25"|sed '/^#/d;/^\s*$/d' > client.conf
 chmod 777 -R /etc/wireguard
 
# 打开防火墙转发功能
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
wg-quick up wg0
systemctl enable wg-quick@wg0
}

wireguard_ubuntu_kernel(){
del=$(uname -r)
sudo apt-get install linux-image-4.4.0-47-generic linux-image-extra-4.4.0-47-generic
sudo apt-get purge $del -y
sudo update-grub
# 更换网卡eth0
sed  -i 's/consoleblank=0/net.ifnames=0 biosdevname=0/g'  /etc/default/grub
sed  -i 's/ens3/eth0/g'  /etc/network/interfaces
sudo grub-mkconfig -o /boot/grub/grub.cfg

     read -p "需要重启VPS，再次执行脚本选择安装wireguard，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [ "$yn" = "y" ] || [ "$yn" = "Y" ]; then
		echo "${Info} VPS 重启中..."
		reboot
	fi

}

wireguard_ubuntu_install(){
apt update
apt install linux-headers-$(uname -r) -y
apt install software-properties-common -y
echo .read | add-apt-repository ppa:wireguard/wireguard
apt update
apt install wireguard resolvconf -y

rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))  
}
port=$(rand 1000 60000)
apt-get update -y && apt-get install curl -y
serverip=$(curl icanhazip.com)
mkdir /etc/wireguard
cd /etc/wireguard
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey | wg pubkey > cpublickey
port=$(rand 10000 60000)
echo "[Interface]
# 服务器的私匙，对应客户端配置中的公匙（自动读取上面刚刚生成的密匙内容）
PrivateKey = $(cat sprivatekey)
# 本机的内网IP地址，一般默认即可，除非和你服务器或客户端设备本地网段冲突
Address = 10.0.0.1/24 
# 运行 WireGuard 时要执行的 iptables 防火墙规则，用于打开NAT转发之类的。
# 如果你的服务器主网卡名称不是 eth0 ，那么请修改下面防火墙规则中最后的 eth0 为你的主网卡名称。
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# 停止 WireGuard 时要执行的 iptables 防火墙规则，用于关闭NAT转发之类的。
# 如果你的服务器主网卡名称不是 eth0 ，那么请修改下面防火墙规则中最后的 eth0 为你的主网卡名称。
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
# 服务端监听端口，可以自行修改
ListenPort = $port
# 服务端请求域名解析 DNS
DNS = 8.8.8.8
# 保持默认
MTU = 1420
# [Peer] 代表客户端配置，每增加一段 [Peer] 就是增加一个客户端账号，具体我稍后会写多用户教程。
[Peer]
# 该客户端账号的公匙，对应客户端配置中的私匙（自动读取上面刚刚生成的密匙内容）
PublicKey = $(cat cpublickey)
# 该客户端账号的内网IP地址
AllowedIPs = 10.0.0.2/32"|sed '/^#/d;/^\s*$/d' > wg0.conf
wg
echo "[Interface]
# 客户端的私匙，对应服务器配置中的客户端公匙（自动读取上面刚刚生成的密匙内容）
PrivateKey = $(cat cprivatekey)
# 客户端的内网IP地址
Address = 10.0.0.2/24
# 解析域名用的DNS
DNS = 8.8.8.8
# 保持默认
MTU = 1420
[Peer]
# 服务器的公匙，对应服务器的私匙（自动读取上面刚刚生成的密匙内容）
PublicKey = $(cat spublickey)
# 服务器地址和端口，下面的 X.X.X.X 记得更换为你的服务器公网IP，端口请填写服务端配置时的监听端口
Endpoint = $serverip:$port
# 因为是客户端，所以这个设置为全部IP段即可
AllowedIPs = 0.0.0.0/0, ::0/0
# 保持连接，如果客户端或服务端是 NAT 网络(比如国内大多数家庭宽带没有公网IP，都是NAT)，那么就需要添加这个参数定时链接服务端(单位：秒)，如果你的服务器和你本地都不是 NAT 网络，那么建议不使用该参数（设置为0，或客户端配置文件中删除这行）
PersistentKeepalive = 25"|sed '/^#/d;/^\s*$/d' > client.conf
 chmod 777 -R /etc/wireguard
 
# 打开防火墙转发功能
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
wg-quick up wg0
systemctl enable wg-quick@wg0
}

wireguard_unane(){
uname -r
echo " debian8 内核为linux-image-3.16.0-4 可以安装兼容安装锐速，如何不是多次更新内核"
echo " ubuntu16 内核为4.4.0-47-generic 可以安装兼容安装锐速，如何不是多次更新内核"
}

#开始菜单
start_menu(){
    clear
    echo "================================="
    echo " 介绍：适用于debian8和ubuntu16"
    echo " debian8 内核为linux-image-3.16.0-4 可以安装兼容安装锐速，如何不是多次更新内核"
    echo " ubuntu16 内核为4.4.0-47-generic 可以安装兼容安装锐速，如何不是多次更新内核"
    echo "只为可以多装协议 又可以装LotServer "
    echo "================================="
    echo "==当前内核,如不对应请再更新内核===="
	uname -r
    echo "================================="
    echo "1. debian8更新内核"
    echo "2. debian8安装wireguard"
    echo "3. ubuntu16更新内核"
    echo "4. ubuntu16安装wireguard"
    echo "5. 查看内核是不是支持安装锐速"
    echo "6. 退出脚本"
    echo
    read -p "请输入数字:" num
    case "$num" in
	1)
	update_debian8_kernel
	;;
	2)
	wireguard_debian8_install
	;;
	3)
	wireguard_ubuntu_kernel
	;;
	4)
	wireguard_ubuntu_install
	;;
	5)
	wireguard_unane
	;;
	6)
	exit 1
	;;
	*)
	clear
	echo "请输入正确数字"
	sleep 5s
	start_menu
	;;
    esac
}

start_menu
