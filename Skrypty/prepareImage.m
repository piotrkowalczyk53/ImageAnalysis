function [binaryImage] = prepareImage(image, darkText, sensitivity)
    % Convert image to grayscale
    grayImage = rgb2gray(image);
    
    % Apply threshold to create binary image
    threshold = graythresh(grayImage);
    binaryImage = imbinarize(grayImage, threshold);
    
    % Invert binary image to have white background and black text
%     binaryImage = ~binaryImage;
end
