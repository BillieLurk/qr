import java.io.File;

ArrayList<PImage> half = new ArrayList<PImage>();
ArrayList<PImage> full = new ArrayList<PImage>();

int count = 0;
int halfSize = 500;
int fullSize = 1000;


PGraphics base;


void setup() {
    System.out.println("Loading images...");
    size(1000, 1000);
    half = loadImagesFromFolder("C:/Users/bill/Desktop/Code/qr/QR-Code_500x500px_Black");
    full = loadImagesFromFolder("C:/Users/bill/Desktop/Code/qr/QR-Code_1000x1000px_Multicolor");
    base = createGraphics(1000, 1000);
    System.out.println("Done loading images.");
    frameRate(1);
}



void draw() {
    PGraphics pg = createQR(width, height, true);
    pg.save("qr" + count + ".png");
    image(pg, 0, 0, 1000, 1000);
    count++;
}

PGraphics createQR(int width, int height, boolean recure) {
    PGraphics pg = createGraphics(width, height);
    background(255);
    pg.beginDraw();
    pg.background(255,255,255,0);
    for (int z = 0; z < 4; z++) {
        int i = (int) random(0, half.size());
        
        int x = z % 2;
        int y = z / 2;
        
        int r = (int) random(0, 4);
        if (r < 1 && recure && width > 100) {
            pg.image(createQR(width / 2, height / 2, true), x * width / 2, y * height / 2, width / 2, width / 2);
        } else {
            pg.image(half.get(i), x * width / 2, y * height / 2, width / 2, height / 2);
        }
        
        
    }
    int r = (int) random(0, 4 * 1000 / width);
    if (r <= 1) {
        pg.image(full.get((int) random(0, full.size())), 0, 0, width, height);
        
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