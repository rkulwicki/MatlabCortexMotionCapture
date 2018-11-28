%{
StandingCalc
Ryan Kulwicki
6/27/2017
Calculates the given frames in which a person is declared standing.

-------------------------------------------------------------------------
 NOTE: The markers used to calculate "Standing" are the R.Heel (Marker 18)
       R.Toe (Marker 19), L.Heel (Marker 24), and L.Toe (Marker 25). If
       any of these change, please make appropriate adjustments.

-------------------------------------------------------------------------
Initialization Section---------------------------------------------------
%}

fprintf('\nPLEASE ENTER THE MARKERS FILEPATH WITH FILENAME.\n');
fprintf(' - (This can be found by right clicking on the file and selecting\n');
fprintf('   "properties". Then copy the information labelled "Location:".\n');
fprintf('   Paste what you copied and add a backslash. Then add the name \n');
fprintf('   of the file.)\n');
userFilePath=input(' - Example: C:\\Users\\John\\Desktop\\excelFileExample\n', 's');
allPositions = xlsread(userFilePath);

%Positions where the total number of frames is and
%where the first frame starts and where the last frame ends.
totalFrames = allPositions(1,3);
frameOneCellRow = find(allPositions(1:50,1) == 1);
endCellRow = totalFrames + frameOneCellRow - 1;

%Initialize columns
RHeelZColumn = zeros(endCellRow-frameOneCellRow+1,2);
RToeZColumn = zeros(endCellRow-frameOneCellRow+1,2);
RFootAntZColumn = zeros(endCellRow-frameOneCellRow+1,2);
RFootLatZColumn = zeros(endCellRow-frameOneCellRow+1,2);

LHeelZColumn = zeros(endCellRow-frameOneCellRow+1,2);
LToeZColumn = zeros(endCellRow-frameOneCellRow+1,2);
LFootAntZColumn = zeros(endCellRow-frameOneCellRow+1,2);
LFootLatZColumn = zeros(endCellRow-frameOneCellRow+1,2);

RFootStanding = zeros(endCellRow-frameOneCellRow+1,1);
LFootStanding = zeros(endCellRow-frameOneCellRow+1,1);

%Get the columns individually
RHeelZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 192);   
RToeZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 203);
RFootAntZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 324);
RFootLatZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 335);

LHeelZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 258);
LToeZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 269);
LFootAntZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 346);
LFootLatZColumn(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 357);


%Get the threshold of the z-value. We take the lowest 50% of all the
%z-values and average them out and call that about the "floor". Then add
%some flexibility.

%right foot
howManyMins = ceil(totalFrames/2);
sortedRHeel = sort(RHeelZColumn,1,'ascend');
RHeelZThreshold = mean(sortedRHeel(1:howManyMins, 1))+15;

sortedRToe = sort(RToeZColumn,1,'ascend');
RToeZThreshold = mean(sortedRToe(1:howManyMins, 1))+15;

sortedRFootAnt = sort(RFootAntZColumn,1,'ascend');
RFootAntZThreshold = mean(sortedRFootAnt(1:howManyMins, 1))+15;

sortedRFootLat = sort(RFootLatZColumn,1,'ascend');
RFootLatZThreshold = mean(sortedRFootLat(1:howManyMins, 1))+15;

%Left foot
sortedLHeel = sort(LHeelZColumn,1,'ascend');
LHeelZThreshold = mean(sortedLHeel(1:howManyMins, 1))+15;

sortedLToe = sort(LToeZColumn, 1, 'ascend');
LToeZThreshold = mean(sortedLToe(1:howManyMins, 1))+15;

sortedLFootAnt = sort(LFootAntZColumn,1,'ascend');
LFootAntZThreshold = mean(sortedLFootAnt(1:howManyMins, 1))+15;

sortedLFootLat = sort(LFootLatZColumn,1,'ascend');
LFootLatZThreshold = mean(sortedLFootLat(1:howManyMins, 1))+15;


fprintf('\nEnter the number corresponding with the surface of the trial:');
fprintf('\n\t1. Flat');
fprintf('\n\t2. Slip Board');
fprintf('\n\t3. Wobble Board, Side to Side');
fprintf('\n\t4. Wobble Board, Front to Back');
fprintf('\n\t5. Foam Mats');
fprintf('\n\t6. Inflatable Rafts');

userSurface=input('\n', 's');

%{
-------------------------------------------------------------------------
This section is for Flat, Slip Board, Mats, and Rafts (1,2,5,6)
These 4 for loops test whether the Z coordinate at a given frame exceeds
the standing thresholds.
The raft and mat threshold needs to be higher because there's so much 
variability
%}

if userSurface == '5'
    RHeelZThreshold = RHeelZThreshold + 24;
    RToeZThreshold = RToeZThreshold + 24;
    LHeelZThreshold = LHeelZThreshold + 24;
    LToeZThreshold = LToeZThreshold + 24;
end

if userSurface == '4' || userSurface == '6' || userSurface == '3'
    RHeelZThreshold = RHeelZThreshold + 30;
    RToeZThreshold = RToeZThreshold + 30;
    LHeelZThreshold = LHeelZThreshold + 30;
    LToeZThreshold = LToeZThreshold + 30;
end
%Filling the matrices second row for each foot marker---------------------
%Right Foot
    for i = 1:(endCellRow-frameOneCellRow+1)
        if RHeelZColumn(i,1) > RHeelZThreshold
           RHeelZColumn(i,2) = 0;
        else
           RHeelZColumn(i,2) = 1;
        end
    end

    for i = 1:(endCellRow-frameOneCellRow+1)
        if RToeZColumn(i,1) > RToeZThreshold
            RToeZColumn(i,2) = 0;
        else
            RToeZColumn(i,2) = 1;
        end
    end
    
    for i = 1:(endCellRow-frameOneCellRow+1)
        if RFootAntZColumn(i,1) > RFootAntZThreshold
           RFootAntZColumn(i,2) = 0;
        else
           RFootAntZColumn(i,2) = 1;
        end
    end
    
    for i = 1:(endCellRow-frameOneCellRow+1)
        if RFootLatZColumn(i,1) > RFootLatZThreshold
           RFootLatZColumn(i,2) = 0;
        else
           RFootLatZColumn(i,2) = 1;
        end
    end
    
%Left Foot
    for i = 1:(endCellRow-frameOneCellRow+1)
        if LHeelZColumn(i,1) > LHeelZThreshold
            LHeelZColumn(i,2) = 0;
        else
            LHeelZColumn(i,2) = 1;
        end
    end

    for i = 1:(endCellRow-frameOneCellRow+1)
        if LToeZColumn(i,1) > LToeZThreshold
            LToeZColumn(i,2) = 0;
        else
            LToeZColumn(i,2) = 1;
        end
    end
    
     for i = 1:(endCellRow-frameOneCellRow+1)
        if LFootAntZColumn(i,1) > LFootAntZThreshold
           LFootAntZColumn(i,2) = 0;
        else
           LFootAntZColumn(i,2) = 1;
        end
    end
    
    for i = 1:(endCellRow-frameOneCellRow+1)
        if LFootLatZColumn(i,1) > LFootLatZThreshold
           LFootLatZColumn(i,2) = 0;
        else
           LFootLatZColumn(i,2) = 1;
        end
    end
    
%-------------------------------------------------------------------------

%Calculate Standing Per Foot----------------------------------------------

%Right Foot
for i = 1:(endCellRow-frameOneCellRow+1)
    if RToeZColumn(i,2) == 0 && RHeelZColumn(i,2) == 0
        RFootStanding (i,1) = 0;
    else
        RFootStanding (i,1) = 1;
    end
end

%Left Foot
for i = 1:(endCellRow-frameOneCellRow+1)
    if LToeZColumn(i,2) == 0 && LHeelZColumn(i,2) == 0
        LFootStanding (i,1) = 0;
    else
        LFootStanding (i,1) = 1;
    end
end

%Put all standing into one matrix
IsStandingMatrix = zeros(totalFrames, 8);
IsStandingMatrix(:,1) = LHeelZColumn(:,2);
IsStandingMatrix(:,2) = LToeZColumn(:,2);
IsStandingMatrix(:,3) = LFootAntZColumn(:,2);
IsStandingMatrix(:,4) = LFootLatZColumn(:,2);


IsStandingMatrix(:,5) = RHeelZColumn(:,2);
IsStandingMatrix(:,6) = RToeZColumn(:,2);
IsStandingMatrix(:,7) = RFootAntZColumn(:,2);
IsStandingMatrix(:,8) = RFootLatZColumn(:,2);

