//something like https://www.openprocessing.org/sketch/112858/

//recording variables:
boolean record = false;
int frameNb = 0;
int totalFrames = 120;
//then launch gifter.py

float _INCR=0.07;
float _RADIUS = 280;     //of the circle, in pixels
float _NOISEMULT = 100;  //factor for noise power
float _PCR = 1.9;        //perlin circle radius, on the 2D Perlin noise map
float _PCR4D = _PCR/240*totalFrames ; //this value works well for any nb of frames
int _DEPTH = 30;  //nb circles
float time=0;
long seed = (long)random(pow(-2,31),pow(2,31)-1);

//float mean=0;
OpenSimplexNoise simplex;
void setup (){
  size(400, 400);
  frameRate(24);
  //background(192, 64, 0);
  stroke(255);
  strokeWeight(1);
  background(40);
  simplex = new OpenSimplexNoise(seed);
  print(seed);
}


void draw(){
     //time+=_INCR;  //'time' as in 3rd dimension of perlin map
     
     //clean canvas
     background(0);
     //display shape
     translate( width/2, height/2);
     for (int i=1; i<=_DEPTH; i++){
       stroke(map( pow(i,2), 1,pow(_DEPTH,2) ,0,255 ));
       float noiseAmp = map(i,0,_DEPTH, _NOISEMULT/_DEPTH, _NOISEMULT);
//noiseAmp = 0;
       //println(noiseAmp);
       float localRadius = pow(i,2)*_RADIUS / pow(_DEPTH,2); //square function to get more circles as we get closer to the center
       printOne(localRadius, noiseAmp, time+i*2*_INCR);
     }
     if(record){
       saveFrame("output/gif-"+nf(frameNb, 3)+".png");
       if (frameNb == totalFrames-1) {
         exit();
       }
       frameNb++;
     }//end if record
     time += TWO_PI / (float)totalFrames;
} //end draw

void printOne(float radius, float noisePower, float time){
  PShape pc =  createShape();
  pc.beginShape();
   //for all angles, create circle with noise
  for (float a = 0 ; a < TWO_PI; a+=0.02) {
    PVector v = PVector.fromAngle(a);      
      //calculate new noise value
      //creates a circle on a 2D noise map. PCR is the radius of said circle.
    //Perlin noise option  
    //float noiseVal = noisePower * (noise( (1+cos(a))*_PCR, (1+sin(a))*_PCR, time ) - 0.5);
    //simplex 3D option
    //float noiseVal = noisePower * (float)simplex.eval( (1+cos(a))*_PCR, (1+sin(a))*_PCR, time) - 0.5;
    //simplex 4D option
    float noiseVal = noisePower * (float)simplex.eval( 
      (1+cos(a))*_PCR ,      (1+sin(a))*_PCR,        //circle around 1&2D
      (1+cos(time))*_PCR4D , (1+sin(time))*_PCR4D  //circle around 3&4D
      ) - 0.5;
    v.mult(radius+noiseVal);
    pc.vertex(v.x, v.y);  //add created vector to shape pc (Perlin Circle)
   }
  pc.noFill();
  pc.endShape(CLOSE);
  shape(pc);
} //<>// //<>//
