import java.io.File;
import processing.svg.*;

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


void setup() {
    System.out.println("Loading images...");
    size(1000, 1000);
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



void draw() {
    PGraphics pg;
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
}

PGraphics createSmallQR(int width, int height) {
    PGraphics pg = createGraphics(width, height);
    background(255);
    pg.beginDraw();
    System.out.println("Creating small QR: " + half.size());
    int i = (int) random(0, half.size());
    PImage img = half.get(i);
    pg.image(img, 0, 0, width, height);
    
    int r = (int) random(0, 4);
    if (r == 3) {
        pg.image(fullOverlay.get((int) random(0, fullOverlay.size())), 0,0, width, height);
    }
    pg.endDraw();
    return pg;
}

PGraphics createQR(int width, int height, boolean recure) {
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



ArrayList<PImage> loadImagesFromFolder(String folderPath) {
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

ArrayList<PShape> loadSVGsFromFolder(String folderPath) {
    File folder = new File(dataPath(folderPath));
    File[] listOfFiles = folder.listFiles();
    System.out.println(folderPath);
    
    //Filter outnon-image files
    ArrayList<File> svgFiles = new ArrayList<File>();
    for (File file : listOfFiles) {
        if (file.isFile() && file.getName().toLowerCase().endsWith(".svg")) {
            svgFiles.add(file);
        }
    }
   System.out.println(svgFiles.size());

    ArrayList<PShape> svgs = new ArrayList<PShape>();
    for (int i = 0; i < svgFiles.size(); i++) {
        System.out.println(svgFiles.get(i).getAbsolutePath());
        PShape svg = loadShape("C:/Users/bill/Desktop/Code/qr/500x500_SVG/Bungie_Single_Black_500x500-01.svg");
        svgs.add(svg);
    }
    return svgs;
}