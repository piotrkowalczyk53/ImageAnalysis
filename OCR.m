%{
Program do optycznego rozpoznawania znaków (OCR) - V0.1

Aktualne założenia i uproszczenia projektu (zależnie od efektów mogą się zmienić):
-tylko język angielski
-tylko jedna czcionka
-tekst jest ułożony horyzontalnie i nie w kolumnach
%}
clear; clc; close all;
selectedImage = imread("level_1.png");

fontImage = imread("arial_characters.png");
im = prepareFont(fontImage);
imshow(im == 9);

function [charactersArray] = prepareFont(fontImage)
    imageLength = length(fontImage(:, 1));
    indexRange = floor(imageLength / 3);
    binaryFontImage = ~imbinarize(rgb2gray(double(fontImage) / 255));
    
    %labeledFontImageAZ = mergeObjects(binaryFontImage(1:indexRange, :));
    labeledFontImageaz = mergeObjects(binaryFontImage(indexRange:(indexRange * 2), :));
    %labeledFontImagespc = mergeObjects(binaryFontImage((indexRange * 2):(indexRange * 3), :));
    
    charactersArray = labeledFontImageaz;
end

function [merged] = mergeObjects(objects)
    objectsPosition = regionprops(objects, 'BoundingBox');
    labeledObjects = bwlabel(objects);
    mergedCount = 0;
    
    for i = 1:(length(objectsPosition) - 1)
        oP1 = objectsPosition(i).BoundingBox;
        oP2 = objectsPosition(i + 1).BoundingBox;
        
        if aOverB(oP1, oP2)
            for j = ((i + 1) : (length(objectsPosition)))
                labeledObjects(labeledObjects == (j - mergedCount)) = j - mergedCount - 1;
            end
            mergedCount = mergedCount + 1;
        end
    end

    merged = labeledObjects;
end

function [isTrue] = aOverB(A, B)
    a1 = A(1);
    a2 = a1 + A(3);
    b1 = B(1);
    b2 = b1 + B(3);

    if a1 >= b1 && a1 <= b2
        isTrue = true;
    elseif a2 >= b1 && a2 <= b2
        isTrue = true;
    elseif a1 < b1 && a2 > b2
        isTrue = true;
    else
        isTrue = false;
    end
end