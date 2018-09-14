float matrices[][][] = {{{ 0   , 0   },
                         { 0   , 0.16}},
                        
                        {{ 0.85, 0.04},
                         {-0.04, 0.85}},
                        
                        {{ 0.20,-0.26},
                         { 0.23, 0.22}},
                        
                        {{-0.15, 0.28},
                         { 0.26, 0.24}}};

float coefficients[] = {0, 1.60, 1.60, 0.44};
vec2 plotPoint;
float displayScale = 1.0/12.0;
int histogram[] = new int[1000*1000];


void setup()
{
  
  for(int i = 0; i < 1000*1000; i++)
  {
    histogram[i] = 0;
  }
  
  
  background(#2187A2);
  size(1000,1000);
  plotPoint = new vec2(0,0);
}
int max = 0;
void draw()
{
  clear();

  
  for(int iterations = 0; iterations < 1000; iterations++)
  {
    float probability = random(1);
    if       (probability <= 0.01)
    {
     plotPoint.transform(matrices[0]);
     plotPoint.y += coefficients[0];
    }else if (probability <= 0.86)
    {
     plotPoint.transform(matrices[1]);
     plotPoint.y += coefficients[1];
    }else if (probability <= 0.93)
    {
     plotPoint.transform(matrices[2]); 
     plotPoint.y += coefficients[2];
    }else
    {
     plotPoint.transform(matrices[3]); 
     plotPoint.y += coefficients[3];
    }
    
    vec2 plotCoord = plotPoint.copy();
    plotCoord.x *= height*displayScale;
    plotCoord.y *= height*displayScale;
    plotCoord.x += width/2;    
    histogram[int(plotCoord.x)+1000*int(plotCoord.y)]++;
  }
  
  for(int i = 0; i < 1000*1000; i++)
  {
    if (histogram[i] > max) max = histogram[i];
  }

  int[]outputArray = sort(histogram);
  
  for(int i = 0; i < outputArray.length; i++)
  {
    if (outputArray[i] > 0) 
    {
      outputArray = subset(outputArray,i);
      break;
    }
  }
  int q0 = (outputArray[outputArray.length/8] + outputArray[outputArray.length/8 + 1])/2;
  int q1 = (outputArray[outputArray.length/4] + outputArray[outputArray.length/4 + 1])/2;
  int q2 = (outputArray[3*outputArray.length/8] + outputArray[3*outputArray.length/8 + 1])/2;
  int q3 = (outputArray[outputArray.length/2] + outputArray[outputArray.length/2 + 1])/2;
  int q4 = (outputArray[5*outputArray.length/8] + outputArray[5*outputArray.length/8 + 1])/2;
  int q5 = (outputArray[3*outputArray.length/4] + outputArray[3*outputArray.length/4 + 1])/2;
  int q6 = (outputArray[7*outputArray.length/8] + outputArray[7*outputArray.length/8 + 1])/2;
  int[] percentiles = new int[99];
  for (int i = 0; i < 99; i++)
  {
    percentiles[i] = outputArray[(i+1) * outputArray.length/100];
  }
  loadPixels();
  for(int i = 0; i < 1000*1000; i++)
  {
           if (histogram[histogram.length-i-1] == 0)
    {
      pixels[i] = color(#000000);
    } else if (histogram[histogram.length-i-1] <= q0)
    {
      pixels[i] = lerpColor(color(#294102),color(#3A5404),map(histogram[histogram.length-i-1],0,q0,0,1));
    } else if (histogram[histogram.length-i-1] <= q1)
    {
      pixels[i] = lerpColor(color(#3A5404),color(#4B6707),map(histogram[histogram.length-i-1],q0,q1,0,1));
    } else if (histogram[histogram.length-i-1] <= q2)
    {
      pixels[i] = lerpColor(color(#4B6707),color(#5C7A09),map(histogram[histogram.length-i-1],q1,q2,0,1));
    } else if (histogram[histogram.length-i-1] <= q3)
    {
      pixels[i] = lerpColor(color(#5C7A09),color(#6D8E0C),map(histogram[histogram.length-i-1],q2,q3,0,1));
    } else if (histogram[histogram.length-i-1] <= q4)
    {
      pixels[i] = lerpColor(color(#6D8E0C),color(#7EA10E),map(histogram[histogram.length-i-1],q3,q4,0,1));
    } else if (histogram[histogram.length-i-1] <= q5)
    {
      pixels[i] = lerpColor(color(#7EA10E),color(#8FB411),map(histogram[histogram.length-i-1],q4,q5,0,1));
    } else if (histogram[histogram.length-i-1] <= q6)
    {
      pixels[i] = lerpColor(color(#8FB411),color(#A0C814),map(histogram[histogram.length-i-1],q5,q6,0,1));
    } else
    {
      pixels[i] = color(#A0C814);
    }
  }
  updatePixels();
  for (int i = 0; i < 98; i++)
  {
    float lineLength = map(percentiles[i],percentiles[0],percentiles[98],0,100);
    rectMode(CORNER);
    stroke(255);
    line(20+i*2,100,20+i*2,100-lineLength);
  }
  String outputString = "Percentiles from a sample size of " + str(outputArray.length) + ": ";
  for (int i = 9; i <= 89; i+= 10)
  {
    outputString += str(percentiles[i]) + ' ';
  }
  println(outputString);
}
