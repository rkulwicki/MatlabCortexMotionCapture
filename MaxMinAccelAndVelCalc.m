%{
MaxMinAccelAndVelCalclator
Ryan Kulwicki
07/06/2017
Calculates the maximum and minimum acceleration and velocity for each 
marker over a given number of frames.

-------------------------------------------------------------------------
 HELP: If you are having trouble getting the file to save, make sure it
       is saved as a "Microsoft Excel Macro-Enable Worksheet" or .xlsm
       and make sure that the file name does not end in ".ts".

 NOTE: Matrices are stored as a 4x4 matrix.
       - 1st Row: Max Velocity X, Y, Z, R
       - 2nd Row: Frames where above maxs occur
       - 3rd Row: Min Velocity X, Y, Z, R
       - 4th Row: Frames where above mins occur
       - 5th Row: Max Acceleration X, Y, Z, R
       - 6th Row: Frame where above maxs occur
       - 7th Row: Min Acceleration X, Y, Z, R
       - 8th Row: Frame where above mins occur
-------------------------------------------------------------------------
%}

fprintf('\nPLEASE ENTER THE CORTEX DATA FILEPATH WITH FILENAME.\n');
fprintf(' - (This can be found by right clicking on the file and selecting\n');
fprintf('   "properties" and adding the file name plus a backslash.)\n');
userFilePath=input(' - Example: C:\\Users\\John\\Desktop\\excelFileExample\n', 's');
allPositions = xlsread(userFilePath);

%Positions where the total number of frames is and
%where the first frame starts and where the last frame ends.
totalFrames = allPositions(1,3);
frameOneCellRow = find(allPositions(1:50,1) == 1);
endCellRow = totalFrames + frameOneCellRow - 1;

%Here is where we start calculating---------------------------------------
%Initializing the marker matrices
counter = 6;
tempMatrix = zeros(8,4);
TopHead = zeros(8,4);                                       %Marker 1
FrontHead = zeros(8,4);                                     %Marker 2
RearHead = zeros(8,4);                                      %Marker 3
RShoulder = zeros(8,4);                                     %Marker 4
ROffset = zeros(8,4);                                       %Marker 5
RElbow = zeros(8,4);                                        %Marker 6
RWrist = zeros(8,4);                                        %Marker 7
LShoulder = zeros(8,4);                                     %Marker 8
LElbow = zeros(8,4);                                        %Marker 9
LWrist = zeros(8,4);                                        %Marker 10
RAsis = zeros(8,4);                                         %Marker 11
LAsis = zeros(8,4);                                         %Marker 12
VSacral = zeros(8,4);                                       %Marker 13
RThigh = zeros(8,4);                                        %Marker 14
RKnee = zeros(8,4);                                         %Marker 15
RShank = zeros(8,4);                                        %Marker 16
RAnkle = zeros(8,4);                                        %Marker 17
RHeel = zeros(8,4);                                         %Marker 18
RToe = zeros(8,4);                                          %Marker 19
LThigh = zeros(8,4);                                        %Marker 20
LKnee = zeros(8,4);                                         %Marker 21
LShank = zeros(8,4);                                        %Marker 22
LAnkle = zeros(8,4);                                        %Marker 23
LHeel = zeros(8,4);                                         %Marker 24
LToe = zeros(8,4);                                          %Marker 25
RKneeMedial = zeros(8,4);                                   %Marker 26
RAnkleMedial = zeros(8,4);                                  %Marker 27
LKneeMedial = zeros(8,4);                                   %Marker 28
LAnkleMedial = zeros(8,4);                                  %Marker 29
RFootANT = zeros(8,4);                                      %Marker 30
RFootLAT = zeros(8,4);                                      %Marker 31
LFootANT = zeros(8,4);                                      %Marker 32
LFootLAT = zeros(8,4);                                      %Marker 33

%{
 - The "k" for loop goes through all markers
 - The "i" loop goes through the velocity and acceleration of each marker.
  The first iteration is for the velocity and the second for accel.
 - The "j" loop goes through the various parts of the marker data. This
  includes X Y Z and R data, and the frame which they occur  
%}

for k = 1:33
    for h = 1:2
        for j = 1:4
            %Maximum
            %frame (if more than one max, it picks the first)
            %Minimum
            %frame (if more than one min, it picks the first)
            if isnan(max(allPositions(frameOneCellRow+1 : endCellRow, counter)))
                tempMatrix(4*h-3,j) = 0;
                tempMatrix(4*h-2,j) = 0;
                tempMatrix(4*h-1,j) = 0;
                tempMatrix(4*h,j) = 0;
            else
                tempMatrix(4*h-3,j) = max(allPositions(frameOneCellRow+1 : endCellRow, counter));
                tempMatrix(4*h-2,j) = find(allPositions(frameOneCellRow+1 : endCellRow, counter)==tempMatrix(4*h-3,j),1)+1;
                tempMatrix(4*h-1,j) = min(allPositions(frameOneCellRow+1 : endCellRow, counter));
                tempMatrix(4*h,j) = find(allPositions(frameOneCellRow+1 : endCellRow, counter)==tempMatrix(4*h-1,j),1)+1;
            end
            
            counter = counter + 1;
        end
    end
    if counter == 14                                        %Marker 1                                             
        TopHead = tempMatrix;
    elseif counter == 25                                    %Marker 2
        FrontHead = tempMatrix;
    elseif counter == 36                                    %Marker 3
        RearHead = tempMatrix;
    elseif counter == 47                                    %Marker 4
        RShoulder = tempMatrix;
    elseif counter == 58                                    %Marker 5
        ROffset = tempMatrix;
    elseif counter == 69                                    %Marker 6
        RElbow = tempMatrix;
    elseif counter == 80                                    %Marker 7
        RWrist = tempMatrix;
    elseif counter == 91                                    %Marker 8
        LShoulder = tempMatrix;
    elseif counter == 102                                   %Marker 9
        LElbow = tempMatrix;
    elseif counter == 113                                   %Marker 10
        LWrist = tempMatrix;
    elseif counter == 124                                   %Marker 11
        RAsis = tempMatrix;
    elseif counter == 135                                   %Marker 12
        LAsis = tempMatrix;
    elseif counter == 146                                   %Marker 13
        VSacral = tempMatrix;
    elseif counter == 157                                   %Marker 14
        RThigh = tempMatrix;
    elseif counter == 168                                   %Marker 15
        RKnee = tempMatrix;
    elseif counter == 179                                   %Marker 16
        RShank = tempMatrix;
    elseif counter == 190                                   %Marker 17
        RAnkle = tempMatrix;
    elseif counter == 201                                   %Marker 18
        RHeel = tempMatrix;
    elseif counter == 212                                   %Marker 19
        RToe = tempMatrix;
    elseif counter == 223                                   %Marker 20
        LThigh = tempMatrix;
    elseif counter == 234                                   %Marker 21
        LKnee = tempMatrix;
    elseif counter == 245                                   %Marker 22
        LShank = tempMatrix;
    elseif counter == 256                                   %Marker 23
        LAnkle = tempMatrix;
    elseif counter == 267                                   %Marker 24
        LHeel = tempMatrix;
    elseif counter == 278                                   %Marker 25
        LToe = tempMatrix;
    elseif counter == 289                                   %Marker 26
        RKneeMedial = tempMatrix;
    elseif counter == 300                                   %Marker 27
        RAnkleMedial = tempMatrix;
    elseif counter == 311                                   %Marker 28
        LKneeMedial = tempMatrix;
    elseif counter == 322                                   %Marker 29
        LAnkleMedial = tempMatrix;
    elseif counter == 333                                   %Marker 30
        RFootANT = tempMatrix;
    elseif counter == 344                                   %Marker 31
        RFootLAT = tempMatrix;
    elseif counter == 355                                   %Marker 32
        LFootANT = tempMatrix;
    elseif counter == 366                                   %Marker 33
        LFootLAT = tempMatrix;
    end
    counter = counter + 3;
end