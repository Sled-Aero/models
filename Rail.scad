magnets = 35;
magnet_h = 2;
magnet_r = 1.97;
rod_length = 73;
rod_width = 6;
rod_depth = 4;
teeth = 24;

$fs = 0.01;
$fa=3;

module knob(grooves, diameter, taper) {
  for (i = [0 : (grooves-1)] ) {
    rotate(i * 360 / grooves, [1, 0, 0])
      rotate([0,90,0]) 
        linear_extrude(height=4, center=false, convexity = 10, scale=taper)
          circle(diameter,$fn=4);
  }
}

union() {
  translate([rod_length/2, 0, 0]) {        
    knob(teeth,2.5,0.95);
  }
  translate([-rod_length/2, 0, 0]) {
    rotate([0, 0, 180]) {
      knob(teeth,2.5,0.95);
    }
  }
  difference() {
    // rod
    cube([rod_length,rod_width,rod_depth], true);
    
    // magnet holes
    translate([0,-magnet_r,-0.7]) // 0.5 + lip
        for (i = [0 : (magnets-1)] )
        {
            start = (magnet_r * (magnets/2-0.5));
            translate([start - (i * magnet_r), magnet_h, 0]) {
                cylinder(h=magnet_h, r=magnet_r);
            }
        }
        
    // retaining lips
    translate([0,-magnet_r,0])
        for (i = [0 : (magnets-1)] )
        {
            start = (magnet_r * (magnets/2-0.5));
            translate([start - (i * magnet_r), magnet_h, 0]) {
                cylinder(h=magnet_h, r=magnet_r-0.1); // rim
            }
        }
           
    // poky holes  
    translate([0,-magnet_r,-4])
        for (i = [0 : (magnets-1)] )
        {
            start = (magnet_r * (magnets/2-0.5));
            translate([start - (i * magnet_r), magnet_h, 0]) {
                cylinder(h=magnet_h * 3, r=0.5); // holes
            }
        }

    }
}