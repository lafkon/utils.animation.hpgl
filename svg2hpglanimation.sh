#!/bin/bash

 FOLDER=$1
 TMPDIR=.

 if [ `echo $FOLDER | wc -c` -le 1 ]; then

       echo "please provide folder path"
       exit 0
 fi
   # REMOVE TRAILING SLASH
   FOLDER=`echo $FOLDER | sed 's,/$,,g'`


wait () {

   POSITION=`cat $HPGL | grep ^PA | tail -1`
   SLEEPCNT=0

   while [ $SLEEPCNT -lt $1 ]
    do
        echo $POSITION >> $HPGL
        SLEEPCNT=`expr $SLEEPCNT + 1`
   done
}

 # -------------------------------------------------------------------------- #
 # START HPGL FILE
 # -------------------------------------------------------------------------- #
 
#  HPGL=${SVG%%.*}.hpgl

   HPGL=$FOLDER/all.hpgl
 
   echo "IN;"                  >  $HPGL
   # http://www.isoplotec.co.jp/HPGL/eHPGL.htm
   # IP p1x,p1y,p2x,p2y;
   echo "IP0,0,16158,11040;"   >> $HPGL
   # http://www.isoplotec.co.jp/HPGL/eHPGL.htm
   # SC xmin,xmax,ymin,ymax;
   echo "SC1488,0,0,1052;"     >> $HPGL
#  echo "SP1;"                 >> $HPGL
   echo "VS5;"                 >> $HPGL

#  http://www.isoplotec.co.jp/HPGL/eHPGL.htm#-LT(Line Type)
#  DOTTED LINE
#  echo "LT1,1;"               >> $HPGL

 for SVG in `ls $FOLDER/*.svg`
  do

  SRCSVG=$SVG

  inkscape --export-pdf=${SRCSVG%%.*}.pdf $SRCSVG

# PLACE ON A3

  e () { echo $1 >> $OUT ; }
# ----------------------------------------------------------------------- #

  OUT=testing.tex
  if [ -f $OUT ]; then rm $OUT ;fi

  e "\documentclass{scrbook}"
  e "\pagestyle{empty}"
  e "\usepackage{pdfpages}"
  e "\usepackage{geometry}"
  e "\geometry{paperwidth=1191pt,paperheight=842pt}"

  e "\begin{document}"

  e "\includepdf"

  e "[nup=1x1,scale=0.58,"
  e " delta=0 0,offset=0 -50]"

  e "{"${SRCSVG%%.*}.pdf"}"

  e "\end{document}"

  pdflatex --output-directory=$TMPDIR $OUT > /dev/null

  rm $OUT ${OUT%%.*}.aux ${OUT%%.*}.log
  mv $TMPDIR/${OUT%%.*}.pdf ${SRCSVG%%.*}.pdf

# ------------------------------------------------------------------------- #
# FORTH-AND-BACK CONVERTING 
# TO PREVENT GEOMERATIVE ERRORS

  pdf2ps ${SRCSVG%%.*}.pdf ${SRCSVG%%.*}.ps
  ps2pdf ${SRCSVG%%.*}.ps ${SRCSVG%%.*}.pdf
  pdf2svg ${SRCSVG%%.*}.pdf ${SRCSVG%%.*}_CONFORM.svg

  rm ${SRCSVG%%.*}.ps ${SRCSVG%%.*}.pdf

  # REMOVE PATH CLOSURE = "Z M" (CAUSED PROBLEM WITH GEOMERATIVE)
  sed -i 's/Z M [^"]*"/"/g' ${SRCSVG%%.*}_CONFORM.svg

  SVG4HPGLLINES=${SRCSVG%%.*}_CONFORM.svg
# -------------------------------------------------------------- #

  echo $SVG4HPGLLINES > svg.i

# START VIRTUAL XSERVER FOR PROCESSING HEADLESS #######################
# Xvfb :1 -screen 0 1152x900x8 -fbdir /tmp &

# EXPORT DISPLAY FOR PROCESSING HEADLESS ##############################
  export DISPLAY=localhost:1.0 ##########################################

  SKETCHNAME=hpgllines_A3_XX

  APPDIR=$(dirname "$0")
  LIBDIR=$APPDIR/src/$SKETCHNAME/application.linux/lib
  SKETCH=$LIBDIR/$SKETCHNAME.jar

  CORE=$LIBDIR/core.jar
  GMRTV=$LIBDIR/geomerative.jar
  BTK=$LIBDIR/batikfont.jar

  LIBS=$SKETCH:$CORE:$GMRTV:$BTK

  java  -Djava.library.path="$APPDIR" \
        -cp "$LIBS" \
        $SKETCHNAME 

  rm svg.i

# -------------------------------------------------------------------------- #
  cat hpgl.hpgl | sed '$!N; /^\(.*\)\n\1$/!P; D'   >> $HPGL

  wait 60

  echo "PA0.0,1052.0;"                             >> $HPGL
# -------------------------------------------------------------------------- #
  echo "PD;"                                       >> $HPGL
  wait 20
  echo "PU;"                                       >> $HPGL

# CLEAN up
# -------------------------------------------------------------------------- #
  rm hpgl.hpgl ${SVG%%.*}_* 

done



exit 0;




