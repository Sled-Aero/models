thick = 5;
gap = 2;
magnets = 5;
magnet_h = 12.0;
magnet_r = 9.0;
pi = 3.14159265;
radius = 50 * sqrt((5 - sqrt(5))/2); 
height = magnet_h + 4;

$fs = 0.01;
$fa=3;
echo(radius * 2);
echo(height);

difference() {
    translate([0,0,0])
    {
        // outer rings
        difference() {
            difference() {
                cylinder(h=height, r=radius, center=true);
                cylinder(h=height, r=radius-thick, center=true);
            }
            
            difference() {
                cylinder(h=height/2, r=radius, center=true);
                cylinder(h=height/2, r=radius-thick, center=true);
            }
        }

        // inner ring
        difference() {
            cylinder(h=5, r=radius-magnet_r/2, center=true);
            cylinder(h=5, r=radius-thick-magnet_r/2 - 1.5, center=true);
        }
        
        // struts
        rotate([0,90,90]) 
            for (i = [0 : (magnets*2-1)] )
            {
                rotate(i * 360 / magnets / 2, [1, 0, 0])
                translate([0, radius-thick/2, 4/2])
                rotate([180,0,0]) {
                    difference() {
                        cylinder(h=4, r1=magnet_r, r2=magnet_r);
                        
                        // hole
                        translate([0,0,-10])
                            cylinder(h=30, r1=4, r2=4);
                    }
                }
            } 
    } 
        
    translate([0,0,0])
    {
    // magnets
    rotate([0,90,0]) 
        for (i = [0 : (magnets-1)] )
        {
            rotate(i * 360 / magnets, [1, 0, 0])
            translate([0-magnet_h/2, radius - thick/2, 0])
            rotate([90,0,90]) {
                cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                
                // hole
                translate([0,0,-10])
                    cylinder(h=40, r1=1, r2=1);
            }
        }
            
    // magnets
    rotate([0,90,180]) 
        for (i = [0 : (magnets-1)] )
        {
            rotate(i * 360 / magnets, [1, 0, 0])
            translate([0, radius + magnet_h/2 - thick/2, 0])
            rotate([90,0,0])  {
                cylinder(h=magnet_h, r1=magnet_r, r2=magnet_r);
                
                // hole
                translate([0,0,-10])
                    cylinder(h=40, r1=1, r2=1);
            }
        }
    }   
}