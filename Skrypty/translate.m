load bim.mat;
tr(binaryImage)

function finalText = tr(binaryImage)
    load net.mat net;

    angle = -6;
    binaryImage = imrotate(binaryImage, angle);
    binaryImage = imclearborder(~binaryImage);
    binaryImage = imopen(binaryImage, ones(3));
    imshow(binaryImage);

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
        
        for im = 1:max(lineChars, [], 'all')
            imgToCheck = 255 * to128Image(lineCharsImg(im).Image);
            finalText = finalText + string(classify(net, imgToCheck));
        end
    end
    
end