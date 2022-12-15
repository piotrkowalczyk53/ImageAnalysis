function [binaryImage] = prepareImage(image, darkText, sensitivity)
    % 1) binaryzacja
    image = rgb2gray(double(image)/255);
    if darkText
        binaryImage = imbinarize(image, "adaptive", "ForegroundPolarity", "dark", "Sensitivity", sensitivity);
    else
        binaryImage = imbinarize(image, "adaptive", "ForegroundPolarity", "bright", "Sensitivity", sensitivity);
    end

    % 2) znalezienie położenia kartki
    
    
end