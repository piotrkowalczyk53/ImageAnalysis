% Lista czcionek
fontsList = ["Arial", "Calibri", "Cambria", "Candara", "Century",...
    "Constantia", "Corbel", "Courier New", "Georgia", "Lucida Sans Unicode",...
    "Palatino Linotype", "Segoe UI", "Tahoma", "Times New Roman", "Trebuchet MS", "Verdana"];

% Lista liter
charsList = ["A", "Ą", "B", "C", "Ć", "D", "E", "Ę", "F", "G", "H", "I", "J", "K", "L", "Ł", "M", "N",...
    "Ń", "O", "Ó", "P", "Q", "R", "S", "Ś", "T", "U", "V", "W", "X", "Y", "Z", "Ź", "Ż", "a", "ą", "b",...
    "c", "ć", "d", "e", "ę", "f", "g", "h", "i", "j", "k", "l", "ł", "m", "n", "ń", "o", "ó", "p", "q",...
    "r", "s", "ś", "t", "u", "v", "w", "x", "y", "z", "ź", "ż", ",", ".", "?", "!", "'", '"', "(", ")", "-",...
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

% Tworzenie folderu "database"
database_folder = "database/";
if ~exist(database_folder, 'dir')
    mkdir(database_folder);
end

% Tworzenie folderów dla każdej litery
leng = length(charsList);
h = waitbar(0, 'Creating database structure', 'Name', 'Creating database');
for i = 1:leng
    folder_name = createName(charsList(i));
    if ~exist(strcat(database_folder,folder_name), 'dir')
       mkdir(strcat(database_folder,folder_name));
    end
    percentage = i / leng;
    waitbar(percentage, h);
end
close(h)

% Tworzenie obrazów dla każdej litery i czcionki
h = waitbar(0, 'Creating database files (this may take a while...)', 'Name', 'Creating database');
imageIterator = 1;
for i = 1:leng
    char = charsList(i);
    folder_name = createName(char);
    for j = 1:length(fontsList)
        %wygeneruj obrazy z literą po różnych zniekształceniach
            font = fontsList(j);
            for iter = 1:100
                image = randImage(char, font);
                imageLabel = bwlabel(imbinarize(rgb2gray(image)));
                imageLabel(imageLabel > 0) = 1;
                imageImage = regionprops(imageLabel, "Image");
                image = to128Image(imageImage(1).Image);
                imwrite(image, strcat(database_folder,folder_name, int2str(imageIterator), '.png'));
                imageIterator = imageIterator + 1;
            end
    end
    percentage = i / leng;
    waitbar(percentage, h);
end
close(h)

%Funkcja tworząca obrazy ze zniekształconymi znakami
function image = randImage(char, font)
    im1 = insertText(zeros(300,300),[0 0],char,'Font',font,'FontSize',200, 'TextColor','white', 'BoxColor','black');
    im2 = imrotate(im1, randi([-15, 15]), "nearest", "crop");
    r = -pi/18 + (pi/9)*rand(1);
    tform = affine2d([1, tan(r), 0; 0, 1, 0; 0, 0, 1]);
    image = imwarp(im2,tform);
end

%Funckja tworząca odpowiednie nazwy folderów dla każdego znaku
function folder_name = createName(char)
    if char == ","
        folder_name = "przecinek/";
    elseif char == "."
        folder_name = "kropka/";
    elseif char == "?"
        folder_name = "pytajnik/";
    elseif char == "!"
        folder_name = "wykrzyknik/";
    elseif char == "'"
        folder_name = "apostrof/";
    elseif char == '"'
        folder_name = "cudzysłów/";
    elseif char == "("
        folder_name = "lewy_nawias/";
    elseif char == ")"
        folder_name = "prawy_nawias/";
    elseif char == "-"
        folder_name = "łącznik/";
    elseif isstrprop(char, 'upper')
        folder_name = upper(char);
        folder_name = strcat(folder_name, '/');
    else
        folder_name = char;
        folder_name = strcat(folder_name, '_lower/');
    end
end