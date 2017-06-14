# 删除旧数据
rm -fr diff_table_name.txt

if [ $1 == "" ]; then
         echo "请输入两个数据库1和数据库2名字参数"
         exit
fi

if [ $2 == "" ]; then
    echo "请输入两个数据库1和数据库2名字参数"
    exit
fi

Pwd=`cat mysql`
OneTableName=`mysql -uroot -p$Pwd -S /tmp/mysql1.sock $1 -e "select distinct table_name from information_schema.columns where table_schema='$1'"`
mysql -uroot -p$Pwd -S /tmp/mysql1.sock $2 -e "select distinct table_name from information_schema.columns where table_schema='$2'" >> TowTableName.txt

for otn in $OneTableName
do
    Num=`grep -c $otn TowTableName.txt`
    if [ $Num == 0 ];then
        echo $otn >> diff_table_name.txt
    fi
done
