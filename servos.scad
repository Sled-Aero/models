//use <lib/gears.scad>

$fs=0.1;
$fa=6;
$fn=200;

teeth = 20;
h = 6;
inner_r = 7.75/2;  //7.4
outer_r = 8.25/2;  //7.9

//spur_gear(d/20, teeth, h, 3, pressure_angle=0, helix_angle=0, optimized=false);
//cylinder(h,r=d/2.05);

module rotate_about_pt(rot, pt) {
    translate(pt)
        rotate(rot)
            translate(-pt)
                children();
}

module servo() {
    rotate_about_pt([0,0,-25], [0,1,0]) {
        translate([0, 1, - 2.1]) cylinder(4.2, r = 0.7);
        translate([0, 1, - 2.7]) cylinder(5.4, r = 0.4);
        cube([2, 4, 4], true);

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
}

module servo_gear() {
    cylinder(h, r = inner_r);

    tooth_top = 1.1;
    tooth_bottom = 1.0;
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
}

module servo_coupling() {
    difference() {
        cylinder(h + 2, r = 5);
        translate([0, 0, h + 1]) cylinder(1, 1.5, 3);
        translate([0, 0, h]) cylinder(2, 1.5, 1.5);
        servo_gear();
    }
    difference() {
        cylinder(2, r = 10);
        cylinder(h, r = 5);

        for (i = [0 : 3]) {
            rotate([0, 0, i * 90])
                translate([0, 7, - 2])
                    cylinder(10, r = 1);
        }
    }
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

};

//difference() {
////    cylinder(h, r = outer_r);
    servo_gear();
//}



//scale([10,10,10])
//servo_coupling();
