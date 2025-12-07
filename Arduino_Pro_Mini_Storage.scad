// Copyright 2025 - Geoff SObering - All Rights Reserved
// Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3
// SPDX-FileCopyrightText: 2025 Geoff SObering
// SPDX-License-Identifier: GPL-3.0-or-later

include <../OpenSCAD_Lib/MakeInclude.scad>
include <../OpenSCADdesigns/chamferedCylinders.scad>

// $fn=360;

boardX = 19.0;
boardY = 34.0;

boardEndPinsCtrsX = 12.2; // 0.5;
// boardEndPinsY = 12.2; // 0.5"?
boardEndPinsOffseetY = 31.7;
boardEndPinsZ = 5.3;

boardMainPinsCtrsX = 15.0; // 0.6"?
boardMainPinsCtrsY = 27.7; // 1.1"?
boardMainPinsOffsetY = 1.6;
boardMainPinsDia = 3;
// boardMainPinsZ = 4.5;
boardMainPinsZ = 9;

holeCtrsX = 8.75;
holeDia = 3;

mountCornerDia = 3;
mountExtraY = 4;
mountBaseZ = 1;

boardRecessZ = 4.5;

boardOffsetZ = mountBaseZ + boardMainPinsZ;

mountX = boardX + mountCornerDia + 2;
mountY = boardY + 2*mountExtraY;
mountZ = mountBaseZ + boardMainPinsZ + boardRecessZ; //boardOffsetZ + boardMainPinsZ + mountBaseZ;

module itemModule()
{
	difference()
    {
        translate([0, mountY/2, 0]) hull() doubleX() doubleY() 
        translate([(mountX-mountCornerDia)/2, (mountY-mountCornerDia)/2, 0]) 
            simpleChamferedCylinder(d = mountCornerDia, h = mountZ, cz = 1);

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
            doubleX() tcy([boardEndPinsCtrsX/2, boardEndPinsOffseetY+mountExtraY-1, boardOffsetZ-boardEndPinsZ], d=boardMainPinsDia, h=100);
            doubleX() tcy([boardEndPinsCtrsX/2, 100, boardOffsetZ-boardEndPinsZ], d=boardMainPinsDia, h=100);
        }

        // Finger recesses:
        // doubleX() hull()
        // {
        //     d = 20;
        //     d2 = d * 1.4;
        //     tsp([mountX/2+d/2-6, mountY/2, mountZ+d*0.07], d=d);
        //     // translate([mountX/2, mountY/2, mountZ+d*0.07]) 
        //     // {
        //     //     tsp([+d/2-6, 0, 0], d=d);
        //     //     dx = (mountX - boardX)/2;
        //     //     rotate([0,90,0]) tcy([0,0,-dx], d=d*0.85, h=100);
        //     // }
        //     tsp([mountX/2+d2/2-6, mountY/2, mountZ+d*0.4], d=d2);
        // }
        d = 20;
        translate([0, mountY/2, mountZ+d*0.05])
        {
            
            d2 = d * 1.4;
            doubleX() hull()
            {
                tsp([mountX/2+d/2-6, 0, d*0.07], d=d);
                tsp([mountX/2+d2/2-6, 0, d*0.4], d=d2);
            }
            f = 0.8;
            hull() doubleX() 
            {
                tsp([100, 0, d*0.07], d=d*f);
                tsp([100, 0, d*0.4], d=d2*f);
            }
        }
    }
}

module clip(d=0)
{
	//tc([-200, -400-d, -10], 400);
}

if(developmentRender)
{
	display() itemModule();
}
else
{
	itemModule();
}
