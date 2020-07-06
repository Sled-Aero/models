struts = 3;
magnet_h = 12.5;
magnet_r = 9.5;
magnet_gap = 50; 
radius = magnet_gap; // https://en.wikipedia.org/wiki/Hexagon

pod_fudge = 1.125;
pod_holes = 24;
pod_thick = 1.5;

ring_holes = 60;
ring_thick = 1.5;
tolerance = 0.1;

$fs = 0.01;
$fa=3;

difference() {
    translate([0,0,0]) {         
        // struts
        rotate([0,90,90]) 
            for (i = [1 : struts])
            {
                rotate(i * 360/struts, [1, 0, 0])
                    translate([0, radius, 0])
                        difference() {
                            cylinder(h=3.5, r=magnet_r * pod_fudge + pod_thick + ring_thick + tolerance, center=true);
                            cylinder(h=3.5, r=magnet_r * pod_fudge + ring_thick + tolerance, center=true);
                        
                            rotate([0,90,0]) 
                                for (i = [1 : pod_holes] ) {
                                    rotate(i * 360 / pod_holes, [1, 0, 0])
                                        translate([0, 0, 10 + 2])
                                            cylinder(h=4.5, r1=1, r2=1);
                                }
                        }
            
            }
           
        // outer ring
        difference() {
            cylinder(h=3, r=radius+magnet_r * pod_fudge + pod_thick + ring_thick, center=true);
            cylinder(h=3, r=radius+magnet_r * pod_fudge + pod_thick , center=true);
        
            rotate([0,90,0]) 
                for (i = [1 : ring_holes]) {
                    rotate(i * 360 / ring_holes, [1, 0, 0])
                        translate([0, 0, radius + magnet_r * pod_fudge + 1])
                            cylinder(h=4, r1=1, r2=1);
                }
        }
        
        
        // inner ring
        difference() {
            cylinder(h=3, r=radius-magnet_r * pod_fudge - pod_thick, center=true);
            
            cylinder(h=3, r=radius-magnet_r * pod_fudge - pod_thick - ring_thick, center=true);
        
            rotate([0,90,0]) 
                for (i = [1 : ring_holes]) {
                    rotate(i * 360 / ring_holes, [1, 0, 0])
                        translate([0, 0, radius - magnet_r * pod_fudge - pod_thick - 3])
                            cylinder(h=4, r1=1, r2=1);
                }
        }
    } 
}