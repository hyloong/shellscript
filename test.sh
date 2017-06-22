f test "x$no_recursion" != "xyes" -a "x$OVERRIDE_CONFIG_CACHE" = "x"; then
   # The no_recursion variable is not documented, but the only
   # action we take on it is disabling caching which is safe!
   if test "x$cache_file" != "x$default_cache_file"; then
   echo "Ignoring the --cache-file argument since it can cause the system to be erroneously configured"
   fi
   echo "Disabling caching"
   if test -f $cache_file; then
   echo "Removing cache file $cache_file"
   rm -f $cache_file
   fi
   cache_file=/dev/null
fi

find $path -name "*.cfg" |grep -vE "config_(appstore921|gjxxyyb|qihoo|suyou_debug).cfg" |grep -vE "config_(manling.*|ml.*)" |xargs sed -i "s#.*ResUrl.*cdn.*#${cdn}#g"

