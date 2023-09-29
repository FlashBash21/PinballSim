/*import java.util.List;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;

String[] input;
List<Circle> circles;
List<Line> lines;
List<Box> boxes;


void setup() {
  size(1024,768);

  for (int task = 1; task <= 10; task++) {

    circles = new ArrayList<>();
    lines = new ArrayList<>();
    boxes = new ArrayList<>();

    //load in task file (doing it manually because im lazy)
    input = loadStrings("../tasks/task" + task + ".txt");


    int i = 0;
    //read in objects
    while (i < input.length) {

      //read in the object name and amount
      String[] pieces = split(input[i], " ");
      int num_objects = parseInt(pieces[1]);
      pieces = split(pieces[0], ":");
      String object = pieces[0];

      i+=2; //skip to object data


      //read in objects
      for (int j = 0; j < num_objects; j++) {
        //read in circles
        if (object.equals("Circles")) {
          pieces = split(input[i], " ");

          int id = parseInt(pieces[0]);
          float x = parseFloat(pieces[2]);
          float y = parseFloat(pieces[3]);
          float r = parseFloat(pieces[4]);

          Circle c = new Circle(x, y, r, id);

          circles.add(c);
        } else if (object.equals("Lines")) {
          pieces = split(input[i], " ");

          int id = parseInt(pieces[0]);
          float x1 = parseFloat(pieces[2]);
          float y1 = parseFloat(pieces[3]);
          float x2 = parseFloat(pieces[4]);
          float y2 = parseFloat(pieces[5]);

          Line l = new Line(x1, y1, x2, y2, id);

          lines.add(l);
        } else if (object.equals("Boxes")) {
          pieces = split(input[i], " ");

          int id = parseInt(pieces[0]);
          float x = parseFloat(pieces[2]);
          float y = parseFloat(pieces[3]);
          float w = parseFloat(pieces[4]);
          float h = parseFloat(pieces[5]);

          Box b = new Box(x, y, w, h, id);

          boxes.add(b);
        }

        i++; //move to next line
      }
    }

    Collisions collisions = new Collisions(boxes, circles, lines);


    long start = System.nanoTime();
    Set<Integer> ids = collisions.detectAllCollisions();
    long end = System.nanoTime();
    long total_time = end-start;


    PrintWriter output = createWriter("../solutions/task" + task + "_solution.txt");
    output.println("Duration: " + total_time/1000000.0 + " ms");
    output.println("Num Collisions: " + ids.size());
    output.flush();

    for (int id : ids) {
      output.println(id);
      output.flush();
    }
    output.close();
  }
  exit();
}

void draw() {
  float scale = 60;
  stroke(0,0,0);
  fill(0,0,255);
  for(Circle i : circles) {
    circle(scale * i.x, scale * i.y, scale * i.r);
  }
  fill(0,255,0);
  for(Box i : boxes) {
    rect(scale * i.x, scale * i.y, scale * i.w, scale * i.h);
  }
  
  for(Line i : lines) {
    line(scale * i.x1,scale * i.y1,scale * i.x2,scale * i.y2);
  }

*/
