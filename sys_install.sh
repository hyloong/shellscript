##
echo "xxxxxx" |passwd root --stdin

# change dns
START_DATETIME=`date +"%Y-%m-%d %H:%M:%S"`
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

#rsync source
echo "xxxxxx" > /etc/rsync.pass
chmod 600 /etc/rsync.pass

## sys update
yum clean all

yum -y install lrzsz subversion screen *openssl* *curses* gcc gcc44* gcc-c++ gcc-g77 \
    flex bison autoconf automake libjpeg libjpeg-devel libpng libpng-devel make \
    freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel \
    bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel pam-devel \
    libXpm libXpm-devel  fontconfig fontconfig-devel mysql-devel sysstat screen wget cmake telnet ksh expect

yum -y install glib2 glib2-devel

yum update


## 快捷键
cat > /root/.bashrc <<EOF

alias vi='vim'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -lh'

if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
export LANG=en_US.UTF-8
export PS1='[\u@${SERVER_ID} \W]\\$ '
EOF

## 时间设置
yum -y install ntp
rm -f /etc/localtime
scp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

cat > /etc/sysconfig/clock <<EOF
ZONE="Asia/Shanghai"
UTC=false
ARC=false
EOF



# install emacs
yum install gtk2 gtk2-devel gtk2-devel-docs
