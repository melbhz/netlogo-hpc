mkdir -p xmls
for i in {1..10}
do
 # create repetitions
 echo $i
 cp "TAC.xml" "xmls/TAC_$i.xml"
done