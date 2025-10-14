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

mountZ = shaftFromFaceZ;

mountingScrewHeadRecessZ = mountingScrewLen - mountingHoleThreadDepth;

module itemModule()
{
	difference()
    {
        simpleChamferedCylinder(d=faceOD, h=mountZ, cz=1.5);

        tcy([0,0,-100], d=faceOpeningOD, h=200);
        translate([0,0,mountZ-faceOpeningOD/2-0.6]) cylinder(d2=30, d1=0, h=15);
        translate([0,0,-15+faceOpeningOD/2+0.6]) cylinder(d1=30, d2=0, h=15);

        for(a = [0, 120, 240])
        {
            rotate([0,0,a]) translate([mountingHoles1CtrsDia,0,])
            {
                tcy([0,0,-100], d=mountingHolesOD, h=200);
                tcy([0,0,mountingScrewHeadRecessZ], d=mountingHoleHeadRecessDia, h=200);
                translate([0,0,mountZ-mountingHoleHeadRecessDia/2-0.6]) cylinder(d2=10, d1=0, h=5);
            }
        }
    }
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
    displayGhost() encoderGhost();
}
else
{
	itemModule();
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
    difference()
    {
        cylinder(d=shaftOD, h=shaftFromFaceZ);
        tcu([shaftFlat-shaftOD/2, -20, 0], 40);
    }
}
