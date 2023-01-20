function OCR

    global binaryImage;

    % Utworzenie okna programu
    mainWindow = uifigure;
    mainWindow.Name = "OCR";
    
    % Parametry siatki
    gridLayout = uigridlayout(mainWindow, [3, 3]);
    gridLayout.RowHeight = {'1x', 30};
    gridLayout.ColumnWidth = {'1x', '1x', '1x'};
    gridLayout.RowHeight = {'1x', 30, 30};

    % Obiekty programu
    originalImage = uiimage(gridLayout, "ImageSource", "../Obrazy/OCR_1.png");
    originalImage.Layout.Row = 1;
    originalImage.Layout.Column = 1;

    preparedImage = uiimage(gridLayout);
    preparedImage.Layout.Row = 1;
    preparedImage.Layout.Column = 2;

    textArea = uitextarea(gridLayout);
    textArea.Layout.Row = 1;
    textArea.Layout.Column = 3;

    selectButton = uibutton(gridLayout, "Text", "Wybierz zdjęcie", "ButtonPushedFcn", @loadImage);
    selectButton.Layout.Row = 2;
    selectButton.Layout.Column = 1;

    prepareButton = uibutton(gridLayout, "Text", "Przygotuj zdjęcie", "ButtonPushedFcn", @loadPreparedImage);
    prepareButton.Layout.Row = 2;
    prepareButton.Layout.Column = 2;

    prepareButton = uibutton(gridLayout, "Text", "Konwertuj na tekst", "ButtonPushedFcn", @translateImage);
    prepareButton.Layout.Row = 2;
    prepareButton.Layout.Column = 3;

    slider = uislider(gridLayout); % tworzymy slider
    slider.Layout.Row = 3;
    slider.Layout.Column = 2;
    slider.Limits = [-90 90]; % ustawiamy zakres wartości
    slider.Value = 0; % ustawiamy wartość początkową
    slider.ValueChangedFcn = @rotateImage;


    function loadImage(src, event)
        [file, path] = uigetfile({'*.png;*.jpg'}, "Wybierz zdjęcie", "../Obrazy");
        filePath = append(path, file);
        originalImage.ImageSource = filePath;
    end
    

    function loadPreparedImage(src, event)
        h = waitbar(0, 'Please wait...');
        image = imread(originalImage.ImageSource);
        treshhold = graythresh(image);
        binaryImage = prepareImage(image, true, treshhold);
        preparedImage.ImageSource = repmat(double(binaryImage), 1, 1, 3);
        close(h)
    end

    function translateImage(src, event)
        h = waitbar(0, 'Please wait...');
        textArea.Value = translate(binaryImage);
        close(h)
    end

    function rotateImage(src, event)
        binaryCopy = binaryImage;
        binaryCopy = imrotate(binaryCopy, slider.Value, 'nearest', 'crop');
        preparedImage.ImageSource = repmat(double(binaryCopy), 1, 1, 3);
    end
end