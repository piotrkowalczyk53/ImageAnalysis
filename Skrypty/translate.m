function finalText = translate(binaryImage)
    load net.mat net;

    rows = [0, 0];

    rowStart = 0;
    rowEnd = 0;
    
    for y = 1:size(binaryImage, 1)
        if rowStart == 0
            if sum(binaryImage(y, :)) ~= 0
                rowStart = y;
            end
        elseif rowStart ~= 0 && rowEnd == 0
            if sum(binaryImage(y, :)) == 0
                rowEnd = y;
            end
        elseif rowStart ~= 0 && rowEnd ~= 0
            if rows == [0, 0]
                rows = [rowStart, rowEnd];
            else
                rows = [rows; [rowStart, rowEnd]];
            end
            rowStart = 0;
            rowEnd = 0;
        end
    end
    
    finalText = "";
    for i = 1:size(rows, 1)
        line = binaryImage(rows(i, 1):rows(i, 2), :);
        lineChars = mergeObjects(line);
        lineCharsImg = regionprops(lineChars, "Image");

        spaceVector = [];
        boxes = regionprops(lineChars, "BoundingBox");
        for obj = 1:(length(boxes) - 1)
            spaceVector(obj) = boxes(obj + 1).BoundingBox(1) - (boxes(obj).BoundingBox(1) + boxes(obj).BoundingBox(3));
        end
        avgSpace = sum(spaceVector, "all") / length(spaceVector);

        for im = 1:max(lineChars, [], 'all')
            imgToCheck = 255 * to128Image(lineCharsImg(im).Image);
            finalText = finalText + string(classify(net, imgToCheck));
            if im ~= max(lineChars, [], 'all')
                if spaceVector(im) > 1.4*avgSpace
                    finalText = finalText + " ";
                end
            end
        end
        finalText = finalText + newline;
    end
end