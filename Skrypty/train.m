% Definiujemy folder z obrazami
database_folder = 'database/';

%Tworzymy imageDatastore z plików z folderu
imds = imageDatastore(database_folder, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

%Poprawiamy etykiety
imds.Labels = cellstr(imds.Labels);
imds.Labels(strcmp(imds.Labels,'wykrzyknik'))={'!'};
imds.Labels(strcmp(imds.Labels,'pytajnik'))={'?'};
imds.Labels(strcmp(imds.Labels,'kropka'))={'.'};
imds.Labels(strcmp(imds.Labels,'przecinek'))={','};
imds.Labels = cellfun(@(x) strrep(x,'apostrof',''''),imds.Labels, 'UniformOutput',false);
imds.Labels(strcmp(imds.Labels,'cudzysłów'))={'"'};
imds.Labels(strcmp(imds.Labels,'lewy_nawias'))={'('};
imds.Labels(strcmp(imds.Labels,'prawy_nawias'))={')'};
imds.Labels(strcmp(imds.Labels,'łącznik'))={'-'};
imds.Labels = cellfun(@(x) x(1),imds.Labels,'un',0);
imds.Labels = categorical(imds.Labels);

%Podział danych na treningowe i walidacji
numTrainFiles = 1150;
[imdsTrain,imdsValidation] = splitEachLabel(imds,numTrainFiles,'randomize');

%Definiowanie architektury sieci
layers = [
    imageInputLayer([128 128 1])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(89)
    softmaxLayer
    classificationLayer];

%Opcje treningu
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs', 10, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',50, ...
    'Verbose',false, ...
    'Plots','training-progress', ...
    'ExecutionEnvironment','gpu');


%Trenowanie
net = trainNetwork(imdsTrain,layers,options);


%Sprawdzenie
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

save net.mat net;

accuracy = sum(YPred == YValidation)/numel(YValidation);