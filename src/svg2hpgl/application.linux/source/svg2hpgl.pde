import geomerative.*;

float points2pixel = 1.25;
int sf = 1;

float x,y;

void setup() 
{
  PrintWriter output;
  float csize = 4 * sf;

  // A3
  size(1052 * sf,1488 * sf); 
  noStroke();

  output = createWriter("hpgl.hpgl");

  RG.init(this);
  RG.ignoreStyles();

  String input = loadStrings("svg.i")[0];
  RShape grafik = RG.loadShape(input);

  RCommand.setSegmentator(RCommand.ADAPTATIVE);

  RShape[] tLetterShapes = grafik.children;

  int tChildCount = tLetterShapes.length;

  for (int k = 0; k < tChildCount; k++) {

    RShape tShape = tLetterShapes[k];

    RPolygon grafikPolygon = tShape.toPolygon();

    for(int i = 0; i < grafikPolygon.countContours(); i++) {

      for(int j = 0; j < grafikPolygon.contours[i].points.length; j++)
      {
        RPoint curPoint = grafikPolygon.contours[i].points[j];

        x = curPoint.x * points2pixel * sf;
        y = curPoint.y * points2pixel * sf;


        if ( j == 0) {

          output.println("PA" + String.format("%.1f",x) + "," + String.format("%.1f",y) + ";");
          output.println("PD;");
        }
        else {

          output.println("PA" + String.format("%.1f",x) + "," + String.format("%.1f",y) + ";");
        }   
      }

      output.println("PU;"); 
    }
  }

  output.flush();
  output.close();

  exit();
}



