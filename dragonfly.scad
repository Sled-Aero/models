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
HAS_AXLES = true;
MEASUREMENTS = false;

REFINEMENT = 100;
ANGLE = 90;
DIHEDRAL = 18;
SPAN = 25;
NACA = 2414;
ATTACK = 5;
SCALE = 7;
SPAR_CORE_R = 0.45 * SCALE;
FRONT_AXLE_R = 0.525 * SCALE; // 1.225;
AXLE_HEIGHT = 3;
FRONT_AXLE_OFFSET = 45;
BACK_AXLE_OFFSET = 280;

WING_AREA = 30000 / cos(DIHEDRAL);
BW_AREA = WING_AREA / 1.9;
FW_AREA = WING_AREA-BW_AREA;
WW = 160 * cos(DIHEDRAL);
FRONT_CABIN_WIDTH = 36;
BACK_CABIN_WIDTH = 25;
CABIN_OVERLAP = 10;
FW = WW - FRONT_CABIN_WIDTH;
BW = WW - BACK_CABIN_WIDTH;
FL = FW_AREA / (FW * 2);
BL = BW_AREA / (BW * 2);

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

module wing(w, l, a=0) {
  // wing data - first dimension selects airfoil
  //             next 3 dimensions describe xyz offsets
  //             last dimension describes rotation of airfoil
  X = [//L,  dx,      dy,  dz,    R
      [l,   w,    0,   SPAN,   -ATTACK,  0],
      [l,   1,     0,   SPAN,   -ATTACK,  0],
      [l,   0.1,   0,   SPAN,   -ATTACK,  0]
  ];
  Xs = nSpline(X, 150); // interpolate wing data

  difference() {
    sweep(gen_dat(Xs, 0, REFINEMENT));

    rotate([0, 90, 0])
      translate([-25.5,0,0]) {
        translate([-l/4,-0.3,0])
          cylinder(w+1, r = FRONT_AXLE_R);
        translate([-l/2,-1.6,0])
          cylinder(w+1, r = SPAR_CORE_R);
      }
  }

  if (HAS_PROPS) {
    translate([w-3, -0.3, 2.5+l/4]) rotate([0,a,0])
      prop2(60, 1);
  }
}

module front_disc(rot=0, intersect=true) {
  rotate([0,0,0])
    rotate_about_pt([90-rot,0,0], [0,0,0])
      scale([1.01,1,1])
          intersection() {
            translate([FRONT_CABIN_WIDTH -8, 0, 0]) {
              difference() {
                rotate([0, 90, 0]) {
                  cylinder(15, r = 16.5);
                }

                if (intersect)
                  translate([0,0,0])
                    rotate([0, 12, -9]) {
                      cube([10, 40, 40], true);
                    }
              }
              //        translate([0,-10,0]) rotate([0, 90, 0]) cylinder(5, r = 10);
            }

            if (intersect)
              translate([0, - AXLE_HEIGHT, - FRONT_AXLE_OFFSET])
                scale([SCALE, SCALE, SCALE])
                  rotate([0, 270, 0]) {
                    dragonfly_cabin();
                  }
          }
}

module front_wing(rot=0) {
  rotate([0,0,0])
    rotate_about_pt([90-rot,0,0], [0,0,0]) {
      if (HAS_AXLES)
        rotate([0, 0, - DIHEDRAL])
          translate([FRONT_CABIN_WIDTH / 2 + 15, 0, 0]) rotate([0, 90, 0]) cylinder(FW + 20, r = FRONT_AXLE_R);

      difference() {
        rotate([0, 0, - DIHEDRAL]) {
          translate([FRONT_CABIN_WIDTH, 0.3, - 25.5 - FL / 4])
            wing(FW, FL, 0);
        }

        translate([0, -AXLE_HEIGHT, -FRONT_AXLE_OFFSET])
          scale([SCALE, SCALE, SCALE])
            rotate([0, 270, 0]) {
              dragonfly_cabin();
            }
      }
  }
}

module back_disc(rot=0) {
  rotate([0,0,0])
    rotate_about_pt([90-rot,0,0], [0,0,0]) {
      translate([BACK_CABIN_WIDTH -12, 0, 0]) {
        rotate([0, 90, 0]) cylinder(5, r = 13);
//        translate([0, 10, 0]) rotate([0, 90, 0]) cylinder(5, r = 10);
      }
    }
}

module back_wing(rot=0) {
  rotate([0,0,0])
    rotate_about_pt([90-rot,0,0], [0,0,0]) {
      rotate([0,0,DIHEDRAL]) {
        if (HAS_AXLES)
          translate([BACK_CABIN_WIDTH/2+7, 0, 0]) rotate([0, 90, 0]) cylinder(BW+22, r=FRONT_AXLE_R);

        translate([BACK_CABIN_WIDTH, 0.3, -25.5-BL/4])
          wing(BW,BL,0);
      }
    }
}

module prop2(r,offset) {
  if (HAS_BLADES)
    translate([6.25,0,-13]) {
      cylinder(12,3,3);
      sphere(3);
      cylinder(4, r, r);
    }

  scale([SCALE / 10, SCALE / 10, SCALE / 10])
    translate([9,0,-13]) {
      2810_motor();
      landing_gear(false);
    }
}

scale([10, 10, 10]) {
  rotate([270, 180, 0]) {
    union() {
      if (HAS_BODY) {
        difference() {
          rotate([0, 270, 0]) {
            dragonfly_shell();
          }

          scale([1 / SCALE, 1 / SCALE, 1 / SCALE])
            translate([0, AXLE_HEIGHT, FRONT_AXLE_OFFSET]) {
              front_disc(ANGLE, false);
              mirror([1, 0, 0]) front_disc(ANGLE, false);
          }
        }
      }

      scale([1 / SCALE, 1 / SCALE, 1 / SCALE]) {
        translate([0, AXLE_HEIGHT, FRONT_AXLE_OFFSET]) {
          front_disc(ANGLE);
          mirror([1, 0, 0]) front_disc(ANGLE);
        }

        translate([0, AXLE_HEIGHT, BACK_AXLE_OFFSET]) {
          back_disc(ANGLE);
          mirror([1, 0, 0]) back_disc(ANGLE);
        }

        difference() {
          union() {
            translate([0, AXLE_HEIGHT, FRONT_AXLE_OFFSET]) {
              front_wing(ANGLE);
              mirror([1, 0, 0]) front_wing(ANGLE);
            }

            translate([0, AXLE_HEIGHT, BACK_AXLE_OFFSET]) {
              back_wing(ANGLE);
              mirror([1, 0, 0]) back_wing(ANGLE);
            }
          }

//          scale([SCALE, SCALE, SCALE])
//            rotate([0, 270, 0]) {
//              dragonfly_cabin();
//            }
        }
      }
    }
  }
}
