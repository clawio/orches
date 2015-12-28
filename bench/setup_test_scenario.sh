#!/bin/bash
USERNAME=demo
PASSWORD=demo
INITIAL="$(echo ${USERNAME} | head -c 1)"
TESTDIR=/local/users/${INITIAL}/${USERNAME}/testing
clawio login ${USERNAME} ${PASSWORD}
clawio home
clawio rm ${TESTDIR}
clawio mkdir ${TESTDIR}
for i in {0,1,2,4,8,16,32,64,128,256,512,1024};do
    clawio mkdir ${TESTDIR}/$i;
    for ((j=0; j < i; j++)); do
        clawio mkdir ${TESTDIR}/$i/$j;
    done;
done;
