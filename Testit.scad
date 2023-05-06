

$fs=0.01;
$fa=6;
$fn=200;


module half() {
  difference() {
    import("X6_propeller.stl", convexity=3);
    translate([-350,-50,-50])
      cube([350,100,100]);
  }
}
//
//intersection() {
//  half();
//  translate([0,-34,-40])
//    cube(68);
//}
//
//scale([1,0.3,1]) 
//  intersection() {
//    translate([68,-34,-40])  
//      cube([300,68,68]);
//    half(); 
//  }


//module plane() {
//  cube([30,30,1])
//}

//s=sphere(10, center=true);


//hull() {
//
//cylinder(10);
//translate([8,0,0])
//  cylinder(10);
//
//  }



//points = [ [0,0,0], [10,0,0], [0,10,0], [10,10,0] ];
// 
//module rounded_box(points, radius, height){
//    hull(){
//        for (p = points){
//            translate(p) cylinder(r=radius, h=height);
//        }
//    }
//}
//
//rounded_box(points,3,10);


//difference() {
//  sphere(10);
//  translate([0,5,0])
//  cylinder(10,5,5,);
//}
//
//hull()
//  for (i = [0:9]) {
//      translate([0,0,i*2])
//       scale([1,1/(i/10+1),1])
//       linear_extrude(height=1, center=true)
//         projection(cut=true)
//          translate([0,0,i])
//            difference() {
//              sphere(10);
//              translate([0,5,0])
//              cylinder(10,5,5,);
//            }
//  }


module nslice(n,step) {
  for (i=[-n/2:step:n/2]) {
    translate([0,0,i])
      scale([1,1,1])
        linear_extrude(1)
          translate([0,0,i*n/2])
            projection(cut=true)
              translate([0,0,-i])
                children();
  }
}


module plane() {
  cube([100,100,1], center=true);
}


module xslice(to,from=0,step=1,angle=[0,0,0],from_scale=[1,1,1],to_scale=[1,1,1]) {
  sx = ((to_scale - from_scale) / (to-from));
  echo(sx);
  j=0;
  for (i = [from:step:to]) {
    intersection() {
      j = i - from;
      rotate(angle) translate([0,0,i]) plane();
      sc = from_scale + (sx * j);
      echo(i, j, sc);
      scale(sc)
        children();
    }
  }
}

module x_hull()
{
  // combine the hull between and the original objects
  difference() {
    hull() children();
    for (childIndex = [0 : $children-1]) {
      difference() {
        hull() children(childIndex);
        children(childIndex);
      }
    }
  }
}

//hull()
//  nslice(20,2)
//    sphere(11);
   
//hull() {
//  xslice(from=-15,to=25,step=1.5,angle=[0,90,0],to_scale=[2,2,1]) 
//    difference() {
//    sphere(10);
//    translate([0,6,-10])
//      cylinder(20,5,5,);
//  }  
//}

//hull()
  xslice(from=70,to=300,step=1,[0,90,0],to_scale=[1,0.3,1])
    half();
    
//intersection() {
//  cube(140, center=true);    
//  half();
//}

//hull()
//  xslice(from=70,to=100,step=2,[0,90,0],to_scale=[1,1,0.5])
//    cube([200,20,20], center = true);

    


//module nslice(obj,n) {
//  for(i=[0:n-1]) [
//    translate([0,i,0]) 
//      projection(cut=true)
//        translate([0,-i,0])
//          obj
//          ]
//}
//  
//  
//
//nslice(sphere(20),20);