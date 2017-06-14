path=/root/shellscript/

cdn="<ResUrl>http://asd.cdn.gogo/a1/</ResUrl>"
find $path -name "*.cfg" | xargs sed -i "s#<ResUrl>.*</ResUrl>#${cdn}#g"
