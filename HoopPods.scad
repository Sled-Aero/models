magnet_h = 12.5;
magnet_r = 9.5;

fudge = 1.125;
holes = 16;
hole_r = 1.5;
thick = 1.5;

connect = 0.6;

$fs = 0.01;
$fa=3;

// connectors
for (i = [1 : 2])
    for (j = [1 : 4]) {
        translate([12.5 - i * 25, 62.5 - j * 25, 0])
            translate([24,0,7])
                rotate([0,90,0])
                    cylinder(h=2, r1=connect, r2=connect);
    }

for (i = [0 : 2])
    for (j = [1 : 3]) {
        translate([12.5 - i * 25, 62.5 - j * 25, 0])
            translate([12.5,-11.5,7])
                rotate([90,0,0])
                    cylinder(h=2, r1=connect, r2=connect);
    }

for (i = [1 : 3])
    for (j = [1 : 4]) {
        translate([50 - i * 25, 62.5 - j * 25, 0]) {
            rotate([0,0,22.5])  
difference() {
    // arms
    difference() {
        translate([0,0,magnet_h/2]) {
            rotate([0,90,0]) {
                difference() {
                    cylinder(h=6, r=magnet_r * fudge + thick, center=true);
                    cylinder(h=6, r=magnet_r * fudge, center=true);
                
                    rotate([0,90,0]) 
                        for (i = [1 : holes] )
                        {
                            rotate(i * 360 / holes, [1, 0, 0])
                                translate([0, 0, 10])
                                    cylinder(h=4, r1=hole_r, r2=hole_r);
                        }
                }
            }

            rotate([0,0,0]) {
                difference() {
                    cylinder(h=6, r=magnet_r * fudge + thick, center=true);
                    cylinder(h=6, r=magnet_r * fudge, center=true);
                    
                    rotate([0,90,0]) 
                        for (i = [1 : holes] )
                        {
                            rotate(i * 360 / holes, [1, 0, 0])
                                translate([0, 0, 10])
                                    cylinder(h=4, r1=hole_r, r2=hole_r);
                        }
                }
            }
            
            rotate([90,0,0]) {
                difference() {
                    cylinder(h=6, r=magnet_r * fudge + thick, center=true);
                    cylinder(h=6, r=magnet_r * fudge, center=true);
                    
                    rotate([0,90,0]) 
                        for (i = [1 : holes] )
                        {
                            rotate(i * 360 / holes, [1, 0, 0])
                                translate([0, 0, 10])
                                    cylinder(h=4, r1=hole_r, r2=hole_r);
                        }
                }
            }
        }
        
        // mask
        translate([0,0,magnet_h + 11])
            cylinder(h=magnet_h + 10, r1=magnet_r + 10, r2=magnet_r + 1);
        translate([0,0,magnet_h + 0])
            cylinder(h=magnet_h + 10, r1=magnet_r - 1, r2=magnet_r + 20);
       
    }
        
    
    // magnet
    difference() {
        translate([0,0,0]) {
            cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
            
            // hole
            translate([0,0,-10])
                cylinder(h=30, r1=hole_r, r2=hole_r);
        }
    }
}
}
}
