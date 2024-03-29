function OCR

    global binaryImage;
    global sensitivity;
    global openSize;
    global badLighting;
    openSize = 0;
    sensitivity = 0;
    badLighting = false;

    % Utworzenie okna programu
    mainWindow = uifigure;
    mainWindow.Name = "OCR";
    
    % Parametry siatki
    gridLayout = uigridlayout(mainWindow, [3, 5]);
    gridLayout.ColumnWidth = {'1x', '1x', '1x'};
    gridLayout.RowHeight = {'1x', 30, 30, 50, 15};

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


    sliderSensitivityLabel = uilabel(gridLayout, "Text", "Wrażliwość");
    sliderSensitivityLabel.Layout.Row = 3;
    sliderSensitivityLabel.Layout.Column = 1;
    sliderSensitivityLabel.HorizontalAlignment = "center";
    

    sliderSensitivity = uislider(gridLayout); % tworzymy slider
    sliderSensitivity.Layout.Row = 4;
    sliderSensitivity.Layout.Column = 1;
    sliderSensitivity.Limits = [0 1]; % ustawiamy zakres wartości
    sliderSensitivity.Value = 0; % ustawiamy wartość początkową
    sliderSensitivity.ValueChangedFcn = @setSensitivity;
    sliderSensitivity.MajorTicks = 0:0.1:1;


    sliderRotationLabel = uilabel(gridLayout, "Text", "Rotacja");
    sliderRotationLabel.Layout.Row = 3;
    sliderRotationLabel.Layout.Column = 2;
    sliderRotationLabel.HorizontalAlignment = "center";

    sliderRotation = uislider(gridLayout); % tworzymy slider
    sliderRotation.Layout.Row = 4;
    sliderRotation.Layout.Column = 2;
    sliderRotation.Limits = [-90 90]; % ustawiamy zakres wartości
    sliderRotation.Value = 0; % ustawiamy wartość początkową
    sliderRotation.ValueChangedFcn = @rotateImage;
    sliderRotation.MajorTicks = -90:10:90;
 

    sliderOpenLabel = uilabel(gridLayout, "Text", "Otwarcie");
    sliderOpenLabel.Layout.Row = 3;
    sliderOpenLabel.Layout.Column = 3;
    sliderOpenLabel.HorizontalAlignment = "center";

    sliderOpen = uislider(gridLayout); % tworzymy slider
    sliderOpen.Layout.Row = 4;
    sliderOpen.Layout.Column = 3;
    sliderOpen.Limits = [0 25]; % ustawiamy zakres wartości
    sliderOpen.Value = 0; % ustawiamy wartość początkową
    sliderOpen.ValueChangedFcn = @setOpenSize;
    sliderOpen.MajorTicks = 0:25;


    checkboxBadLighting = uicheckbox(gridLayout);
    checkboxBadLighting.Layout.Row = 5;
    checkboxBadLighting.Layout.Column = 1;
    checkboxBadLighting.Text = 'Złe oświetlenie';
    checkboxBadLighting.ValueChangedFcn = @setBadLighting;


    function loadImage(src, event)
        sliderRotation.Value = 0;
        sliderOpen.Value = 0;
        sliderSensitivity.Value = 0;
        checkboxBadLighting.Value = 0;
        badLighting = false;
        [file, path] = uigetfile({'*.png;*.jpg'}, "Wybierz zdjęcie", "../Obrazy");
        filePath = append(path, file);
        originalImage.ImageSource = filePath;
    end
    

    function loadPreparedImage(src, event)
        h = waitbar(0, 'Please wait...');
        image = imread(originalImage.ImageSource);
        [binaryImage, sliderRotation.Value] = prepareImage(image, badLighting, sensitivity, openSize);
        binaryCopy = binaryImage;
        binaryCopy = imrotate(binaryCopy, sliderRotation.Value, 'nearest', 'loose');
        preparedImage.ImageSource = repmat(double(binaryCopy), 1, 1, 3);
        close(h)
    end

    function translateImage(src, event)
        h = waitbar(0, 'Please wait...');
        textArea.Value = translate(imrotate(binaryImage, sliderRotation.Value, 'bilinear', 'loose'));
        close(h)
    end

    function rotateImage(src, event)
        binaryCopy = binaryImage;
        binaryCopy = imrotate(binaryCopy, sliderRotation.Value, 'bilinear', 'loose');
        preparedImage.ImageSource = repmat(double(binaryCopy), 1, 1, 3);
    end

    function setSensitivity(src, event)
        sensitivity = sliderSensitivity.Value;
    end

    function setOpenSize(src, event)
        openSize = round(sliderOpen.Value);
    end

    function setBadLighting(src, event)
        if src.Value == 1
            badLighting = true;
        else
            badLighting = false;
        end
    end
end