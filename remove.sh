TRASH_DIR="/home/root/.trash"  
  
for i in $*; do  
    STAMP=`date +%s`  
    fileName=`basename $i`  
    mv $i $TRASH_DIR/$fileName.$STAMP  
done
