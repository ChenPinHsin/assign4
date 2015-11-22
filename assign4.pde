final int GAME_START = 0;
final int GAME_PLAYING = 1;
final int GAME_LOSE = 2;
final int RESET=3;
final int ENEMY_RESET=4;

final int ENEMY_STATE = 0;
final int ENEMY_STATE2 = 1;
final int ENEMY_STATE3 = 2;

int bgX=0, hpL, i, j;
int fighterX, fighterY;
int treasureX, treasureY;
int enemyX, enemyY, enemySpacing=62;
int speed=6;
int enemySpeed=3;
int gameState, enemyState;
int[][] enemyArray=new int[5][5];
int[][] flameX=new int[5][5];
int[][] flameY=new int[5][5];
float[][] count=new float [5][5];

PImage start1;
PImage start2;
PImage end1;
PImage end2;
PImage bg1;
PImage bg2;
PImage enemy;
PImage fighter;
PImage hp;
PImage treasure;
PImage[] flame=new PImage[5];

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

void setup () {

  size(640, 480) ;
  frameRate(60);

  start1=loadImage("img/start1.png");
  start2=loadImage("img/start2.png");
  bg1=loadImage("img/bg1.png");
  bg2=loadImage("img/bg2.png");
  end1=loadImage("img/end1.png");
  end2=loadImage("img/end2.png");
  enemy=loadImage("img/enemy.png");
  fighter=loadImage("img/fighter.png");
  hp=loadImage("img/hp.png");
  treasure=loadImage("img/treasure.png");
  for (int i=1; i<=5; i++) {
    flame[i-1]=loadImage("img/flame"+i+".png");
  }

  for (int i=0; i<5; i++) {
    for (int j=0; j<5; j++) {
      count[i][j]=0;
    }
  }
  gameState=GAME_START;
}

void draw() {

  switch(gameState) {  

  case GAME_START:
    if (mouseX > width/2-120 
      && mouseX <width/2+120 
      && mouseY >height/2+150 
      && mouseY<height/2+180) {
      image(start1, 0, 0);
      if (mousePressed) {

        treasureX=floor(random(30, 610));
        treasureY=floor(random(30, 450));

        fighterX=550;
        fighterY=height/2-20;
        hpL=20;
        gameState=ENEMY_RESET;
      }
    } else
      image(start2, 0, 0);
    break;


  case GAME_PLAYING:  
    background(0);
    image(bg1, bgX, 0);
    image(bg2, bgX-width, 0);
    image(bg1, bgX-width*2, 0);
    bgX++;
    bgX%= width*2;

    image(fighter, fighterX, fighterY);
    image(treasure, treasureX, treasureY);


    switch(enemyState) {
    case ENEMY_STATE:
      for (i=0; i<5; i++) {
        if (enemyX<=width+320&&enemyArray[i][0]==1)
          image(enemy, enemyX-i*enemySpacing, enemyY);
      }
      enemyX+=enemySpeed;
      if (enemyX>width+320) {
        for (i=0; i<5; i++) {
          enemyArray[i][0]=0;
        }
        enemyState=ENEMY_STATE2;
        gameState=ENEMY_RESET;
      }

      for (i=0; i<5; i++) {
        if (fighterX-(enemyX-i*enemySpacing)<=60
          &&fighterX-(enemyX-i*enemySpacing)>=-60
          &&fighterY-enemyY<=60
          &&fighterY-enemyY>=-60
          &&enemyArray[i][0]==1)
        {
          enemyArray[i][0]=2;
          flameX[i][0]=enemyX-i*enemySpacing;
          flameY[i][0]=enemyY;
          hpL-=20;
        }
        if (hpL<=0) {
          hpL=0;
          gameState=GAME_LOSE;
        }
      }

      for (i=0; i<5; i++) {

        if (enemyArray[i][0]==2) {
          image(flame[int(count[i][0])], flameX[i][0], flameY[i][0]);
          count[i][0]+=0.2;
        }
        if (count[i][0]>=4) {
          enemyArray[i][0]=0;
          count[i][0]=0;
        }
      }

      break;

    case ENEMY_STATE2:
      for (i=0; i<5; i++) {
        for (j=4; j>=0; j--) {

          if (enemyX<=width+320&&enemyArray[i][j]==1)
            image(enemy, enemyX-i*enemySpacing, enemyY+i*enemySpacing);
        }
      }
      enemyX+=enemySpeed;
      if (enemyX>width+320) {
        for (i=0; i<5; i++) {
          for (j=4; j>=0; j--) { 
            enemyArray[i][j]=0;
          }
        }
        enemyState=ENEMY_STATE3;
        gameState=ENEMY_RESET;
      }

      for (i=0; i<5; i++) {
        for (j=4; j>=0; j--) {
          if (fighterX-(enemyX-i*enemySpacing)<=60
            &&fighterX-(enemyX-i*enemySpacing)>=-60
            &&fighterY-(enemyY+i*enemySpacing)<=60
            &&fighterY-(enemyY+i*enemySpacing)>=-60
            &&enemyArray[i][j]==1) {
            enemyArray[i][j]=2;
            flameX[i][j]=enemyX-i*enemySpacing;
            flameY[i][j]=enemyY+i*enemySpacing;
            hpL-=20;
            if (hpL<=0) {
              hpL=0;
              gameState=GAME_LOSE;
            }
          }
        }
      }

      for (i=0; i<5; i++) {
        for (j=4; j>=0; j--) {
          if (enemyArray[i][j]==2) {
            image(flame[int(count[i][j])], flameX[i][j], flameY[i][j]);
            count[i][j]+=0.2;
          }
          if (count[i][j]>=4) {
            enemyArray[i][j]=0;
            count[i][j]=0;
          }
        }
      }

      break;

    case ENEMY_STATE3:
      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          if (enemyX<=width+160&&enemyArray[(2+i-j)][4-i-j]==1) {
            image(enemy, enemyX-(+i-j)*enemySpacing, (enemyY+(2-i-j)*enemySpacing));
          }
        }
      }
      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          if (enemyX<=width+160&&enemyArray[(2-i+j)][4-i-j]==1) {
            image(enemy, enemyX-(-i+j)*enemySpacing, (enemyY+(2-i-j)*enemySpacing));
          }
        }
      }
      enemyX+=enemySpeed;


      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          if (fighterX-(enemyX-(i-j)*enemySpacing)<=60
            &&fighterX-(enemyX-(i-j)*enemySpacing)>=-60
            &&fighterY-(enemyY+(2-i-j)*enemySpacing)<=60
            &&fighterY-(enemyY+(2-i-j)*enemySpacing)>=-60
            &&enemyArray[2+i-j][4-i-j]==1) {
            enemyArray[2+i-j][4-i-j]=2;
            flameX[2+i-j][4-i-j]=enemyX-(i-j)*enemySpacing;
            flameY[2+i-j][4-i-j]=enemyY+(2-i-j)*enemySpacing;
            hpL-=20;
            if (hpL<=0) {
              hpL=0;
              gameState=GAME_LOSE;
            }
          }
        }
      }
      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          if (fighterX-(enemyX-(-i+j)*enemySpacing)<=60
            &&fighterX-(enemyX-(-i+j)*enemySpacing)>=-50
            &&fighterY-(enemyY+(2-i-j)*enemySpacing)<=60
            &&fighterY-(enemyY+(2-i-j)*enemySpacing)>=-50
            &&enemyArray[2-i+j][4-i-j]==1) 
          {
            enemyArray[2-i+j][4-i-j]=2;
            flameX[2-i+j][4-i-j]=enemyX-(-i+j)*enemySpacing;
            flameY[2-i+j][4-i-j]=enemyY+(2-i-j)*enemySpacing;
            hpL-=20;
            if (hpL<=0) {
              hpL=0;
              gameState=GAME_LOSE;
            }
          }
        }
      }

      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          if (enemyArray[2+i-j][4-i-j]==2) {
            image(flame[int(count[2+i-j][4-i-j])], flameX[2+i-j][4-i-j], flameY[2+i-j][4-i-j]);
            if (i==1)
              count[2+i-j][4-i-j]+=0.2;
            else
              count[2+i-j][4-i-j]+=0.1;
          }
          if (count[2+i-j][4-i-j]>=4) {
            enemyArray[2+i-j][4-i-j]=0;
            count[2+i-j][4-i-j]=0;
          }
        }
      }

      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          if (enemyArray[2-i+j][4-i-j]==2) {
            image(flame[int(count[2-i+j][4-i-j])], flameX[2-i+j][4-i-j], flameY[2-i+j][4-i-j]);
            if (i==1)
              count[2-i+j][4-i-j]+=0.2;
            else
              count[2-i+j][4-i-j]+=0.1;
          }
          if (count[2-i+j][4-i-j]>=4) {
            enemyArray[2-i+j][4-i-j]=0;
            count[2-i+j][4-i-j]=0;
          }
        }
      }
      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          if (enemyArray[2+i-j][4-i-j]==2) {
            image(flame[int(count[2+i-j][4-i-j])], flameX[2+i-j][4-i-j], flameY[2+i-j][4-i-j]);
            if (i==1)
              count[2+i-j][4-i-j]+=0.2;
            else
              count[2+i-j][4-i-j]+=0.1;
          }
          if (count[2+i-j][4-i-j]>=4) {
            enemyArray[2+i-j][4-i-j]=0;
            count[2+i-j][4-i-j]=0;
          }
        }
      }


      if (enemyX>width+160) {
        for (i=0; i<3; i++) {
          for (j=0; j<3; j+=2) {
            enemyArray[2+i-j][4-i-j]=0;
          }
        }
        for (i=0; i<3; i++) {
          for (j=0; j<3; j+=2) {
            enemyArray[2-i+j][4-i-j]=0;
          }
        } 

        enemyState=ENEMY_STATE;
        gameState=ENEMY_RESET;
      }
      break;
    }


    //hp
    fill(255, 0, 0);
    rect(20, 20, hpL*2-5, 30, 7);
    image(hp, 10, 20);


    if ( fighterX >= treasureX - fighter.width 
      && fighterX <= treasureX + treasure.width
      && fighterY >= treasureY - fighter.height
      && fighterY <= treasureY + treasure.height) {
      treasureX=floor(random(10, 620));
      treasureY=floor(random(20, 460));
      hpL+=10;
      if (hpL>=100)
        hpL=100;
    }

    //fighter move    
    if (upPressed) {
      if (fighterY > 0) {
        fighterY -= speed;
      }
    }
    if (downPressed) {
      if (fighterY < 430) {
        fighterY += speed;
      }
    }
    if (leftPressed) {
      if (fighterX > 0) {
        fighterX -= speed;
      }
    }
    if (rightPressed) {
      if (fighterX <590) {
        fighterX += speed;
      }
    }  


    break;

  case ENEMY_RESET:

    if (enemyState==ENEMY_STATE3) {
      enemyX=-220;
      enemyY=floor(random(100, 300));
      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          enemyArray[2+i-j][4-i-j]=1;
        }
      }
      for (i=0; i<3; i++) {
        for (j=0; j<3; j+=2) {
          enemyArray[2-i+j][4-i-j]=1;
        }
      }
    } else if (enemyState==ENEMY_STATE2) {
      enemyX=-100; 
      enemyY=floor(random(30, 100));
      for (i=0; i<5; i++) {
        for (j=4; j>=0; j--) {
          enemyArray[i][4-i]=1;
        }
      }
    } else {
      enemyX=-100;
      enemyY=floor(random(60, 420));
      for (i=0; i<5; i++) {
        enemyArray[i][0]=1;
      }
    }

    gameState=GAME_PLAYING;
    break;     


  case GAME_LOSE:
    if (mouseX > width/2-120 
      && mouseX <width/2+120 
      && mouseY >height/2+60 
      && mouseY<height/2+110) {
      image(end1, 0, 0);
      if (mousePressed) {
        gameState=GAME_START;
        enemyState=ENEMY_STATE;
      }
    } else {
      image(end2, 0, 0);
    }
    break;
  }
}


void keyPressed() {

  if (key==CODED) {

    switch(keyCode) {
    case UP:
      upPressed = true;
      break;
    case DOWN:
      downPressed = true;
      break;
    case LEFT:
      leftPressed = true;
      break;
    case RIGHT:
      rightPressed = true;
      break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
    case UP:
      upPressed = false;
      break;
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    }
  }
}
