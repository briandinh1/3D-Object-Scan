% calculate extrinsic parameters given the intrinsic camera parameters 

% left camera:
% 
% Focal Length:          fc = [ 1856.90556   1863.13475 ]
% Principal point:       cc = [ 1403.64394   869.11608 ]
% Distortion:            kc = [ -0.06813   0.06477   -0.00360   0.00841  0.00000 ]
% 
% right camera:
% 
% Focal Length:          fc = [ 1844.49412   1843.96528 ] 
% Principal point:       cc = [ 1376.02154   942.95783 ] 
% Distortion:            kc = [ -0.06103   0.02402   0.00353   0.00259  0.00000 ]
% 
% 

scandir = '/Project/teapot/calib/';

% teapot given values;
camL.f = [1856.90556 1863.13475];
camL.c = [1403.64394 869.11608];
camR.f = [1844.49412 1843.96528];
camR.c = [1376.02154 942.95783];


% click order: bottom left then clockwise
[camL,xL,Xtrue] = calibrate_ext2([scandir 'l_calib_02.jpg'],camL);
[camR,xR,Xtrue] = calibrate_ext2([scandir 'r_calib_02.jpg'],camR);

save camL.mat camL;
save camR.mat camR;