%{
TotalDistance
Ryan Kulwicki
08/02/2017
Calculates the total arc distance of a given marker over a given number of
frames.
%}

fprintf('\nPLEASE ENTER THE MARKERS FILEPATH WITH FILENAME.\n');
fprintf(' - (This can be found by right clicking on the file and selecting\n');
fprintf('   "properties". Then copy the information labelled "Location:".\n');
fprintf('   Paste what you copied and add a backslash. Then add the name \n');
fprintf('   of the file.)\n');
userFilePath=input(' - Example: C:\\Users\\John\\Desktop\\excelFileExample\n', 's');
allPositions = xlsread(userFilePath);

fprintf('\nPLEASE ENTER THE NUMBER CORRESPONDING TO THE DESIRED MARKER.');
fprintf('\n\t1.\tTop Head\t\t\t2.\tFront Head');
fprintf('\n\t3.\tRear Head\t\t\t4.\tR Shoulder');
fprintf('\n\t5.\tR Offset\t\t\t6.\tR Elbow');
fprintf('\n\t7.\tR Wrist\t\t\t\t8.\tL Shoulder');
fprintf('\n\t9.\tL Elbow\t\t\t\t10.\tL Wrist');
fprintf('\n\t11.\tR Asis\t\t\t\t12.\tL Asis');
fprintf('\n\t13.\tV Sacral\t\t\t14.\tR Thigh');
fprintf('\n\t15.\tR Knee\t\t\t\t16.\tR Shank');
fprintf('\n\t17.\tR Ankle\t\t\t\t18.\tR Heel');
fprintf('\n\t19.\tR Toe\t\t\t\t20.\tL Thigh');
fprintf('\n\t21.\tL Knee\t\t\t\t22.\tL Shank');
fprintf('\n\t23.\tL Ankle\t\t\t\t24.\tL Heel');
fprintf('\n\t25.\tL Toe\t\t\t\t26.\tR Knee Medial');
fprintf('\n\t27.\tR Ankle Medial\t\t28.\tL Knee Medial');
fprintf('\n\t29.\tL Ankle Medial\t\t30.\tR Foot Ant');
fprintf('\n\t31.\tR Foot Lat\t\t\t32.\tL Foot Ant');
fprintf('\n\t33.\tL Foot Lat\n');
userMarkerNumber=input('\n', 's');

fprintf('\nPLEASE ENTER THE START FRAME.');
userStartFrame=str2double(input('\n', 's'));
fprintf('\nPLEASE ENTER THE END FRAME.');
userEndFrame=str2double(input('\n', 's'));

%Ok so we have the data, the specified marker and the start and end frames

%Feet Start/Finish and Total Frames 
totalFrames = allPositions(1,3);
frameOneCellRow = find(allPositions(1:50,1) == 1);
endCellRow = totalFrames + frameOneCellRow - 1;

%initialize the desired marker
markerMatrix = zeros(endCellRow-frameOneCellRow+1,11);

if strcmp(userMarkerNumber,'1')
    markerColumnX = 3;
    markerName = 'Top Head';
elseif strcmp(userMarkerNumber,'2')
    markerColumnX = 14;
    markerName = 'Front Head';
elseif strcmp(userMarkerNumber,'3')
    markerColumnX = 25;
    markerName = 'Rear Head';
elseif strcmp(userMarkerNumber,'4')
    markerColumnX = 36;
    markerName = 'R Shoulder';
elseif strcmp(userMarkerNumber,'5')
    markerColumnX = 47;
    markerName = 'R Offset';
elseif strcmp(userMarkerNumber,'6')
    markerColumnX = 58;
    markerName = 'R Elbow';
elseif strcmp(userMarkerNumber,'7')
    markerColumnX = 69;
    markerName = 'R Wrist';
elseif strcmp(userMarkerNumber,'8')
    markerColumnX = 80;
    markerName = 'L Shoulder';
elseif strcmp(userMarkerNumber,'9')
    markerColumnX = 91;
    markerName = 'L Elbow';
elseif strcmp(userMarkerNumber,'10')
    markerColumnX = 102;
    markerName = 'L Wrist';
elseif strcmp(userMarkerNumber,'11')
    markerColumnX = 113;
    markerName = 'R Asis';
elseif strcmp(userMarkerNumber,'12')
    markerColumnX = 124;
    markerName = 'L Asis';
elseif strcmp(userMarkerNumber,'13')
    markerColumnX = 135;
    markerName = 'V Sacral';
elseif strcmp(userMarkerNumber,'14')
    markerColumnX = 146;
    markerName = 'R Thigh';
elseif strcmp(userMarkerNumber,'15')
    markerColumnX = 157;
    markerName = 'R Knee';
elseif strcmp(userMarkerNumber,'16')
    markerColumnX = 168;
    markerName = 'R Shank';
elseif strcmp(userMarkerNumber,'17')
    markerColumnX = 179;
    markerName = 'R Ankle';
elseif strcmp(userMarkerNumber,'18')
    markerColumnX = 190;
    markerName = 'R Heel';
elseif strcmp(userMarkerNumber,'19')
    markerColumnX = 201;
    markerName = 'R Toe';
elseif strcmp(userMarkerNumber,'20')
    markerColumnX = 212;
    markerName = 'L Thigh';
elseif strcmp(userMarkerNumber,'21')
    markerColumnX = 223;
    markerName = 'L Knee';
elseif strcmp(userMarkerNumber,'22')
    markerColumnX = 234;
    markerName = 'L Shank';
elseif strcmp(userMarkerNumber,'23')
    markerColumnX = 245;
    markerName = 'L Ankle';
elseif strcmp(userMarkerNumber,'24')
    markerColumnX = 256;
    markerName = 'L Heel';
elseif strcmp(userMarkerNumber,'25')
    markerColumnX = 267;
    markerName = 'L Toe';
elseif strcmp(userMarkerNumber,'26')
    markerColumnX = 278;
    markerName = 'R Knee Medial';
elseif strcmp(userMarkerNumber,'27')
    markerColumnX = 289;
    markerName = 'R Ankle Medial';
elseif strcmp(userMarkerNumber,'28')
    markerColumnX = 300;
    markerName = 'L Knee Medial';
elseif strcmp(userMarkerNumber,'29')
    markerColumnX = 311;
    markerName = 'L Ankle Medial';
elseif strcmp(userMarkerNumber,'30')
    markerColumnX = 322;
    markerName = 'R Foot Ant';
elseif strcmp(userMarkerNumber,'31')
    markerColumnX = 333;
    markerName = 'R Foot Lat';
elseif strcmp(userMarkerNumber,'32')
    markerColumnX = 344;
    markerName = 'L Foot Ant';
elseif strcmp(userMarkerNumber,'33')
    markerColumnX = 355;
    markerName = 'L Foot Lat';
end

markerMatrix(1:end, 1) = allPositions(frameOneCellRow: endCellRow, markerColumnX);
markerMatrix(1:end, 2) = allPositions(frameOneCellRow: endCellRow, markerColumnX+1);
markerMatrix(1:end, 3) = allPositions(frameOneCellRow: endCellRow, markerColumnX+2);
markerMatrix(1:end, 4) = allPositions(frameOneCellRow: endCellRow, markerColumnX+3);
markerMatrix(1:end, 5) = allPositions(frameOneCellRow: endCellRow, markerColumnX+4);
markerMatrix(1:end, 6) = allPositions(frameOneCellRow: endCellRow, markerColumnX+5);
markerMatrix(1:end, 7) = allPositions(frameOneCellRow: endCellRow, markerColumnX+6);
markerMatrix(1:end, 8) = allPositions(frameOneCellRow: endCellRow, markerColumnX+7);
markerMatrix(1:end, 9) = allPositions(frameOneCellRow: endCellRow, markerColumnX+8);
markerMatrix(1:end, 10) = allPositions(frameOneCellRow: endCellRow, markerColumnX+9);
markerMatrix(1:end, 11) = allPositions(frameOneCellRow: endCellRow, markerColumnX+10);
    
totalDist = 0;

for i = userStartFrame:(userEndFrame-1)
    %distance formula
    dist = sqrt( (markerMatrix(i,1) - markerMatrix(i+1,1))^2 + (markerMatrix(i,2) - markerMatrix(i+1,2))^2 ...
        + (markerMatrix(i,3) - markerMatrix(i+1,3))^2);
   totalDist = totalDist + dist;
end

maxXVel = max(markerMatrix(userStartFrame:userEndFrame, 4));
minXVel = min(markerMatrix(userStartFrame:userEndFrame, 4));
maxYVel = max(markerMatrix(userStartFrame:userEndFrame, 5));
minYVel = min(markerMatrix(userStartFrame:userEndFrame, 5));
maxZVel = max(markerMatrix(userStartFrame:userEndFrame, 6));
minZVel = min(markerMatrix(userStartFrame:userEndFrame, 6));
maxRVel = max(markerMatrix(userStartFrame:userEndFrame, 7));
minRVel = min(markerMatrix(userStartFrame:userEndFrame, 7));
maxXAcc = max(markerMatrix(userStartFrame:userEndFrame, 8));
minXAcc = min(markerMatrix(userStartFrame:userEndFrame, 8));
maxYAcc = max(markerMatrix(userStartFrame:userEndFrame, 9));
minYAcc = min(markerMatrix(userStartFrame:userEndFrame, 9));
maxZAcc = max(markerMatrix(userStartFrame:userEndFrame, 10));
minZAcc = min(markerMatrix(userStartFrame:userEndFrame, 10));
maxRAcc = max(markerMatrix(userStartFrame:userEndFrame, 11));
minRAcc = min(markerMatrix(userStartFrame:userEndFrame, 11));

fprintf('\nRESULTS:');
fprintf('\n%s',markerName);
fprintf('\n%-8.4f \t\t\t\t\t- Total distance traveled by the marker.',totalDist);
fprintf('\n%-8.4f / %8.4f \t\t- X direction maximum/minimum velocity.',maxXVel, minXVel);
fprintf('\n%-8.4f / %8.4f \t\t- X direction maximum/minimum acceleration.',maxYVel, minYVel);
fprintf('\n%-8.4f / %8.4f \t\t- Y direction maximum/minimum velocity.',maxZVel, minZVel);
fprintf('\n%-8.4f / %8.4f \t\t- Y direction maximum/minimum accelertion.',maxRVel, minRVel);
fprintf('\n%-8.4f / %8.4f \t- Z direction maximum/minimum velocity.',maxXAcc, minXAcc);
fprintf('\n%-8.4f / %8.4f \t- Z direction maximum/minimum acceleration.',maxYAcc, minYAcc);
fprintf('\n%-8.4f / %8.4f \t- R direction maximum/minimum velocity.',maxZAcc, minZAcc);
fprintf('\n%-8.4f / %8.4f \t\t- R direction maximum/minimum accelertion.\n',maxRAcc, minRAcc);

    