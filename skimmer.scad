 use <lib/ShortCuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <lib/Naca4.scad>
 use <lib/polyround.scad>

/*
 project: https://www.thingiverse.com/thing:4054381
 
 motor: https://www.geekbuying.com/item/Flywoo-NIN-1404-3750KV-2-4S-Brushless-Motor-For-FPV-Racing-RC-Drone-418014.html
 
 blade: https://www.banggood.com/2-Pairs-HQProp-T4X2_5-4025-4-Inch-2-blade-Durable-PC-Propeller-2CW+2CCW-for-RC-Drone-FPV-Racing-p-1590493.html?akmClientCountry=AU&rmmds=search&p=YQ270915554535201710&custlixnkid=731048&cur_warehouse=CN
 */

$fs = 0.01;
$fa=3;

engine_radius=52; // (5" blades are 63.5 mm, 4" blades are 50.8mm)
engine_height=14.5 + 5.5 + 3; // motor + blade height + mount
engine_centre=102;
w=6;
l=engine_radius+3;
w2=1;
l2=9;

flag_left_wing = true;
flag_right_wing = true;
flag_top_frame = true;
flag_engines = true;
flag_front_engine_only = false;
flag_floor = true;
flag_bars = true;

difference() {
    translate([0,0,0])
    {
        // wings
        /*translate([4,-83,0])
        rotate([-20,5,-7])*/
        rotate([20,0,0]) { 
            if (flag_left_wing) {
                // left
                difference() {
                    translate([-44,40,0]) {
                        rotate([95,0,270])          
                            scale([1.45,0.8,1])
                                linear_extrude(height=120, twist=0, scale=0.6)
                                    translate([-120, 0, 0])
                                        polygon(points = airfoil_data(naca=[.0, .0, .18]));
                        // tip
                        translate([-121,108,-16])
                            rotate([85,0,270])
                                scale([1.1,2,1])
                                    linear_extrude(height=3, twist=0, scale=1)
                                        polygon(points = airfoil_data(naca=[.0, .0, .18]));
                    }
                    // mount cavity
                    translate([-40,227,0])
                        rotate([90,90,0])            
                            cylinder(10,8,8.5);
                }
                
                // mounts
                translate([-40,192,0])
                    rotate([90,0,0])            
                        cylinder(5,7,7); 
                translate([-40,177,0])
                    rotate([90,0,0])            
                        cylinder(5,7,7);
                translate([-40,127,0])
                    rotate([90,0,0])            
                        cylinder(5,6,6);
            }
                
            if (flag_right_wing) 
            {
                // right
                difference() {
                    translate([44,40,0]) {
                        mirror([1,0,0])
                            rotate([95,0,270])  
                                scale([1.45,0.8,1])
                                    linear_extrude(height=120, twist=0, scale=0.6)
                                        translate([-120, 0, 0])
                                            polygon(points = airfoil_data(naca=[.0, .0, .18]));
                        // tip
                        translate([121,108,-16])
                            rotate([95,0,270])
                                scale([1.1,2,1])
                                    linear_extrude(height=3, twist=0, scale=1)
                                        polygon(points = airfoil_data(naca=[.0, .0, .18]));        
                    }
                    // mount cavity
                    translate([40,227,0])
                        rotate([90,90,0])            
                            cylinder(10,8,8.5);
                }
                
                // mounts
                translate([40,192,0])
                    rotate([90,0,0])            
                        cylinder(5,7,7); 
                translate([40,177,0])
                    rotate([90,0,0])            
                        cylinder(5,7,7);
                translate([40,127,0])
                    rotate([90,0,0])            
                        cylinder(5,6,6);
            }
            
            if (flag_top_frame) {
                // wing frame cross bar
                translate([-40,182,0])
                    rotate([0,90,0])        
                        linear_extrude(height=80) 
                            circle(4);  
                translate([-40,186.9,0])
                    rotate([90,90,0])            
                        cylinder(9.8,7,7);    
                translate([40,186.9,0])
                    rotate([90,90,0])            
                        cylinder(9.8,7,7);
                
                // up/down spars
                translate([40,182,-68]) 
                    rotate([0,0,0]) 
                        linear_extrude(height=68) 
                            circle(4); 
                translate([-40,182,-68]) 
                    rotate([0,0,0]) 
                        linear_extrude(height=68) 
                            circle(4); 
                            
                // front/back spars
                translate([40,200,0]) 
                    rotate([90,0,0])
                        linear_extrude(height=200) 
                            circle(4);                     
                translate([36,0,0])
                    rotate([0,90,0])            
                        cylinder(8,10,10);
                  
                translate([-40,200,0]) 
                    rotate([90,0,0]) 
                        linear_extrude(height=200) 
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
                    linear_extrude(height=205) 
                        circle(4);  
            translate([engine_centre,0,0])        
                rotate([0,90,-252.5])        
                    linear_extrude(height=205) 
                        circle(4);  
        }
        
        if (flag_floor) {
            // front engine mount
            translate([0,252,0]) 
                rotate([0,0,233])
                    rotate_extrude(angle=360) {
                          translate([67,0]) 
                             circle(4);
                    }
                    
            // servo mounts
            translate([0,171,0])        
                rotate([270,0,0])        
                    linear_extrude(height=18)
                        circle(5);
            translate([0,315,0])        
                rotate([270,0,0])        
                    linear_extrude(height=8)
                        circle(5); 
                  
             // floor
            difference() {
                translate([0,0,-1])        
                    linear_extrude(height=2)        
                        polygon([[-40,0],[40,0],[40,195],[30,195],[0,180],[-30,195],[-40,195]]);   
                
                // holes
                translate([-45,2,-5])   
                    for (i = [1 : 8])
                        for (j = [1 : 17]) {
                            translate([i * 10, j * 10, 0])
                                cylinder(h=10, r1=4, r2=4);
                        }
                }        
        }        
  
        if (flag_engines) {
            // front engine 
            translate([0,252,0]) {
                scale([1,1,engine_height/10])
                //  difference() {
                        rotate_extrude() {
                          translate([engine_radius+2,0]) 
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
                
            if (!flag_front_engine_only) {
                // rear engines
                translate([engine_centre,0,0]) {
                    scale([1,1,engine_height/10])
                    //  difference() {
                            rotate_extrude() {
                              translate([engine_radius+2,0]) 
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
                    scale([1,1,engine_height/10])
                    //  difference() {
                            rotate_extrude() {
                              translate([engine_radius+2,0]) 
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
    }
    
    if (flag_engines) {
        // engine cores (5" blades are 63.5 mm)
        {
            translate([0,252,-20])
                cylinder(engine_radius, engine_radius, engine_radius);
            translate([engine_centre,0,-20])
                cylinder(engine_radius, engine_radius, engine_radius);
            translate([-engine_centre,0,-20])
                cylinder(engine_radius, engine_radius, engine_radius);
        }
        
        // wiring holes
        {
            translate([-75,0,0])        
                rotate([0,90,0])        
                    linear_extrude(height=170) 
                        circle(3);
            
             translate([0,170,0])
                rotate([270,0,0])        
                    linear_extrude(height=250) 
                        circle(3);   
            
            translate([-15,168,-10])
                cube([30,8,20]);
        }
    }
}

if (flag_engines) {
    // engine supports
    translate([0,252,3/2-engine_height/2])     
        linear_extrude(height=3) { 
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
    if (!flag_front_engine_only) {    
    translate([engine_centre,0,3/2-engine_height/2])     
        linear_extrude(height=3) {
            difference() {
                union() { 
                    polygon([[-w,l],[w,l],[w,w],[l,w],[l,-w],[w,-w],[w,-l],[-w,-l],[-w,-w],[-l,-w],[-l,w],[-w,w]]); 
                    circle(13); 
                }
                circle(3.5); 
                for (i = [0 : 1])
                    for (j = [0 : 1]) {
                            translate([i * 12 - 6, j * 12 - 6, 0])
                                circle(1.05);
                        }    
                polygon([[-w2,l2],[w2,l2],[w2,w2],[l2,w2],[l2,-w2],[w2,-w2],[w2,-l2],[-w2,-l2],[-w2,-w2],[-l2,-w2],[-l2,w2],[-w2,w2]]);         
            }
        }
    translate([-engine_centre,0,3/2-engine_height/2])     
        linear_extrude(height=3) {  
            difference() {
                union() { 
                    polygon([[-w,l],[w,l],[w,w],[l,w],[l,-w],[w,-w],[w,-l],[-w,-l],[-w,-w],[-l,-w],[-l,w],[-w,w]]); 
                    circle(13); 
                }
                circle(3.5); 
                for (i = [0 : 1])
                    for (j = [0 : 1]) {
                            translate([i * 12 - 6, j * 12 - 6, 0])
                                circle(1.05);
                        }
                polygon([[-w2,l2],[w2,l2],[w2,w2],[l2,w2],[l2,-w2],[w2,-w2],[w2,-l2],[-w2,-l2],[-w2,-w2],[-l2,-w2],[-l2,w2],[-w2,w2]]);          
            }
        }
    }
}
    



