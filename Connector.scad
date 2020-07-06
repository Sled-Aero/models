sleeve = 9;
tolerance = 0.00;
connect = 0.48;

$fs = 0.01;
$fa=3;

// connectors
for (i = [1 : 2])
    for (j = [1 : 4]) {
        translate([i * 5, j * 5, 0])
            translate([2.5,0,0])
                cylinder(h=connect, r1=connect, r2=connect);
    }
    
for (i = [1 : 1])
    for (j = [1 : 3]) {
        translate([i * 5, j * 5, 0])
            translate([5,2.5,0])
                cylinder(h=connect, r1=connect, r2=connect);
    }
        
// parts
for (i = [1 : 3])
    for (j = [1 : 4]) {
        translate([i * 5, j * 5, 0]) {            
            difference() {
                // sleeve
                cylinder(h=sleeve, r1=2.05, r2=2.05);

                // sleeve hole
                translate([0,0,sleeve/2]) {
                    cylinder(h=sleeve/2, r1=1.25 + tolerance, r2=1.27 + tolerance);
                }
                translate([0,0,0]) {
                    cylinder(h=sleeve/2, r1=1.27 + tolerance, r2=1.25 + tolerance); 
                }   

                // nubbins       
                translate([0, 0, sleeve/2 - sleeve/3])
                    rotate_extrude() {
                        translate([1.1,0]) 
                            circle(0.25 + tolerance/2);
                    } 
                translate([0, 0, sleeve/2 + sleeve/3])
                    rotate_extrude() {
                        translate([1.1,0]) 
                            circle(0.25 + tolerance/2);
                    }   
             
                // magnet hole
                rotate([90,0,30]) {
                    translate([0,sleeve/2,-10])
                        cylinder(h=20, r1=1, r2=1);
                    } 
                } 
            }
        }

            
  