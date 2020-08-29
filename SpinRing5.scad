thick = 5;
gap = 2;
magnet_h = 12.0;
magnet_r = 9.5;
magnet_gap = 46;
radius = magnet_gap; 
height = magnet_h + 4;
disc_h = 3;
magnets = 10;
spin = 8;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);


difference() {
    // ring
    rotate_extrude() {
      translate([radius-magnet_r/2,0]) 
         circle(2);
    } 

    // holes
    rotate([0,90,0]) {        
        for (j = [1 : spin * magnets]) {
            rotate(j * 360 / spin / magnets, [1, 0, 0]) {
                translate([0, radius-magnet_r/2, 0]) {
                    rotate([90,0,j * 180 / spin]) {
                        translate([0, 0, -5])
                            cylinder(h=10, r1=1, r2=1);
                    }
                    rotate([90,0,90 + j * 180 / spin]) {
                        translate([0, 0, -5])
                            cylinder(h=10, r1=1, r2=1);
                    }
                }
            }
        }
    }      
}

