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
