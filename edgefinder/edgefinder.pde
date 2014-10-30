import processing.video.*;

Capture cam;

PImage edges;

float maxDist = 10.0;

color edgeColor = color(0);
color fillColor = color(255);

void captureEvent(Capture c) {
  c.read();
}

void setup() {
  size(1280, 720);
  cam = new Capture(this, 1280, 720);
  cam.start();
  
  edges = createImage(cam.width, cam.height, RGB);
}

void draw() {
  // draw background
  //background(255);
  //tint(255, 126);
  //image(cam,0,0);

  cam.loadPixels();
  //edges.loadPixels();
  for (int y=1; y<cam.height-1; y++) {
    for (int x=1; x<cam.width-1; x++) {
      // initialize edge as false
      boolean edge = false;
      // establish neighbor pixel color values
      color c0 = cam.pixels[x + y * cam.width];
      color c1 = cam.pixels[(x-1) + (y-1) * cam.width];
      color c2 = cam.pixels[x + (y-1) * cam.width];
      //color c3 = cam.pixels[(x+1) + (y-1) * cam.width];
      color c4 = cam.pixels[(x-1) + y * cam.width];
      //color c5 = cam.pixels[(x+1) + y * cam.width];
      //color c6 = cam.pixels[(x-1) + (y+1) * cam.width];
      //color c7 = cam.pixels[x + (y+1) * cam.width];
      //color c8 = cam.pixels[(x+1) + (y+1) * cam.width];
      // make neighbor pixels array
      color[] np = {
        c1, c2, c4
      };
      // loop through neighbor_pixels and find greatest distance
      for (int i=0; i<np.length; i++) {
        float d = dist(red(c0), green(c0), blue(c0), red(np[i]), green(np[i]), blue(np[i]));
        if (d > maxDist) {
          edge = true;
        }
      }
      if (edge == true) {
        edges.pixels[x + y * edges.width] = edgeColor;
      } else {
        edges.pixels[x + y * edges.width] = fillColor;
      }
    }
  }
  edges.updatePixels();
  
  // new part starts here...
  
  edges.loadPixels();
  for (int y=1; y<edges.height-1; y++) {
    for (int x=1; x<edges.width-1; x++) {
      boolean isolated = false;      
      color k0 = cam.pixels[x + y * cam.width];
      color k1 = cam.pixels[(x-1) + (y-1) * cam.width];
      color k2 = cam.pixels[x + (y-1) * cam.width];
      color k3 = cam.pixels[(x+1) + (y-1) * cam.width];
      color k4 = cam.pixels[(x-1) + y * cam.width];
      color k5 = cam.pixels[(x+1) + y * cam.width];
      color k6 = cam.pixels[(x-1) + (y+1) * cam.width];
      color k7 = cam.pixels[x + (y+1) * cam.width];
      color k8 = cam.pixels[(x+1) + (y+1) * cam.width];
      
      color[] npk = {k1, k2, k3, k4, k5, k6, k7, k8};
      if (k0 == edgeColor) {
        for (int i=0; i<npk.length; i++) {
          if (npk[i] == fillColor) isolated = true;
        }
        if (isolated) edges.pixels[x+y*edges.width] = fillColor;
      } 
    }
  }
  edges.updatePixels();
  
  // ...new part ends here
  
  // extra new part begins here...
  
  // edges.loadPixels();
  // for (int y=5; y<edges.height-5; y++) {
  //   for (int x=5; x<edges.width-5; x++) {
      
  //     color l0 = edges.pixels[x + y * edges.width];
  //     color l1 = edges.pixels[(x+5) + y * edges.width];
  //     color l2 = edges.pixels[x + (y+5) * edges.width];
  //     if (l0 == edgeColor && l1 == edgeColor && l2 == edgeColor) {
        
  //       stroke(0);
  //       noFill();
  //       ellipse(x+2.5, y+2.5, 5, 5);
  //       // fill(0);
  //       // noStroke();
  //       // rect(x, y, 3, 3);
  //       // noFill();
  //       // beginShape();
  //       // vertex(x, y-1);
  //       // vertex(x-1, y-1);
  //       // vertex(x-1, y);
  //       // endShape();
  //     }
  //     // else if (l0 == edgeColor && l2 == edgeColor) {
  //     //   stroke(0);
  //     //   noFill();
  //     //   line(x, y, x, y+5);
  //     // }
      
  //   }
  // }
  
  // ...extra new part ends here
  scale(-1, 1);
  image(edges, -1*edges.width, 0);
}
