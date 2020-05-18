%% Segment data of wrist

Wreceive = W{4}(300:1100,:);


figure()
plot3(Wreceive(:,1), Wreceive(:,2), Wreceive(:,3), '.');

%% Segment data of elbow

Ereceive = E{4}(300:1100,:);


figure()
plot3(Ereceive(:,1), Ereceive(:,2), Ereceive(:,3), '.');

%% Segment data of Shoulder

Sreceive = S{4}(300:1100,:);

figure();
plot3(Sreceive(:,1), Sreceive(:,2), Sreceive(:,3), '.');

