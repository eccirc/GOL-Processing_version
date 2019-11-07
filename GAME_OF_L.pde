/* David Williams November 2019
GOL Rules: 
Live Cell has 2 or 3 neighbours - it stays alive;
Live Cell has < 2 neighbours, it dies.
Live Cell has > 3 neighbours, it dies.
Dead Cell has == 3 neighbours, it is brought back to life
*/

//GENERATIONS: alive or dead - 2D array to be filled with 0's or 1's
int[][] generation;
//the next iteration
int[][] nextGeneration;

//SIZING VARIABLES
int w, h, scale, rad; //position stuff on the canvas
int genCount; // generation counter

//CONTROLS
char start, randomise, reset, drawCells; //toggle things with different key presses
  
//DISPLAY
PFont drawCount; //generation no. 
PFont instructions; //instructions for key toggles
//*****************************************************************************\\
void setup(){

  size(700,700);
  background(255);
  
  //bigger number = smaller grid (don't go beyond 500 though!)
  scale = 5;
  
  //scale the width/height to fit nicely in the canvas
  w = width/scale;
  h = height/scale;
  print(w + " " + h + " grid"); // 
  //initialise the generation array
  generation = new int[w][h];
  //generation no. starts at  0
  genCount = 0;
  
  //init controls
  start = 's';
  randomise = 'x';
  reset = 'r';
  drawCells = 'd';
  
  //Set up generation counter
  //print(PFont.list());
  pushStyle();
  drawCount = createFont("DejaVu Sans Bold", 20);
  textAlign(CENTER, LEFT);
  textFont(drawCount);
  popStyle(); 
}
//*****************************************************************************\\
void draw(){  
  //Show instruction screen for 8 seconds
  if(millis() < 8000){
    //Instructions
  pushStyle();
  String[] textFile = loadStrings("instructions.txt");
  instructions = createFont("Courier", 22);
  String textJoined = join(textFile, "\n");
  textAlign(CENTER, CENTER);
  textFont(instructions);
  fill(0);
  text(textJoined, width/2, height/2);
  popStyle();
    
  }
  //Start things off
  else{
  visualiseLife();
  
  //draw generation counter
  pushStyle();
  fill(255,0,0);
  text("Generation: " + str(genCount), 20, 20);
  popStyle();
  
  //Toggles
  if(key == reset){noLife(); genCount = 0;}
  if(key == randomise) randomiseLife(); 
  if(key == start){startGame(); genCount +=1;} 
  }
}
//*****************************************************************************\\
void conditions(int adjCells, int posX, int posY){
 //SET OUT THE CONDITIONS FOR LIFE!!
  
  int count = adjCells;
  
      //Cell has less than two neighbours - it dies in the next generation
      if((generation[posX][posY] == 1) && (count < 2)){
        nextGeneration[posX][posY] = 0;
      }
      //Cell is overcrowded - it dies in the next generation
      else if((generation[posX][posY] == 1) && (count > 3)){
        nextGeneration[posX][posY] = 0;
      }
      //Cell has exactly three neighbours - it comes back to life
      else if((generation[posX][posY] == 0) && (count == 3)){
         nextGeneration[posX][posY] = 1; 
      }
      //No change - go through to the next generation
      else{
        nextGeneration[posX][posY] = generation[posX][posY];
      }
}
//*****************************************************************************\\
void startGame(){
  //Start the GAME OF LIFE

  nextGeneration = new int[w][h]; //init new gen each loop
   
  //loop through the grid
  for(int x = 0; x < w; x ++){
    for(int y = 0; y < h; y ++){
     //create variable to count the number of living neighbours
      int countNeighbours = 0;   
      //another nested loop checks all of the cells surrounding - left/right, up/down
      //(a shorter way of hand coding each of the eight cell positions e.g x - 1 = left)
      for(int lr = -1; lr <= 1; lr++){
        for(int ud = -1; ud <= 1; ud++){
          //by using a modulus, the edges are kept intact i.e when x,y = 0,0
          countNeighbours += generation[(x + lr + w) % w][(y + ud + h) % h];
        }
      }
      //update the local(surounding cells)
      countNeighbours -= generation[x][y];
      //apply the conditions for life
      conditions(countNeighbours, x, y);  
    }
  }
  //Update the current generation with new values
  generation = nextGeneration;  
}
//*****************************************************************************\\
void visualiseLife(){
//Create the grid in which to see life in action

  rad = width/w;//calculate the radius of the shapes to be drawn - fits onto the canvas nicely
  for(int x = 0; x < w; x ++){
    for(int y = 0; y < h; y ++){
      //if alive - fill with a colour. Otherwise, leave blank
      if(generation[x][y] == 1){ fill(0);}
      else{ fill(255);}
      rect(x * rad, y * rad, rad, rad);
    }
  }  
}
//*****************************************************************************\\
void randomiseLife(){
//create random inital starting point
 
 for(int x = 0; x < w; x ++){
     for(int y = 0; y < h; y++){
       //stop spitting out random grids once key is released!
       if(keyPressed){
       generation[x][y] = int(random(2));
       }
       
     }  
   }
}
//*****************************************************************************\\
void noLife(){
//reset to blank grid
 for(int x = 0; x < w; x ++){
     for(int y = 0; y < h; y++){
       generation[x][y] = 0;      
     }     
   }
}
//*****************************************************************************\\
void mouseDragged(){
//draw your own cells  
  if(key == drawCells){
   for(int x = 0; x < w; x ++){
     for(int y = 0; y < h; y++){
       int posX = x * rad;
       int posY = y * rad;
       if(mouseX > posX && mouseX < (posX + rad) && mouseY > posY && mouseY < (posY + rad)){
         generation[x][y] = 1; 
       }
     }     
   } 
  }
}
   
