%Ryan Kulwicki
%7/26/2017
%Finds the intersection of two line segments
%line1 is line1 = [x1 x2 y1 y2]
%line2 is the composition of 4 separate integer values: x1, x2, y1, y2
%This was the most convienient way for me to write it in order to use it
%with the rest of my code.
function [ intersectionPoint ] = lineSegmentIntersection (line1, x1, x2, y1, y2)
    %fit linear polynomial
    p1 = polyfit([line1(1) line1(2)],[line1(3) line1(4)],1);
    p2 = polyfit([x2 x1], [y2 y1],1);
        
    %gets the intersection as if the two lines were infinite
    x_intersect_Maybe = fzero(@(x) polyval(p1-p2,x),3);
    y_intersect_Maybe = polyval(p1,x_intersect_Maybe);
        
    %determines the starting and ending points of the line segments
    if x1 > x2
        xEnd = x1;
        xStart = x2;
    else
        xStart = x1;
        xEnd = x2;
    end
        
    if y1 > y2
        yEnd = y1;
        yStart = y2;
    else
        yStart = y1;
        yEnd = y2;
    end
    
    %askes whether or not the intersection of the infinite line is actually
    %within the bounds of the line segments
    if x_intersect_Maybe > line1(1) && x_intersect_Maybe < line1(2)...
           && x_intersect_Maybe > xStart && x_intersect_Maybe < xEnd...
           && y_intersect_Maybe > yStart && y_intersect_Maybe < yEnd
        x_intersect = x_intersect_Maybe;
        y_intersect = polyval(p1,x_intersect);
        hold on;
        intersectionPoint = [x_intersect,y_intersect];
    else
        %If there is no intersection, it returns [-10000, -10000]
        intersectionPoint = [-10000,-10000];
    end
end