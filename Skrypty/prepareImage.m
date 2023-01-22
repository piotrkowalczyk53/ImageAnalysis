function [binaryImage, rotation] = prepareImage(image, badLightning, sensitivity, openSize)
    % Funkcja zwraca obraz z białym tekstem na czarnym tle

    % Konwersja do odcieni szarości
    image = im2gray(image);

    % Sprawdzenie czy na ramach obrazu jest on biały, jeśli tak jest
    % traktowany jak wygenerowany cyfrowo
    testBinarize = imbinarize(image);
    fullImage = false;
    if sum(testBinarize(1, :), "all") == size(testBinarize, 2) && ...
            sum(testBinarize(size(testBinarize, 1), :), "all") == size(testBinarize, 2) && ...
            sum(testBinarize(:, 1), "all") == size(testBinarize, 1) && ...
            sum(testBinarize(:, size(testBinarize, 2)), "all") == size(testBinarize, 1)
        binaryImage = imbinarize(image);
        fullImage = true;
    else
        fullImage = false;
    end

    if fullImage
        binaryImage = ~imbinarize(image);
        if openSize > 0
            binaryImage = bwareaopen(binaryImage, openSize);
        end
        rotation = 0;
        return
    end
    
    if badLightning
        image = imbinarize(image, "adaptive", "ForegroundPolarity", "dark", "Sensitivity", sensitivity);
    else
        image = imbinarize(image);
    end
    
    % Wyliczenie obrotu kartki
    objectsProps = regionprops(image, 'Area', 'Image', 'Orientation', 'Extrema', 'Centroid');

    maxArea = 0;
    paperID = 0;
    for i = 1:length(objectsProps)
        if objectsProps(i).Area > maxArea
            maxArea = objectsProps(i).Area;
            paperID = i;
        end
    end
    % wymaga interpretacji
    rotation = objectsProps(paperID).Orientation;
    if rotation > 0
        rotation = -90 + rotation;
    else
        rotation = 90 + rotation;
    end

    % Wycięcie danych poza kartką
    points = objectsProps(paperID).Extrema;
    center = objectsProps(paperID).Centroid;
    
    topLeft = [0, 0];
    topRight = [0, 0];
    bottomLeft = [0, 0];
    bottomRight = [0, 0];
    for i = 1:length(points)
        if points(i, 1) < center(1) && points(i, 2) < center(2)
            topLeft = points(i, :);
        elseif points(i, 1) > center(1) && points(i, 2) < center(2)
            topRight = points(i, :);
        elseif points(i, 1) < center(1) && points(i, 2) > center(2)
            bottomLeft = points(i, :);
        elseif points(i, 1) > center(1) && points(i, 2) > center(2)
            bottomRight = points(i, :);
        end
    end
    
    maxError = 0.01;
    topLeft = topLeft + [maxError, maxError] .* center;
    topRight = topRight + [-maxError, maxError] .* center;
    bottomLeft = bottomLeft + [maxError, -maxError] .* center;
    bottomRight = bottomRight + [-maxError, -maxError] .* center;
    
    % górna linia
    x1 = topLeft(1, 1);
    x2 = topRight(1, 1);
    y1 = topLeft(1, 2);
    y2 = topRight(1, 2);
    p1 = polyfit([x1, x2], [y1, y2], 1);

    % dolna linia
    x1 = bottomLeft(1, 1);
    x2 = bottomRight(1, 1);
    y1 = bottomLeft(1, 2);
    y2 = bottomRight(1, 2);
    p2 = polyfit([x1, x2], [y1, y2], 1);

    % lewa linia
    x1 = topLeft(1, 1);
    x2 = bottomLeft(1, 1);
    y1 = topLeft(1, 2);
    y2 = bottomLeft(1, 2);
    p3 = polyfit([x1, x2], [y1, y2], 1);

    % prawa linia
    x1 = topRight(1, 1);
    x2 = bottomRight(1, 1);
    y1 = topRight(1, 2);
    y2 = bottomRight(1, 2);
    p4 = polyfit([x1, x2], [y1, y2], 1);

    for x = 1:size(image, 2)
        for y = 1:size(image, 1)
            if y < polyval(p1, x) || y > polyval(p2, x)
                image(y, x) = 0;
            elseif rotation > 0
                if y > polyval(p3, x) || y < polyval(p4, x)
                    image(y, x) = 0;
                end
            elseif rotation < 0
                if y < polyval(p3, x) || y > polyval(p4, x)
                    image(y, x) = 0;
                end
            end
        end
    end
    image = imclearborder(~image);
    if openSize > 0
        image = bwareaopen(image, openSize);
    end
    rotation = -rotation;
    binaryImage = image;
end
