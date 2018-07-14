%
% first calibrate the left and right cameras
%
%[camL,xL,Xtrue] = calibrate([scandir 'left/left_calib.jpg']);
%[camR,xR,Xtrue] = calibrate([scandir 'right/right_calib.jpg']);

% 
% visualize the calibration results
% 
% Xest = triangulate(xL,xR,camL,camR);
% figure(1); clf;
% hold on;
% plot3(Xest(1,:),Xest(2,:),Xest(3,:),'r.')
% plot3(Xtrue(1,:),Xtrue(2,:),Xtrue(3,:),'.')
% unitz = [0 0 5]';
% a = camL.t; b = camL.t + camL.R*unitz;
% plot3([a(1) b(1)],[a(2) b(2)],[a(3) b(3)],'g-','LineWidth',3);
% a = camR.t; b = camR.t + camR.R*unitz;
% plot3([a(1) b(1)],[a(2) b(2)],[a(3) b(3)],'c-','LineWidth',3);
% a = camL.t; b = camL.t + camL.R*unitz;
% plot3(a(1),a(2),a(3),'gs');
% a = camR.t; b = camR.t + camR.R*unitz;
% plot3(a(1),a(2),a(3),'cs');
% set(gca,'projection','perspective')
% legend('estimate','true','left camera','right camera')
% camorbit(30,-80)
% axis vis3d; 
% axis image;
% grid on;

% the above section ^^^^ was moved to a separate script called calibrate_cameras.m




load camL.mat;
load camR.mat;

scandir = '/Project/teapot/set_10/';
thresh = 0.001;

[R_h,R_h_good] = decode([scandir 'r_'],1,10,thresh);
[R_v,R_v_good] = decode([scandir 'r_'],11,20,thresh);
[L_h,L_h_good] = decode([scandir 'l_'],1,10,thresh);
[L_v,L_v_good] = decode([scandir 'l_'],11,20,thresh);


%
% visualize the masked out horizontal and vertical
% codes for left and right camera
%
% figure(1); clf;
% subplot(2,2,1); imagesc(R_h.*R_h_good); axis image; axis off;title('right camera, h coord');
% subplot(2,2,2); imagesc(R_v.*R_v_good); axis image; axis off;title('right camera,v coord');
% subplot(2,2,3); imagesc(L_h.*L_h_good); axis image; axis off;title('left camera,h coord');  
% subplot(2,2,4); imagesc(L_v.*L_v_good); axis image; axis off;title('left camera,v coord');  
% colormap jet

%
% combine horizontal and vertical codes
% into a single code and mask.
%

% background subtraction
bg_thresh = 0.0003; % use a different threshold for the background
r_rgb = im2double(imread([scandir 'r_rgb.jpg']));
r_rgb_bg = im2double(imread([scandir 'r_rgb_bg.jpg']));
l_rgb = im2double(imread([scandir 'l_rgb.jpg']));
l_rgb_bg = im2double(imread([scandir 'l_rgb_bg.jpg']));

r_color_mask = ones(size(r_rgb,1),size(r_rgb,2));
l_color_mask = ones(size(l_rgb,1),size(l_rgb,2));
for z = 1:3
   r_color_mask = r_color_mask & abs(r_rgb(:,:,z) - r_rgb_bg(:,:,z)).^2 > bg_thresh;
   l_color_mask = l_color_mask & abs(l_rgb(:,:,z) - l_rgb_bg(:,:,z)).^2 > bg_thresh;
end

Rmask = R_h_good & R_v_good & r_color_mask;
R_code = R_h + 1024*R_v;
Lmask = L_h_good & L_v_good & l_color_mask;
L_code = L_h + 1024*L_v;

%
% now find those pixels which had matching codes
% and were visible in both the left and right images
%
% only consider good pixels
Rsub = find(Rmask(:));
Lsub = find(Lmask(:));
% find matching pixels 
[matched,iR,iL] = intersect(R_code(Rsub),L_code(Lsub));
indR = Rsub(iR);
indL = Lsub(iL);
% indR,indL now contain the indices of the pixels whose 
% code value matched

% pull out the pixel coordinates of the matched pixels
[h,w] = size(Rmask);
[xx,yy] = meshgrid(1:w,1:h);
xL = []; xR = [];
xR(1,:) = xx(indR);
xR(2,:) = yy(indR);
xL(1,:) = xx(indL);
xL(2,:) = yy(indL);

%
% while we are at it, we can use the same indices (indR,indL) to
% pull out the colors of the matched pixels
%

% array to store the (R,G,B) color values of the matched pixels
xColor = zeros(3,size(xR,2));

% load in the images and seperate out the red, green, blue
% color channels into separate matrices
rgbL = imread([scandir 'l_rgb.jpg']);
rgbL_R = rgbL(:,:,1); 
rgbL_G = rgbL(:,:,2);
rgbL_B = rgbL(:,:,3);

rgbR = imread([scandir 'r_rgb.jpg']);
rgbR_R = rgbR(:,:,1);
rgbR_G = rgbR(:,:,2);
rgbR_B = rgbR(:,:,3);

% use the average of the color in the left and 
% right image.  depending on the scan, it may
% be better to just use one or the other.
xColor(1,:) = 0.5*(rgbR_R(indR) + rgbL_R(indL));
xColor(2,:) = 0.5*(rgbR_G(indR) + rgbL_G(indL));
xColor(3,:) = 0.5*(rgbR_B(indR) + rgbL_B(indL));


%
% now triangulate the matching pixels using the calibrated cameras
%
X = triangulate(xL,xR,camL,camR);


%
% save the results of all our hard work
%
save scandata_set_10.mat X xColor xL xR camL camR;
