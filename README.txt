Brian Dinh
34546266
CS117
FINAL PROJECT
Spring 2017

The following shows the steps I took in my project pipeline to go from a scan to mesh to final 3D object.
It is in the same format as the comments in my demoscript.m, which is the top level script of my project.
After that you can reference the appendix of software that I used to complete the pipeline. 
The same appendix can also be found in the final report PDF. 

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


Appendix: Software:
•	buildrotation.m – copy provided by the instructor
•	calibrate.m – copy provided by the instructor; unused
•	calibrate_cameras.m – written for the project
	o	calculates extrinsic camera parameters given the intrinsic parameters
	o	is a wrapper script that calls calibrate_ext2.m 
•	calibrate_ext2.m – written for the project; modification of calibrate_planar_ext.m
	o	calibrates only extrinsic parameters from a planar checkerboard pattern
	o	added code to work for a 9x6 square pattern
•	calibrate_planar_ext.m – copy provided by the instructor; unused
•	dec2gray.m – copy provided by the instructor
•	decode.m – copy provided by the instructor
•	demoscript.m – written for the project; top level script
	o	provides details on how to run project code from initial scans to output meshes
	o	for specific details, see comments in the script itself
•	genimages.m – copy provided by the instructor; unused
•	harris.m – copy provided by the instructor
•	homography.m – copy provided by the instructor; unused
•	make_ply.m – written for the project
	o	takes a mesh, scales color values to 0-255, and converts to .ply file format
	o	is a wrapper script that calls mesh_2_ply.m
•	mapgrid.m – copy provided by the instructor
•	mapnearest.m – copy provided by the instructor
•	mesh.m – copy provided by the instructor; modified
	o	added code to move object back to origin for easier pruning of bounding box 
	o	added code for bounding boxes of all image sets; uncomment to use
	o	added code to remove points not referenced anymore in triangles
•	mesh_2_ply.m – copy provided by the instructor; modified
	o	removed sections where xColor is multiplied by 255. 
	o	instead, added code in make_ply.m to scale xColor to 0-255 
•	nbr_error.m – copy provided by the instructor
•	nbr_smooth.m – copy provided by the instructor
•	nonmaxsupprts.m – copy provided by the instructor
•	project.m – copy provided by the instructor; modified
	o	added code to accept two focal lengths instead of one
•	project_error.m – copy provided by the instructor; unused
•	project_error_ext.m – written for the project; modification of project_error.m
	o	is a wrapper for project.m for optimization of camera parameters
	o	added code to search over 6 parameters instead of 7; skipped focal length
•	reconstruct.m – copy provided by the instructor; modified
	o	added code to do background subtraction, used as binary mask for good pixels
•	tri_error.m – copy provided by the instructor
•	triangulate.m - copy provided by the instructor; modified
	o	added code to accept two focal lengths instead of one
•	visualize_point_cloud.m – written for the project
	o	plots the point cloud result from reconstruct.m
	o	used to visualize bounding box for manually choosing points to remove
