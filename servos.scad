//use <lib/gears.scad>

$fs=0.1;
$fa=6;
$fn=200;

teeth = 20;
h = 4;
inner_r = 5.8/2; //7.75/2;  //7.4
outer_r = 6.2/2; //8.25/2;  //7.9

//spur_gear(d/20, teeth, h, 3, pressure_angle=0, helix_angle=0, optimized=false);
//cylinder(h,r=d/2.05);

module rotate_about_pt(rot, pt) {
    translate(pt)
        rotate(rot)
            translate(-pt)
                children();
}

module rounded_cube(size=[1,1,1], radius, fn=100) {
    hull() {
        translate ([size[0]/2-radius,size[1]/2-radius,size[2]/2-radius])
            sphere(r = radius,$fn = fn);
        translate ([-size[0]/2+radius,size[1]/2-radius,size[2]/2-radius])
            sphere(r = radius,$fn = fn);
        translate ([-size[0]/2+radius,-size[1]/2+radius,size[2]/2-radius])
            sphere(r = radius,$fn = fn);
        translate ([size[0]/2-radius,-size[1]/2+radius,size[2]/2-radius])
            sphere(r = radius,$fn = fn);

        translate ([size[0]/2-radius,size[1]/2-radius,-size[2]/2+radius])
            sphere(r = radius,$fn = fn);
        translate ([-size[0]/2+radius,size[1]/2-radius,-size[2]/2+radius])
            sphere(r = radius,$fn = fn);
        translate ([-size[0]/2+radius,-size[1]/2+radius,-size[2]/2+radius])
            sphere(r = radius,$fn = fn);
        translate ([size[0]/2-radius,-size[1]/2+radius,-size[2]/2+radius])
            sphere(r = radius,$fn = fn);
    }
}

module servo(detailed=true, r=65) {
    rotate_about_pt([0,0,r], [0,1,0]) {
        translate([0, 1, - 2.15]) cylinder(4.3, r = 1.27 / 2);
        translate([0, 1, - 2.55]) cylinder(4.6, r = 0.3);

        if (detailed) difference() {
            rounded_cube([2, 4, 4.1], 0.2);
            servo_holes(0.05);
        } else union() {
            rounded_cube([2, 4, 4.1], 0.2);
            servo_holes(0.1);
        }

        //        servo_mount();

        translate([0, 1, 2.15])
            scale([0.1, 0.1, 0.1])
                servo_gear(detailed);
    }
}

module servo_holes(r=0.05) {
    translate([0.75, - 1.75, - 3]) cylinder(3, r = r);
    translate([- 0.75, - 1.75, - 3]) cylinder(3, r = r);
    translate([0.75, - 0.25, - 3]) cylinder(3, r = r);
    translate([- 0.75, - 0.25, - 3]) cylinder(3, r = r);

    translate([0, - 1.75, 0]) cylinder(3, r = r);
    translate([0.75, - 1, 0]) cylinder(3, r = r);
    translate([-0.75, - 1, 0]) cylinder(3, r = r);
}

module servo_mount() {
    difference() {
        union() {
            translate([0, -(2 - 0.65), 2.11]) cube([2, 2.7, 0.2], true);
            translate([0, -(2 - 0.65), - 2.11]) cube([2, 2.7, 0.2], true);
            translate([0, - 2.6, 0]) cube([2, 0.2, 4.42], true);
        }
        translate([0.75, - 0.25, - 2.25]) cylinder(4.5, r = 0.1);
        translate([ - 0.75, - 0.25, - 2.25]) cylinder(4.5, r = 0.1);
        translate([0.75, - 1.75, - 2.25]) cylinder(4.5, r = 0.1);
        translate([ - 0.75, - 1.75, - 2.25]) cylinder(4.5, r = 0.1);
    }
}

module servo_gear(detailed=true) {
    if (detailed) {
        cylinder(h, r = inner_r);

        tooth_top = 0.9;
        tooth_bottom = 0.8;
        tooth_angle = 180;
        tooth_h = outer_r - inner_r + 0.1;
        for (i = [0 : teeth - 1]) {
            rotate([0, 0, i * 360 / 20])
                translate([0, inner_r, 0])
                    rotate([0, 0, - tooth_angle / teeth])
                        linear_extrude(h)
                            polygon([[0, 0],
                                    [tooth_h * tooth_bottom * 1 / tooth_top, tooth_h],
                                    [tooth_h * tooth_bottom * (3 - 1 / tooth_top), tooth_h],
                                    [tooth_h * tooth_bottom * 3, 0]]);
        };
    } else {
        cylinder(h, r = outer_r);
    }
}

module servo_coupling(detailed=true, teeth=true) {
    scale([0.1,0.1,0.1]) {
        difference() {
            cylinder(h + 2, r = 4.75);
            translate([0, 0, h+1]) cylinder(1, 1.5, 3);
            if (teeth) {
                servo_gear(detailed);
            } else {
                cylinder(h, r = outer_r);
            }
            translate([0, 0, h-1]) cylinder(4, 1.5, 1.5);
        }
        difference() {
            cylinder(10, r = 10);
            cylinder(h, r = 4.75);
            translate([0, 0, 9])
                rotate([0, -21, 0])
                    cube([30, 25, 10], true);
            if (detailed) {
                servo_coupling_holes(0.75);
            }
            translate([0, 0, h-1]) cylinder(4, 1.5, 1.5);
        }
        if (!detailed) {
            servo_coupling_holes();
        }
//        }
        //    for (i = [0 : 3]) {
        //        rotate([0, 0, i * 90])
        //            translate([0, 7, -2])
        //                cylinder(10, r = 1);
        //    }

        //    for (i = [0 : 3]) {
        //        rotate([0, 0, i * 90])
        //            translate([0, 7, 0])
        //                cylinder(2, r = 1);
        //    }
    }
};

module servo_coupling_holes(r=1) {
    translate([0,0,5])
        rotate([0,-21,0])
            for (i = [0 : 3]) {
                rotate([0, 0, i * 90])
                    translate([0, 7, -10])
                        cylinder(20, r = r);
            }
}

//difference() {
////    cylinder(h, r = outer_r);
//    servo_gear();
//}
//servo(true);

//
scale([10,10,10])
  servo_coupling(detailed=true, teeth=false);
