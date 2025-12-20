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
boardMainPinsOffsetY = 1.6;
boardMainPinsDia = boardX - boardMainPinsCtrsX;
boardMainPinsZ = 9;

echo(str("boardMainPinsDia = ", boardMainPinsDia));

mountCornerDia = 3;
mountExtraY = 4;
mountBaseZ = 1;

boardRecessZ = 4.5;

boardOffsetZ = mountBaseZ + boardMainPinsZ;

mountX = boardX + mountCornerDia + 2;
mountY = mountExtraY + boardY + boardEndPintsExtraY;
mountZ = mountBaseZ + boardMainPinsZ + boardRecessZ;

module mountExterior()
{
    translate([0, mountY/2, 0]) hull() doubleX() doubleY() 
        translate([(mountX-mountCornerDia)/2, (mountY-mountCornerDia)/2, 0]) 
            simpleChamferedCylinderDoubleEnded(d = mountCornerDia, h = mountZ, cz = 1);
}

module itemModule(nubs=false, rubberBands=false)
{
	difference()
    {
        mountExterior();

        // Board recess:
        tcu([-boardX/2, -50, boardOffsetZ], [boardX, 100, 100]);

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
            translate([0, mountExtraY+boardY/2, mountZ+0.2])
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
        mountExterior();
        d = 2;
        translate([0, boardY/2+mountExtraY, boardOffsetZ+pcbThickness+d/2-0.1]) doubleX() doubleY() tsp([boardX/2+d/2-0.5, boardY/2-6, 0], d=d);
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule(rubberBands=true);
    displayGhost() boardGhost();
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
