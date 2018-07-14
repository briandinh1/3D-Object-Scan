load 'mesh_set_9.mat';

% scale color values of xColor to 0-255
xColor_new(1,:) = uint8(255 * mat2gray(xColor_new(1,:)));
xColor_new(2,:) = uint8(255 * mat2gray(xColor_new(2,:)));
xColor_new(3,:) = uint8(255 * mat2gray(xColor_new(3,:)));

% toggle 1/0 to check if mesh is good before converting to .ply file
if (1)
    figure(2); clf;
    h = trisurf(tri_new,Y(1,:),Y(2,:),Y(3,:));
    set(h,'edgecolor','flat')
    axis image; axis vis3d;
    camorbit(120,0); camlight left;
    camorbit(120,0); camlight left;
    lighting flat;
    set(gca,'projection','perspective')
    set(gcf,'renderer','opengl')
    set(h,'facevertexcdata',xColor_new'/255);
    material dull
else
    mesh_2_ply(Y, xColor_new, tri_new, 'mesh_set_10b.ply');
end