plate_width = 132;
plate_height = 30;
teeth = 24;

$fs = 0.01;
$fa=3;
//$fn=100;

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
      cube([3,plate_width,plate_height], true);
      
    // centre row
    step = 5; 
    inc = 6;

    x = 0;
    first_x = step - plate_width/2;
    first_y = sqrt(step * step * 0.75);
    for (i = [0 : 16] ) {
        x = first_x + (step + i/inc) * i;
        next_x = first_x + (step + (i+1)/inc) * (i+1);
        echo("x=", x);
        echo("step_x=", next_x - x);
        y = next_x - x;
        translate([0, x, 0])
            knob(teeth,2.5,0.95); 
        
        for (j = [0 : 1] ) {
            translate([0, x + y/2, 3*step/4 * j + step/4 + first_y-i/inc])
                if (x < plate_width/2-step)
                    knob(teeth,2.5,0.95); 
        }
            
        for (j = [0 : 1] ) {    
            translate([0, x + y/2, -3*step/4 * j - first_y+i/inc])
                if (x < plate_width/2-step)
                    knob(teeth,2.5,0.95);  
        }  
    }
}