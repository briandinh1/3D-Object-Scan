% Brian Dinh
% 34546266
% CS117 Final Project
% Spring 2017

% This is the top level script of my pipeline. This top level script 
% represents the general steps I took to produce my final 3D object.
% Call each script in the order they are listed and comment out the others.
% My pipeline is not very automated, so remember to change the 
% load and saved filenames and/or scan directories so they correspond
% to which set is being worked on. Most of the code that prints to
% console or displays intermediate figures has been commented 
% out to speed up performance.


% STEP 1:
% first calibrate the cameras by finding extrinsic params
% save results as 'camL.mat' and 'camR.mat'
calibrate_cameras 

% STEP 2:
% reconstruct object using the two calibrated camera params
% save results as 'scandata_set_x.mat'
reconstruct

% STEP 3: 
% visualize the point cloud created from reconstruct
% move object back to origin, eyeball bounding box, manually remove points
visualize_point_cloud

% STEP 4:
% once we have cleaner point cloud, make a mesh of it
% save results as 'mesh_set_x.mat'
mesh

% STEP 5: 
% convert mesh to .ply file to be used in meshlab
% save results as 'mesh_set_x.ply'
make_ply

% STEP 6:
% manually align meshes in MeshLab using the uploaded .ply files
% use point based glueing and process it for approximate alignment
% use rough manual glueing to fine-tune after if alignment is still off

% STEP 7:
% perform screened Poisson surface reconstruction on the aligned meshes

% all files used to create final 3D object can be found in the data folder
% the final object is named 'Poisson mesh.ply'
% the project is named 'cs117 project final.ply'
