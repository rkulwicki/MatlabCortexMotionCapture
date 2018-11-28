%Not original. Was modified for use in the motionlab by Ryan Kulwicki
%Modified on 7/26/2017
%% Finding the Centroid of any Polygon
function [ CentroidPosition ] = Centroid (x, y)

% check if inputs are same size
if ~isequal( size(x), size(y) )
  error( 'X and Y must be the same size');
end

if isnan(x(1))
    error( 'The trial is longer or shorter than the marker data.');
end
 
% temporarily shift data to mean of vertices for improved accuracy
xm = mean(x);
ym = mean(y);
x = x - xm;
y = y - ym;
  
% summations for CCW boundary
xp = x( [2:end 1] );
yp = y( [2:end 1] );
a = x.*yp - xp.*y;
 
A = sum( a ) /2;
xc = sum( (x+xp).*a  ) /6/A;
yc = sum( (y+yp).*a  ) /6/A;
Ixx = sum( (y.*y +y.*yp + yp.*yp).*a  ) /12;
Iyy = sum( (x.*x +x.*xp + xp.*xp).*a  ) /12;
Ixy = sum( (x.*yp +2*x.*y +2*xp.*yp + xp.*y).*a  ) /24;
 
dx = xp - x;
dy = yp - y;
P = sum( sqrt( dx.*dx +dy.*dy ) );
 
% check for CCW versus CW boundary
if A < 0
  A = -A;
  Ixx = -Ixx;
  Iyy = -Iyy;
  Ixy = -Ixy;
end
 
% centroidal moments
Iuu = Ixx - A*yc*yc;
Ivv = Iyy - A*xc*xc;
Iuv = Ixy - A*xc*yc;
J = Iuu + Ivv;
 
% replace mean of vertices
Centroidx = xc + xm;
Centroidy = yc + ym;
Ixx = Iuu + A*Centroidy*Centroidy;
Iyy = Ivv + A*Centroidx*Centroidx;
Ixy = Iuv + A*Centroidx*Centroidy;
 
% principal moments and orientation
I = [ Iuu  -Iuv ;
     -Iuv   Ivv ];
[ eig_vec, eig_val ] = eig(I);
I1 = eig_val(1,1);
I2 = eig_val(2,2);
ang1 = atan2( eig_vec(2,1), eig_vec(1,1) );
ang2 = atan2( eig_vec(2,2), eig_vec(1,2) );
 
% return values
geom = [ A  Centroidx  Centroidy  P ];
iner = [ Ixx  Iyy  Ixy  Iuu  Ivv  Iuv ];
cpmo = [ I1  ang1  I2  ang2  J ];

CentroidPosition = [Centroidx Centroidy];
 
end
