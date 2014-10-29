import processing.video.*;

Capture cam;

PImage edges;

float maxDist = 16.0;

color edgeColor = color(0,255);
color fillColor = color(255,0);

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
  background(0);
  tint(255, 126);
  image(cam,0,0);

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
  
  // edges.loadPixels();
  // for (int y=1; y<edges.height-1; y++) {
  //   for (int x=1; x<edges.width-1; x++) {
  //     boolean isolated = false;
  //     color k0 = edges.pixels[x + y * edges.width];
  //     color k1 = edges.pixels[(x+1) + (y) * edges.width];
  //     color k2 = edges.pixels[(x+1) + (y+1) * edges.width];
  //     color k4 = edges.pixels[x + (y+1) * edges.width];
  //     color[] npk = {k1, k2, k4};
  //     if (k0 == edgeColor) {
  //       for (int i=0; i<npk.length; i++) {
  //         if (npk[i] == fillColor) isolated = true;
  //       }
  //       if (isolated) edges.pixels[x+y*edges.width] = fillColor;
  //     } 
  //     // else if (k0 == fillColor) {
  //     //   for (int i=0; i<npk.length; i++) {
  //     //     if (npk[i] == edgeColor) isolated = true;
  //     //   }
  //     //   if (isolated) edges.pixels[x+y*edges.width] = edgeColor;
  //     // }
  //   }
  // }
  // edges.updatePixels();
  
  // ...new part ends here
  
  image(edges, 0, 0);
}
