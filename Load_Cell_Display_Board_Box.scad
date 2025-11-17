include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>


boardX = 55;
boardY = 35;
boardClearanceBelow = 4.8;
boardThickness = 1.6;
boardClearanceAbove = 9.5;
boardHoleSpacingX = 31.4;
boardHoleCtrsY = 10.6;
boardHoleDia = 3.1;

boxInteriorCornerDia = 10;
boxInteriorX = boardX + boxInteriorCornerDia;
boxInteriorY = boardY + boxInteriorCornerDia;
boxInteriorZ = boardClearanceBelow + boardThickness + boardClearanceAbove;

boxExteriorCZ = 1;

boxWallThicknessXY = 2*boxExteriorCZ + 2;
boxWallThicknessZ = 2;

boxExteriorCornerDia = boxInteriorCornerDia + boxWallThicknessXY;

boxExteriorZ = boxWallThicknessZ + boxInteriorZ;

cX = boxInteriorX/2 - boxInteriorCornerDia/2;
c1Y = boxInteriorCornerDia/2;
c2Y = boxInteriorY + boxInteriorCornerDia/2;

module itemModule()
{
	difference()
    {
        hull()
        {
            doubleX() translate([cX, c1Y, -boxWallThicknessZ]) simpleChamferedCylinderDoubleEnded(d=boxExteriorCornerDia, h=boxExteriorZ, cz=boxExteriorCZ);
            doubleX() translate([cX, c2Y, -boxWallThicknessZ]) simpleChamferedCylinderDoubleEnded(d=boxExteriorCornerDia, h=boxExteriorZ, cz=boxExteriorCZ);
        }

        hull()
        {
            doubleX() translate([cX, c1Y, 0]) simpleChamferedCylinderDoubleEnded(d=boxInteriorCornerDia, h=100, cz=boxExteriorCZ);
            doubleX() translate([cX, c2Y, 0]) simpleChamferedCylinderDoubleEnded(d=boxInteriorCornerDia, h=100, cz=boxExteriorCZ);
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
}
else
{
	itemModule();
}
