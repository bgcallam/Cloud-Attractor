import traer.physics.*;

class CloudAttractor{

  //Particle mouse, b, c;
  Particle[] fixedParticles;
  Particle[] others;
  ParticleSystem physics;
  int frameHeight, frameWidth;
  PImage img;
  int maxFixedParts;

  CloudAttractor(int xWidth, int yHeight, int numParts)
  {
    //size( 400, 400 );
    //frameRate(24);
    //cursor(CROSS);
    frameHeight = yHeight;
    frameWidth = xWidth;
    maxFixedParts = numParts;

    // sprite mask thing stolen from dan shiffman 
    PImage msk = loadImage("part.jpg");
    img = new PImage( msk.width, msk.height );
    for ( int i = 0; i < img.pixels.length; i++ ) 
      img.pixels[i] = color(0);
    img.mask(msk);
    imageMode(CORNER);
    tint( 255, 24 );

    physics = new ParticleSystem( 0, 0.1 );
    fixedParticles = new Particle[0];
    //fixedParticles[0] = physics.makeParticle();

    others = new Particle[2000];
    for ( int i = 0; i < others.length; i++ )
    {
      others[i] = physics.makeParticle( 1.0, random( 0, frameWidth ), random( 0, frameHeight ), 0 );
      //physics.makeAttraction( mouse, others[i], 5000, 50 ); 
    }
  }

  void addParticle(int xCoord, int yCoord, float partWeight)
  {
    Particle newPart;
    // If we have the max number of particles
    if(fixedParticles.length>maxFixedParts){
      // See if any should be killed
      for(int i=0;i<fixedParticles.length;i++){
        if((float)fixedParticles[i].age()>maxFixedParts){
          fixedParticles[i].kill();
          fixedParticles[i] = physics.makeParticle( 1.0, xCoord, yCoord, 0 );
          //newPart.makeFixed();
          for ( int j = 0; j < others.length; j++ )
          {
            physics.makeAttraction( fixedParticles[i], others[j], partWeight, 50 ); 
          }
        }
      }
    }
    else{
      newPart = physics.makeParticle( 1.0, xCoord, yCoord, 0 );
      //newPart.makeFixed();
      for ( int i = 0; i < others.length; i++ )
      {
        physics.makeAttraction( newPart, others[i], partWeight, 50 ); 
      }
      fixedParticles = (Particle[])append(fixedParticles, newPart);
    }

    println("num fixed particles:" + fixedParticles.length);
    println("added at: " + xCoord + "," + yCoord + " POWER:" + partWeight);
  }

  void evalSystem(){
    //mouse.moveTo( mouseX, mouseY, 0 );
    background( 255 );
    physics.tick();
    for ( int i = 0; i < others.length; i++ )
    {
      Particle p = others[i];
      //ellipse(p.position().x()-img.width/2,p.position().y()-img.height/2,10,10);    
      image(img,p.position().x()-img.width/2,p.position().y()-img.height/2);
    }
  }

}
