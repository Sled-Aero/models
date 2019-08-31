magnets = 17;
magnet_h = 2;
magnet_r = 1.97;
rod_length = 38;
rod_width = 6;
rod_depth = 4;

$fs = 0.01;
$fa = 2;
//$fn = 120;

module arm(position) {
    translate([position,0,21.9]) {
        rotate([0,90,0]) 
            difference() {
                cylinder(h=4, r=23, center=true);
                cylinder(h=4, r=20, center=true);
                translate([-40,-24,-rod_width/2])
                    cube([50, 50, rod_width]);
            }
        }
} 

    
difference() {
    // rod
    union() {
        cube([rod_length,rod_width,rod_depth], true);
        arm(17);
        arm(0);
        arm(-17);
        translate([0,19.5,10])
            cube([rod_length,4,4], true);
        translate([0,-19.5,10])
            cube([rod_length,4,4], true);
    }

    // magnet holes
    translate([0,-magnet_r,-0.7]) // 0.5 + lip
        for (i = [0 : (magnets-1)] )
        {
            start = (magnet_r * (magnets/2-0.5));
            translate([start - (i * magnet_r), magnet_h, 0]) {
                cylinder(h=magnet_h, r=magnet_r);
            }
        }
        
    // retaining lips
    translate([0,-magnet_r,0])
        for (i = [0 : (magnets-1)] )
        {
            start = (magnet_r * (magnets/2-0.5));
            translate([start - (i * magnet_r), magnet_h, 0]) {
                cylinder(h=magnet_h, r=magnet_r-0.1); // rim
            }
        }
           
    // poky holes  
    translate([0,-magnet_r,-4])
        for (i = [0 : (magnets-1)] )
        {
            start = (magnet_r * (magnets/2-0.5));
            translate([start - (i * magnet_r), magnet_h, 0]) {
                cylinder(h=magnet_h * 3, r=0.5); // holes
            }
        }
}

