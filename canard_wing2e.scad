// for libaries refer to: http://www.thingiverse.com/thing:1208001
use <lib/thing_libutils/Naca4.scad>
use <lib/thing_libutils/splines.scad>
use <lib/thing_libutils/Naca_sweep.scad>

use <lib/BOSL/constants.scad>
use <lib/BOSL/beziers.scad>
use <lib/BOSL/paths.scad>
use <lib/BOSL/math.scad>
use <lib/BOSL/transforms.scad>

use <lib/scad-utils/morphology.scad>

use <cabin8b.scad>

/* ----------------------------------------------------

Centre of wing lift:

30 .... 340
^         ^

30 + 310 * 3 / 5 = 216

Center of prop lift:
25 .... 365
^         ^

25 + 340 / 2 = 195

---

1. Fill the hole in the floor
2. Wing axles: 10mm
3. Back body: 14mm
4. All holes round
5. Worry about feet once we have motors to mount them on

------------------------------------------------------- */

$fs=0.1;
$fa=6;
$fn=100;

HAS_BACK_AXLES = true;
HAS_BACK_WING = true;
HAS_TAIL = true;
HAS_FRONT_LEFT_AXLE = true;
HAS_FRONT_LEFT_WING = true;
HAS_FRONT_RIGHT_AXLE = true;
HAS_FRONT_RIGHT_WING = true;
HAS_HATCH = true;
HAS_PROPS = true;
HAS_BLADES = true;
HAS_BODY = true;
FLATTEN = false;
FLATTEN_TAIL = true;
MEASUREMENTS = false;

REFINEMENT = 100;
ANGLE = 90;
NACA = 2414;
ATTACK = 5;
SCALE = 7;
SPAR_CORE_1_R = 0.2 * SCALE;
SPAR_CORE_2_R = 0.4 * SCALE;
FRONT_AXLE_R = 0.525 * SCALE; // 1.225;
REAR_AXLE_R = 0.7 * SCALE; // 1.225;

WING_AREA = 30000;
BW_AREA = 19200;
FW_AREA = WING_AREA-BW_AREA;
BW = 125;             // one wing
CABIN_WIDTH = 45;     // one side
CABIN_OVERLAP = 12;   // one side
FW = BW - CABIN_WIDTH;
BL = BW_AREA / (BW * 2);
FL = FW_AREA / (FW * 2);

module rotate_about_pt(rot, pt) {
  translate(pt)
    rotate(rot)
      translate(-pt)
        children();   
}

function gen_dat(X, R=0, N=100) = [for(i=[0:len(X)-1])
    let(x=X[i])  // get row
    let(v2 = airfoil_data(naca=NACA, L=x[0], N=N))
    let(v3 = T_(x[1], x[2], x[3], R_(0, R+90, x[5], R_(0, 0, x[4], vec3D(v2)))) )   // rotate and translate
     v3];

module pie_slice(angle, radius, height) {
  rotate_extrude(angle=angle) square([radius, height]);
}

module fwing(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 25;
  d = FW+CABIN_OVERLAP;
  X = [//L,  dx,      dy,  dz,    R
      [FL,   w*d,    0,   l-5,   -ATTACK,  0],
      [FL,   w*70,    0,   l-5,   -ATTACK,  0],
      [FL,   w*8,     0,   l-5,   -ATTACK,  0],
      [FL,   w*0.1,   0,   l-5,   -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,REFINEMENT));
}

module front_wing(l, rot=0) {
  translate([0,7,30.5]) {
    rotate_about_pt([rot,0,0], [0,0,0]) {
      difference() {
        union() {
          if (HAS_FRONT_RIGHT_WING)
            translate([CABIN_WIDTH-CABIN_OVERLAP, 0.3, -20.5-FL/4])
              fwing(l, 0);
        }

        translate([CABIN_WIDTH-CABIN_OVERLAP, 0, 0]) {
          rotate([0, 90, 0]) cylinder(FW + CABIN_OVERLAP, FRONT_AXLE_R, FRONT_AXLE_R);

          translate([0, -1.5, FL/4]) rotate([0, 90, 0]) cylinder(FW + CABIN_OVERLAP, SPAR_CORE_2_R, SPAR_CORE_2_R);
        }
      }
    }
  
    mirror([1, 0, 0]) {
      rotate_about_pt([rot,0,0], [0,0,0]) {
        difference() {
          union() {
            if (HAS_FRONT_LEFT_WING)
              translate([CABIN_WIDTH-CABIN_OVERLAP, 0.3, -20.5-FL/4])
                fwing(l, 0);
          }

          translate([CABIN_WIDTH-CABIN_OVERLAP, 0, 0]) {
            rotate([0, 90, 0]) cylinder(FW + CABIN_OVERLAP, FRONT_AXLE_R, FRONT_AXLE_R);

            translate([0, -1.5, FL/4]) rotate([0, 90, 0]) cylinder(FW + CABIN_OVERLAP, SPAR_CORE_2_R, SPAR_CORE_2_R);
          }
        }
      }
    }
  }
}

module bwing(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 25;
  X = [//L,  dx,     dy,   dz,    R
      [BL,   w*BW*2,  0,   l-5,   -ATTACK,  0],  
      [BL,   w*100,  0,   l-5,   -ATTACK,  0],
      [BL,   0,    0,   l-5,  -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,REFINEMENT));
}

module aframe_curved(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 30;
  X = [//L,  dx,   dy,    dz,    R
      [5,    -8,     2,   l+23,  0,  0],
      [25,   -2,    -1,   l+8,  0,  0],  
      [20,   20,   -10,    l+3,  0,  0],
      [12,   95,   -13,   l+35,  0,  0],
      [15,  106,   -17,   l+56,  0,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs,orientation,REFINEMENT/2));
}

module aframe(w, orientation=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  l = 33;
  X = [//L,  dx,   dy,    dz,    R
      [0,    -5,    0,   l+13,  0,  0],
      [19,   0,    0,   l+7,  0,  0],
      [12,   40,    0,    l,  0,  0],
      [15,   95,    0,   l+11,  0,  0],
      [4,   102,    0,   l+20,  0,  0]
    ];
  Xs = nSpline(X, 150); // interpolate wing data
  sweep(gen_dat(Xs, orientation, REFINEMENT / 2));
}

module aframe_flat(w) {
  translate([106,0,0])
    rotate([270,-90,0])
      linear_extrude(height=2)
        rounding(r = 1)
        projection(cut = true)
          rotate([0, 90, 0])
            translate([0,-106,0])
              rotate([0, 0, 90])
                aframe(w);
}

module tail() {
  translate([0, -96, -280])
    rotate([0, 270, 0]) {
      translate([220, 28, 21])
        rotate([21, 0, 0]) rotate([90, 0, 72])
          if (FLATTEN_TAIL) {aframe_flat(1);} else {aframe(1);}

//      translate([220, 30, 15])
//        rotate([90, -20, 70])
//          if (FLATTEN_TAIL) {aframe_flat(1);} else {aframe(1);}
    }
}

module back_wing(l, rot) {
  rotate_about_pt([rot,0,0], [0,-78,-13]) {
    difference() {
      union() {
        if (HAS_BACK_WING)
          difference() {
            translate([-BW, 0.5, -BL/4])
              bwing(l, 0);

            if (!HAS_TAIL) {
              tail();
              mirror([1, 0, 0]) {
                tail();
              }
            }
          }

        if (HAS_TAIL) {
          tail();
          mirror([1, 0, 0])
            tail();
        }
      }

      // back axle hole
      translate([-25, -78, -13])
        rotate([0, 90, 0]) {
          if (FLATTEN)
            cylinder(50, 1, 1);
          else
            cylinder(50, REAR_AXLE_R, REAR_AXLE_R);
      }

      // wing spar holes
      translate([0, 0, 19])
        rotate([0, 90, 0]) {
          if (FLATTEN) {
            cylinder(50, 1, 1);
          } else {
              translate([0, 0, - BW]) cylinder(BW * 2, FRONT_AXLE_R, FRONT_AXLE_R);

              translate([- BL / 4, - 1.5, - BW]) cylinder(BW * 2, SPAR_CORE_2_R, SPAR_CORE_2_R);
          }
        }
    }

    if (HAS_BACK_AXLES) {
      translate([0, 0, 19]) {
        rotate([0, 90, 0]) {
          translate([0, 0, -BW-20]) cylinder((BW + 20) * 2, FRONT_AXLE_R, FRONT_AXLE_R);
        }

        if (HAS_PROPS) {
          translate([-14-BW, 0, -21]) prop2(60, 1);
          translate([1+BW, 0, -21]) prop2(60, 1);
        }
      }

      translate([-20.5, -78, -13])
        rotate([0, 90, 0]) {
          cylinder(41, REAR_AXLE_R, REAR_AXLE_R);
        }
    }
  }
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

module prop(r,d=1) {
  if (HAS_BLADES)
    translate([0,0,-4]) {
      cylinder(12,3,3);
      sphere(3);
      cylinder(4, r, r);
    }
  
  difference() {
    drop(0.3,0.7,1.3*d);
    translate([-10,-10,(12+BL)*d])
      cube([20,20,40]);
  }
}

module prop2(r,offset) {
  if (HAS_BLADES)
    translate([0,0,-16]) {
      cylinder(12,3,3);
      sphere(3);
      cylinder(4, r, r);
    }

  scale([SCALE / 10, SCALE / 10, SCALE / 10])
    translate([9,0,-16]) {
      2810_motor();

      translate([0,0,24]) {
        axle_mount();
      }

//    difference() {
//      translate([0,0,-8]) drop(0.85, 0.85, 1.7);
//      translate([-15, -15, (30 + BL) * d]) cube([30, 30, 60]);
//      translate([0,0,1.4]) cylinder(17,16.5,16.5);
//      translate([0,0,18.4]) hull() motor_mount();
//    }
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
    motor_mount(5);

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
      translate([0, 6.5, 18.5]) cube([6, 2, 27], true);
      translate([0, -6.5, 18.5]) cube([6, 2, 27], true);
    }
    translate([0, 0, 19]) cube([16, 1.5, 28], true);

    translate([0, -6.5, one]) rotate([90, 0, 0]) cylinder(2, 2.25, 2.25);
    translate([0, -6.5, two]) rotate([90, 0, 0]) cylinder(2, 2.25, 2.25);
    translate([0, 0, one]) rotate([90, 0, 0]) cylinder(8, 1.2, 1.2);
    translate([0, 0, two]) rotate([90, 0, 0]) cylinder(8, 1.2, 1.2);

    translate([0, 8, one]) rotate([90, 0, 0]) cylinder(8, 1, 1);
    translate([0, 8, two]) rotate([90, 0, 0]) cylinder(8, 1, 1);

    rotate([0, 0, 90])
      translate([0, 8, one + (two - one) / 2]) rotate([90, 0, 0]) cylinder(16, axle_r, axle_r);

  }

}

module motor_mount(h=2.5) {
  d = 19 / sqrt(2) / 2;

  linear_extrude(h)
    difference() {
      round2d(r = 1.2) {
        translate([- d, - d, 0]) circle(3.2);
        translate([- d, d, 0]) circle(3.2);
        translate([d, - d, 0]) circle(3.2);
        translate([d, d, 0]) circle(3.2);
        ring(8, 5.5);
      }

      translate([- d, - d, 0]) circle(1.5);
      translate([- d, d, 0]) circle(1.5);
      translate([d, - d, 0]) circle(1.5);
      translate([d, d, 0]) circle(1.5);
    }
}

module ring(d, w=1) {
  difference() {
    circle(d);
    circle(w);
  }
}

module naca_pole(h,w=12) {
  linear_extrude(height=h, twist=0, scale=1)
    polygon(points = airfoil_data(naca=NACA, L=w, N=REFINEMENT));
}

module scaled_front_wing(l, r=0) {
  rotate_about_pt([r-90, 0, 0], [0, 7, 30.5])
    difference() {
      rotate_about_pt([90, 0, 0], [0, 7, 30.5])
      difference() {
        front_wing(l, 0);
        translate([0, 11, -0.5]) rotate([0, 270, 0]) {
          quad_cabin(false, 250, 1.1, 1, 0.8);
        }
      }
      translate([0, 11, -0.5]) rotate([0, 270, 0]) {
        quad_cabin(false, 250, 1.1, 1, 0.8);
      }
    }
}

module nubbins(l) {
  difference() {
    front_wing(l, 0);
    translate([0, 11, -7]) rotate([0, 270, 0]) {
      quad_cabin(false, 250, 1.1, 1, 0.8);
    }
    scaled_front_wing(l, 0);
  }
}

module back_wing_notch(l) {
  translate([0, -0, 2])
    scale([0.29, 0.82, 0.9])
      translate([- BW, 0.5, - BL / 4])
        bwing(l, 0);
}

module back_wing_mask() {
  translate([-35, -10, -10]) cube([70, 35, 105]);
}

scale([10, 10, 10]) {
  rotate([270, 180, 0]) {
    intersection() { // intersection or difference
      union() {
        if (HAS_BODY)
          rotate([0, 270, 0]) {
            //    top_shell();
  //              bottom_shell();
  //              floor();

              scale([1 / SCALE, 1 / SCALE, 1 / SCALE]) {
                quad_cabin(HAS_HATCH, 250, 1.1, 1, 0.8);
              }
          }

        scale([1 / SCALE, 1 / SCALE, 1 / SCALE]) {
          if (FLATTEN) {
            translate([0, -1, -11.2])
              scaled_front_wing(1, ANGLE);
          } else {
            translate([0, - 11.5, 1.5]) {
              //        nubbins(1);

              scaled_front_wing(1, ANGLE);

              if (HAS_FRONT_LEFT_AXLE) {
                translate([-BW-20, 7, 30.5]) {
                  rotate([0, 90, 0])
                    cylinder(BW-15, FRONT_AXLE_R, FRONT_AXLE_R);

                  if (HAS_PROPS) {
                    rotate([90, 0, 0])
                      translate([6, 0, -21]) prop2(60, 1);
                  }
                }
              }

              if (HAS_FRONT_RIGHT_AXLE) {
                translate([35, 7, 30.5]) {
                  rotate([0, 90, 0])
                    cylinder(BW-15, FRONT_AXLE_R, FRONT_AXLE_R);

                  if (HAS_PROPS) {
                    rotate([90,0,0])
                      translate([BW-34, 0, -21]) prop2(60, 1);
                  }
                }
              }
            }
          }

          if (FLATTEN) {
            translate([0, 6, 0])
              back_wing(1, ANGLE);
          } else {
            translate([0, 105.5, 295]) {
              difference() {
                back_wing(1, ANGLE);
//                back_wing_notch(1);
//                back_wing_mask();
              }

//              union() {
//                intersection() {
//                  back_wing(1, ANGLE);
//                  back_wing_mask();
//                }
//                intersection() {
//                  scale([1.2, 1, 1]) back_wing(1, ANGLE);
//                  back_wing_notch(1);
//                }
//              }
            }
          }
        }
      }

//      union() {
////        // front wing masks
//        translate([-20, -4, 0]) cube([20, 5, 12]);  // left
//        translate([0, -4, 0]) cube([20, 5, 12]);  // right
////
////        // back wing masks
//        translate([0, 13, 41]) cube([20, 5, 14]);
//        translate([- 20, 13, 41]) cube([20, 5, 14]);
//      }
    }
  }

  if (FLATTEN) {
    linear_extrude(height = 0.2)
      projection(cut = true)
        rotate([90, 0, 0])
          scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
            translate([30, - 44, 2])
              rotate([- 20, 0, 110])
                back_wing(1, ANGLE);
  }

  // measures
  if (MEASUREMENTS) {
    frpt = 4.55;
    uppt = 44.84;
    dnpt = 51.42;
    hoverpt = (dnpt - frpt) / 2 + frpt;
    cruisept = (uppt - frpt) * (BW_AREA / (FW_AREA + BW_AREA)) + frpt;

    color("red") {translate([- 20, uppt, 15.05]) sphere(0.2);}
    color("red") {translate([- 20, frpt, - 0.65]) sphere(0.2);}
    color("red") {translate([- 20, dnpt, - 0.65]) sphere(0.2);}
    color("orange") {translate([- 20, hoverpt, - 0.65]) sphere(0.2);}
    color("cyan") {translate([- 20, cruisept, - 0.65]) sphere(0.2);}
    color("lightgreen") {translate([- 30, 40.3, 3.9]) sphere(0.2);}
    color("lightgreen") {translate([- 30, 40.3, -1.3]) sphere(0.2);}
  }
}
