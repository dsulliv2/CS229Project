function  labeledPlot(x,y,c)
%{
x - x data
y - y data
c - data label 
C- color map
%}

%% https://stackoverflow.com/questions/31685078/change-color-of-2d-plot-line-depending-on-3rd-value

%% // Prepare matrix data
%every 5th

l = 4;

N = length(unique(c)); %%number of unique Classes
ix = c/l == floor(c/l);
C = getColorMap(floor(N/l) + l);



xx=[x(ix) x(ix)];           %// create a 2D matrix based on "X" column
yy=[y(ix) y(ix)];           %// same for Y
zz=zeros(size(xx)); %// everything in the Z=0 plane
cc =[c(ix) c(ix)] ;         %// matrix for "CData"

%// draw the surface (actually a line)
figure
hs=surf(xx,yy,zz,cc,'EdgeColor','interp','FaceColor','none','Marker','o') ;

colormap(C) ;     %// assign the colormap
shading flat                    %// so each line segment has a plain color
view(2) %// view(0,90)          %// set view in X-Y plane
colorbar