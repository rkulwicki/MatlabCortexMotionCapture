%{ 
Ryan Kulwicki
Sacrum Versus Center of Mass
07/11/2017
This code compares the sacrum marker to the center of mass. This will be used
to determine if a sacrum marker can be replaced as an accurate approximation
for the center of mass in times where the center of mass cannot be easily 
calculated. See Cortex-Matlab Code Guide for more details.
%}
clear

%Prompts from the user----------------------------------------------------
fprintf('\nPLEASE ENTER THE MARKERS FILEPATH WITH FILENAME.\n');
fprintf(' - (This can be found by right clicking on the file and selecting\n');
fprintf('   "properties". Then copy the information labelled "Location:".\n');
fprintf('   Paste what you copied and add a backslash. Then add the name \n');
fprintf('   of the file.)\n');
userFilePath=input(' - Example: C:\\Users\\John\\Desktop\\excelFileExample\n', 's');
allPositions = xlsread(userFilePath);

userFilePath=input('\nPLEASE ENTER THE COM FILEPATH WITH FILENAME.\n', 's');
comPositions = xlsread(userFilePath);

fprintf('\nWHAT WOULD YOU LIKE TO SEE PLOTTED? Enter the number.\n');
fprintf('1. X versus Y over T (time)\n');
fprintf('2. X versus Z over T (time)\n');
fprintf('3. Y versus Z over T (time)\n');
fprintf('4. X offset over T (time)\n');
fprintf('5. Y offset over T (time)\n');
fprintf('6. Z offset over T (time)\n');
fprintf('7. X, Y, and Z offset over T (time)\n');
userChoice = input('\n', 's');

if userChoice == '1' || userChoice == '2' || userChoice == '3'
fprintf('\nWOULD YOU LIKE TO FIX THE OFFSET? y/n?');
isOffset = input('\n', 's');

fprintf('\nWOULD YOU LIKE TO INSTANTLY PLOT? y/n?');
isQuickplot = input('\n', 's');

if isQuickplot == 'n' %Won't ask if you don't want the animation cuz no point
    fprintf('\nWOULD YOU LIKE TO DRAW THE GRAPH IN REAL TIME (WILL LOSE FRAMES)? y/n?');
    isRealTime = input('\n', 's');
end
end
%Formatting the data------------------------------------------------------
totalFrames = allPositions(1,3);
frameOneCellRow = find(allPositions(1:50,1) == 1);
endCellRow = totalFrames + frameOneCellRow - 1;

frameOneCellRowCom = find(comPositions(1:50,1) == 1);
if size(frameOneCellRowCom,1) > 1
    maxim = max(frameOneCellRowCom);
    frameOneCellRowCom = maxim;
end
endCellRowCom = totalFrames + frameOneCellRowCom - 1;

COMxColumn = 2;
t = zeros(totalFrames,1);
for i = 1:totalFrames
    t(i,1) = i;
end

COM = zeros(endCellRowCom-frameOneCellRowCom+1,3);
%grabbing the COM data (x,y,z) from the 2nd file the user enterd
for i = 1:3
    COM(1:end, i) = comPositions(frameOneCellRowCom: endCellRowCom, COMxColumn+i-1);
end

%grabbing the sacral marker data (x,y,z) from the first file the user enterd
Sacral = zeros(endCellRow-frameOneCellRow+1,3); %column EE, row 7 (typically)
for i = 1:3
    Sacral(1:end, i) = allPositions(frameOneCellRow: endCellRow, 135+i-1);
end

%Calculating the offsets for the X,Y,Z Positions--------------------------
sum = 0;
firstIndex = 1;
XoffsetMatrix = zeros(totalFrames, 1);
%checks if empty because sometimes there are empty frames at the end or 
%beginning. This is why I use the while loop instead of the 
%"for 1:totalFrames" like I normally do.

%basically cuts off the front part if it is empty or insanely large numbers
if isnan(COM(1,1)) || isnan(Sacral(1,1))
    firstIndex = find(COM <= 1999 ,1);
end

%The following three while loops conditions are long because it needs to
%check if the end of the file has NaN or stupid large numbers that are
%outliers/errors.
i = firstIndex;
while (~isnan(COM(i,1)) && ~isnan(Sacral(i,1)) && i < totalFrames && COM(i,1)< 1999 && Sacral(i,1) < 1999)
    dif = abs(COM(i,1)-Sacral(i,1));
    XoffsetMatrix(i,1) = dif;
    sum = dif + sum;
    i = i+1;
end
%the reason I use "i-1" instead of "totalFrames" is because frames are
%empty at the end sometimes.
Xoffset = sum/(i-firstIndex);

sum = 0;
i = firstIndex;
YoffsetMatrix = zeros(totalFrames, 1);
while (~isnan(COM(i,2)) && ~isnan(Sacral(i,2))&& i < totalFrames && COM(i,1)< 1999 && Sacral(i,1) < 1999)
    dif = abs(COM(i,2)-Sacral(i,2));
    YoffsetMatrix(i,1) = dif;
    sum = dif + sum;
    i = i+1;
end
Yoffset = sum/(i-firstIndex);

sum = 0;
i = firstIndex;
ZoffsetMatrix = zeros(totalFrames, 1);
while (~isnan(COM(i,3)) && ~isnan(Sacral(i,3))&& i < totalFrames && COM(i,1)< 1999 && Sacral(i,1) < 1999)
    dif = abs(COM(i,3)-Sacral(i,3));
    ZoffsetMatrix(i,1) = dif;
    sum = dif + sum;
    i = i+1;
end
Zoffset = sum/(i-firstIndex);

%START of Sacral Marker and COM graphing----------------------------------
%Setting up the Plot for the marker and COM-------------------------------
if userChoice == '1' || userChoice == '2' || userChoice == '3'
x1 = Sacral(1:end, 1);
y1 = Sacral(1:end, 2);
z1 = Sacral (1:end, 3);
x2 = COM(1:end, 1);
y2 = COM(1:end, 2);
z2 = COM(1:end, 3);

curve1 = animatedline('LineWidth', 2);
curve2 = animatedline('LineWidth', 0.75);

%Scaling the graph appropriately----------
if min(Sacral(1:end,1)) < min(COM(1:end,1))
    XsmallestYLimMin = min(Sacral(1:end,1));
else
    XsmallestYLimMin = min(COM(1:end,1));
end

if max(Sacral(1:end,1)) > max(COM(1:end,1))
    XbiggestYLimMax = max(Sacral(1:end,1));
else
    XbiggestYLimMax = max(COM(1:end,1));
end

if min(Sacral(1:end,2)) < min(COM(1:end,2))
    YsmallestZLimMin = min(Sacral(1:end,2));
else
    YsmallestZLimMin = min(COM(1:end,2));
end

if max(Sacral(1:end,2)) > max(COM(1:end,2))
    YbiggestZLimMax = max(Sacral(1:end,2));
else
    YbiggestZLimMax = max(COM(1:end,2));
end

if min(Sacral(1:end,3)) < min(COM(1:end,3))
    ZsmallestZLimMin = min(Sacral(1:end,3));
else
    ZsmallestZLimMin = min(COM(1:end,3));
end

if max(Sacral(1:end,3)) > max(COM(1:end,3))
    ZbiggestZLimMax = max(Sacral(1:end,3));
else
    ZbiggestZLimMax = max(COM(1:end,3));
end

%Depending on what the user chose, the graph will scale using those max and
%mins from either x/y, x/z, or y/z.
if userChoice == '1'
    smallestYLimMin = XsmallestYLimMin;
    biggestYLimMax = XbiggestYLimMax;
    smallestZLimMin = YsmallestZLimMin;
    biggestZLimMax = YbiggestZLimMax;
elseif userChoice == '2'
    smallestYLimMin = XsmallestYLimMin;
    biggestYLimMax = XbiggestYLimMax;
    smallestZLimMin = ZsmallestZLimMin;
    biggestZLimMax = ZbiggestZLimMax;
elseif userChoice =='3'
    smallestYLimMin = YsmallestZLimMin;
    biggestYLimMax = YbiggestZLimMax;
    smallestZLimMin = ZsmallestZLimMin;
    biggestZLimMax = ZbiggestZLimMax;
end
%-----------------------------------------

set(gca,'XLim',[1 totalFrames],'YLim',[smallestYLimMin biggestYLimMax],'ZLim',[smallestZLimMin biggestZLimMax]);
view(90,0); %starts the 3D graph looking at the x/y 
hold on; %what I say when my girlfriend jumps to conclusions
title('Graph of Sacral Marker (Blue) and Center of Mass (Red)');
xlabel('Time - in Frames (120 FPS)');
if userChoice == '1'
    ylabel('X - in mm');
    zlabel('Y - in mm');
elseif userChoice == '2'
    ylabel('X - in mm');
    zlabel('Z - in mm');
elseif userChoice == '3'
    ylabel('Y - in mm');
    zlabel('Z - in mm');
end
legend('Sacral Marker','Center of Mass');

if isOffset ~= 'y' %if user doesn't want an offest
    Xoffset = 0;
    Yoffset = 0;
    Zoffset = 0;
end

%-------------------------------------------------------------------------
%Plotting the Sacral Marker (blue) versus the Center of Mass (red)
%For drawing the graph, you can either draw it with every frame (super
%slow), or you can draw it every 11th frame which is less accurate but is
%more in line with real time movement speed.
if isQuickplot == 'n'
 if userChoice == '1'
    %plots every frame
    if isRealTime == 'n'
        for i=1:length(t)
            addpoints(curve1, t(i), x1(i)+Xoffset, y1(i)+Yoffset);
            addpoints(curve2, t(i), x2(i), y2(i));
            head1 = scatter3(t(i),x1(i)+Xoffset,y1(i)+Yoffset, 'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
            head2 = scatter3(t(i),x2(i),y2(i), 'filled','MarkerFaceColor','r','MarkerEdgeColor','r');
            drawnow
            delete(head1);
            delete(head2);
        end
        
    %plots every 11th frame
    elseif isRealTime == 'y'
        for i=1:length(t)/11
            addpoints(curve1, t(i*11), x1(i*11)+Xoffset, y1(i*11)+Yoffset);
            addpoints(curve2, t(i*11), x2(i*11), y2(i*11));
            head1 = scatter3(t(i*11),x1(i*11)+Xoffset,y1(i*11)+Yoffset, 'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
            head2 = scatter3(t(i*11),x2(i*11),y2(i*11), 'filled','MarkerFaceColor','r','MarkerEdgeColor','r');
            drawnow
            delete(head1);
            delete(head2);
        end
    end
    
 elseif userChoice == '2'
    %plots every frame
    if isRealTime == 'n'
        for i=1:length(t)
            addpoints(curve1, t(i), x1(i)+Xoffset, z1(i)-Zoffset);
            addpoints(curve2, t(i), x2(i), z2(i));
            head1 = scatter3(t(i),x1(i)+Xoffset,z1(i)-Zoffset, 'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
            head2 = scatter3(t(i),x2(i),z2(i), 'filled','MarkerFaceColor','r','MarkerEdgeColor','r');
            drawnow
            delete(head1);
            delete(head2);
        end
        
    %plots every 11th frame
    elseif isRealTime == 'y'
        for i=1:length(t)/11
            addpoints(curve1, t(i*11), x1(i*11)+Xoffset, z1(i*11)-Zoffset);
            addpoints(curve2, t(i*11), x2(i*11), z2(i*11));
            head1 = scatter3(t(i*11),x1(i*11)+Xoffset,z1(i*11)-Zoffset, 'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
            head2 = scatter3(t(i*11),x2(i*11),z2(i*11), 'filled','MarkerFaceColor','r','MarkerEdgeColor','r');
            drawnow
            delete(head1);
            delete(head2);
        end
    end
    
  elseif userChoice == '3'
    %plots every frame
    if isRealTime == 'n'
        for i=1:length(t)
            addpoints(curve1, t(i), y1(i)+Yoffset, z1(i)-Zoffset);
            addpoints(curve2, t(i), y2(i), z2(i));
            head1 = scatter3(t(i),y1(i)+Yoffset,z1(i)-Zoffset, 'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
            head2 = scatter3(t(i),y2(i),z2(i), 'filled','MarkerFaceColor','r','MarkerEdgeColor','r');
            drawnow
            delete(head1);
            delete(head2);
        end
        
    %plots every 11th frame
    elseif isRealTime == 'y'
        for i=1:length(t)/11
            addpoints(curve1, t(i*11), y1(i*11)+Yoffset, z1(i*11)-Zoffset);
            addpoints(curve2, t(i*11), y2(i*11), z2(i*11));
            head1 = scatter3(t(i*11),y1(i*11)+Yoffset,z1(i*11)-Zoffset, 'filled','MarkerFaceColor','b','MarkerEdgeColor','b');
            head2 = scatter3(t(i*11),y2(i*11),z2(i*11), 'filled','MarkerFaceColor','r','MarkerEdgeColor','r');
            drawnow
            delete(head1);
            delete(head2);
        end
    end
 end
%-------------------------------------------------------------------------
elseif isQuickplot == 'y'
    
    %Plots instantly without animation
    if isOffset == 'y'
        for i = 1:totalFrames
            Sacral(i,1) = Sacral(i,1) + Xoffset;
            Sacral(i,2) = Sacral(i,2) + Yoffset;
            Sacral(i,3) = Sacral(i,3) - Zoffset;
        end
        
        %have to reinstantiate because we changed them above
        x1 = Sacral(1:end, 1);
        y1 = Sacral(1:end, 2);
        z1 = Sacral (1:end, 3);
    end
    
    if userChoice == '1'
        SacralOverTime = plot3(t, x1, y1, t, x2, y2);
    elseif userChoice == '2'
        SacralOverTime = plot3(t, x1, z1, t, x2, z2);
    elseif userChoice == '3'
        SacralOverTime = plot3(t, y1, z1, t, y2, z2);
    end
end
end %END of Sacral Marker and COM graphing--------------------------------

%START of Offset graphing-------------------------------------------------
if userChoice == '4' || userChoice == '5' || userChoice == '6' || userChoice =='7'
    if userChoice == '4'
        ylabel('X Offset - (mm)');
        f = XoffsetMatrix;
        ff(1:size(XoffsetMatrix),1) = Xoffset;
        biggestYLimMax = max(XoffsetMatrix);
    elseif userChoice == '5'
        ylabel('Y Offset - (mm)');
        f = YoffsetMatrix;
        ff(1:size(YoffsetMatrix),1) = Yoffset;
        biggestYLimMax = max(YoffsetMatrix);
    elseif userChoice == '6'
        ylabel('Z Offset - (mm)');
        f = ZoffsetMatrix;
        ff(1:size(ZoffsetMatrix),1) = Zoffset;
        biggestYLimMax = max(ZoffsetMatrix);
    elseif userChoice == '7'
        ylabel('Offset - (mm)');
        f1 = ZoffsetMatrix;
        ff1(1:size(f1),1) = Zoffset;
        f2 = YoffsetMatrix;
        ff2(1:size(f2),1) = Yoffset;
        f3 = XoffsetMatrix;
        ff3(1:size(f3),1) = Xoffset;
        biggestYLimMax = max(XoffsetMatrix);
    end
    
    set(gca,'XLim',[1 totalFrames],'YLim',[0 biggestYLimMax]);
    hold on;
    title('Graph of the Offset Between Sacral Marker and COM');
    xlabel('Time - in Frames (120 FPS)');
    
    if userChoice == '7'
        p1=plot(t,f1);
        p2=plot(t,ff1);
        p3=plot(t,f2);
        p4=plot(t,ff2);
        p5=plot(t,f3);
        p6=plot(t,ff3);
        legend([p1,p2,p3,p4,p5,p6], 'ZOffset','Average ZOffset','YOffset per Frame','Average YOffset','XOffset per Frame','Average XOffset');
    end
    
    if userChoice ~= '7'
        p1 = plot(t, f); 
        p2 = plot(t, ff);
        legend([p1,p2], 'Offset per Frame', 'Average Offset');
    end
end%END of Offset graphing------------------------------------------------
