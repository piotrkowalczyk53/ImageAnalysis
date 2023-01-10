%{
objects - obraz binarny ze znakami (linijka tekstu)
merged - obraz, gdzie każdy znak otrzymał unikalny numer (podobnie jak w bwlabel)
%}
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
end