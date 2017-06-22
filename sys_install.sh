##
PWD=xxxxxx
NAME=xxxxx
MAIL=xxxxx

echo $PWD |passwd root --stdin

# change dns
START_DATETIME=`date +"%Y-%m-%d %H:%M:%S"`
echo "nameserver 8.8.8.8" >> /etc/resolv.conf

#rsync source
echo $PWD > /etc/rsync.pass
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

alias gad='git add .'
alias gci='git commit -m '
alias gft='git fetch'
alias gpom='git push -u origin master'


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


## git设置
git config --global user.name $NAME
git config --global user.email $MAIL


# install emacs
function emace_install(){
	yum install gtk2 gtk2-devel gtk2-devel-docs
    yum install libXpm libXpm-devel \
                libjpeg libjpeg-devel \
                libgif libgif-devel \
                libungif libungif-devel \
                libtiff libtiff-devel

    cd /root/download
    wget http://mirrors.ustc.edu.cn/gnu/emacs/emacs-25.2.tar.gz
    tar -zxvf emacs-25.2.tar.gz
    cd emacs-25.2
    ./configure
    make
    make install
}


function elrang_install(){
    cd /root/download

    yum clean

    yum -y install unixODBC unixODBC-devel

    # install wx
    # wget http://sourceforge.net/projects/wxwindows/files/3.0.0/wxWidgets-3.0.0.tar.bz2
    # tar -xvf wxWidgets-3.0.0.tar.bz2
    # cd wxWidgets-3.0.0
    # ./configure --with-cocoa --prefix=/usr/local
    # ./configure --with-cocoa --prefix=/usr/local --with-macosx-version-min=10.9 --disable-shared
    # make
    # make install
    # export PATH=/usr/local/bin:$PATH

    # get erlang
    tar -zxf otp_src_19.3.tar.gz
    cd otp_src_19.3
    export ERL_TOP=`pwd`
    export LANG=C

    # export MAKEFLAGS=-j8

    ./configure
    make

    # test
    # make release_tests
    # cd release/tests/test_server
    # $ERL_TOP/bin/erl -s ts install -s ts smoke_test batch -s init stop

    # install
    make install

    # build doc
    # export PATH=$ERL_TOP/bin:$PATH
    # export FOP_HOME=/path/to/fop/dir

    # make docs

    # build a debug Enabled Erlang RunTime System
    # cd $ERL_TOP/erts/emulator
    # export FLAVOR=smp
    # make debug FLAVOR=$FLAVOR

    # other debug type
    # `$TYPE` is `opt`, `gcov`, `gprof`, `debug`, `valgrind`, or `lcnt` 
    # make $TYPE FLAVOR=$FLAVOR

}

