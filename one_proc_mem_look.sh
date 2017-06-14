ps -eo pid -o pcpu,rss,args | grep $1 |awk '{ sum+=$3 } END { print ("%d, %d, %d%s\n", NR-1, sum/1024, sum/(NR-1)/1024, "M") }'
