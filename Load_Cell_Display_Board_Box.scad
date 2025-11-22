include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>
include <../OpenSCADdesigns/Hardware.scad>


boardX = 55;
boardY = 35;
boardClearanceBelow = 4.8;
boardThickness = 1.6;
boardClearanceAbove = 9.5;
boardHoleSpacingX = 31.6;
boardHolesOffsetX = -1.3;
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
standoffBaseOD = standoffOD + 6;

topOfBoardZ = boardClearanceBelow + boardThickness;
echo(str("topOfBoardZ = ", topOfBoardZ));

frontOfBoardY = boardInteriorExtraY;

boltLength = 8; // M3x8mm
// nutRecessDia = M3_nutRecessDia;
// nutRecessZ = topOfBoardZ - boltLength - M3_nutRecessDepth;
// echo(str("nutRecessZ = ", nutRecessZ));

module itemModule(testPrint=false)
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

                if(!testPrint) 
                {
                    // Barrel-jack hole:
                    barrelJackHoleZ = 20; //8;
                    tcu([-100, frontOfBoardY+21.1, topOfBoardZ-0.5], [100, 6.5, barrelJackHoleZ]);

                    // 4-pin load-cell connector hole:
                    openingY = 12.5;
                    tcu([0, frontOfBoardY+boardY-openingY+0.4, topOfBoardZ+0.5], [100, openingY, 20]);
                }
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
                    // translate([0,0,-nothing]) cylinder(d1=standoffBaseOD, d2=0, h=standoffOD);
                }

                // Front corners board supports:
                intersection()
                {
                    exterior();
                    
                    echo(str("boxInteriorX/2 = ", boxInteriorX/2));
                    union()
                    {
                        d = 4;
                        cz = 1;
                        x1 = boxInteriorX/2 - 17 + d/2;
                        x2 = 40;
                        y1 = boardInteriorExtraY + 14 - d/2;
                        // Right side front:
                        hull()
                        {
                            translate([x1, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x1,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                        }
                        // Right side:
                        x3 = boxInteriorX/2 - 4.5 + d/2;
                        y2 = 60;
                        hull()
                        {
                            translate([x3, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x3,y2,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([x2,y2,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                        }
                        // Left Side front:
                        x4 = -boxInteriorX/2 + 15.1 - d/2;
                        hull()
                        {
                            translate([ x4, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([-x2, 0,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([ x4,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                            translate([-x2,y1,0]) simpleChamferedCylinder(d=d, h=h, cz=cz);
                        }
                        // Left Side:
                        x5 = -boxInteriorX/2 + 4 - d/2;
                        y3 = boardInteriorExtraY + 18 - d/2;
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

        if(testPrint) tcu([-200, -200, boardClearanceBelow+boardThickness-0.4], 400);
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
    tcy([0,0,-100], d=3, h=200);
    // tcy([0,0,-20-boxWallThicknessZ-nutRecessZ], d=nutRecessDia, h=20, $fn=6);
}

module holesXform()
{
    translate([boardHolesOffsetX, boardHolesY, 0]) doubleX() translate([boardHoleSpacingX/2, 0, 0]) children();
}

module clip(d=0)
{
	// tc([-200, -400+0.1-d, -10], 400);

    // tcu([-d, -200, -200], 400);
    // tcu([-400-d, -200, -200], 400);
    // tcu([-200, boxInteriorY/2-d, -200], 400);

    // tcu([boardHolesOffsetX+boardHoleSpacingX/2-d, -200, -100], 400);
}

if(developmentRender)
{
	display() itemModule(testPrint=false);
    displayGhost() boardGhost();
    displayGhost() boltGhosts();
}
else
{
	itemModule(testPrint=false);
}

module boardGhost()
{
    translate([-boardX/2, boardInteriorExtraY, boardClearanceBelow]) difference()
    {
        tcu([0, 0, 0], [boardX, boardY, boardThickness]);

        translate([0,10.6,0])
        {
            // Left hole:
            tcy([10.6, 0, -50], d=3, h=100);
            // Right Hole
            tcy([42.0, 0, -50], d=3, h=100);
        }
    }
}

module boltGhosts()
{
    boltGhost(x = 10.6);
    boltGhost(x = 42.0);
}

module boltGhost(x)
{
    translate([x-boardX/2, 10.6+boardInteriorExtraY, topOfBoardZ])
    {
        tcy([0,0,0], d=5.4, h=2.9);
        tcy([0,0,-boltLength], d=3, h=boltLength);
    }
}
