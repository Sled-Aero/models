use <lib/thing_libutils/Naca4.scad>
use <lib/BOSL/transforms.scad>

$fs=0.1;
$fa=6;
$fn=200;

REFINEMENT = 100;

module landing_foot(detailed=true) {
    d = 19 / sqrt(2) / 2;
    d2 = d + 1;

    difference() {
        // drop
        translate([0, 0, - 8]) drop(0.85, 0.85, 1.7);

        // top cut
        translate([0, 0, - 16]) cylinder(40, 20, 20);

        // bottom cut
        translate([0, 0, 140]) cylinder(40, 20, 20);

        // axle hole
        translate([- 25, 0, 46]) rotate([90, 0, 90]) cylinder(50, 5.25, 5.25);

        if (detailed) {
            // carve-out inner drop
            translate([0, 0, - 15]) drop(0.65, 0.65, 1.5);

            // side carves
            translate([21, 0, 90]) cube([20, 20, 140], true);
            translate([- 21, 0, 90]) cube([20, 20, 140], true);
            //
            // mounting holes
            translate([0, 0, 29]) {
                translate([- d, - d, 0]) cylinder(100, 2.5, 2.5);
                translate([- d, d, 0]) cylinder(100, 2.5, 2.5);
                translate([d, - d, 0]) cylinder(100, 2.5, 2.5);
                translate([d, d, 0]) cylinder(100, 2.5, 2.5);

                translate([0, 0, 5]) {
                    translate([- d2, - d2, 0]) {
                        rotate([0, 0, 135]) {slot();}
                    }
                    translate([- d2, d2, 0]) {
                        rotate([0, 0, 45]) {slot();}
                    }
                    translate([d2, - d2, 0]) {
                        rotate([0, 0, 45]) {slot();}
                    }
                    translate([d2, d2, 0]) {
                        rotate([0, 0, 135]) {slot();}
                    }
                }
            }
            translate([0, 0, 24])
                linear_extrude(5) {
                    translate([- d, - d, 0]) circle(r = 1.5);
                    translate([- d, d, 0]) circle(r = 1.5);
                    translate([d, - d, 0]) circle(r = 1.5);
                    translate([d, d, 0]) circle(r = 1.5);
                }
            translate([0, 0, 28])
                linear_extrude(1) {
                    translate([- d, - d, 0]) circle(2.5);
                    translate([- d, d, 0]) circle(2.5);
                    translate([d, - d, 0]) circle(2.5);
                    translate([d, d, 0]) circle(2.5);
                }

            // screw holes
            translate([0, 0, 39.5]) rotate([90, 0, 0]) cylinder(20, r = 2.65);
            translate([0, 0, 52.5]) rotate([90, 0, 0]) cylinder(20, r = 2.65);
            translate([0, 20, 39.5]) rotate([90, 0, 0]) cylinder(20, r = 2.65);
            translate([0, 20, 52.5]) rotate([90, 0, 0]) cylinder(20, r = 2.65);

            // core
            translate([0, 0, - 18.5]) cylinder(200, 2, 2);
        }
    }
}

module 2810_motor() {
    translate([0, 0, -13.1]) cylinder(37,1,1);
    translate([0, 0, -13.1]) cylinder(14, 2.5, 2.5);
    translate([0, 0, 0.9]) cylinder(2.9, 2.5, 16);
    translate([0, 0, 3.8]) cylinder(14.7, 33.3/2, 33.3/2);
    translate([0, 0, 18.5]) cylinder(2.9, 7, 8);
    translate([0, 0, 21.4]) motor_mount(2.5);
}

module axle_mount() {
    difference() {
        motor_mount(5, true);

        d = 19 / sqrt(2) / 2;

        translate([0,0,4])
            linear_extrude(4) {
                translate([- d, - d, 0]) circle(2.5);
                translate([- d, d, 0]) circle(2.5);
                translate([d, - d, 0]) circle(2.5);
                translate([d, d, 0]) circle(2.5);
            }
    }

    one = 15.5;
    two = 28.5;
    axle_r = 5.2;

    difference() {
        union() {
            linear_extrude(32) ring(7, 3.5);
            translate([0, 6.5, 18.5]) cube([6, 3, 27], true);
            translate([0, -6.5, 18.5]) cube([6, 3, 27], true);
        }
        translate([0, 0, 19]) cube([16, 1.5, 28], true);

        // insets
        translate([0, -7, one]) rotate([90, 0, 0]) cylinder(2, 2.25, 2.25);
        translate([0, -7, two]) rotate([90, 0, 0]) cylinder(2, 2.25, 2.25);

        // holes
        translate([0, 0, one]) rotate([90, 0, 0]) cylinder(8, 1.2, 1.2);
        translate([0, 0, two]) rotate([90, 0, 0]) cylinder(8, 1.2, 1.2);

        // insets
        translate([0, 9, one]) rotate([90, 0, 0]) cylinder(h=2, r=2.25, $fn=6);
        translate([0, 9, two]) rotate([90, 0, 0]) cylinder(h=2, r=2.25, $fn=6);

        // holes
        translate([0, 8, one]) rotate([90, 0, 0]) cylinder(8, 1, 1);
        translate([0, 8, two]) rotate([90, 0, 0]) cylinder(8, 1, 1);

        rotate([0, 0, 90])
            translate([0, 8, one + (two - one) / 2]) rotate([90, 0, 0]) cylinder(16, axle_r, axle_r);

    }
}

module motor_mount(h=2.5,fill=false) {
    d = 19 / sqrt(2) / 2;

    linear_extrude(h)
        difference() {
            motor_foot(d);

            translate([- d, - d, 0]) circle(1.5);
            translate([- d, d, 0]) circle(1.5);
            translate([d, - d, 0]) circle(1.5);
            translate([d, d, 0]) circle(1.5);
        }
}

module motor_foot(d, hole=5.5) {
    round2d(r = 1.2) {
        translate([- d, - d, 0]) circle(3.2);
        translate([- d, d, 0]) circle(3.2);
        translate([d, - d, 0]) circle(3.2);
        translate([d, d, 0]) circle(3.2);
        ring(8, hole);
    }
}

module ring(d, w=1) {
    difference() {
        circle(d);
        if (w != 0) {
            circle(w);
        }
    }
}

module slot() {
    cube([6, 5, 10], true);
    translate([0,-2.5,5]) rotate([0,90,90]) cylinder(5,3,3);
}

module drop_slice() {
    rotate([0,0,90])
        difference() {
            polygon(points = airfoil_data(30, N=REFINEMENT));
            square(100, 100);
        }
}

module drop(w,h,l) {
    scale([w,h,l])
        translate([0,0,0]) {
            rotate_extrude(angle = 360, $fn=REFINEMENT)
                drop_slice();
        }
}

module landing_gear(detailed=true) {
    if (detailed) {
        translate([0, 0, 24]) axle_mount();
    }
    landing_foot(detailed);
}

landing_gear(false);
