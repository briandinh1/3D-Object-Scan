
% scan we are working on
scandir = '/Project/data/';

%
% threshold for pruning neighbors
%  TODO: These thresholds depend on the details of the scanning (e.g. how large
%  the object is that you are scanning and how far away it from the projector 
%  so you will likely need to experiment with them to get the best results).
%
nbrthresh = 0.25;
trithresh = 1;

% load in results of reconstruct 
load([scandir 'scandata_set_1.mat']);


%
% cleaning step 1: remove points outside known bounding box
%

% move object back to origin
X(1,:) = X(1,:) - mean(X(1,:));
X(2,:) = X(2,:) - mean(X(2,:));
X(3,:) = X(3,:) - mean(X(3,:));

% uncomment to get lower and upper bounds (bounding box) for a particular set
% set_1:
goodpoints = find( (X(1,:)>-8) & (X(1,:)<8) & (X(2,:)>-12) & (X(2,:)<12) & (X(3,:)>-6) & (X(3,:)<5.1));
% set_2:
% goodpoints = find( (X(1,:)>-9) & (X(1,:)<13) & (X(2,:)>-13.3) & (X(2,:)<10.3) & (X(3,:)>-6) & (X(3,:)<2.3));
% set_3:
% goodpoints = find( (X(1,:)>-7.3) & (X(1,:)<5.2) & (X(2,:)>-11.1) & (X(2,:)<11) & (X(3,:)>-7.5) & (X(3,:)<5.7));
% set_4:
% goodpoints = find( (X(1,:)>-9.2) & (X(1,:)<6.6) & (X(2,:)>-9.6) & (X(2,:)<11.2) & (X(3,:)>-6) & (X(3,:)<3.4));
% set_5:
% goodpoints = find( (X(1,:)>-13.2) & (X(1,:)<7.6) & (X(2,:)>-10) & (X(2,:)<10.5) & (X(3,:)>-15) & (X(3,:)<1.3));
% set_6:
% goodpoints = find( (X(1,:)>-6.6) & (X(1,:)<6) & (X(2,:)>-11.6) & (X(2,:)<12) & (X(3,:)>-5.6) & (X(3,:)<4.3));
% set_7:
% goodpoints = find( (X(1,:)>-7.3) & (X(1,:)<5.7) & (X(2,:)>-11.5) & (X(2,:)<12.1) & (X(3,:)>-8) & (X(3,:)<4));
% set_8:
% goodpoints = find( (X(1,:)>-11.1) & (X(1,:)<6.6) & (X(2,:)>-12.3) & (X(2,:)<11.4) & (X(3,:)>-6.8) & (X(3,:)<1.2));
% set_9:
% goodpoints = find( (X(1,:)>-7.7) & (X(1,:)<9) & (X(2,:)>-12) & (X(2,:)<12) & (X(3,:)>-5.6) & (X(3,:)<2.4));
% set_10a:
% goodpoints = find( (X(1,:)>-11.1) & (X(1,:)<4.6) & (X(2,:)>-5.1) & (X(2,:)<6.6) & (X(3,:)>-6.2) & (X(3,:)<3.3));
% set_10b:
% goodpoints = find( (X(1,:)>6) & (X(1,:)<14.5) & (X(2,:)>-7.3) & (X(2,:)<1.3) & (X(3,:)>-6.3) & (X(3,:)<-2));

fprintf('dropping %2.2f %% of points from scan',100*(1 - (length(goodpoints)/size(X,2))));
X = X(:,goodpoints);
xR = xR(:,goodpoints);
xL = xL(:,goodpoints);
xColor = xColor(:,goodpoints);



%%
%% cleaning step 2: remove points whose neighbors are far away
%%
% fprintf('filtering right image neighbors\n');
[tri,pterrR] = nbr_error(xR,X);
fprintf('filtering right image neighbors complete\n');

% fprintf('filtering left image neighbors\n');
[tri,pterrL] = nbr_error(xL,X);
fprintf('filtering left image neighbors complete\n');

goodpoints = find((pterrR<nbrthresh) & (pterrL<nbrthresh));
fprintf('dropping %2.2f %% of points from scan\n',100*(1-(length(goodpoints)/size(X,2))));
X = X(:,goodpoints);
xR = xR(:,goodpoints);
xL = xL(:,goodpoints);
xColor = xColor(:,goodpoints);

%
% cleaning step 3: remove triangles which have long edges
%
[tri,terr] = tri_error(xL,X);
subt = find(terr<trithresh);
tri = tri(subt,:);
fprintf('removing long edge triangles complete\n');

%
% TODO:  we should remove points which are not referenced
%  in tri in order to avoid writing them out to our final
%  reconstruction.
%
% When removing points from X, also remove them from xR, xL and xColor
%
% Also, you will need to modify the indicies in tri since they
%  will be invalid once you remove points from X.
%
keepind = unique(tri);
X_new = X(:,keepind);
xR_new = xR(:,keepind);
xL_new = xL(:,keepind);
xColor_new = xColor(:,keepind);

tri_new = [];
tcount = 0;
for s = 1:size(tri,1)
    i = find(keepind==tri(s,1));
    j = find(keepind==tri(s,2));
    k = find(keepind==tri(s,3));
    if ~(isempty(i) || isempty(j) || isempty(k))   %defensive check to make sure we actually found all three points
      tcount = tcount + 1;
      tri_new(tcount,:) = [i j k];
    end
end


%
% render intermediate results
%
% figure(1); clf;
% h = trisurf(tri_new,X_new(1,:),X_new(2,:),X_new(3,:));
% set(h,'edgecolor','none')
% axis image; axis vis3d;
% camorbit(120,0); camlight left;
% camorbit(120,0); camlight left;
% lighting phong;
% set(gca,'projection','perspective')
% set(gcf,'renderer','opengl')
% set(h,'facevertexcdata',xColor_new'/255);

%
% cleaning step 4: simple smoothing
%
Y = nbr_smooth(tri_new,X_new,3);
fprintf('smoothing complete\n');

% visualize results of smooth with
% mesh edges visible
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


%
% TODO: you will be running this for multiple scans so you
%  should set up some way to systematically organize and save
%  out the data for different scans.
%

save mesh_set_1.mat Y tri_new X_new xR_new xL_new xColor_new;