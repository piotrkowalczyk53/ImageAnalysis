function OCR
    % Utworzenie okna programu
    mainWindow = uifigure;
    mainWindow.Name = "OCR";
    
    % Parametry siatki
    gridLayout = uigridlayout(mainWindow, [2, 3]);
    gridLayout.RowHeight = {'1x', 30};
    gridLayout.ColumnWidth = {'1x', '1x', '1x'};

    % Obiekty programu
    originalImage = uiimage(gridLayout, "ImageSource", "kiepskie_zdjecie.jpg");
    originalImage.Layout.Row = 1;
    originalImage.Layout.Column = 1;

    preparedImage = uiimage(gridLayout);
    preparedImage.Layout.Row = 1;
    preparedImage.Layout.Column = 2;

    textArea = uitextarea(gridLayout);
    textArea.Layout.Row = 1;
    textArea.Layout.Column = 3;

    selectButton = uibutton(gridLayout, "Text", "Wybierz zdjęcie");
    selectButton.Layout.Row = 2;
    selectButton.Layout.Column = 1;
end