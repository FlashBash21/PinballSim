
public class InputParser {
  String[] input;
  
  private int numBalls;
  private int numLines;
  private int numBLines;
  private int numObs;
  private int numZones;
  
  private Vec2 lp1[];
  private Vec2 lp2[];
  
  private Vec2 blp1[];
  private Vec2 blp2[];
  
  private Vec2 zone_p[];
  private Vec2 zone_d[];
  private int zone_s[];
  
  Vec2 obs_pos[];
  float[] obs_r;
  
  public InputParser(String name) {
    input = loadStrings(name + ".txt");
    if (input == null) {
      println("Parsing Failed: File not found");
      exit();
    }
    
    parseAllObjects();
    
  }
  
  private float getParsedRatio(String[] nd) {
    if (nd.length == 1) return Float.parseFloat(nd[0]);
    else {
      float r = Float.parseFloat(nd[0]) / Float.parseFloat(nd[1]);
      return r;
    }
  }
  
  private void parseAllObjects() {
    int i = 1; //start at first object data
    while (i < input.length) {
      String[] input_bits = input[i].split(":");
      String object = input_bits[0];
      int num_objects = Integer.parseInt(input_bits[1]);
      
      
      
      if (object.equals("LINES")) {
        println("Lines read: " + num_objects); //<>//
        this.lp1 = new Vec2[num_objects];
        this.lp2 = new Vec2[num_objects];
        
        this.numLines = num_objects;
        
        for(int j = 0; j < num_objects; j++) {
          i++;
          input_bits = input[i].split(" ");
          this.lp1[j] = new Vec2(
                                  width * getParsedRatio(input_bits[0].split("/")), //<>//
                                  height * getParsedRatio(input_bits[1].split("/"))
                                 );
          this.lp2[j] = new Vec2(
                                  width * getParsedRatio(input_bits[2].split("/")),
                                  height * getParsedRatio(input_bits[3].split("/"))
                                 );
        }
        
        
      } else if (object.equals("OBSTACLES")) {
        println("Obstacles read: " + num_objects);
        this.obs_pos = new Vec2[num_objects];
        this.obs_r = new float[num_objects];
        
        this.numObs = num_objects;
        
        for(int j = 0; j < num_objects; j++) {
          i++;
          input_bits = input[i].split(" ");
          this.obs_pos[j] = new Vec2(
                                      width * getParsedRatio(input_bits[0].split("/")),
                                      height * getParsedRatio(input_bits[1].split("/"))
                                     );
          this.obs_r[j] = getParsedRatio(input_bits[2].split("/"));
        }
        
        
      } else if (object.equals("BALLS")) {
        this.numBalls = num_objects;
      } else if (object.equals("ZONES")) {
        this.numZones = num_objects;
        this.zone_p = new Vec2[num_objects];
        this.zone_d = new Vec2[num_objects];
        this.zone_s = new int[num_objects];
        
        for(int j = 0; j < num_objects; j++) {
          i++;
          input_bits = input[i].split(" ");
          this.zone_p[j] = new Vec2(
                                 width * getParsedRatio(input_bits[0].split("/")),
                                 height * getParsedRatio(input_bits[1].split("/"))
                                );
          this.zone_d[j] = new Vec2(
                                 height * getParsedRatio(input_bits[2].split("/")),
                                 height * getParsedRatio(input_bits[3].split("/"))
                                );
          this.zone_s[j] = (int)(getParsedRatio(input_bits[4].split("/")));
        }
        
      } else if (object.equals("BOUNCYLINES")) {
        this.blp1 = new Vec2[num_objects];
        this.blp2 = new Vec2[num_objects];
        
        this.numBLines = num_objects;
        
        for(int j = 0; j < num_objects; j++) {
          i++;
          input_bits = input[i].split(" ");
          this.blp1[j] = new Vec2(
                                  width * getParsedRatio(input_bits[0].split("/")),
                                  height * getParsedRatio(input_bits[1].split("/"))
                                 );
          this.blp2[j] = new Vec2(
                                  width * getParsedRatio(input_bits[2].split("/")),
                                  height * getParsedRatio(input_bits[3].split("/"))
                                 );
        }
      } else {
        println("Parsing Error: Failed to read in object \"" + object + "\". Check your formating and try again.") ;
        exit();
      }
      
      i++; //jump to next object line
    }
  }
  
  public Vec2[] getLinePos1() {
    return this.lp1;
  }
  
  public Vec2[] getLinePos2() {
    return this.lp2;
  }
  
  public Vec2[] getBLinePos1() {
    return this.blp1;
  }
  
  public Vec2[] getBlinePos2() {
    return this.blp2;
  }
  
  public Vec2[] getObsPos() {
    return this.obs_pos;
  }
  
  public Vec2[] getZonePos() {
    return this.zone_p;
  }
  
  public Vec2[] getZoneDim() {
    return this.zone_d;
  }
  
  public float[] getObsR() {
    return this.obs_r;
  }
  
  public int[] getZoneScore() {
    return this.zone_s;
  }
  
  public int getNumBalls() {
    return this.numBalls;
  }
  
  public int getNumObs() {
    return this.numObs;
  }
  
  public int getNumLines() {
    return this.numLines;
  }
  
  public int getNumBLines() {
    return this.numBLines;
  }
  
  public int getNumZones() {
    return this.numZones;
  }
}
