#!/bin/bash

export BUCKET='s3://deletemebucket-9919238777512'
export FILE='test.txt'

echo 'hello' > ${FILE}

aws s3 mv test.txt ${BUCKET}

aws s3 cp ${BUCKET}/${FILE} ./

aws s3 rm ${BUCKET}/${FILE}
