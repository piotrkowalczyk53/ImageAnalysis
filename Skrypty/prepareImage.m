function [binaryImage] = prepareImage(image, darkText, sensitivity)
    % 1) binaryzacja
    image = rgb2gray(double(image)/255);
    if darkText
        binaryImage = imbinarize(image, "adaptive", "ForegroundPolarity", "dark", "Sensitivity", sensitivity);
    else
        binaryImage = imbinarize(image, "adaptive", "ForegroundPolarity", "bright", "Sensitivity", sensitivity);
    end

    % 2) usunięcie ramki
    binaryImage = imclearborder(binaryImage);

    % 3) znalezienie id kartki
    objectsProps = regionprops(binaryImage, "Area", "Extrema", "Centroid");

    maxArea = 0;
    objectI = 0;
    for i = 1:length(objectsProps)
        if objectsProps(i).Area > maxArea
            maxArea = objectsProps(i).Area;
            objectI = i;
        end
    end

    % 4) wyczyszczenie obiektów które nie znajdują się w obrębie kartki
    labeledImage = bwlabel(binaryImage);
    points = objectsProps(objectI).Extrema;
    x1 = points(1, 1);
    x2 = points(3, 1);
    y1 = points(1, 2);
    y2 = points(3, 2);
    p1 = polyfit([x1, x2], [y1, y2], 1);

    x1 = points(3, 1);
    x2 = points(5, 1);
    y1 = points(3, 2);
    y2 = points(5, 2);
    p2 = polyfit([x1, x2], [y1, y2], 1);

    x1 = points(5, 1);
    x2 = points(7, 1);
    y1 = points(5, 2);
    y2 = points(7, 2);
    p3 = polyfit([x1, x2], [y1, y2], 1);

    x1 = points(7, 1);
    x2 = points(1, 1);
    y1 = points(7, 2);
    y2 = points(1, 2);
    p4 = polyfit([x1, x2], [y1, y2], 1);

    for i = 1:length(objectsProps)
        if i == objectI
            continue;
        end
        cent = objectsProps(i).Centroid;
        if cent(2) < line1(cent(1)) || cent(2) > line2(cent(1)) || cent(2) > line3(cent(1)) || cent(2) < line4(cent(1))
            labeledImage(labeledImage == i) = 0;
        else
            labeledImage(labeledImage == i) = objectI;
        end
    end
    
    function [y] = line1(x)
        y = p1(1) * x + p1(2);
    end

    function [y] = line2(x)
        y = p2(1) * x + p2(2);
    end

    function [y] = line3(x)
        y = p3(1) * x + p3(2);
    end

    function [y] = line4(x)
        y = p4(1) * x + p4(2);
    end
    
    binaryImage = imbinarize(labeledImage);
end