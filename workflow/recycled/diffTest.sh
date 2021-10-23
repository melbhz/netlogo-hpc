bash xml_step1n2n3_ALL_IN_ONE_clean_Test.sh
diff head.xml head_.xml
diff seed.xml seed_.xml
diff tail.xml tail_.xml
cd xmls
diff exp_1.xml exp_1_.xml
diff exp_11.xml exp_11_.xml

for i in {1..100}
do
 diff Test_29April/xmls/exp_$i.xml Test_29April_val/xmls/exp_$i.xml
done

origindir='Test_29April'
validationdir='Test_29April_val'
diff ${origindir}/head.xml ${validationdir}/head.xml
diff ${origindir}/seed.xml ${validationdir}/seed.xml
diff ${origindir}/tail.xml ${validationdir}/tail.xml
diff ${origindir}/Experiment_auto.xml ${validationdir}/Experiment_auto.xml

for i in {1..100}
do
 diff ${origindir}/xmls/exp_$i.xml ${validationdir}/xmls/exp_$i.xml
done