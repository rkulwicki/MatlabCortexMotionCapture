%{
BaseOfSupport
Ryan Kulwicki
08/01/2017
A more accurate and faster version of BaseOfSupport.m but it does not graph
%}

%BaseOfSupportNoAnimation.m uses the functions PartiallyInfiniteLine.m, Centroid.m,
%and lineSegmentIntersection.m. Make sure those files are in the same
%folder as this code.

% NOTE: Depending on the size of the trial, calculating can take from 15
%       seconds to a minute.
%       Also, If people cross their feet in a trial, this could make the
%       excursion really weird.

clear

%Getting all the data------------------------------------------------------
fprintf('\nPLEASE ENTER THE MARKERS FILEPATH WITH FILENAME.\n');
fprintf(' - (This can be found by right clicking on the file and selecting\n');
fprintf('   "properties". Then copy the information labelled "Location:".\n');
fprintf('   Paste what you copied and add a backslash. Then add the name \n');
fprintf('   of the file.)\n');
userFilePath=input(' - Example: C:\\Users\\John\\Desktop\\excelFileExample\n', 's');
allPositions = xlsread(userFilePath);

userFilePath=input('\nPLEASE ENTER THE COM FILEPATH WITH FILENAME.\n', 's');
comPositions = xlsread(userFilePath);

fprintf('\nEnter the number corresponding with the surface of the trial:');
fprintf('\n\t1. Flat');
fprintf('\n\t2. Slip Board');
fprintf('\n\t3. Wobble Board, Side to Side');
fprintf('\n\t4. Wobble Board, Front to Back');
fprintf('\n\t5. Foam Mats');
fprintf('\n\t6. Inflatable Rafts');

userSurface=input('\n', 's'); %this is used to determine the z threshold

fprintf('\nPlease wait. Processing can take up to a minute or more...');
%Feet Start/Finish and Total Frames 
totalFrames = allPositions(1,3);
frameOneCellRow = find(allPositions(1:50,1) == 1);
endCellRow = totalFrames + frameOneCellRow - 1;

%Heels and Toes columns (MATRICES)
    %Initialize columns
    RHeel = zeros(endCellRow-frameOneCellRow+1,4);
    RToe = zeros(endCellRow-frameOneCellRow+1,4);
    RFootAnt = zeros(endCellRow-frameOneCellRow+1,4);
    RFootLat = zeros(endCellRow-frameOneCellRow+1,4);
    LHeel = zeros(endCellRow-frameOneCellRow+1,4);
    LToe = zeros(endCellRow-frameOneCellRow+1,4);
    LFootAnt = zeros(endCellRow-frameOneCellRow+1,4);
    LFootLat = zeros(endCellRow-frameOneCellRow+1,4);
    
RHeel(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 190);
RHeel(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 191);
RHeel(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 192); %For Standing

RToe(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 201);
RToe(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 202);
RToe(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 203); %For Standing

RFootAnt(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 322);
RFootAnt(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 323);
RFootAnt(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 324); %For Standing

RFootLat(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 333);
RFootLat(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 334);
RFootLat(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 335); %For Standing

LHeel(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 256);
LHeel(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 257);
LHeel(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 258); %For Standing

LToe(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 267);
LToe(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 268);
LToe(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 269); %For Standing

LFootAnt(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 344);
LFootAnt(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 345);
LFootAnt(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 346); %For Standing

LFootLat(1:end, 1) = allPositions(frameOneCellRow: endCellRow, 355);
LFootLat(1:end, 2) = allPositions(frameOneCellRow: endCellRow, 356);
LFootLat(1:end, 3) = allPositions(frameOneCellRow: endCellRow, 357); %For Standing

%Calculating Standing-----------------------------------------------------
%Get the threshold of the z-value. We take the lowest 50% of all the
%z-values and average them out and call that about the "floor". Then add
%some flexibility.

howManyMins = ceil(totalFrames/2);

%Adjust threshold based on surface
if userSurface == '1' || userSurface == '2'
    addToThreshold = 15;
elseif userSurface == '4' || userSurface == '6' || userSurface == '3'
    addToThreshold = 55;
elseif userSurface == '5'
    addToThreshold = 49;
end

%right foot
sortedRHeel = sort(RHeel(1:end, 3),1,'ascend');
RHeelZThreshold = mean(sortedRHeel(1:howManyMins, 1))+addToThreshold;

sortedRToe = sort(RToe(1:end, 3),1,'ascend');
RToeZThreshold = mean(sortedRToe(1:howManyMins, 1))+addToThreshold;

sortedRFootAnt = sort(RFootAnt(1:end, 3),1,'ascend');
RFootAntZThreshold = mean(sortedRFootAnt(1:howManyMins, 1))+addToThreshold;

sortedRFootLat = sort(RFootLat(1:end, 3),1,'ascend');
RFootLatZThreshold = mean(sortedRFootLat(1:howManyMins, 1))+addToThreshold;

%Left foot
sortedLHeel = sort(LHeel(1:end, 3),1,'ascend');
LHeelZThreshold = mean(sortedLHeel(1:howManyMins, 1))+addToThreshold;

sortedLToe = sort(LToe(1:end, 3), 1, 'ascend');
LToeZThreshold = mean(sortedLToe(1:howManyMins, 1))+addToThreshold;

sortedLFootAnt = sort(LFootAnt(1:end, 3),1,'ascend');
LFootAntZThreshold = mean(sortedLFootAnt(1:howManyMins, 1))+addToThreshold;

sortedLFootLat = sort(LFootLat(1:end, 3),1,'ascend');
LFootLatZThreshold = mean(sortedLFootLat(1:howManyMins, 1))+addToThreshold;

%Filling the isStandingMatrix with 1s or 0s depending on whether the
%z-values of each marker per frame is greater than the threshold.
%ISM is short for isStandingMatrix
ISM = zeros(totalFrames, 8);
%Right Foot
    for i = 1:(endCellRow-frameOneCellRow+1)
        if RHeel(i,3) > RHeelZThreshold
           ISM(i,5) = 0;
        else
           ISM(i,5) = 1;
        end
    end

    for i = 1:(endCellRow-frameOneCellRow+1)
        if RToe(i,3) > RToeZThreshold
            ISM(i,6) = 0;
        else
            ISM(i,6) = 1;
        end
    end
    
    for i = 1:(endCellRow-frameOneCellRow+1)
        if RFootAnt(i,3) > RFootAntZThreshold
           ISM(i,7) = 0;
        else
           ISM(i,7) = 1;
        end
    end
    
    for i = 1:(endCellRow-frameOneCellRow+1)
        if RFootLat(i,3) > RFootLatZThreshold
           ISM(i,8) = 0;
        else
           ISM(i,8) = 1;
        end
    end
    
%Left Foot
    for i = 1:(endCellRow-frameOneCellRow+1)
        if LHeel(i,3) > LHeelZThreshold
            ISM(i,1) = 0;
        else
            ISM(i,1) = 1;
        end
    end

    for i = 1:(endCellRow-frameOneCellRow+1)
        if LToe(i,3) > LToeZThreshold
            ISM(i,2) = 0;
        else
            ISM(i,2) = 1;
        end
    end
    
     for i = 1:(endCellRow-frameOneCellRow+1)
        if LFootAnt(i,3) > LFootAntZThreshold
           ISM(i,3) = 0;
        else
           ISM(i,3) = 1;
        end
    end
    
    for i = 1:(endCellRow-frameOneCellRow+1)
        if LFootLat(i,3) > LFootLatZThreshold
           ISM(i,4) = 0;
        else
           ISM(i,4) = 1;
        end
    end

%COM start and end--------------------------------------------------------
frameOneCellRowCom = find(comPositions(1:50,1) == 1);
if size(frameOneCellRowCom,1) > 1
    maxim = max(frameOneCellRowCom);
    frameOneCellRowCom = maxim;
end
endCellRowCom = totalFrames + frameOneCellRowCom - 1;
COMxColumn = 2;

%TIME Matrix--------------------------------------------------------------
t = zeros(totalFrames,1); 
for i = 1:totalFrames
    t(i,1) = i;
end

COM = zeros(endCellRowCom-frameOneCellRowCom+1,3);
%grabbing the COM data (x,y,z) from the 2nd file the user entered---------
for i = 1:3
    COM(1:end, i) = comPositions(frameOneCellRowCom: endCellRowCom, COMxColumn+i-1);
end

%Setting up Graphing------------------------------------------------------

%If you set the speedOfGraphing to 1, it graphs every frame which is super
%slow. We divide by speedOfGraphing to graph say, every 15th frame or so.
speedOfGraphing = 1;

x1 = LHeel(1:end,1); 
y1 = LHeel(1:end,2);
x2 = LFootLat(1:end,1); 
y2 = LFootLat(1:end,2);
x3 = LFootAnt(1:end,1); 
y3 = LFootAnt(1:end,2);
x4 = LToe(1:end,1); 
y4 = LToe(1:end,2);

x5 = RHeel(1:end,1); 
y5 = RHeel(1:end,2);
x6 = RToe(1:end,1); 
y6 = RToe(1:end,2);
x7 = RFootAnt(1:end,1); 
y7 = RFootAnt(1:end,2);
x8 = RFootLat(1:end,1); 
y8 = RFootLat(1:end,2);

x9 = COM(1:end, 1);
y9 = COM(1:end, 2);

LimMin = -1000;
LimMax = 1500;

%Instantiating matrices to fit the intersection/centroid/COM for excursion
intersectionMatrix = zeros(ceil(totalFrames/speedOfGraphing),2);
centroidMatrix = zeros(ceil(totalFrames/speedOfGraphing),2);
COMMatrix = zeros(ceil(totalFrames/speedOfGraphing),2);
excursionMatrix = zeros(ceil(totalFrames/speedOfGraphing),3);

%Actually Graphing========================================================
%{
The graphing for loop below is set up as follows:
    - First, we determine what parts of the feet are on the ground to
    determine the base of support
    - Second, we determine the determine the centroid (see Centroid.m)
    - Third, we draw a line from the Centroid to the COM and onward.
    - Fourth, we find the intersection of that line and the base of
    support. This is tedious because we first must check what part of the
    base of support it is intersecting and then calculate.
%}
for i=1:length(t)/speedOfGraphing
  s = i*speedOfGraphing;
  if ~isnan(x1(s)) && ~isnan(x2(s)) && ~isnan(x3(s)) && ~isnan(x4(s)) &&...
        ~isnan(x6(s)) && ~isnan(x7(s)) && ~isnan(x8(s)) && ~isnan(x9(s))
  
    %Both Heels Up--------------------------------------------------------
    if (ISM(s,1) == 0 && ISM(s,2) == 1 && ISM(s,3) == 1 && ISM(s,4) == 1 ...
    && ISM(s,5) == 0 && ISM(s,6) == 1 && ISM(s,7) == 1 && ISM(s,8) == 1)

        %Creating the centroid based on the base of support points
        centroid = Centroid([x4(s) x2(s) x3(s) x7(s) x8(s) x6(s)], [y4(s) y2(s) y3(s) y7(s) y8(s) y6(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);       
        
        %START BOTH HEELS UP INTERSECTION
        %LToe to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x2(s), y4(s), y2(s));
        
        %LFootLat to LFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x3(s), y2(s), y3(s));
        end
        
        %LFootAnt to RFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x3(s), x7(s), y3(s), y7(s));
        end
        
        %RFootAnt to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x7(s), x8(s), y7(s), y8(s));
           
        end
        
        %RFootLat to RToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x6(s), y8(s), y6(s));
            
        end
        
        %RToe to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x4(s), y6(s), y4(s));
          
        end
        %END BOTH HEELS UP INTERSECTION
    
    %Both Toes Up---------------------------------------------------------
    elseif (ISM(s,1) == 1 && ISM(s,2) == 1 && ISM(s,3) == 0 && ISM(s,4) == 1 ...
    && ISM(s,5) == 1 && ISM(s,6) == 1 && ISM(s,7) == 0 && ISM(s,8) == 1)

        %Creating the centroid based on the base of support points
        centroid = Centroid([x1(s) x2(s) x4(s) x6(s) x8(s) x5(s)], [y1(s) y2(s) y4(s) y6(s) y8(s) y5(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);        
        
        %START BOTH TOES UP INTERSECTION
        %LHeel to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x1(s), x2(s), y1(s), y2(s));
        
        %LFootLat to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x4(s), y2(s), y4(s));
        end
        
        %LToe to RToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x6(s), y4(s), y6(s));
        end
        
        %RToe to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x8(s), y6(s), y8(s));
        end
        
        %RFootLat to RHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x5(s), y8(s), y5(s));
        end
        
        %RHeel to LHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x1(s), y5(s), y1(s));
        end
        %END BOTH TOES UP INTERSECTION

    %Right Heel Up--------------------------------------------------------
    elseif (ISM(s,1) == 1 && ISM(s,2) == 1 && ISM(s,3) == 1 && ISM(s,4) == 1 ...
    && ISM(s,5) == 0 && ISM(s,6) == 1 && ISM(s,7) == 1 && ISM(s,8) == 1)

        %Creating the centroid based on the base of support points
        centroid = Centroid([x1(s) x2(s) x3(s) x7(s) x8(s) x6(s)], [y1(s) y2(s) y3(s) y7(s) y8(s) y6(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);        
        
        %START RIGHT HEEL UP INTERSECTION
        %LHeel to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x1(s), x2(s), y1(s), y2(s));
        
        %LFootLat to LFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x3(s), y2(s), y3(s));
        end
        
        %LFootAnt to RFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x3(s), x7(s), y3(s), y7(s));
        end
        
        %RFootAnt to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x7(s), x8(s), y7(s), y8(s));
        end
        
        %RFootLat to RToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x6(s), y8(s), y6(s));
        end
        
        %RToe to LHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x1(s), y6(s), y1(s));
        end
        %END RIGHT HEEL UP INTERSECTION

    %Right Toe Up---------------------------------------------------------
    elseif (ISM(s,1) == 1 && ISM(s,2) == 1 && ISM(s,3) == 1 && ISM(s,4) == 1 ...
    && ISM(s,5) == 1 && ISM(s,6) == 0 && ISM(s,7) == 0 && ISM(s,8) == 0)       

        %Creating the centroid based on the base of support points
        centroid = Centroid([x1(s) x2(s) x3(s) x4(s) x6(s) x8(s) x5(s)], [y1(s) y2(s) y3(s) y4(s) y6(s) y8(s) y5(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);       
        
        %START RIGHT TOE UP INTERSECTION
        %LHeel to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x1(s), x2(s), y1(s), y2(s));
        
        %LFootLat to LFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x3(s), y2(s), y3(s));
        end
        
        %LFootAnt to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x3(s), x4(s), y3(s), y4(s));
        end
        
        %LToe to RToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x6(s), y4(s), y6(s));
        end
        
        %RToe to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x8(s), y6(s), y8(s));
        end
        
        %RFootLat to RHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x5(s), y8(s), y5(s));
        end
        
        %RHeel to LHeel 
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x1(s), y5(s), y1(s));
        end
        %END RIGHT TOE UP INTERSECTION
        
    %Right Foot Up--------------------------------------------------------
    elseif (ISM(s,1) == 1 && ISM(s,2) == 1 && ISM(s,3) == 1 && ISM(s,4) == 1 ...
    && ISM(s,5) == 0 && ISM(s,6) == 0 && ISM(s,7) == 0 && ISM(s,8) == 0)   

        %Creating the centroid based on the base of support points
        centroid = Centroid([x1(s) x2(s) x3(s) x4(s)], [y1(s) y2(s) y3(s) y4(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);        
        
        %START RIGHT FOOT UP INTERSECTION
        %LHeel to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x1(s), x2(s), y1(s), y2(s));
        
        %LFootLat to LFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x3(s), y2(s), y3(s));
        end
        
        %LFootAnt to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x3(s), x4(s), y3(s), y4(s));
        end
        
        %LToe to LHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x1(s), y4(s), y1(s));
        end
        %END RIGHT FOOT UP INTERSECTION
       
    %Right Toe Only-------------------------------------------------------
    elseif (ISM(s,1) == 0 && ISM(s,2) == 0 && ISM(s,3) == 0 && ISM(s,4) == 0 ...
    && ISM(s,5) == 0 && ISM(s,6) == 1 && ISM(s,7) == 1 && ISM(s,8) == 1) 
        %Creating the centroid based on the base of support points
        centroid = Centroid([x6(s) x7(s) x8(s)], [y6(s) y7(s) y8(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);        
        
        %START RIGHT TOE ONLY INTERSECTION
        %RToe to RFootAnt
        intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x7(s), y6(s), y7(s));
        
        %RFootAnt to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x7(s), x8(s), y7(s), y8(s));

        end
        
        %LFootLat to RToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x6(s), y8(s), y6(s));
        end
        %END RIGHT TOE ONLY INTERSECTION
 
    %Right Heel Only------------------------------------------------------
    elseif (ISM(s,1) == 0 && ISM(s,2) == 0 && ISM(s,3) == 0 && ISM(s,4) == 0 ...
    && ISM(s,5) == 1 && ISM(s,6) == 1 && ISM(s,7) == 0 && ISM(s,8) == 1)

        %Creating the centroid based on the base of support points
        centroid = Centroid([x5(s) x6(s) x8(s)], [y5(s) y6(s) y8(s)]);

        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);       
        
        %START RIGHT HEEL ONLY INTERSECTION
        %RHeel to RToe
        intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x6(s), y5(s), y6(s));
        
        %RToe to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x8(s), y6(s), y8(s));
        end
        
        %RFootLat to RHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x5(s), y8(s), y5(s));
        end
        %END RIGHT HEEL ONLY INTERSECTION

    %Left Heel Up---------------------------------------------------------
    elseif (ISM(s,1) == 0 && ISM(s,2) == 1 && ISM(s,3) == 1 && ISM(s,4) == 1 ...
    && ISM(s,5) == 1 && ISM(s,6) == 1 && ISM(s,7) == 1 && ISM(s,8) == 1)
        %Creating the centroid based on the base of support points
        centroid = Centroid([x4(s) x2(s) x3(s) x7(s) x8(s) x5(s)], [y4(s) y2(s) y3(s) y7(s) y8(s) y5(s)]);

        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);       
        
        %START LEFT HEEL UP INTERSECTION
        %LToe to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x2(s), y4(s), y2(s));
        
        %LFootLat to LFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x3(s), y2(s), y3(s));
        end
        
        %LFootAnt to RFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x3(s), x7(s), y3(s), y7(s));
        end
        
        %RFootAnt to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x7(s), x8(s), y7(s), y8(s));
        end
        
        %RFootLat to RHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x5(s), y8(s), y5(s));
        end
        
        %RHeel to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x4(s), y5(s), y4(s));
        end
        %END LEFT HEEL UP INTERSECTION

    %Left Toe Up----------------------------------------------------------
    elseif (ISM(s,1) == 1 && ISM(s,2) == 0 && ISM(s,3) == 0 && ISM(s,4) == 0 ...
    && ISM(s,5) == 1 && ISM(s,6) == 1 && ISM(s,7) == 1 && ISM(s,8) == 1)

        %Creating the centroid based on the base of support points
        centroid = Centroid([x1(s) x2(s) x4(s) x6(s) x7(s) x8(s) x5(s)], [y1(s) y2(s) y4(s) y6(s) y7(s) y8(s) y5(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);      
        
        %START LEFT TOE UP INTERSECTION
        %LHeel to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x1(s), x2(s), y1(s), y2(s));
        
        %LFootLat to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x4(s), y2(s), y4(s));
        end
        
        %LToe to RToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x6(s), y4(s), y6(s));
        end
        
        %RToe to RFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x7(s), y6(s), y7(s));
        end
        
        %RFootAnt to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x7(s), x8(s), y7(s), y8(s));
        end
        
        %RFootLat to RHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x5(s), y8(s), y5(s));
        end
        
        %RHeel to LHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x1(s), y5(s), y1(s));
        end
        %END LEFT TOE UP INTERSECTION

    %Left Foot Up---------------------------------------------------------
    elseif (ISM(s,1) == 0 && ISM(s,2) == 0 && ISM(s,3) == 0 && ISM(s,4) == 0 ...
    && ISM(s,5) == 1 && ISM(s,6) == 1 && ISM(s,7) == 1 && ISM(s,8) == 1)   

        %Creating the centroid based on the base of support points
        centroid = Centroid([x6(s) x7(s) x8(s) x5(s)], [y6(s) y7(s) y8(s) y5(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);        
        
        %START LEFT FOOT UP INTERSECTION
        %RToe to RFootAnt
        intersectionPoint = lineSegmentIntersection(CentCOM, x6(s), x7(s), y6(s), y7(s));
        
        %RFootAnt to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x7(s), x8(s), y7(s), y8(s));
        end
        
        %RFootLat to RHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x8(s), x5(s), y8(s), y5(s));
        end
        
        %RHeel to RToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x6(s), y5(s), y6(s));
        end
        %END LEFT FOOT UP INTERSECTION 

    %Left Toe Only--------------------------------------------------------
    elseif (ISM(s,1) == 0 && ISM(s,2) == 1 && ISM(s,3) == 1 && ISM(s,4) == 1 ...
    && ISM(s,5) == 0 && ISM(s,6) == 0 && ISM(s,7) == 0 && ISM(s,8) == 0)

        %Creating the centroid based on the base of support points
        centroid = Centroid([x2(s) x3(s) x4(s)], [y2(s) y3(s) y4(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);        

        %START LEFT TOE ONLY INTERSECTION
        %LFootLat to LFootAnt
        intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x3(s), y2(s), y3(s));
        
        %LFootAnt to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x3(s), x4(s), y3(s), y4(s));
        end
        
        %LToe to LFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x2(s), y4(s), y2(s));
        end
        %END LEFT TOE ONLY INTERSECTION 

    %Left Heel Only-------------------------------------------------------
    elseif (ISM(s,1) == 1 && ISM(s,2) == 0 && ISM(s,3) == 0 && ISM(s,4) == 0 ...
    && ISM(s,5) == 0 && ISM(s,6) == 0 && ISM(s,7) == 0 && ISM(s,8) == 0)

        %Creating the centroid based on the base of support points
        centroid = Centroid([x1(s) x2(s) x4(s)], [y1(s) y2(s) y4(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);

        %START LEFT HEEL ONLY INTERSECTION
        %LHeel to LFootLat
        intersectionPoint = lineSegmentIntersection(CentCOM, x1(s), x2(s), y1(s), y2(s));
        
        %LFootLat to LToe
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x4(s), y2(s), y4(s));
        end
        
        %LToe to LHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x4(s), x1(s), y4(s), y1(s));
        end
        %END LEFT HEEL ONLY INTERSECTION       

    %No Feet Down---------------------------------------------------------
    elseif (ISM(s,1) == 0 && ISM(s,2) == 0 && ISM(s,3) == 0 && ISM(s,4) == 0 ...
    && ISM(s,5) == 0 && ISM(s,6) == 0 && ISM(s,7) == 0 && ISM(s,8) == 0)
        
    %Both Feet Down-------------------------------------------------------
    else
        %Creating the centroid based on the base of support points
        centroid = Centroid([x1(s) x2(s) x3(s) x7(s) x8(s) x5(s)], [y1(s) y2(s) y3(s) y7(s) y8(s) y5(s)]);
        %Connecting Centroid and COM
        CentCOM = PartiallyInfiniteLine(centroid, x9, y9, t, s, LimMin, LimMax);
        
        %START BOTH FEET DOWN INTERSECTION
        %Calculate intersection if and only if the intersection is between
        %the line segments. The Centroid COM line end points is consistent
        %but the points that change here are the x values of the
        %base of support side.
        
        %RFootLat to RHeel
        intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x8(s), y5(s), y8(s));
        
        %RHeel to LHeel
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x5(s), x1(s), y5(s), y1(s));
        end
        
        %LHeel to LFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x1(s), x2(s), y1(s), y2(s));
        end
        
        %LFootLat to LFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x2(s), x3(s), y2(s), y3(s));
        end
        
        %LFootAnt to RFootAnt
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x3(s), x7(s), y3(s), y7(s));
        end
        
        %RFootAnt to RFootLat
        if intersectionPoint(1) == -10000
            intersectionPoint = lineSegmentIntersection(CentCOM, x7(s), x8(s), y7(s), y8(s));
        end
        %END BOTH FEET DOWN INTERSECTION
    end
    
    %Putting the intersection point in with all the other points
    intersectionMatrix(i,1) = intersectionPoint(1);
    intersectionMatrix(i,2) = intersectionPoint(2);
    centroidMatrix(i,1) = centroid(1);
    centroidMatrix(i,2) = centroid(2);
    COMMatrix(i,1) = x9(s);
    COMMatrix(i,2) = y9(s);
  end
end
%=========================================================================

%Finally we will calculate the distance between the Centroid and the COM
%per frame and the Centroid and the intersection point per same frame and
%then compare the two as a fraction. This will then go into the excursion
%matrix.

for i = 1:length(intersectionMatrix)
    %distance from Centroid to COM
    excursionMatrix(i,1) = sqrt((centroidMatrix(i,1)-COMMatrix(i,1))^2+(centroidMatrix(i,2)-COMMatrix(i,2))^2);
    %distance from Centroid to intersection point
    excursionMatrix(i,2) = sqrt((centroidMatrix(i,1)-intersectionMatrix(i,1))^2+(centroidMatrix(i,2)-intersectionMatrix(i,2))^2);
    %proportion of CentroidToCOM over CentroidToIntersection
    excursionMatrix(i,3) = excursionMatrix(i,1)/excursionMatrix(i,2);
end

aboveOne = 0;
i = 1;
c = 1;
activeFrames = 0;
startFrame = 0;

%This sets the stage for calculating. We didn't need these earlier but it
%is essential to know where the first active frame is and how long the
%trial is active
while i<s
    if ~isnan(excursionMatrix(i,3))
        activeFrames = activeFrames+1;
        if startFrame == 0
            startFrame = i;
        end
    end 
    i=i+1;
end

for n = startFrame:(startFrame+activeFrames)
    if excursionMatrix(n,3) >= 1
        aboveOne = aboveOne+1;
    end
end
fractionOut = aboveOne/(i-1);
fprintf('\n\nRESULTS:');
fprintf('\n%-5.4f - Fraction of trial where the subject COM was outside of the base of support.\n',fractionOut);
maxExcursion = max(excursionMatrix(c:(i-1),3));
fprintf('%-8.4f - The maximum excursion of this trial.',maxExcursion);
frameOfMax = find(maxExcursion == excursionMatrix(c:(i-1),3));
fprintf('\n%-d - Frame which maximum excursion occors.\n', frameOfMax);

%plotting the excursion over time
title('Graph of the Excursion over Time');
xlabel('Time - in Frames (120 FPS)');
ylabel('Percentage of Excursion');

lineOfJust1(1:size(excursionMatrix(:,3)),1) = 1;
plot(t, excursionMatrix(:,3), t, lineOfJust1);

