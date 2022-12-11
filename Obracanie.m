I = imread("kiepskie_zdjecie.jpg");
BW = imbinarize(I(:,:,2),'adaptive','ForegroundPolarity','dark','Sensitivity',0.2);
BW = bwlabel(imclearborder(BW));
objectsArea = regionprops(BW, 'Area');
objectsImage = regionprops(BW, 'Image');
objectsOrientation = regionprops(BW, 'Orientation');

maxArea = 0;
objectI = 0;
for i = 1:length(objectsArea)
    if objectsArea(i).Area > maxArea
        maxArea = objectsArea(i).Area;
        objectI = i;
    end
end
BW2 = objectsImage(objectI).Image;
disp(objectsOrientation(objectI).Orientation);
BW = imrotate(BW, 270 - objectsOrientation(objectI).Orientation);
imshow(BW);



% theta = 45;
% A = [1 1 0;
%      1 1 0;
%      0.001 0.001 1];
% t_proj = projtform2d(A);
% I_projective = imwarp(BW, t_proj);
% imshow(I_projective);