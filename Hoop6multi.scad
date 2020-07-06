thick = 5;

magnets = 12;
magnet_h = 12.5;
magnet_r = 9.5;
magnet_gap = 52.5;
radius = magnet_gap; // https://en.wikipedia.org/wiki/Hexagon
height = magnet_h + 4;
disc_h = 2;
span = 27;
sleeve = 9;
gap = 3;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    translate([0,0,0]) {
        // struts
        rotate([0,90,90]) 
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets + 15, [1, 0, 0])
                translate([0, radius-thick/2, disc_h/2])
                rotate([180,0,0]) {
                    difference() {
                        cylinder(h=disc_h, r1=11, r2=11);
                        
                        // hole
                        translate([0,0,-10])
                            cylinder(h=30, r1=6.5, r2=6);
                    }
                }
            } 

        // spans
        rotate([0,90,0]) 
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([-8.5, radius-3, -span/2])
                    rotate([0,0,90]) {
                        difference() {
                            cylinder(h=span, r1=2, r2=2);
                            
                            // sleeve
                            translate([0, 0, span/2 - sleeve/2])
                                difference() {
                                    cylinder(h=sleeve, r1=2.5, r2=2.5);
                                    cylinder(h=sleeve, r1=1.25, r2=1.25);
                                }
                                
                            // gap
                            translate([0, 0, span/2 - sleeve/6])    
                                rotate([0,0,90]) {
                                    cylinder(h=sleeve/3, r1=3, r2=3);
                                }      
                        }
                        
                        // nubbins
                        translate([0, 0, span/2-3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            } 
                        translate([0, 0, span/2+3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            }     
                    }   
            }
        rotate([0,90,0]) 
            for (i = [1 : magnets] )
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([8.5, radius-3, -span/2])
                    rotate([0,0,90]) {
                        difference() {
                            cylinder(h=span, r1=2, r2=2);
                            
                            // sleeve
                            translate([0, 0, span/2 - sleeve/2])
                                difference() {
                                    cylinder(h=sleeve, r1=2.5, r2=2.5);
                                    cylinder(h=sleeve, r1=1.25, r2=1.25);
                                }
                                
                            // gap
                            translate([0, 0, span/2 - sleeve/6])    
                                rotate([0,0,90]) {
                                    cylinder(h=sleeve/3, r1=3, r2=3);
                                }      
                        }
                        
                        // nubbins
                        translate([0, 0, span/2-3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            } 
                        translate([0, 0, span/2+3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            }     
                    }   
            }
    }
    
    // mask  
    rotate([0,90,90]) 
        for (i = [1 : magnets-1])
        {
            rotate(i * 360/magnets - 15, [1, 0, 0])
            translate([0, radius-thick/2, 12])
                rotate([180,0,0]) {
                    cylinder(h=24, r1=12, r2=12);
                }
        }

    // magnets   
   /*
    translate([0,0,0]) {
        rotate([0,90,90]) 
            for (i = [0 : (magnets-1)])
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([-magnet_h/2, radius-2, 0])
                rotate([90,0,90]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=30, r1=1, r2=1);
                }
            } 
         
        rotate([0,90,0]) 
            for (i = [0 : (magnets-1)])
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([-magnet_h/2-3, radius-2-3, 0])
                rotate([90,0,-30]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=30, r1=1, r2=1);
                }
            }
            
        rotate([0,90,0]) 
            for (i = [0 : (magnets-1)])
            {
                rotate(i * 360 / magnets, [1, 0, 0])
                translate([magnet_h/2+3, radius-2-3, 0])
                rotate([90,0,30]) {
                    cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                    
                    // hole
                    translate([0,0,-10])
                        cylinder(h=30, r1=1, r2=1);
                }
            }        
            
    } */
}