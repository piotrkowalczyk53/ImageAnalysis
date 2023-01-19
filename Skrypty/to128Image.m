function img128 = to128Image(image)
    [y, x] = size(image);
    if x > y
        image = imresize(image, 128 / x);
        [y, ~] = size(image);
        toAdd = 128 - y;
        if mod(toAdd, 2) == 0
            image = [zeros(toAdd / 2, 128); image; zeros(toAdd / 2, 128)];
        else
            image = [zeros(fix(toAdd / 2), 128); image; zeros(fix(toAdd / 2) + 1, 128)];
        end
    else
        image = imresize(image, 128 / y);
        [~, x] = size(image);
        toAdd = 128 - x;
        if mod(toAdd, 2) == 0
            image = [zeros(128, toAdd / 2), image, zeros(128, toAdd / 2)];
        else
            image = [zeros(128, fix(toAdd / 2)), image, zeros(128, fix(toAdd / 2) + 1)];
        end
    end
    img128 = image;
end