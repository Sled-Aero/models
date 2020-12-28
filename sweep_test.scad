
use <sweep.scad>
use <utils/transformations.scad>
use <utils/shapes.scad>

bottom_w = 120;
top_w = 3;
height = 120;
steps = 360;

pathstep = height/steps;
delt = top_w - bottom_w;

square_points = square(1);
circle_points = circle(r=0.5, $fn=60);

sweep(circle_points, my_path);

my_path = [ for (i=[0:steps])
    translation([18*sin(i), 18-18*cos(i*0.7),     36*sin(i/2)]) *
    //scaling([11 * (1.2 - i/steps), 11 * (1.2 - i/steps), 1]) *
    rotation([0,0, steps]) ];


module parabola()
    projection(cut = true)
        rotate([0, 70, 0]) cylinder(d1 = 20, d2 = 0, h = 30);

//sweep(parabola);

//
//function f(t) = [
//    (t / 1.5 + 0.5) * 100 * cos(6 * 360 * t),
//    (t / 1.5 + 0.5) * 100 * sin(6 * 360 * t),
//    200 * (1 - t)
//];
//
//function shape() = [
//    [-10, -1],
//    [-10,  6],
//    [ -7,  6],
//    [ -7,  1],
//    [  7,  1],
//    [  7,  6],
//    [ 10,  6],
//    [ 10, -1]];
//
//step = 0.005;
//path = [for (t=[0:step:1-step]) f(t)];
//path_transforms = construct_transform_path(path);
//sweep(square(2), path_transforms);


function func0(x)= 1;
function func1(x) = 30 * sin(180 * x);
function func2(x) = -30 * sin(180 * x);
function func3(x) = (sin(270 * (1 - x) - 90) * sqrt(6 * (1 - x)) + 2);
function func4(x) = 100 / ((x * x) + 1);
function func5(x) = 2 * 180 * x * x * x;
function func6(x) = 3 - 2.5 * x;

pathstep = 1;
height = 100;

shape_points = square(10);
//path_transforms1 = [for (i=[0:pathstep:height]) let(t=i/height) translation([func1(t),func1(t),i]) * rotation([0,0,func4(t)])];
//path_transforms2 = [for (i=[0:pathstep:height]) let(t=i/height) translation([func2(t),func2(t),i]) * rotation([0,0,func4(t)])];
//path_transforms3 = [for (i=[0:pathstep:height]) let(t=i/height) translation([func1(t),func2(t),i]) * rotation([0,0,func4(t)])];
path_transforms4 = [for (i=[0:pathstep:height]) let(t=i/height) translation([func4(t),(t),i]) * rotation([0,0,0])];
//sweep(shape_points, path_transforms1);
//sweep(shape_points, path_transforms2);
//sweep(shape_points, path_transforms3);
sweep(shape_points, path_transforms4);


//path_transforms5 = [for (i=[0:pathstep:height]) let(t=i/height) translation([0,0,i]) * scaling([func3(t),func3(t),i]) * rotation([0,0,func4(t)])];
//translate([100, 0, 0]) sweep(shape_points, path_transforms5);
//
//
//path_transforms6 = [for (i=[0:pathstep:height]) let(t=i/height) translation([0,0,i]) * scaling([func6(t),func6(t),i]) * rotation([0,0,func5(t)])];
//translate([-100, 0, 0]) sweep(shape_points, path_transforms6);



ring_extrude(square(2), radius = 50, angle = 180, scale = 2);