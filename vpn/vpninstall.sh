#!/bin/bash

pptpserver='xxx'
user='xxx'
pass='xxx'
vpn_name='xxx'

source /etc/profile

function logfun()
{
        timenow=`date +"%Y-%m-%d %H-%M-%S"`
        echo "$timenow  -------- $1" >> /tmp/vpnhistory.log
}

#检测是否存在ppp0
function checkpppno()
{
        num=`/sbin/ifconfig|grep ppp[0-9]|awk '{print $1}'`
        if [ -n "$num" ];then
                logfun "已经有vpn连接，请先断开重拨"
                exit 11
        fi
}

function checkpppyes()
{
        echo "请稍等，正在拨号...."
        sleep 30
        interface=`/sbin/ifconfig |grep ppp[0-9]|awk '{print $1}'`
        if [ -n "$interface" ];then
                route add -net 139.162.0.0/16 dev $interface
                route add -net 52.74.0.0/16 dev $interface
                route add -net 45.79.0.0/16 dev $interface
                route add -net 103.56.159.0/24 dev $interface
                route add -net 123.31.11.0/24 dev $interface
                route add -net 45.33.31.0/24 dev $interface
                logfun "启动成功，添加路由成功"
        else
                logfun "添加路由失败，ppp接口没启动"
        fi
}

function install()
{
        yum -y install ppp pptp pptp-setup

        #ppp开关指令
        ln -s /usr/share/doc/ppp-2.4.5/scripts/poff /usr/bin 2> /dev/null
        ln -s /usr/share/doc/ppp-2.4.5/scripts/pon /usr/bin 2> /dev/null
        chmod 700 /usr/share/doc/ppp-2.4.5/scripts/pon
        chmod 700 /usr/share/doc/ppp-2.4.5/scripts/poff
        rm -f /etc/ppp/chap-secrets 2> /dev/null

        ipt=`cat /etc/sysconfig/iptables|grep -w gre 2> /dev/null`
        if [ -n "$ipt" ];then
                echo "" > /dev/null
        else
                iptables -I RH-Firewall-1-INPUT -p gre -j ACCEPT
                service iptables save
                service iptables restart
         fi

         #生成拨号文件，pon name  进行拨号
         /usr/sbin/pptpsetup --create $vpn_name --server $pptpserver --username  $user  --password  $pass --encrypt
         checkpppno
         /usr/bin/pon $vpn_name
         sleep 5
         interface=`/sbin/ifconfig |grep ppp[0-9]|awk '{print $1}'`
        if [ -n "$interface" ];then
                route add -net 139.162.0.0/16 dev $interface
                route add -net 52.74.0.0/16 dev $interface
                route add -net 45.79.0.0/16 dev $interface
                route add -net 103.56.159.0/24 dev $interface
                route add -net 123.31.11.0/24 dev $interface
                route add -net 45.33.31.0/24 dev $interface
                logfun "启动成功，添加路由成功"
        else
                logfun "添加路由失败，ppp接口没启动"
        fi
         
}

function restartvpn()
{
        killall pppd 2>/dev/null
        /usr/bin/pon $dailname
        checkpppyes

}

function startvpn()
{
        checkpppno
        logfun "1111111"
        for((i=1;i<=2;i++))
        do
                /usr/bin/pon $vpn_name
                echo "请稍等，正在拨号...."
                sleep 15
                interface=`/sbin/ifconfig |grep ppp[0-9]|awk '{print $1}'`
                if [ -n "$interface" ];then
                        route add -net 139.162.0.0/16 dev $interface
                        route add -net 52.74.0.0/16 dev $interface
                        route add -net 45.79.0.0/16 dev $interface
                        route add -net 103.56.159.0/24 dev $interface
                        route add -net 123.31.11.0/24 dev $interface
                        logfun "启动成功，添加路由成功"
                        echo "启动成功，添加路由成功"
                        break
                else
                        logfun "添加路由失败，ppp接口没启动"
                        echo "添加路由失败，ppp接口没启动"
                fi
        done

}

case $1 in 
"install")
        install
;;
"restart")
        restartvpn
;;
"start")
        startvpn
;;
*)
echo "参数错误  install|restart"
exit 11
;;
esac
