#!/bin/bash

RESULTDIR=$1

# Calculate means
for i in $(ls -d $RESULTDIR/*-*-*); do ./calculate_mean.sh $i; done;

# Run gnuplot to generate the plots
for i in $(ls -d $RESULTDIR/*-*-*); do
title=$(basename $i)
echo $title
echo $i
title=$title file=$i/mean.csv gnuplot mean.gpl > $i/mean.png;
done;

