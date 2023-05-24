/* autogenerated by Processing revision 1292 on 2023-05-23 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import java.io.File;
import processing.svg.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class qr extends PApplet {




ArrayList<PImage> half = new ArrayList<PImage>();
ArrayList<PImage> fullOverlay = new ArrayList<PImage>();
ArrayList<PImage> halfOverlay = new ArrayList<PImage>();

ArrayList<PShape> halfSVG = new ArrayList<PShape>();
ArrayList<PShape> fullOverlaySVG = new ArrayList<PShape>();
ArrayList<PShape> halfOverlaySVG = new ArrayList<PShape>();

int count = 0;
int halfSize = 500;
int fullSize = 1000;

int size = 1; //1, 2, 3,
String type = "svg"; //png, svg

String halfPng = "C:/Users/bill/Desktop/Code/qr/500x500px";
String fullOverlayPng = "C:/Users/bill/Desktop/Code/qr/1000x1000_overlay";
String halfOverlayPng = "C:/Users/bill/Desktop/Code/qr/500x500_overlay";

String halfSvg = "C:/Users/bill/Desktop/Code/qr/500x500_SVG";
String fullOverlaySvg = "C:/Users/bill/Desktop/Code/qr/1000x1000_Overlay_SVG";
String halfOverlaySvg = "C:/Users/bill/Desktop/Code/qr/500x500_Overlay_SVG";

PGraphics base;
PShape baseSvg;


public void setup() {
    System.out.println("Loading images...");
    /* size commented out by preprocessor */;
    if (type.equals("png")) {
        half = loadImagesFromFolder(halfPng);
        fullOverlay = loadImagesFromFolder(fullOverlayPng);
        halfOverlay = loadImagesFromFolder(halfOverlayPng);
        
    } else if (type.equals("svg")) {
        halfSVG = loadSVGsFromFolder(halfSvg);
        fullOverlaySVG = loadSVGsFromFolder(fullOverlaySvg);
        halfOverlaySVG = loadSVGsFromFolder(halfOverlaySvg);
    }
    base = createGraphics(1000, 1000);
    System.out.println("Done loading images.");
    frameRate(1);
}



public void draw() {
    
    PGraphics pg = null;
    
    if (type.equals("png")) {
        
        if (size == 1) {
            pg = createSmallQR(width, height);
        } else {
            pg = createQR(width, height, true);
        }
        if (size == 1) {
            pg.save("./" + type + "S/qr" + count + "." + type);
        } else if (size == 2) {
            pg.save("./" + type + "M/qr" + count + "." + type);
        } else if (size == 3) {
            pg.save("./" + type + "L/qr" + count + "." + type);
        }
        image(pg, 0, 0, 1000, 1000);
        count++;
    } else {
        
        PShape svg = null;
        if (size == 1) {
            svg = createSmallQRSvg(width, height);
            pg = createGraphics(width, height, SVG, "./" + type + "S/qr" + count + "." + type);
        } else {
            // ... create the SVG for other sizes ...
        }
        
        // Create the SVG file
        String filename;
        if (size == 1) {
            filename = "./" + type + "S/qr" + count + "." + type;
        } else if (size == 2) {
            filename = "./" + type + "M/qr" + count + "." + type;
        } else if (size == 3) {
            filename = "./" + type + "L/qr" + count + "." + type;
        } else {
            throw new RuntimeException("Invalid size: " + size);
        }
        
        pg.beginDraw();
        pg.shape(svg, 0, 0, 1000, 1000);
        pg.endDraw();
        pg.dispose(); // this is necessary to actually write the SVG file
        
        shape(svg, 0, 0, 1000, 1000);
        count++;
    }
}

public PShape createSmallQRSvg(int width, int height) {
    PShape svg = createShape(GROUP);

    System.out.println("Creating small QR: " + halfSVG.size());
    int i = (int) random(0, halfSVG.size());
    PShape img = halfSVG.get(i);
    img.scale(width/img.width, height/img.height);
    svg.addChild(img);

    int r = (int) random(0, 4);
    if (r == 3) {
        PShape overlay = fullOverlaySVG.get((int) random(0, fullOverlaySVG.size()));
        overlay.scale(width/overlay.width, height/overlay.height);
        svg.addChild(overlay);
    }

    return svg;
}




public PGraphics createSmallQR(int width, int height) {
    PGraphics pg = createGraphics(width, height);
    background(255);
    
    pg.beginDraw();
    System.out.println("Creating small QR: " + half.size());
    int i = (int) random(0, half.size());
    PImage img = half.get(i);
    pg.image(img, 0, 0, width, height);
    
    int r = (int) random(0, 4);
    if (r >= 2) {
        pg.image(fullOverlay.get((int) random(0, fullOverlay.size())), 0,0, width, height);
    }
    pg.endDraw();
    return pg;
}

public PGraphics createQR(int width, int height, boolean recure) {
    PGraphics pg = createGraphics(width, height);
    background(255);
    pg.beginDraw();
    pg.background(255,255,255,0);
    
    boolean hasHalfOverlay = false;
    for (int z = 0; z < 4; z++) {
        
        int x = z % 2;
        int y = z / 2;
        
        int newHeight = height / 2;
        int newWidth = width / 2;
        
        int r = (int) random(0, 4);
        if (r < 1 && recure && width >= 500 && size == 3) {
            pg.image(
                createQR(newWidth, newHeight, false), 
                x * width / 2, y * height / 2, width / 2, width / 2);
            
        } else {
            pg.image(half.get((int) random(0, half.size())),
                x * width / 2, y * height / 2, width / 2, height / 2);
            
            int q = (int) random(0, 4);
            if (q == 3 && !hasHalfOverlay && size >= 2) {
                hasHalfOverlay = true;
                pg.image(halfOverlay.get((int) random(0, halfOverlay.size())), 
                    x * width / 2, y * height / 2, width / 2, height / 2);
            }
        }
    }
    
    int r = (int) random(0, 4 * 1000 / width);
    if (r <= 1) {
        pg.image(fullOverlay.get((int) random(0, fullOverlay.size()))
            , 0,0, width, height);
    }
    pg.endDraw();
    
    //draw the image
    //image(pg, 0, 0, 1000, 1000);
    // pg.save("qr" + count + ".png");
    return pg;
}



public ArrayList<PImage> loadImagesFromFolder(String folderPath) {
    File folder = new File(dataPath(folderPath));
    File[] listOfFiles = folder.listFiles();
    System.out.println(folderPath);
    
    //Filter outnon-image files
    ArrayList<File> imageFiles = new ArrayList<File>();
    for (File file : listOfFiles) {
        if (file.isFile() && file.getName().toLowerCase().endsWith(".png")) {
            imageFiles.add(file);
        }
    }
    
    ArrayList<PImage> images = new ArrayList<PImage>();
    for (int i = 0; i < imageFiles.size(); i++) {
        images.add(loadImage(imageFiles.get(i).getAbsolutePath()));
    }
    return images;
}

public ArrayList<PShape> loadSVGsFromFolder(String folderPath) {
    File folder = new File(dataPath(folderPath));
    File[] listOfFiles = folder.listFiles();
    System.out.println(folderPath);
    
    // Filter out non-SVG files
    ArrayList<File> svgFiles = new ArrayList<File>();
    for (File file : listOfFiles) {
        if (file.isFile() && file.getName().toLowerCase().endsWith(".svg")) {
            svgFiles.add(file);
        }
    }
    System.out.println(svgFiles.size());
    
    ArrayList<PShape> svgs = new ArrayList<PShape>();
    for (int i = 0; i < svgFiles.size(); i++) {
        PShape svg = loadShape(svgFiles.get(i).getAbsolutePath()); // Use loadShape() function
        svgs.add(svg);
    }
    return svgs;
}


  public void settings() { size(1000, 1000); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "qr" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
