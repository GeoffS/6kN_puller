include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

shaftOD = 6;
shaftFlat = 5.48;
shaftFromFaceZ = 20;

faceOD = 38.3;
faceOpeningOD = 20.2;
faceOpeningZ = 5;

mountingHoles1CtrsDia = 13.8;
mountingHolesOD = 3.2; // m3
mountingHoleHeadRecessDia = 5.9; // m3 SH
mountingHoleThreadDepth = 4;
mountingScrewLen = 8;

mountZ = shaftFromFaceZ + 1.8;
mountOD = faceOD;

mountingScrewHeadRecessZ = mountingScrewLen - mountingHoleThreadDepth;

module mount()
{
	difference()
    {
        simpleChamferedCylinder(d=mountOD, h=mountZ, cz=1.5);

        tcy([0,0,-100], d=faceOpeningOD, h=200);
        translate([0,0,mountZ-faceOpeningOD/2-0.6]) cylinder(d2=30, d1=0, h=15);
        translate([0,0,-15+faceOpeningOD/2+0.6]) cylinder(d1=30, d2=0, h=15);

        // Mounting screw holes:
        for(a = [0, 120, 240])
        {
            rotate([0,0,a]) translate([mountingHoles1CtrsDia,0,0])
            {
                tcy([0,0,-100], d=mountingHolesOD, h=200);
                tcy([0,0,mountingScrewHeadRecessZ], d=mountingHoleHeadRecessDia, h=200);
                translate([0,0,mountZ-mountingHoleHeadRecessDia/2-0.6]) cylinder(d2=10, d1=0, h=5);
            }
        }

        // string guides:
        translate([0,0,faceOpeningZ]) translate([0,0,sheaveZ/2]) 
            doubleZ() 
                translate([0,0,-sheaveZ/2+4.4])  
                    rotate([0,-90,0]) 
                    {
                        stringHoleDia = 2;
                        cylinder(d=stringHoleDia, h=100);
                        translate([0,0,faceOpeningOD/2-3+stringHoleDia/2+0.6]) cylinder(d1=6,d2=0,h=3);
                        translate([0,0,mountOD/2-stringHoleDia/2-1.5]) cylinder(d2=6,d1=0,h=3);
                    }
    }
}

sheaveZ = shaftFromFaceZ - faceOpeningZ;
sheaveDia = shaftOD + 2*4.4; // Aded 4.7mm for m3 set-screw.
echo(str("sheaveDia = ", sheaveDia));

module sheave()
{
    difference() 
    {
        union()
        {
            // Main body:
            cylinder(d=sheaveDia, h=sheaveZ);
            // Ends:
            translate([0,0,sheaveZ/2]) doubleZ() translate([0,0,-sheaveZ/2]) simpleChamferedCylinder(d=faceOpeningOD-1, h=3, cz=2.25);
        }
        rotate([0,0,180]) shaft(dd=0.2, z=20);
        // Set screw:
        translate([0,0,sheaveZ/2]) rotate([0,-90,0]) cylinder(d=2.9, h=100);
        
    }
}

module shaft(dd=0, z=shaftFromFaceZ)
{
    effDia = shaftOD + dd;
    difference()
    {
        cylinder(d=effDia, h=z);
        tcu([shaftFlat-shaftOD/2+dd/2, -20, -1], 40);
    }
}

module clip(d=0)
{
	tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
    display() sheave();
    translate([0,0,-faceOpeningZ])
    {
        displayGhost() mount();
        displayGhost() encoderGhost();
    }

	// display() mount();
    // displayGhost() encoderGhost();
}
else
{
	mount();
}

module encoderGhost()
{
    faceZ = 2.8;
    bodyOD = 38.5;
    bodyAndFaceZ = 35;
    bodyZ = bodyAndFaceZ - faceZ;

    tcy([0,0,-faceZ], d=faceOD, h=faceZ);
    tcy([0,0,-bodyAndFaceZ], d=bodyOD, h=bodyZ);
    simpleChamferedCylinder(d=faceOpeningOD, h=faceOpeningZ, cz=0.2);
    rotate([0,0,180]) shaft();
}
