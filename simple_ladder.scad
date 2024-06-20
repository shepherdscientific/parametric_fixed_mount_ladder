// baseplate constants
screwhole_offset = 15;
screwhole_radius = 2.5;
baseplate_x = 175;
baseplate_y = 95;
platethickness=3;
piperadius=15;
// ladder constants
incline_deg = 1;
z = 2400;               // height
width = 320;
step_spacing=300;       // space between steps
num_steps=35;
num_segments=5;
steps_seg=num_steps/num_segments;
echo("    steps per segment : ",steps_seg);
//
x_delta = round( z * tan(incline_deg));
hypotenouse = ( z / cos(incline_deg));
echo(x_delta);
echo(hypotenouse);
for (i = [1:1:num_segments]){
    segment(steps_seg,step_spacing,5);
}


module segment(steps,spacing,start){
    
    rail(steps,spacing,"left");
    translate([0,width,0])
    rail(steps,spacing,"right");
    
    for (i = [1:1:steps+1]){
        z_delta = (i-1)*step_spacing;
        x_delta = z_delta*tan(incline_deg);
        translate([x_delta,0,step_spacing*steps-z_delta])
        step();
    }
}
module step(){
    translate([100-piperadius/2,width+piperadius,20+piperadius/2])
    rotate([90,0,0])
    cylinder(r=piperadius, h=width+piperadius*2);
}
module rail(steps,spacing,side){
    adjacent = (step_spacing*(steps_seg))+piperadius*2;
    hyp = adjacent / cos(incline_deg);
    opp = adjacent * tan(incline_deg);
    echo("  adjacent    : ", adjacent);
    echo("  hypotenouse : ", hyp);
    echo("  opposite : ", opp);
    translate([100+20+opp,0,piperadius])
    rotate([0,-incline_deg,0])
    cylinder(r=piperadius, h=hyp);
    rotate([0,90,0]) baseplate("down",opp);
    translate([0,0,step_spacing*(steps_seg)+60])
    rotate([0,90,0]) baseplate("up",0);
    mid_x_delta = ((step_spacing*(steps_seg)+60)/2)*tan(incline_deg);
    if (side=="right"){
        translate([0,0,(step_spacing*(steps_seg)+60)/2])
        rotate([0,90,0]) baseplate("midr",mid_x_delta);
    }else if(side=="left"){
        translate([0,0,(step_spacing*(steps_seg)+60)/2])
        rotate([0,90,0]) baseplate("midl",mid_x_delta);
    }
    
}

module baseplate(type,depth){
    if (type=="midr"){
        translate([-20,20,0])
        baseplate();
    } else if (type=="midl"){
        translate([-20,-20,0])
        baseplate();
    }else{
        baseplate();
    }
    module baseplate(){
    cylinder(r=piperadius, 100+depth);
linear_extrude(height=platethickness){
    
    difference(){
            roundedplate();
            translate([baseplate_x/2-screwhole_offset,baseplate_y/2-screwhole_offset,0]) circle(screwhole_radius);
            translate([baseplate_x/2-screwhole_offset,-
            baseplate_y/2+screwhole_offset,0]) circle(screwhole_radius);
            translate([-baseplate_x/2+screwhole_offset,baseplate_y/2-screwhole_offset,0]) circle(screwhole_radius);
            translate([-baseplate_x/2+screwhole_offset,-baseplate_y/2+screwhole_offset,0]) circle(screwhole_radius);
        }
    }
    }
    translate([0,0,depth])
    arc(20,type);
}

module roundedplate(){
minkowski()
{
    square([baseplate_x,baseplate_y],center=true);
    circle(r = 10);
}
}

module arc(rad,type){
    eps = 0.01;
    echo(type);
    translate([eps-rad, 0, 100])
    if (type=="down"){
        rotate([90,0,0]) arc(90+incline_deg);
    } else if( type=="up"){
        translate([40,0,0])
        rotate([90,-90-incline_deg,0]) arc(90-incline_deg);
    } else if( type=="midr"){
        rotate([90,0,90]) arc(90);
    } else if( type=="midl"){
        rotate([90,0,-90]) arc(90);
    }
    module arc(angle){
       rotate_extrude(angle=angle, convexity=10)
           translate([rad, 0]) circle(piperadius);     
        }
    
}