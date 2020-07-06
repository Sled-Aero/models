magnet_h = 12.5;
magnet_r = 9.5;

fudge = 1.125;
holes = 24;
thick = 1.5;

connect = 0.35;

$fs = 0.01;
$fa=3;

// connectors
for (i = [1 : 2])
    for (j = [1 : 4]) {
        translate([12.5 - i * 25, 62.5 - j * 25, 0])
            translate([25,0,5])
                cylinder(h=connect, r1=connect, r2=connect);
    }
 
for (i = [1 : 1])
    for (j = [1 : 3]) {
        translate([12.5 - i * 25, 62.5 - j * 25, 0])
            translate([12.5,-12.5,5])
                cylinder(h=connect, r1=connect, r2=connect);
    } 

for (i = [1 : 3])
    for (j = [1 : 4]) {
        translate([50 - i * 25, 62.5 - j * 25, 0]) {
            rotate([0,0,22.5])  //22.5  
difference() {
    // arms
    difference() {
        translate([0,0,magnet_h/2]) {
            rotate([0,90,0]) {
                difference() {
                    cylinder(h=3, r=magnet_r * fudge + thick, center=true);
                    cylinder(h=3, r=magnet_r * fudge, center=true);
                
                    rotate([0,90,0]) 
                        for (i = [1 : holes] )
                        {
                            rotate(i * 360 / holes, [1, 0, 0])
                                translate([0, 0, 10])
                                    cylinder(h=4, r1=1, r2=1);
                        }
                }
            }

            rotate([0,0,0]) {
                difference() {
                    cylinder(h=3, r=magnet_r * fudge + thick, center=true);
                    cylinder(h=3, r=magnet_r * fudge, center=true);
                    
                    rotate([0,90,0]) 
                        for (i = [1 : holes] )
                        {
                            rotate(i * 360 / holes, [1, 0, 0])
                                translate([0, 0, 10])
                                    cylinder(h=4, r1=1, r2=1);
                        }
                }
            }
            
            rotate([90,0,0]) {
                difference() {
                    cylinder(h=3, r=magnet_r * fudge + thick, center=true);
                    cylinder(h=3, r=magnet_r * fudge, center=true);
                    
                    rotate([0,90,0]) 
                        for (i = [1 : holes] )
                        {
                            rotate(i * 360 / holes, [1, 0, 0])
                                translate([0, 0, 10])
                                    cylinder(h=4, r1=1, r2=1);
                        }
                }
            }
        }
        
        // mask
        translate([0,0,magnet_h - 0.1])
            cylinder(h=magnet_h + 10, r1=magnet_r - 0.8, r2=magnet_r + 25);
        translate([0,0,magnet_h + 0])
            cylinder(h=magnet_h + 10, r1=magnet_r - 0.2, r2=magnet_r);
    }
        
    
    // magnet
    difference() {
        translate([0,0,0]) {
            cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
            
            // hole
            translate([0,0,-10])
                cylinder(h=30, r1=1, r2=1);
        }
    }
}
}
}
