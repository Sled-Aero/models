magnets = 35;
magnet_h = 2;
magnet_r = 1.95;
rod_length = 72;
rod_width = 4.5;
rod_depth = 3;
teeth = 24;

$fs = 0.01;
$fa=3;
$fn=100;

module knob(grooves, diameter, taper) {
  for (i = [0 : (grooves-1)] ) {
    rotate(i * 360 / grooves, [1, 0, 0])
      rotate([0,90,0]) 
        linear_extrude(height=4, center=false, convexity = 10, scale=taper)
          circle(diameter,$fn=4);
  }
}

difference() {
    // plate
    translate([2, 0, 0])
      cube([3,40,40], true);
      
    // holes
    dim = 3;
    step = 7;  
    for (i = [1-dim : dim-1] ) {
       for (j = [1-dim : dim-1] ) {
           x = step * i;
           y = step * j + (i % 2 * step / 2);
           translate([0, x, y])
               if (y > -17 && y < 17)
                   knob(teeth,2.5,0.95); 
           
       }
   }
}