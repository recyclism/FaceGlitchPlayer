/*
 Processing video player + Corrupt.video + OpenCV Face Tracking = FaceGLitching
 Made with Processing by Recyclism aka Benjamin Gaulon
 Paris. May 2014.
 Fill free to use / hack / modify this code
*/

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Movie myMovie;
OpenCV opencv;

PImage photo;
PImage faceSave;

String fileName = "partialSave"; // You file name here (should be in the DATA Folder)
String fileExt = ".jpg"; // file extansion (works best with JPG or PNG)


void setup() {
  background(0);
  size(320, 180);

  // video = new Capture(this, width, height);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  
  myMovie = new Movie(this, "test.3gp");
  myMovie.play();

}

void draw() {
  scale(1);
  opencv.loadImage(myMovie);
  image(myMovie, 0, 0);
  noFill();
  noStroke();
//  strokeWeight(1);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {

    photo = loadImage(fileName + fileExt);

    println(faces[i].x + "/" + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);

    PImage partialSave = get(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  
    partialSave.save(fileName + fileExt);

  //  partialSave.save(fileName + i + fileExt);

    byte b[] = loadBytes(fileName + fileExt);

    // glitch faces

    byte bCopy[] = new byte[b.length];
    arrayCopy(b, bCopy);
    // load binary of file

    int scrambleStart = 5;
    // scramble start excludes 10 bytes///

    int scrambleEnd = b.length;
    // scramble end ///

    int nbOfReplacements = int (random(1, 10));
    // Number of Replacements - Go easy with this as too much will just kill the file ///

    // Swap bits ///
    for (int g = 0; g < nbOfReplacements; g++)

    {
      int PosA = int(random (scrambleStart, scrambleEnd));

      int PosB = int(random (scrambleStart, scrambleEnd));

      byte tmp = bCopy[PosA];

      bCopy[PosA] = bCopy[PosB];

      bCopy[PosB] = tmp;

      saveBytes(fileName + fileExt, bCopy);
    }


    image(photo, faces[i].x, faces[i].y, faces[i].width, faces[i].height );
  //  saveFrame("####.jpg");
  }
}


void movieEvent(Movie m) {
  m.read();
}
