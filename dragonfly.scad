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
use <landing_gear.scad>
use <servos.scad>


$fs=0.1;
$fa=6;
$fn=100;

HAS_PROPS = true;
HAS_BLADES = true;
HAS_SHELL = true;
HAS_BODY = true;
MEASUREMENTS = false;

REFINEMENT = 100;
ANGLE = 90;
DIHEDRAL = 15;
RAKE = 0;
SPAN = 25;
NACA = 2414;
ATTACK = 5;
SCALE = 7;
SPAR_CORE_1_R = 0.2 * SCALE;
SPAR_CORE_2_R = 0.4 * SCALE;
FRONT_AXLE_R = 0.525 * SCALE; // 1.225;
REAR_AXLE_R = 0.4 * SCALE; // 1.225;

WING_AREA = 30000 / cos(DIHEDRAL);
BW_AREA = WING_AREA / 2;
FW_AREA = WING_AREA-BW_AREA;
BW = 125 * cos(DIHEDRAL);   // one wing
FRONT_CABIN_WIDTH = 33;     // one side
BACK_CABIN_WIDTH = 30;     // one side
CABIN_WIDTH = 50;
CABIN_OVERLAP=10;
FW = BW;
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

module wing(w, l=25, a=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  X = [//L,  dx,      dy,  dz,    R
      [FL,   w,    0,   l,   -ATTACK,  0],
      [FL,   1,     0,   l,   -ATTACK,  0],
      [FL,   0.1,   0,   l,   -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data
  difference() {
    sweep(gen_dat(Xs, 0, REFINEMENT));
//    translate([w, 0, l * 2.5]) rotate([0, a, 0]) cube([20, 20, l * 4], true);
  }

  if (HAS_PROPS) {
    translate([w-3, 0, 19]) rotate([0,a,0])
      prop2(60, 1);
  }
}

module front_wing(rot=0) {
  translate([0,7,30.5]) {
    rotate([0,RAKE,0])
      rotate_about_pt([90-rot,0,0], [0,0,0]) {
        rotate([0,0,-DIHEDRAL]) {
          translate([FRONT_CABIN_WIDTH, 0.3, -20.5-FL/4])
            wing(FW,SPAN,-RAKE);

          translate([FRONT_CABIN_WIDTH, 0, 0]) {
            rotate([0, 90, 0]) cylinder(FW, FRONT_AXLE_R, FRONT_AXLE_R);

            translate([0, -1.5, FL/4]) rotate([0, 90, 0]) cylinder(FW, SPAR_CORE_2_R, SPAR_CORE_2_R);
          }
       }
    }
  
    mirror([1, 0, 0]) {
      rotate([0,RAKE,0])
        rotate_about_pt([90-rot,0,0], [0,0,0]) {
          rotate([0,0,-DIHEDRAL]) {
            translate([FRONT_CABIN_WIDTH, 0.3, -20.5-FL/4])
              wing(FW,SPAN,-RAKE);

            translate([FRONT_CABIN_WIDTH, 0, 0]) {
              rotate([0, 90, 0]) cylinder(FW, FRONT_AXLE_R, FRONT_AXLE_R);

              translate([0, -1.5, FL/4]) rotate([0, 90, 0]) cylinder(FW, SPAR_CORE_2_R, SPAR_CORE_2_R);
            }
          }
      }
    }
  }
}

module back_wing(rot=0) {
  translate([0,7,30.5]) {
    rotate([0,-RAKE,0])
      rotate_about_pt([90-rot,0,0], [0,0,0]) {
        rotate([0,0,DIHEDRAL]) {
          translate([BACK_CABIN_WIDTH, 0.3, -20.5-FL/4])
            wing(BW,SPAN,RAKE);

          translate([BACK_CABIN_WIDTH, 0, 0]) {
            rotate([0, 90, 0]) cylinder(FW, FRONT_AXLE_R, FRONT_AXLE_R);

            translate([0, -1.5, FL/4]) rotate([0, 90, 0]) cylinder(BW, SPAR_CORE_2_R, SPAR_CORE_2_R);
          }
        }
      }

    mirror([1, 0, 0]) {
      rotate([0,-RAKE,0])
        rotate_about_pt([90-rot,0,0], [0,0,0]) {
          rotate([0,0,DIHEDRAL]) {
            translate([BACK_CABIN_WIDTH, 0.3, -20.5-FL/4])
              wing(BW,SPAN,RAKE);

            translate([BACK_CABIN_WIDTH, 0, 0]) {
              rotate([0, 90, 0]) cylinder(FW, FRONT_AXLE_R, FRONT_AXLE_R);

              translate([0, -1.5, FL/4]) rotate([0, 90, 0]) cylinder(BW, SPAR_CORE_2_R, SPAR_CORE_2_R);
            }
          }
        }
    }
  }
}

module prop2(r,offset) {
  if (HAS_BLADES)
    translate([9,0,-22]) {
      cylinder(12,3,3);
      sphere(3);
      cylinder(4, r, r);
    }

  scale([SCALE / 10, SCALE / 10, SCALE / 10])
    translate([9,0,-16]) {
      2810_motor();
      landing_gear(false);
    }
}

scale([10, 10, 10]) {
  rotate([270, 180, 0]) {
    intersection() { // intersection or difference
      union() {
        if (HAS_BODY)
          rotate([0, 270, 0]) {
            dragonfly_cabin();
          }

        scale([1 / SCALE, 1 / SCALE, 1 / SCALE]) {
          translate([0, -10, 10]) {
            front_wing(ANGLE);

            //            if (HAS_FRONT_LEFT_AXLE) {
//              translate([-BW-20, 7, 30.5]) {
//                rotate([0, 90, 0])
//                  cylinder(BW-15, FRONT_AXLE_R, FRONT_AXLE_R);
//
//                if (HAS_PROPS) {
//                  rotate([ANGLE, 0, 0])
//                    translate([6, 0, -21]) prop2(60, 1);
//                }
//              }
//            }

            //            if (HAS_FRONT_RIGHT_AXLE) {
//              translate([35, 7, 30.5]) {
//                rotate([0, 90, 0])
//                  cylinder(BW-15, FRONT_AXLE_R, FRONT_AXLE_R);
//
//                if (HAS_PROPS) {
//                  rotate([ANGLE,0,0])
//                    translate([BW-34, 0, -21]) prop2(60, 1);
//                }
//              }
//            }

          }
            translate([0, -10, 240]) {
              back_wing(ANGLE);
          }
        }
      }
    }
  }
}
