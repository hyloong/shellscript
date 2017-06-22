yum install gtk2 gtk2-devel gtk2-devel-docs

yum install libXpm libXpm-devel libjpeg libjpeg-devel libgif libgif-devel libungif libungif-devel libtiff libtiff-devel

cd /root/download
wget http://mirrors.ustc.edu.cn/gnu/emacs/emacs-25.2.tar.gz


tar -zxvf emacs-25.2.tar.gz

cd emacs-25.2

./configure
make
make install

