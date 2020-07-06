thick = 5;

magnets = 10;
magnet_h = 12.5;
magnet_r = 9.5;
magnet_gap = 46;
radius = magnet_gap; // https://en.wikipedia.org/wiki/Hexagon
height = magnet_h + 4;
disc_h = 2;
span = 28;
sleeve = 18;
gap = 12;
holes = 12;

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
                rotate((i-7) * 360/magnets, [1, 0, 0])
                    translate([0, radius, disc_h/2])
                        rotate([180,0,0]) {
                            difference() {
                                cylinder(h=disc_h, r1=magnet_r+1.5, r2=magnet_r+1.5);
                                
                                // centre hole
                                translate([0,0,-10])
                                    cylinder(h=30, r1=6.5, r2=6);
                           
                                /*
                                translate([0,0,-1]) {
                                    // spoke holes
                                    for (j = [3 : holes/2])
                                        rotate((j + 2) * 360/holes - 15, [0, 0, 1])
                                            translate([0, 8.6, 0])
                                                cylinder(h=4, r1=1.7, r2=1.7);
                                    
                                    for (j = [2 : holes/2])
                                        rotate((j + 8) * 360/holes, [0, 0, 1])
                                            translate([0, 8.6, 0])
                                                cylinder(h=4, r1=1.7, r2=1.7);
                                }
                                */
                            }
                            
                        }
            } 
           
        // rings 
         /*   
        difference() {
            cylinder(h=3, r=radius+magnet_r+1.5, center=true);
            cylinder(h=3, r=radius+magnet_r, center=true);
        }
        difference() {
            cylinder(h=3, r=radius-magnet_r, center=true);
            cylinder(h=3, r=radius-magnet_r-1.5, center=true);
        }    */  

        // spans
        rotate([0,90,0]) {
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
                            translate([0, 0, span/2 - gap/2])    
                                rotate([0,0,90]) {
                                    difference() {
                                        cylinder(h=gap, r1=3, r2=3);
                                                                               
                                        //if (i > 7 || i == 1)
                                        //    cylinder(h=gap, r1=0.3, r2=0.3);
                                    }
                                }      
                        }
                        
                        // nubbins
                        translate([0, 0, span/2 - gap/2 - 1.5])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            } 
                        translate([0, 0, span/2 + gap/2 + 1.5])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            }     
                    }   
            }
            
            for (i = [1 : magnets])
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
                            translate([0, 0, span/2 - gap/2])    
                                rotate([0,0,90]) {
                                    difference() {
                                        cylinder(h=gap, r1=3, r2=3);
                                        
                                        //if (i > 7 || i == 1)
                                        //    cylinder(h=gap, r1=0.3, r2=0.3);
                                    }
                                }    
                        }
                        
                        // nubbins
                        translate([0, 0, span/2 - gap/2 - 1.5])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            } 
                        translate([0, 0, span/2 + gap/2 + 1.5])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            }     
                    }   
            }    
            
            // inner
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([0, radius-12.5, 3-span/2])
                    rotate([0,0,90]) {
                        difference() {
                            cylinder(h=span-6, r1=2, r2=2);
                            
                            // sleeve
                            translate([0, 0, span/2 - sleeve/2 -3])
                                difference() {
                                    cylinder(h=sleeve, r1=2.5, r2=2.5);
                                    cylinder(h=sleeve, r1=1.25, r2=1.25);
                                }
                             
                            // gap
                            translate([0, 0, span/2 - gap/2 - 3])    
                                rotate([0,0,90]) {
                                    difference() {
                                        cylinder(h=gap, r1=3, r2=3);
                                        
                                        //if (i > 7 || i == 1)
                                        //    cylinder(h=gap, r1=0.3, r2=0.3);
                                    }
                                }    
                        }
                        
                        // nubbins
                        translate([0, 0, span/2 - gap/2 - 1.5 -3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            } 
                        translate([0, 0, span/2 + gap/2 + 1.5 -3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            }     
                    }   
            }
            
            // outer
            for (i = [1 : magnets])
            {
                rotate(i * 360/magnets, [1, 0, 0])
                translate([0, radius+3.7, -span/2-3])
                    rotate([0,0,90]) {
                        difference() {
                            cylinder(h=span + 6, r1=2, r2=2);
                            
                            // sleeve
                            translate([0, 0, span/2 - sleeve/2+3])
                                difference() {
                                    cylinder(h=sleeve, r1=2.5, r2=2.5);
                                    cylinder(h=sleeve, r1=1.25, r2=1.25);
                                }
                             
                            // gap
                            translate([0, 0, span/2 - gap/2 + 3])    
                                rotate([0,0,90]) {
                                    difference() {
                                        cylinder(h=gap, r1=3, r2=3);
                                        
                                        //if (i > 7 || i == 1)
                                        //    cylinder(h=gap, r1=0.3, r2=0.3);
                                    }
                                }    
                        }
                        
                        // nubbins
                        translate([0, 0, span/2 - gap/2 - 1.5 + 3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            } 
                        translate([0, 0, span/2 + gap/2 + 1.5 +3])
                            rotate_extrude() {
                              translate([1.1,0]) 
                                 circle(0.25);
                            }     
                    }   
            }
        } 
    }
    
    // mask  
    /*
    rotate([0,90,90]) 
        for (i = [1 : magnets/2])
        {
            rotate((i-6) * 360/magnets, [1, 0, 0])
            translate([0, radius-thick/2, 13])
                rotate([180,0,0]) {
                    cylinder(h=27, r1=12, r2=12);
                }
        } */

    // magnets   
/*    
    translate([0,0,0]) {
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