charsList = ["A", "Ą", "B", "C", "Ć", "D", "E", "Ę", "F", "G", "H", "I", "J", "K", "L", "Ł", "M", "N", "Ń", "O", "Ó", "P", "Q", "R", "S", "Ś", "T", "U", "V", "W", "X", "Y", "Z", "Ź", "Ż",...
             "a", "ą", "b", "c", "ć", "d", "e", "ę", "f", "g", "h", "i", "j", "k", "l", "ł", "m", "n", "ń", "o", "ó", "p", "q", "r", "s", "ś", "t", "u", "v", "w", "x", "y", "z", "ź", "ż",...
             ",", ".", "?", "!"];
fontsList = ["Arial"];

image = double(zeros(300, length(charsList) * 300));

for i = 1:length(charsList)
    image = insertText(image, [300 * (i - 1), 0], charsList(i), "FontSize", 200, "Font", "Arial", "TextColor", "white", "BoxOpacity", 0);
end

image = imbinarize(rgb2gray(image));
image = mergeObjects(image);
charsProperties = regionprops(image, "Circularity", "Eccentricity", "EulerNumber", "Solidity", "Image");

input = zeros(12, length(charsList));
funs = {@AO5RBlairBliss, @AO5RCircularityL, @AO5RCircularityS, @AO5RDanielsson, @AO5RFeret, @AO5RHaralick, @AO5RMalinowska, @AO5RShape};

for i = 1:length(charsList)
    input(1, i) = charsProperties(i).Circularity;
    input(2, i) = charsProperties(i).Eccentricity;
    input(3, i) = charsProperties(i).EulerNumber;
    input(4, i) = charsProperties(i).Solidity;
end

for obj = 1:length(charsList)
    for fun = 1:length(funs)
        input(fun + 4, obj) = funs{fun}(charsProperties(obj).Image);
    end
end

input = input';
mn = mean(input);
sigma = std(input);
stdM = abs((input - mn) ./ sigma);
input = input';

output = eye(length(charsList));

nn = feedforwardnet(10);
nn = train(nn, input, output);
result = nn(input);
[~, it] = max(result);

disp(charsList(it));