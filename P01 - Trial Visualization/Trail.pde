import java.util.Random;

/**************************** HEADER ****************************
 LecturesInGraphics: Template for Processing sketches in 2D
 Template author: Jarek ROSSIGNAC
 Class: CS3451 Fall 2014
 Student: Bo Chen && Shen Yang
 Project number: P01
 Project title: Bouncing Rectangles
 Date of submission: 8/26/2014
*****************************************************************/
    
//**************************** global variables ****************************
final int numOfCircles = 30;
float[] trailX = new float[numOfCircles];
float[] trailY = new float[numOfCircles];
float[] newTrailX = new float[numOfCircles];
float[] newtrailY = new float[numOfCircles];

// Index for color
int index = 0;

// Delay so color iteration slows down.
int delay = 0;

// Array of colors for the circle to iterate through.
color[] colorArray = {#000000,#150517,#250517,#2B1B17,#302217,#302226,#342826,#34282C,#382D2C,#3b3131,#3E3535,#413839,#41383C,#463E3F,#4A4344,#4C4646,#4E4848,#504A4B,#544E4F,#565051,#595454,#5C5858,#5F5A59,#625D5D,#646060,#666362,#696565,#6D6968,#6E6A6B,#726E6D,#747170,#736F6E,#616D7E,#657383,#646D7E,#6D7B8D,#4C787E,#4C7D7E,#806D7E,#5E5A80,#4E387E,#151B54,#2B3856,#25383C,#463E41,#151B8D,#15317E,#342D7E,#2B60DE,#306EFF,#2B65EC,#2554C7,#3BB9FF,#38ACEC,#357EC7,#3090C7,#25587E,#1589FF,#157DEC,#1569C7,#153E7E,#2B547E,#4863A0,#6960EC,#8D38C9,#7A5DC7,#8467D7,#9172EC,#9E7BFF,#728FCE,#488AC7,#56A5EC,#5CB3FF,#659EC7,#41627E,#737CA1,#737CA1,#98AFC7,#F6358A,#F6358A,#E4317F,#F52887,#E4287C,#C12267,#7D053F,#CA226B,#C12869,#800517,#7D0541,#7D0552,#810541,#C12283,#E3319D,#F535AA,#FF00FF,#F433FF,#E238EC,#C031C7,#B048B5,#D462FF,#C45AEC,#A74AC7,#6A287E,#8E35EF,#893BFF,#7F38EC,#6C2DC7,#461B7E,#571B7e,#7D1B7E,#842DCE,#8B31C7,#A23BEC,#B041FF,#7E587E,#D16587,#F778A1,#E56E94,#C25A7C,#7E354D,#B93B8F,#F9B7FF,#E6A9EC,#C38EC7,#D2B9D3,#C6AEC7,#EBDDE2,#C8BBBE,#E9CFEC,#FCDFFF,#E3E4FA,#FDEEF4,#C6DEFF,#ADDFFF,#BDEDFF,#E0FFFF,#C2DFFF,#B4CFEC,#B7CEEC,#52F3FF,#00FFFF,#57FEFF,#50EBEC,#4EE2EC,#48CCCD,#43C6DB,#9AFEFF,#8EEBEC,#78c7c7,#46C7C7,#43BFC7,#77BFC7,#92C7C7,#AFDCEC,#3B9C9C,#307D7E,#3EA99F,#82CAFA,#A0CFEC,#87AFC7,#82CAFF,#79BAEC,#566D7E,#6698FF,#736AFF,#CFECEC,#AFC7C7,#717D7D,#95B9C7,#5E767E,#5E7D7E,#617C58,#348781,#306754,#4E8975,#254117,#387C44,#4E9258,#347235,#347C2C,#667C26,#437C17,#347C17,#348017,#4AA02C,#41A317,#4AA02C,#8BB381,#99C68E,#4CC417,#6CC417,#52D017,#4CC552,#54C571,#57E964,#5EFB6E,#64E986,#6AFB92,#B5EAAA,#C3FDB8,#00FF00,#87F717,#5FFB17,#59E817,#7FE817,#8AFB17,#B1FB17,#CCFB5D,#BCE954,#A0C544,#FFFF00,#FFFC17,#FFF380,#EDE275,#EDDA74,#EAC117,#FDD017,#FBB917,#E9AB17,#D4A017,#C7A317,#C68E17,#AF7817,#ADA96E,#C9BE62,#827839,#FBB117,#E8A317,#C58917,#F87431,#E66C2C,#F88017,#F87217,#E56717,#C35617,#C35817,#8A4117,#7E3517,#7E2217,#7E3117,#7E3817,#7F5217,#806517,#805817,#7F462C,#C85A17,#C34A2C,#E55B3C,#F76541,#E18B6B,#F88158,#E67451,#C36241,#C47451,#E78A61,#F9966B,#EE9A4D,#F660AB,#F665AB,#E45E9D,#C25283,#7D2252,#E77471,#F75D59,#E55451,#C24641,#FF0000,#F62217,#E41B17,#F62817,#E42217,#C11B17,#FAAFBE,#FBBBB9,#E8ADAA,#E7A1B0,#FAAFBA,#F9A7B0,#E799A3,#C48793,#C5908E,#B38481,#C48189,#7F5A58,#7F4E52,#7F525D,#817679,#817339,#827B60,#C9C299,#C8B560,#ECD672,#ECD872,#FFE87C,#ECE5B6,#FFF8C6,#FAF8CC};

//**************************** main methods ****************************

// Mode 2. Circle is at the average of the current and next location.
void drag(float x, float y){
    
    // Repeat average once.
    for (int j = 0; j < 1; j++) {
        for (int i = 0; i < trailX.length-1; i++ ) {
            newTrailX[i] = (trailX[i] + trailX[i+1])/2; // Average of X Coordinate
            newtrailY[i] = (trailY[i] + trailY[i+1])/2; // Average of Y Coordinate
        }
        newTrailX[trailX.length-1] = x; // Dequeue the last one
        newtrailY[trailX.length-1] = y; // Dequeue the last one
    } 
    // Replace to current trail.
    trailX = newTrailX;
    trailY = newtrailY;
} // end of drag()

void push(float x, float y) {
  
    // Enqueue is added to the back of the array.
    // Move all the elements in the array one step front, and the first one is replaced (dequeue)
    for(int i = 0; i < trailX.length-1; i ++) {
        trailX[i] = trailX[i+1];
        trailY[i] = trailY[i+1];
    }
    // Enqueue the current coordinates.
    trailX[trailX.length-1] = x;
    trailY[trailX.length-1] = y;
} // end of push()

void mode3(float x, float y) {
  
    // Repeating drag(x, y) twice since it repeats the average.
    drag(x, y);
    drag(x, y);
} // end of mode3

void mode5(float x, float y) {
 
    // Repeating drag(x, y) twice since it repeats the average.
    drag(x, y);
    drag(x, y);
    
    // Generate a random int between -10 to 10 which controls how much the circle shakes.
    Random randomGenerator = new Random();
    int randomInt = randomGenerator.nextInt(21)-10;
    int randomInt2 = randomGenerator.nextInt(21)-10;
    
    // Shakes the circle
    for (int i = 25; i < 30; i++) {
        newTrailX[i]+=randomInt;
        newtrailY[i]+=randomInt2;
    }
    trailX = newTrailX;
    trailY = newtrailY;
} // end of mode4

void show(){    
  
    for (int i = 0; i < trailX.length; i++) {
        
        // The color of the border of the circle changes, while the center is always white.
        stroke(colorArray[index]); fill(white);
        
        // If it is not mode 4, it shrinks and disappear
        if (!mode4) {
            showDisk(trailX[i], trailY[i], i);
        } else if (mode4) { // If the mode is 4, the size is proportional to the distance of the current and circle before.
            if (i < 29) {
                showDisk(trailX[i], trailY[i], (trailX[i+1]-trailX[i])*2);
            }
        }
        
        // Control the delay of the color change so it won't change too fast.
        if (delay == 100) {
            index++;
            delay = 0;
        }
        delay++;
        
        // Repeats from beginning if it reaches the end.
        if (index >= colorArray.length) {
            index = 0;
        }
        
        if (mode5) image(troll,trailX[29]-19,trailY[29]-20); // Set the image for the "high" mode.
    }
} // end of show()

// Reset to initial values when not in mode 5
void reset() {
  animating = false;
  gravity = 0.1;
  vx = 0;
  vy = 1; 
} // end of reset()
