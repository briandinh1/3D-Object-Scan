% scan we are working on
scandir = '/Project/data/';

% load in results of reconstruct 
load([scandir 'scandata_set_1.mat']);

% move object back to origin 
X(1,:) = X(1,:) - mean(X(1,:));
X(2,:) = X(2,:) - mean(X(2,:));
X(3,:) = X(3,:) - mean(X(3,:));

% toggle 1/0 to plot cleaned vs raw cloud
if (1)
    % manually change these values 
    goodpoints = find( (X(1,:)>-8) & (X(1,:)<8) & (X(2,:)>-12) & (X(2,:)<12) & (X(3,:)>-6) & (X(3,:)<5.1));
    fprintf('dropping %2.2f %% of points from scan',100*(1 - (length(goodpoints)/size(X,2))));
    X = X(:,goodpoints);
    xR = xR(:,goodpoints);
    xL = xL(:,goodpoints);
    xColor = xColor(:,goodpoints);
end 


figure(1); plot3(X(1,:),X(2,:),X(3,:),'.');
