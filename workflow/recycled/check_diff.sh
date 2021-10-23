for i in $(ls xmls_old)
do
 #echo $i
 diff "xmls_old/$i" "xmls/$i"
done
