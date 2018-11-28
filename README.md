# WireGuard_1
手工安装可用在 debian和 Ubuntu  可以用在指定内核

# Debian安装步骤


  1.更换内核 可以用在多种协议   可支持装锐速加速器
  
  debian 8 下载3.16.0.4-deb内核
 ```bash
 下载
wget http://security-cdn.debian.org/pool/updates/main/l/linux/linux-image-3.16.0-4-amd64_3.16.43-2+deb8u5_amd64.deb

安装内核
dpkg -i linux-image-3.16.0-4*.deb

通用展示所有内核版本
dpkg -l|grep linux-image

debian 8 删除内核
apt-get -y remove linux-image-3.16.0-5-amd64

 @@@   注意有选择NO.   @@@

更新 grub 系统引导文件并重启系统。
update-grub
```

 ubuntu 更换内核  linux-image-4.4.0-47-generic
 
 ```bash
1：查看当前系统内核

dpkg -l|grep linux-image

2：查看可以更新的内核版本：

sudo apt-cache search linux-image

选者合适的内核

3：安装新内核

sudo apt-get install linux-image-4.4.0-47-generic linux-image-extra-4.4.0-47-generic

4：卸载不要的内核

sudo apt-get purge linux-image-4.4.0-31-generic linux-image-extra-4.4.0-31-generic

5：更新 grub引导

sudo update-grub

6：重启VPS

reboot

重启后直接安装即可。

 ```
Debian安装步骤

 安装内核

 首先，Debian 无论是哪个系统，默认往往都没有 linux-headers 内核，而安装使用 WireGuard 必须要这货，所以我们需要先安装：
 
 ```bash
 # 更新软件包源
apt update
# 安装和 linux-image 内核版本相对于的 linux-headers 内核
apt install linux-headers-$(uname -r) -y
 ```
 
 ```bash
# 以下为示例内容（仅供参考）
 
# Debian8 安装前内核列表(空)
root@doubi:~# dpkg -l|grep linux-headers
# 空，没有任何输出
 
# Debian8 安装后内核列表（注意这里的版本号 可能不一样）
root@doubi:~# dpkg -l|grep linux-headers
ii  linux-headers-3.16.0-6-amd64   3.16.57-2                          amd64        Header files for Linux 3.16.0-6-amd64
ii  linux-headers-3.16.0-6-common  3.16.57-2   
 
 
# Debian9 安装前内核列表(空)
root@doubi:~# dpkg -l|grep linux-headers
# 空，没有任何输出
 
# Debian9 安装后内核列表（注意这里的版本号 可能不一样）
root@doubi:~# dpkg -l|grep linux-headers
ii  linux-headers-4.9.0-7-amd64   4.9.110-3+deb9u2               amd64        Header files for Linux 4.9.0-7-amd64
ii  linux-headers-4.9.0-7-common  4.9.110-3+deb9u2               all          Common header files for Linux 4.9.0-7
 
# 以上为示例内容（仅供参考）
 ```
 安装WireGuard

 然后我们就可以开始安装 WireGuard 了。

  ```bash
  # 添加 unstable 软件包源，以确保安装版本是最新的
echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
echo -e 'Package: *\nPin: release a=unstable\nPin-Priority: 150' > /etc/apt/preferences.d/limit-unstable
 
# 更新一下软件包源
apt update
 
# 开始安装 WireGuard ，resolvconf 是用来指定DNS的，旧一些的系统可能没装。
apt install wireguard resolvconf -y
```
Ubuntu安装步骤
```bash
# 更新软件包源
apt update
# 安装和 linux-image 内核版本相对于的 linux-headers 内核
apt install linux-headers-$(uname -r) -y
apt install software-properties-common -y

```
 
```bash
安装完成后，我们还需要通过 PPA 工具添加 WireGuard 源：

add-apt-repository ppa:wireguard/wireguard
# 执行后提示如下示例内容（仅供参考）：
 
root@doubi:~# add-apt-repository ppa:wireguard/wireguard
 WireGuard is a novel VPN that runs inside the Linux Kernel. This is the Ubuntu packaging for WireGuard. More info may be found at its website, listed below.
 
More info: https://www.wireguard.com/
Packages: wireguard wireguard-tools wireguard-dkms
 
Install with: $ apt install wireguard
 
For help, please contact 
 More info: https://launchpad.net/~wireguard/+archive/ubuntu/wireguard
Press [ENTER] to continue or ctrl-c to cancel adding it
 
# 这里会提示你是否继续，点击 回车键 继续，点击 Ctrl+C 键退出。
# 然后输出大概如下内容。
 
gpg: keyring '/tmp/tmp8bgitjjx/secring.gpg' created
gpg: keyring '/tmp/tmp8bgitjjx/pubring.gpg' created
gpg: requesting key 504A1A25 from hkp server keyserver.ubuntu.com
gpg: /tmp/tmp8bgitjjx/trustdb.gpg: trustdb created
gpg: key 504A1A25: public key "Launchpad PPA for wireguard-ppa" imported
gpg: Total number processed: 1
gpg:               imported: 1  (RSA: 1)
OK
 
# 以上为输出示例内容（仅供参考）
 ```
 安装WireGuard
 ```bash
  
然后我们就可以开始安装 WireGuard 了。

# 更新一下软件包源
apt update
 
# 开始安装 WireGuard ，resolvconf 是用来指定DNS的，旧一些的系统可能没装。
apt install wireguard resolvconf -y
  
   ```
   
   验证是否安装成功
```bash
     当你通过上面的步骤安装完后，请用下面的代码验证一下是否安装成功。

lsmod | grep wireguard
# 执行该代码后，提示大概如下示例内容（仅供参考），第一行是必须要有的，至于下面的两行不同系统似乎还不一样，但是不影响使用。
 
root@doubi:~# modprobe wireguard && lsmod | grep wireguard
wireguard             212992  0
ip6_udp_tunnel         16384  1 wireguard
udp_tunnel             16384  1 wireguard
```
  
  配置步骤
```bash
  生成密匙对

当你确定安装成功后，就要开始配置服务端和客户端的配置文件了。放心，这很简单。

# 首先进入配置文件目录，如果该目录不存在请先手动创建：mkdir /etc/wireguard
cd /etc/wireguard
 
# 然后开始生成 密匙对(公匙+私匙)。
wg genkey | tee sprivatekey | wg pubkey > spublickey
wg genkey | tee cprivatekey | wg pubkey > cpublickey
```
查看主网卡名称

```bash
先查看一下你的主网卡名是什么：

ip addr
# 执行命令后，示例如下（仅供参考），lo 是本地环回 忽略，eth0 就是主网卡名了。
# 写着你的服务器外网IP的(下面 X.X.X.X 处)，就是你的主网卡，NAT的服务器则是显示内网IP。
# 如果你拿不准哪个网卡是主网卡，请留言询问。
 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:16:3c:cf:89:73 brd ff:ff:ff:ff:ff:ff
    inet X.X.X.X/25 brd 255.255.255.255 scope global eth0
       valid_lft forever preferred_lft forever
```


生成服务端配置文件


```bash
接下来就开始生成服务端配置文件：

# 井号开头的是注释说明，用该命令执行后会自动过滤注释文字。
# 下面加粗的这一大段都是一个代码！请把下面几行全部复制，然后粘贴到 SSH软件中执行，不要一行一行执行！
 
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
ListenPort = 6700
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
 
# 上面加粗的这一大段都是一个代码！请把下面几行全部复制，然后粘贴到 SSH软件中执行，不要一行一行执行！
```

生成客户端配置文件


```bash
接下来就开始生成客户端配置文件：

# 井号开头的是注释说明，用该命令执行后会自动过滤注释文字。
# 下面加粗的这一大段都是一个代码！请把下面几行全部复制，然后粘贴到 SSH软件中执行，不要一行一行执行！
 
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
Endpoint = X.X.X.X:443
# 因为是客户端，所以这个设置为全部IP段即可
AllowedIPs = 0.0.0.0/0, ::0/0
# 保持连接，如果客户端或服务端是 NAT 网络(比如国内大多数家庭宽带没有公网IP，都是NAT)，那么就需要添加这个参数定时链接服务端(单位：秒)，如果你的服务器和你本地都不是 NAT 网络，那么建议不使用该参数（设置为0，或客户端配置文件中删除这行）
PersistentKeepalive = 25"|sed '/^#/d;/^\s*$/d' > client.conf
 
# 上面加粗的这一大段都是一个代码！请把下面几行全部复制，然后粘贴到 SSH软件中执行，不要一行一行执行！
```
 接下来你就可以将这个客户端配置文件 [/etc/wireguard/client.conf] 通过SFTP、HTTP等方式下载到本地了。

 不过我更推荐，SSH中打开显示配置文件内容并复制出来后，本地设备新建一个文本文件 [xxx.conf] (名称随意，后缀名需要是 .conf) 并写入其中，提供给 WireGuard 客户端读取使用。

```bash
cat /etc/wireguard/client.conf
```
其他剩余其他操作：

```bash
# 赋予配置文件夹权限
chmod 777 -R /etc/wireguard
 
# 打开防火墙转发功能
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
sysctl -p
```
启动WireGuard

```bash
wg-quick up wg0
# 执行命令后，输出示例如下（仅供参考）
 
[#] ip link add wg0 type wireguard
[#] wg setconf wg0 /dev/fd/63
[#] ip address add 10.0.0.1/24 dev wg0
[#] ip link set mtu 1420 dev wg0
[#] ip link set wg0 up
[#] resolvconf -a tun.wg0 -m 0 -x
[#] iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
 
# 如果此处没有报错：RTNETLINK answers: Operation not supported，且输入内容差不多，那么说明启动成功了！
```

停止WireGuard

```bash
wg-quick down wg0
```

查询WireGuard状态

```bash
wg
```

开机启动

```bash
注意：Ubuntu 14.04 系统默认是没有 systemctl 的，所以无法配置开机启动。
# 设置开机启动
systemctl enable wg-quick@wg0
# 取消开机启动
systemctl disable wg-quick@wg0
```


# WireGuard —— 多用户配置教程

服务端配置文件添加用户

以下步骤是动态添加客户端配置（以下配置前提是你已经配置过 WireGuard 配置文件并启动了）。

你也可以手动修改配置文件 [/etc/wireguard/wg0.conf]，记得修改完重启一下。以下动态添加无需重启。

```bash
# 重新生成一对客户端密匙
# cprivatekey1 为客户端私匙，cpublickey1 为客户端公匙
 
wg genkey | tee cprivatekey1 | wg pubkey > cpublickey1
# 服务器上执行添加客户端配置代码(新增一个 [peer])：
# $(cat cpublickey1) 这个是客户端公匙，10.0.0.3/32 这个是客户端内网IP地址，按序递增最后一位(.3)，不要重复
 
wg set wg0 peer $(cat cpublickey1) allowed-ips 10.0.0.3/32
```
然后查看 WireGuard 状态：

```bash
wg
 
# 执行命令后输出内容如下（仅供参考，下面的不是让你执行的命令）：
interface: wg0
  public key: xxxxxxxxxxxxxxxxx #服务端私匙
  private key: (hidden)
  listening port: 443
 
peer: xxxxxxxxxxxxxxxxxxxx #旧客户端账号的公匙
  allowed ips: 10.0.0.2/32 #旧客户端账号的内网IP地址
 
peer: xxxxxxxxxxxxxxxxxxxx #新客户端账号的公匙
  allowed ips: 10.0.0.3/32 #新客户端账号的内网IP地址
# 以上内容仅为输出示例（仅供参考）
```
如果显示正常，那么我们就保存到配置文件：

```bash
wg-quick save wg0

然后我们就要开始生成对应的客户端配置文件了。
```
生成对应客户端配置文件

新客户端配置文件，和其他客户端账号的配置文件只有 [Interface] 中的客户端私匙、内网IP地址参数不一样。

```bash
# 井号开头的是注释说明，用该命令执行后会自动过滤注释文字。
# 下面加粗的这一大段都是一个代码！请把下面几行全部复制，然后粘贴到 SSH软件中执行，不要一行一行执行！
 
echo "[Interface]
# 客户端的私匙，对应服务器配置中的客户端公匙（自动读取上面刚刚生成的密匙内容）
PrivateKey = $(cat cprivatekey1)
# 客户端的内网IP地址（如果上面你添加的内网IP不是 .3 请自行修改）
Address = 10.0.0.3/24
# 解析域名用的DNS
DNS = 8.8.8.8
# 保持默认
MTU = 1420
[Peer]
# 服务器的公匙，对应服务器的私匙（自动读取上面刚刚生成的密匙内容）
PublicKey = $(cat spublickey)
# 服务器地址和端口，下面的 X.X.X.X 记得更换为你的服务器公网IP，端口请填写服务端配置时的监听端口
Endpoint = X.X.X.X:6700
# 因为是客户端，所以这个设置为全部IP段即可
AllowedIPs = 0.0.0.0/0, ::0/0
# 保持连接，如果客户端或服务端是 NAT 网络(比如国内大多数家庭宽带没有公网IP，都是NAT)，那么就需要添加这个参数定时链接服务端(单位：秒)，如果你的服务器和你本地都不是 NAT 网络，那么建议不使用该参数（设置为0，或客户端配置文件中删除这行）
PersistentKeepalive = 25"|sed '/^#/d;/^\s*$/d' > client1.conf
 
# 上面加粗的这一大段都是一个代码！请把下面几行全部复制，然后粘贴到 SSH软件中执行，不要一行一行执行！
```
接下来你就可以将这个客户端配置文件 [/etc/wireguard/client.conf] 通过SFTP、HTTP等方式下载到本地了。

不过我更推荐，SSH中打开显示配置文件内容并复制出来后，本地设备新建一个文本文件 [xxx.conf] (名称随意，后缀名需要是 .conf) 并写入其中，提供给 WireGuard 客户端读取使用。
```bash

cat /etc/wireguard/client.conf
```

保存WireGuard

```bash
wg-quick save wg0
```

重启WireGuard

```bash
wg-quick down wg0

wg-quick up wg0
```




```
服务端配置文件删除用户

```bash
wg set wg0 peer $(cat cpublickey1) remove
# 如果客户端公匙文件还在，那么可以执行这个命令删除。
# 注意：该命令执行后，就可以跳过下面这段命令了，直接保存配置文件即可。
 
——————————————
 
# 如果客户端公匙文件已删除，那么可以通过 wg 命令看到客户端的公匙：
wg
 
# 执行命令后输出内容如下（仅供参考，下面的不是让你执行的命令）：
interface: wg0
  public key: xxxxxxxxxxxxxxxxx #服务端私匙
  private key: (hidden)
  listening port: 443
 
peer: xxxxxxxxxxxxxxxxxxxx #客户端账号的公匙
  allowed ips: 10.0.0.2/32 #客户端账号的内网IP地址
 
peer: xxxxxxxxxxxxxxxxxxxx #客户端账号的公匙
  allowed ips: 10.0.0.3/32 #客户端账号的内网IP地址
# 以上内容仅为输出示例（仅供参考）
 
# 复制你要删除的客户端账号的公匙(peer 后面的字符)，替换下面命令中的 xxxxxxx 并执行即可
wg set wg0 peer xxxxxxx remove
# 执行后，我们在用 wg 命令查看一下是否删除成功。
如果删除成功，那么我们就保存到配置文件：

wg-quick save wg0
完啦~
```
