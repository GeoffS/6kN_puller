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

boardInteriorExtraX = 0.2;
boardInteriorExtraY = boxInteriorCornerDia/2;

boardHolesY = boardHoleCtrsY + boardInteriorExtraY;

boxInteriorX = boardX + 2*boardInteriorExtraX;
boxInteriorY = boardY + 2*boardInteriorExtraY;
boxInteriorZ = boardClearanceBelow + boardThickness + boardClearanceAbove;
echo("boxInteriorZ = ", boxInteriorZ);
echo("0.47 inches = ", 0.47*25.4, "mm");

boxExteriorCZ = 1;

boxWallThicknessXY = 4*boxExteriorCZ + 2;
boxWallThicknessZ = 3;

boxExteriorCornerDia = boxInteriorCornerDia + boxWallThicknessXY;

boxExteriorZ = boxWallThicknessZ + boxInteriorZ;

cX = boxInteriorX/2 - boxInteriorCornerDia/2;
c1Y = boxInteriorCornerDia/2;
c2Y = boxInteriorY - boxInteriorCornerDia/2;

standoffOD = boardHoleDia + 2*1.5;
standoffBaseOD = standoffOD + 4;

topOfBoardZ = boardClearanceBelow + boardThickness;

frontOfBoardY = boardInteriorExtraY;

module itemModule()
{
	difference()
    {
        union()
        {
            // Basic box exterior and interior:
            difference()
            {
                exterior();

                // Interior:
                hull()
                {
                    doubleX() translate([cX, c1Y, 0]) simpleChamferedCylinderDoubleEnded1(d=boxInteriorCornerDia, h=100, cz=boxExteriorCZ);
                    doubleX() translate([cX, c2Y, 0]) simpleChamferedCylinderDoubleEnded1(d=boxInteriorCornerDia, h=100, cz=boxExteriorCZ);
                }

                // Interior top wall chamfer:
                hull()
                {
                    z = boxInteriorZ - boxInteriorCornerDia/2 - boxExteriorCZ;
                    doubleX() translate([cX, c1Y, z]) cylinder(d1=0, d2=20, h=10);
                    doubleX() translate([cX, c2Y, z]) cylinder(d1=0, d2=20, h=10);
                }

                // // Barrel-jack hole:
                tcu([-100, frontOfBoardY+20.5, topOfBoardZ-0.5], [100, 6.5, 8]);

                // // Micro-USB Hole:
                // tcu([-100, frontOfBoardY+9, topOfBoardZ-2], [100, 10, 50]);

                // // Barrel-jack and micro-USB holes combined:
                // tcu([-100, frontOfBoardY+9, topOfBoardZ-2], [100, 23, 50]);

                // 4-pin load-cell connector hole:
                openingY = 12; //4*(0.1*25.4) + 5; // 4 pins at 0.1" spacing plus some extra
                tcu([0, frontOfBoardY+boardY-openingY+0.5, topOfBoardZ+0.5], [100, openingY, 20]);
            }

            // Board support structure:
            translate([0,0,-nothing])
            {
                h = boardClearanceBelow + nothing;

                // Standoffs for board:
                holesXform() 
                {
                    cylinder(d=standoffOD, h=h);
                    // Chamfered at bottom:
                    translate([0,0,-nothing]) cylinder(d1=standoffBaseOD, d2=0, h=standoffOD/2+2);
                }

                // Front corners board supports:
                intersection()
                {
                    exterior();
                    
                    union()
                    {
                        d = 4;
                        cz = 1;
                        x1 = boxInteriorX/2 - 17; //boardHoleSpacingX/2 - standoffBaseOD/2 + d/2;
                        x2 = 40;
                        y1 = boardHolesY - d/2;
                        // Right side front:
                        hull()
                        {
                            translate([x1, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x1,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                        }
                        // Right side:
                        x3 = boxInteriorX/2 - 4.5;
                        y2 = 60;
                        hull()
                        {
                            translate([x3, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x3,y2,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2,y2,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                        }
                        // Left Side front:
                        x4 = -boxInteriorX/2 + 15;
                        hull()
                        {
                            translate([ x4, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([-x2, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([ x4,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([-x2,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                        }
                        // Left Side"
                        x5 = -boxInteriorX/2 + 4;
                        y3 = 21;
                        hull()
                        {
                            translate([ x5, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([-x2, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([ x5,y3,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([-x2,y3,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                        }
                    }
                }
            }
        }

        // Holes:
        holesXform() hole();
    }
}

module exterior()
{
    // Exterior:
    hull()
    {
        doubleX() translate([cX, c1Y, -boxWallThicknessZ]) simpleChamferedCylinderDoubleEnded1(d=boxExteriorCornerDia, h=boxExteriorZ, cz=boxExteriorCZ);
        doubleX() translate([cX, c2Y, -boxWallThicknessZ]) simpleChamferedCylinderDoubleEnded1(d=boxExteriorCornerDia, h=boxExteriorZ, cz=boxExteriorCZ);
    }
}

module hole()
{
    tcy([0,0,-100], d=3.2, h=200);
}

module holesXform()
{
    doubleX() translate([boardHoleSpacingX/2, boardHolesY, 0]) children();
}

module clip(d=0)
{
	// tc([-200, -400-d, -10], 400);

    // tcu([-d, -200, -200], 400);
    // tcu([-400-d, -200, -200], 400);
    // tcu([-200, boxInteriorY/2-d, -200], 400);
}

if(developmentRender)
{
	display() itemModule();
    displayGhost() boardGhost();
}
else
{
	itemModule();
}

module boardGhost()
{
    difference()
    {
        tcu([-boardX/2, boardInteriorExtraY, boardClearanceBelow], [boardX, boardY, boardThickness]);

        doubleX() translate([boardHoleSpacingX/2, boardHoleCtrsY+boardInteriorExtraY, -10]) cylinder(d=boardHoleDia, h=100);
    }
}
