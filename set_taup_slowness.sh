#!/bin/bash
#for dir in `ls -d 20*/`
#do
#date=${dir:0:14}
#cd $dir
#rm -f *.mat *.tiff
#echo $dir
    for SACFILE in `ls *.SAC`
    do
    echo $SACFILE
    EVDP=`echo "read ${SACFILE}; lh EVDP; quit;" | sac | grep EVDP | awk '{printf("%8.1f\n",$3)}'`
    DIST=`echo "read ${SACFILE}; lh DIST; quit;" | sac | grep DIST | awk '{ printf("%10.3f\n",$3) }'`
    GCARC=`echo "read ${SACFILE}; lh GCARC; quit;" | sac | grep GCARC | awk '{ printf("%10.3f\n",$3) }'`
#    echo "HT:DEBUG: EVDP: ${EVDP}; DIST: ${DIST};"
    echo Focal depth = $EVDP Epicentral distance =  $DIST = $GCARC degree
    r1=`taup_time -mod ak135 -h $EVDP -ph P -deg $GCARC -rayp` #> temp0
    #r1=`awk '{print $1}' temp0`
    echo Slowness = ${r1}
    rs=$(echo "scale=5 ; $r1 / 111.0" | bc)
    #rs=$(("${r1} / 111"))
    echo $rs
sac << EOF
r $SACFILE
ch t0 $rs
write over
quit 
EOF
   done
#cd ../
#done
#done
