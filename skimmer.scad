 use <ShortCuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <Naca4.scad>
 use <polyround.scad>

$fs = 0.01;
$fa=3;

w=6;
l=67;
w2=1;
l2=9;
engine_centre=115;

flag_left_wing = true;
flag_right_wing = false;
flag_top_frame = false;
flag_engines = false;
flag_floor = false;

difference() {
    translate([0,0,0])
    {
        // wings
        rotate([20,0,0]) { 
            if (flag_left_wing) {
                // left
                difference() {
                    translate([-44,49,0]) {
                        rotate([100,0,270])          
                            scale([1.7,1,1])
                                linear_extrude(height=153, twist=0, scale=0.6)
                                    translate([-120, 0, 0])
                                        polygon(points = airfoil_data(naca=[.0, .0, .18]));
                    }
                    translate([-40,227,0])
                        rotate([90,90,0])            
                            cylinder(10,10,10.5);
                }
                
                translate([-195,171,-28])
                    rotate([90,0,270])
                        scale([1.2,2,1])
                            linear_extrude(height=3, twist=0, scale=1)
                                polygon(points = airfoil_data(naca=[.0, .0, .18]));
                
                translate([-40,232,0])
                    rotate([90,0,0])            
                        cylinder(5,9,9); 
                
                translate([-40,217,0])
                    rotate([90,0,0])            
                        cylinder(5,9,9);   
            }
                
            if (flag_right_wing) 
            {
                // right
                difference() {
                    translate([44,49,0]) {
                        mirror([1,0,0])
                            rotate([100,0,270])  
                                scale([1.7,1,1])
                                    linear_extrude(height=153, twist=0, scale=0.6)
                                        translate([-120, 0, 0])
                                            polygon(points = airfoil_data(naca=[.0, .0, .18]));           
                    }
                    translate([40,227,0])
                        rotate([90,90,0])            
                            cylinder(10,10,10.5);
                }
                
                translate([198,171,-28])
                    rotate([90,0,270])
                        scale([1.2,2,1])
                            linear_extrude(height=3, twist=0, scale=1)
                                polygon(points = airfoil_data(naca=[.0, .0, .18]));
                
                translate([40,232,0])
                    rotate([90,0,0])            
                        cylinder(5,9,9); 
                
                translate([40,217,0])
                    rotate([90,0,0])            
                        cylinder(5,9,9);
            }
            
            if (flag_top_frame) {
                // wing frame cross bar
                translate([-40,222,0])        
                    rotate([0,90,0])        
                        linear_extrude(height=80) 
                            circle(5);  
                translate([-40,226.9,0])
                    rotate([90,90,0])            
                        cylinder(9.8,9,9);    
                translate([40,226.9,0])
                    rotate([90,90,0])            
                        cylinder(9.8,9,9);
                
                // up/down spars
                translate([40,222,-80]) 
                    rotate([0,0,0]) 
                        linear_extrude(height=80) 
                            circle(4); 
                translate([-40,222,-80]) 
                    rotate([0,0,0]) 
                        linear_extrude(height=80) 
                            circle(4); 
                            
                // front/back spars
                translate([40,237,0]) 
                    rotate([90,0,0])
                        linear_extrude(height=237) 
                            circle(4);                     
                translate([36,0,0])
                    rotate([0,90,0])            
                        cylinder(8,10,10);
                  
                translate([-40,237,0]) 
                    rotate([90,0,0]) 
                        linear_extrude(height=237) 
                            circle(4);
                translate([-44,0,0])
                    rotate([0,90,0])            
                        cylinder(8,10,10);
            }        
            
        }
                
        if (flag_bars) {
            // engine frame (back cross-member)  
            difference() {
                translate([-75,0,0])       
                    rotate([0,90,0])        
                        linear_extrude(height=150) 
                            circle(5); 
                translate([-15,0,0])    
                    cube([30,10,20]);        
            }
                   
            // engine frame (front/back spars)
            translate([-engine_centre,0,0])        
                rotate([0,90,72.5])        
                    linear_extrude(height=250) 
                        circle(4);  
            translate([engine_centre,0,0])        
                rotate([0,90,-252.5])        
                    linear_extrude(height=250) 
                        circle(4);  
        }
        
        if (flag_floor) {
            // front engine mount
            translate([0,302,0]) 
                rotate([0,0,233])
                    rotate_extrude(angle=360) {
                          translate([77,0]) 
                             circle(4);
                    }
                    
            // servo mounts
            translate([0,201,0])        
                rotate([270,0,0])        
                    linear_extrude(height=34)
                        circle(5);
            translate([0,380,0])        
                rotate([270,0,0])        
                    linear_extrude(height=10)
                        circle(5); 
                  
             // floor
        difference() {
            translate([0,0,-1.5])        
                linear_extrude(height=3)        
                    polygon([[-40,0],[40,0],[40,235],[30,235],[0,220],[-30,235],[-40,235]]);   
            
            // holes
            translate([-45,2,-5])   
                for (i = [1 : 8])
                    for (j = [1 : 19]) {
                        translate([i * 10, j * 10, 0])
                            cylinder(h=10, r1=4, r2=4);
                    }
            }        
        }        
  
        if (flag_engines) {
            // front engine 
            translate([0,302,0]) {
                scale([1,1,3])
                //  difference() {
                        rotate_extrude() {
                          translate([66,0]) 
                             circle(5);
                        } 
                //        rotate_extrude() {
                //          translate([66,0]) 
                //             circle(8.5);
                //        } 
                //    }
                //translate([0,0,-14])
                //    cylinder(28, 66.5, 66.5);
            }
                
            // rear engines
            translate([engine_centre,0,0]) {
                scale([1,1,3])
                //  difference() {
                        rotate_extrude() {
                          translate([66,0]) 
                             circle(5);
                        } 
                //        rotate_extrude() {
                //          translate([66,0]) 
                //             circle(8.5);
                //        } 
                //    }
                //translate([0,0,-14])
                //    cylinder(28, 66.5, 66.5);
            }

            translate([-engine_centre,0,0]) {
                scale([1,1,3])
                //  difference() {
                        rotate_extrude() {
                          translate([66,0]) 
                             circle(5);
                        } 
                //        rotate_extrude() {
                //          translate([66,0]) 
                //             circle(8.5);
                //        } 
                //    }
                //translate([0,0,-14])
                //    cylinder(28, 66.5, 66.5); 
            }
        }
    }
    
    if (flag_engines) {
        // engine cores (5" blades are 63.5 mm)
        {
            translate([0,302,-20])
                cylinder(64, 64, 64);
            translate([engine_centre,0,-20])
                cylinder(64, 64, 64);
            translate([-engine_centre,0,-20])
                cylinder(64, 64, 64);
        }
        
        // wiring holes
        {
            translate([-75,0,0])        
                rotate([0,90,0])        
                    linear_extrude(height=170) 
                        circle(3);
            
             translate([0,202,0])
                rotate([270,0,0])        
                    linear_extrude(height=250) 
                        circle(3);   
            
            translate([-17.5,210,-10])
                cube([35,10,20]);
        }
    }
}

if (flag_engines) {
    // engine supports
    translate([0,302,-14.5])     
        linear_extrude(height=4) { 
            difference() {
                union() { 
                    polygon([[-w,l],[w,l],[w,w],[l,w],[l,-w],[w,-w],[w,-l],[-w,-l],[-w,-w],[-l,-w],[-l,w],[-w,w]]); 
                    circle(13); 
                }
                circle(3.5); 
                for (i = [0 : 1])
                    for (j = [0 : 1]) {
                            translate([i * 12.5 - 6.25, j * 12.5 - 6.25, 0])
                                circle(1.05);
                        }
                polygon([[-w2,l2],[w2,l2],[w2,w2],[l2,w2],[l2,-w2],[w2,-w2],[w2,-l2],[-w2,-l2],[-w2,-w2],[-l2,-w2],[-l2,w2],[-w2,w2]]);          
            }
        }
    translate([engine_centre,0,-14.5])     
        linear_extrude(height=4) {
            difference() {
                union() { 
                    polygon([[-w,l],[w,l],[w,w],[l,w],[l,-w],[w,-w],[w,-l],[-w,-l],[-w,-w],[-l,-w],[-l,w],[-w,w]]); 
                    circle(13); 
                }
                circle(3.5); 
                for (i = [0 : 1])
                    for (j = [0 : 1]) {
                            translate([i * 12.5 - 6.25, j * 12.5 - 6.25, 0])
                                circle(1.05);
                        }    
                polygon([[-w2,l2],[w2,l2],[w2,w2],[l2,w2],[l2,-w2],[w2,-w2],[w2,-l2],[-w2,-l2],[-w2,-w2],[-l2,-w2],[-l2,w2],[-w2,w2]]);         
            }
        }
    translate([-engine_centre,0,-14.5])     
        linear_extrude(height=4) {  
            difference() {
                union() { 
                    polygon([[-w,l],[w,l],[w,w],[l,w],[l,-w],[w,-w],[w,-l],[-w,-l],[-w,-w],[-l,-w],[-l,w],[-w,w]]); 
                    circle(13); 
                }
                circle(3.5); 
                for (i = [0 : 1])
                    for (j = [0 : 1]) {
                            translate([i * 12.5 - 6.25, j * 12.5 - 6.25, 0])
                                circle(1.05);
                        }
                polygon([[-w2,l2],[w2,l2],[w2,w2],[l2,w2],[l2,-w2],[w2,-w2],[w2,-l2],[-w2,-l2],[-w2,-w2],[-l2,-w2],[-l2,w2],[-w2,w2]]);          
            }
        }
}   
    



