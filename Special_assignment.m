% Special Assignement:- MATLAB based Photoeditor application 
% Submitted By:- Dipti Sharma
% Subject: Image Processing and it's applications
% First Part of the project to get the image from the respetive computer 
clc;                  % clear the command window screen
clear all;            % clear all variables form the workspace
close all;            % close all the figure window

% To capture image from webcam 
cam = webcam;
image1 = snapshot(cam);     % this takes single image
figure(1)
imshow(image1)
title('Captured image')


imtool(image1)              % to crop the image according to user 

% converting the captured image in gray scale [shift enter to replace
% all the variables in the program] 
image1 = rgb2gray(image1);
figure(3)
imshow(image1)
title('Gray Scaled version of the image')

% Now the editting of the selcted picture
% to get the negative of the image captured 
I = imcomplement(image1);
figure(4)
imshow(I)

% to equilise the image 
I1 = histeq(image1);
figure(5)
imshowpair(image1, I1, 'montage')

% performing operations to darken or lighten the image using 
% for darkening the image we use subtraction and for lightening the image
% we use addition 
I_dark = image1 - 22;      % here i can also use division
I_light = image1 + 22;     % here i can also use multiplication
figure(6)
subplot(1,3,1)
imshow(image1)
title('original image')
subplot(1,3,2)
imshow(I_dark)
title('Dark image')
subplot(1,3,3)
imshow(I_light)
title('Light image')

% to get the certain part of the image blurred and certain clear [ irris
% blur effect] 
h=figure;
imshow(image1);
title('image1');
[x y]=getpts(h);

cenx=x(1);                      % applying cany mask with the value 1 on x- axis points
ceny=y(1);                      % applying cany mask with the value 1 on y- axis points

X=[x(2),y(2);cenx,ceny];
in_r = pdist(X,'euclidean');

X=[x(3),y(3);cenx,ceny];
out_r = pdist(X,'euclidean');

L=out_r - in_r;

[r c d]=size(image1);

mask=zeros(r,c);

for i=1:r

for j=1:c
X=[j,i;cenx,ceny];
d=pdist(X,'euclidean');

if(d >= out_r)
    mask(i,j)=1;
else if(d > in_r)
    
    Lx=((d-in_r)./L).^2;
    mask(i,j)=Lx;
    end
end

end

end

bl_mask=zeros(r,c,3);

bl_mask(:,:,1)=mask;
bl_mask(:,:,2)=mask;
bl_mask(:,:,3)=mask;

%bl_mask=cast(bl_mask,'uint8');

hsize=10;
sigma=100;

PSF = fspecial('gaussian',hsize,sigma);
bl_ori= imfilter(image1,PSF,'circular','corr');
bl_ori=cast(bl_ori,'double');
image1=cast(image1,'double');

last=bl_mask.*bl_ori+(1-bl_mask).*image1;

last=cast(last,'uint8');
figure; imshow(last);
title('Iris Blurred Image');
imwrite(last,'blurred.jpg');