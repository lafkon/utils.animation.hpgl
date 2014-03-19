// REVERSE EVERY SECOND PATH (05 INVERTED)
// DECREASE DECIMAL PLACES

import geomerative.*;

float points2pixel = 1.25;
int sf = 1; // scalefactor for more precision?

float x,y;

void setup() 
{
  PrintWriter output;
  float csize = 4 * sf;

  // A3
  size(1052 * sf,1488 * sf); 
  // A3 QUER
  //size(1488 * sf,1052 * sf); 
  noStroke();

  output = createWriter("hpgl.hpgl");

  RG.init(this);
  RG.ignoreStyles();

  String input = loadStrings("svg.i")[0];
  RShape grafik = RG.loadShape(input);


//RCommand.setSegmentLength(2);
//RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  RCommand.setSegmentator(RCommand.ADAPTATIVE);


  //get the PShape[] containing all the single letters as RShapes
  RShape[] tLetterShapes = grafik.children;

  int tChildCount = tLetterShapes.length;

  for (int k = 0; k < tChildCount; k++) {

    RShape tShape = tLetterShapes[k];

    RPolygon grafikPolygon = tShape.toPolygon();

    for(int i = 0; i < grafikPolygon.countContours(); i++) {



//   if ( i%2 != 0 ) {
     
     //println("forward");

   for(int j = 0; j < grafikPolygon.contours[i].points.length; j++)
      {
        RPoint curPoint = grafikPolygon.contours[i].points[j];

        x = curPoint.x * points2pixel * sf;
        y = curPoint.y * points2pixel * sf;


        if ( j == 0) {

        //output.println("forward");
        //output.println("PA" + x + "," + y + ";");
          output.println("PA" + String.format("%.1f",x) + "," + String.format("%.1f",y) + ";");
          output.println("PD;");
        }
        else {

        //output.println("PA" + x + "," + y + ";");        
          output.println("PA" + String.format("%.1f",x) + "," + String.format("%.1f",y) + ";");
        //ellipse(x,y,csize,csize);
        }   
      }

/*
   }

   else {


     
   //println("backward");
     
   for(int j = grafikPolygon.contours[i].points.length - 1; j >= 0; j--)
      {
        RPoint curPoint = grafikPolygon.contours[i].points[j];

        x = curPoint.x * points2pixel * sf;
        y = curPoint.y * points2pixel * sf;

        if ( j == grafikPolygon.contours[i].points.length - 1) {

        //output.println("backward");
        //output.println("PA" + x + "," + y + ";");
          output.println("PA" + String.format("%.1f",x) + "," + String.format("%.1f",y) + ";");
          output.println("PD;");
        }
        else {

        //output.println("PA" + x + "," + y + ";");        
          output.println("PA" + String.format("%.1f",x) + "," + String.format("%.1f",y) + ";");
        //ellipse(x,y,csize,csize);
        }   
      }
      
    
   }
*/
      output.println("PU;"); 
    }
  }

  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file

  exit();         // Stops the program
}


