// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2025 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

makeNubs = false;
makeRubberBand = false;

$fn=120;

boardX = 19.1;
boardY = 34.0;
pcbThickness = 1.6;

boardEndPinsCtrsX = 12.7; // 0.5;
boardEndPintsExtraY = 7.5;
boardEndPinsOffseetY = 29.7;
boardEndPinsZ = 5.7;

boardMainPinsCtrsX = 15.0; // 0.6"?
boardMainPinsCtrsY = 27.7; // 1.1"?
boardMainPinsDia = boardX - boardMainPinsCtrsX;
boardMainPinsOffsetY = boardMainPinsDia/2;
boardMainPinsZ = 9;

echo(str("boardMainPinsDia = ", boardMainPinsDia));

mountCornerDia = 3;
mountExtraY = 3;
mountBaseZ = 1;

boardRecessZ = 4.5;

boardOffsetZ = mountBaseZ + boardMainPinsZ;

mountX = boardX + mountCornerDia + 2;
mountY = mountExtraY + boardY + boardEndPintsExtraY;
mountZ = mountBaseZ + boardMainPinsZ + boardRecessZ;

mountCZ = 1;

nubsDia = 2;

fingerRecessY = mountExtraY+boardY/2;

module mountExterior(nubs=false)
{
    difference()
    {
    translate([0, mountY/2, 0]) hull() doubleX() doubleY() 
        translate([(mountX-mountCornerDia)/2, (mountY-mountCornerDia)/2, 0]) 
            simpleChamferedCylinderDoubleEnded(d = mountCornerDia, h = mountZ, cz = mountCZ);
    
    // Make the nubs on "fingers" for more bend:
    if(nubs)
    {
        fingersGapY = 0.3;
        nubsXform() translate([-0.1, 0, mountBaseZ+1]) doubleY() tcu([0, 1,0], [20, fingersGapY, 20]);
    }
    }
}

module itemModule(nubs=false, rubberBands=false)
{
	difference()
    {
        mountExterior(nubs=nubs);

        // Board recess:
        boardRecessOffsetX = boardX/2;
        boardRecessOffsetY = mountExtraY-0.3;
        tcu([-boardRecessOffsetX, boardRecessOffsetY, boardOffsetZ], [boardX, 100, 100]);

        // Board recess chamfer:
        boardRecessCZ = 1;
        hull() 
        {
            doubleX() translate([-boardRecessOffsetX, boardRecessOffsetY, mountZ-boardRecessCZ]) cylinder(d1=0, d2=10, h=5);
            doubleX() translate([-boardRecessOffsetX, 60, mountZ-boardRecessCZ]) cylinder(d1=0, d2=10, h=5);
        }

        // Main-pins recess:
        doubleX() hull()
        {
            tcy([boardMainPinsCtrsX/2, boardMainPinsOffsetY+mountExtraY, mountBaseZ], d=boardMainPinsDia, h=100);
            tcy([boardMainPinsCtrsX/2, boardMainPinsOffsetY+mountExtraY+boardMainPinsCtrsY, mountBaseZ], d=boardMainPinsDia, h=100);
        }
        
        // End-pins recess:
        hull()
        {
            doubleX() tcy([boardEndPinsCtrsX/2, boardEndPinsOffseetY+mountExtraY, boardOffsetZ-boardEndPinsZ], d=boardMainPinsDia, h=100);
            doubleX() tcy([boardEndPinsCtrsX/2, 100, boardOffsetZ-boardEndPinsZ], d=boardMainPinsDia, h=100);
        }

        // End-pins connector recess:
        doubleX() hull()
        {
            tcy([boardMainPinsCtrsX/2, mountY-boardEndPintsExtraY, boardOffsetZ-boardEndPinsZ], d=boardMainPinsDia, h=100);
            tcy([boardMainPinsCtrsX/2, 100, boardOffsetZ-boardEndPinsZ], d=boardMainPinsDia, h=100);
        }

        // Finger recesses:
        d = 20;
        difference()
        {
            translate([0, fingerRecessY, mountZ+0.2])
            {
                
                d2 = d * 1.4;
                doubleX() hull()
                {
                    tsp([mountX/2+d/2-6, 0, d*0.07], d=d);
                    tsp([mountX/2+d2/2-6, 0, d*0.4], d=d2);
                }
                f = 0.8;
                difference() 
                {
                    hull() doubleX() 
                    {
                        tsp([100, 0, d*0.07], d=d*f);
                        tsp([100, 0, d*0.4], d=d2*f);
                    }
                }
            }

            // Trim the center:
            bx1 = boardX - 1;
            tcu([-bx1/2, -10, 0], [bx1, 200, 100]);
        }
    }

    // Detents to keep the board from falling out:
    if(nubs) intersection() 
    {
        mountExterior(nubs=nubs);
        nubsXform() tsp([nubsDia/2-0.5, 0, boardOffsetZ+pcbThickness+nubsDia/2-0.3], d=nubsDia);
        
    }

    // Rubber band holders:
    if(rubberBands) 
    {
        rubberBandHoleDia = 3.5;
        rubberbandTabZ = 5;
        mx2 = mountX/2;
        dx = mx2 + rubberBandHoleDia/2 + mountCZ + 0.2;
        echo(str("dx = ", dx));
        difference()
        {
            translate([0, fingerRecessY, 0]) 
            {   
                difference()
                {
                    hull() doubleX() doubleY() translate([dx, 1, 0]) simpleChamferedCylinderDoubleEnded(d=10, h=rubberbandTabZ, cz=mountCZ);
                    // Hole at -X:
                    translate([-dx, 0, 0]) 
                    {
                        // Hole:
                        tcy([0,0,-10], d=rubberBandHoleDia, h=50);
                        // Chamfers:
                        translate([0,0,rubberbandTabZ/2]) doubleZ() translate([0,0,rubberbandTabZ/2-rubberBandHoleDia/2-mountCZ]) cylinder(d1=0, d2=10, h=5);
                    }
                }
            }
            mountExterior();
        }
    }
}

module nubsXform()
{
    translate([0, boardY/2+mountExtraY, 0]) doubleX() doubleY() translate([boardX/2, boardY/2-5.5, 0]) children();
}

module clip(d=0)
{
	// tcu([-400-14.8-d, -200, -10], 400);
}

if(developmentRender)
{
	// display() itemModule(rubberBands=true);
    // displayGhost() boardGhost();
    // display() translate([-40,0,0]) itemModule(nubs=true);

	display() itemModule(nubs=true);
    displayGhost() boardGhost();
    display() translate([-40,0,0]) itemModule(rubberBands=true);
}
else
{
	if(makeNubs) itemModule(nubs=true);
    if(makeRubberBand) itemModule(rubberBands=true);
}

module boardGhost()
{
    tcu([-boardX/2, mountExtraY, boardOffsetZ], [boardX, boardY, pcbThickness]);
}
