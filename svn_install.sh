function svn_install(){
    yum remove subversion
    cat > /etc/yum.repos.d/wandisco-svn.rep <<EOF
[WandiscoSVN]
name=Wandisco SVN Repo
baseurl=http://opensource.wandisco.com/centos/6/svn-1.8/RPMS/$basearch/
enabled=1
gpgcheck=0
EOF
    yum clean all
    yum install subversion
}

svn_install

