 use <ShortCuts.scad>  // see: http://www.thingiverse.com/thing:644830
 use <Naca4.scad>
 use <polyround.scad>

$fs = 0.01;
$fa=3;


            //rotate_extrude(angle = 45, convexity=10)   

difference() {
    translate([0,0,0])
    {
        // wings
        rotate([20,0,0]) {
            // left
            translate([-70,40,-5]) {
                rotate([90,0,270])          
                    scale([1.6,1,1])
                        linear_extrude(height=130, twist=0, scale=0.5)
                            translate([-120, 0, 0])
                                polygon(points = airfoil_data(naca=[.0, .0, .18]));
            }
            translate([-200,145,-5])
                rotate([90,0,270])
                    scale([1,2,1])
                        linear_extrude(height=5, twist=0, scale=1)
                            polygon(points = airfoil_data(naca=[.0, .0, .18]));
            
            // right
            translate([200,40,-5]) {
                rotate([90,0,270])          
                    scale([0.8,0.5,1])
                        linear_extrude(height=130, twist=0, scale=2)
                            translate([-120, 0, 0])
                                polygon(points = airfoil_data(naca=[.0, .0, .18]));           
            }
            translate([205,145,-5])
                rotate([90,0,270])
                    scale([1,2,1])
                        linear_extrude(height=5, twist=0, scale=1)
                            polygon(points = airfoil_data(naca=[.0, .0, .18]));
        
            // wing frame
            translate([-80,164,-5])        
                rotate([0,90,0])        
                    linear_extrude(height=160) 
                        circle(5); 
            
            // front spars
            translate([60,180,-65]) 
                rotate([0,30,0]) 
                    linear_extrude(height=75) 
                        circle(4); 
            translate([-60,180,-65]) 
                rotate([0,-30,0]) 
                    linear_extrude(height=75) 
                        circle(4); 
            
            // back spars (connect to curves)
            /*
            translate([20,100,-36]) 
                rotate([0,65,0]) 
                    linear_extrude(height=77) 
                        circle(4); 
            translate([-20,100,-36]) 
                rotate([0,-65,0]) 
                    linear_extrude(height=77) 
                        circle(4); */
                        
            // back spars (connect to uncurved)
            translate([50,100,-37]) 
                rotate([0,55,0]) 
                    linear_extrude(height=56) 
                        circle(4); 
            translate([-50,100,-37]) 
                rotate([0,-55,0]) 
                    linear_extrude(height=56) 
                        circle(4);             
        }
            
        // engine frame (curved)
        /* translate([170,160,0])
            rotate(179)
                rotate_extrude(angle=54) {
                  translate([160,0]) 
                     circle(4);
                }  
        translate([-170,160,0])
            rotate(-54)
                rotate_extrude(angle=54) {
                  translate([160,0]) 
                     circle(4);
                } */
                
         // engine frame (cross-member)        
        translate([-63,0,0])        
            rotate([0,90,0])        
                linear_extrude(height=126) 
                    circle(5);         
               
        // engine frame (uncurved)      
        translate([-100,0,0])        
            rotate([0,90,65])        
                linear_extrude(height=260) 
                    circle(4);  
        translate([100,0,0])        
            rotate([0,90,-245])        
                linear_extrude(height=260) 
                    circle(4);  
          
        // front engine
        translate([0,220,0])
            scale([1,1,2])
                rotate_extrude() {
                  translate([65,0]) 
                     circle(5);
                } 
            
        // rear engines
        translate([100,0,0])
            scale([1,1,2])
                rotate_extrude() {
                  translate([65,0]) 
                     circle(5);
                } 

        translate([-100,0,0])
            scale([1,1,2])
                rotate_extrude() {
                  translate([65,0]) 
                     circle(5);
                }  
                
        // floor
        difference() {
            translate([0,0,-1.5])        
                linear_extrude(height=3)        
                    polygon([[-30,0],[30,0],[30,150],[0,220],[-30,150]]);   
            
            translate([-30,2,-5])   
                for (i = [1 : 9])
                    for (j = [1 : 24]) {
                        translate([i * 6, j * 6, 0])
                            cylinder(h=10, r1=2, r2=2);
                    }   
                }  
    }
    
    // engine cores
    {
        translate([0,220,-20])
            cylinder(61, 61, 61);
        translate([100,0,-20])
            cylinder(61, 61, 61);
        translate([-100,0,-20])
            cylinder(61, 61, 61); 
    }
}



