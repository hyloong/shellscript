# $1=project name
# $2=project path, if null, use current path

rm -fr configure depcomp Makefile.am auto* install-sh missing aclocal.m4 config.h.in Makefile.in Makefile stamp-h1 

if [ -z $1 ];then
    echo "no project name"
    exit
fi
ProjectName=$1

basepath=$(cd `dirname $0`; pwd)
if [ -z $2 ];then
    Path=${basepath}/configure.in
else
    Path=$2/configure.in
fi

echo $Path

if [ ! -f "$Path" ];then
    Version=1.0
else
    # get old version from configure.in
    V=`cat configure.in |grep AM_INIT_AUTOMAKE|grep -Eo '[0-9]{1,}.[0-9]'`
    echo $V
    Version=`echo "scale=1; ${V}+0.1 " | bc -l`
fi

echo $Version

rm -fr configure.in

# 生成configure.scan
# AC_INIT([FULL-PACKAGE-NAME], [VERSION], [BUG-REPORT-ADDRESS])
# 必备添加的宏:AM_INIT_AUTOMAKE(FULL-PACKAGE-NAME, VERSION)
# 扫描源代码以搜寻普通的可移植性问题，比如检查编译器，库，头文件等，生成文件configure.scan
autoscan
mv configure.scan configure.in
# 修改版本号
sed -i '/AC_INIT.*/d' configure.in
sed -i "/AC_PREREQ/a\AC_INIT(${ProjectName}, ${Version}, 1942007864@qq.com)" configure.in 
sed -i "/AC_CONFIG_HEADERS/a\AM_INIT_AUTOMAKE(${ProjectName}, ${Version})" configure.in
sed -i 's/AC_OUTPUT/AC_OUTPUT(Makefile)/g' configure.in

# 将configure.ac文件所需要的宏集中定义到文件 aclocal.m4
aclocal
# 生成了configure.h.in如果在configure.ac中定义了AC_CONFIG_HEADER
autoheader
# 自动生成Makefile.am
cat > Makefile.am <<EOF
AUTOMAKE_OPTIONS=foreign
bin_PROGRAMS=${ProjectName}
${ProjectName}_SOURCE=${ProjectName}.c
EOF

# 生成Makefile.in
automake --add-missing

# 将configure.in 的宏展开生成configure文件

autoconf

# ./configure 生成Makefile config.log config.status
