#!/bin/bash

 FOLDER=$1

 if [ `echo $FOLDER | wc -c` -le 1 ]; then

       echo "please provide folder path"
       exit 0
 fi

# REMOVE TRAILING SLASH
  FOLDER=`echo $FOLDER | sed 's,/$,,g'`

  for JPG in `ls $FOLDER/*.jpg`
   do
 
      autotrace -centerline \
                -color-count 2 \
                -background-color FFFFFF \
                -output-file ${JPG%%.*}.pdf \
                $JPG
 
      pdf2svg ${JPG%%.*}.pdf ${JPG%%.*}.svg
      rm ${JPG%%.*}.pdf
 
  done

exit 0;
