%Ryan Kulwicki
%7/26/2017
%function takes a point, another point, a time matrix, an iterator, and the bounds of
%"infinity". It returns a line. Expected to only be used with
%BaseOfSupport.m

function [ CentCOM ] = PartiallyInfiniteLine (centroid, x9, y9, t, s, LimMin, LimMax)
        
    %Connecting Centroid and COM
    centCOMSlope = (centroid(2) - y9(s))/(centroid(1) - x9(s));
    if x9(s) > centroid(1) %if COM is to the right of centroid
        xStartLineCentCOM = centroid(1);
        xEndLineCentCOM = LimMax;
        yStartLineCentCOM = centroid(2);
        yEndLineCentCOM = centroid(2) + centCOMSlope*(xEndLineCentCOM-centroid(1)); %y = m(x-x1)+y1
    else %if COM is to the left of centroid
        xStartLineCentCOM = LimMin;
        xEndLineCentCOM = centroid(1);
        yStartLineCentCOM = centroid(2) + centCOMSlope*(xStartLineCentCOM-centroid(1)); %y = m(x-x1)+y1
        yEndLineCentCOM = centroid(2);
    end

%line that connects Centroid to COM and beyond = [x1, x2, y1, y2, slope]
CentCOM = [xStartLineCentCOM xEndLineCentCOM yStartLineCentCOM yEndLineCentCOM centCOMSlope];
end