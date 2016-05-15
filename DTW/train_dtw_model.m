function [] = train_dtw_model(FeatureList,trainingIDX)

    %FeatureList is a list of all the digits features organized
    %by two index FeatureList{1}{10} access to the 10th sample
    %of the 1st class (digit 0)
    
    %DTW does not requiere training
    %This simply stores the training samples into a variable
    %To be used for the test and the evaluation
    
    tdigits0 = vertcat(FeatureList{1} {trainingIDX});
    tdigits1 = vertcat(FeatureList{2} {trainingIDX});
    tdigits2 = vertcat(FeatureList{3} {trainingIDX});
    tdigits3 = vertcat(FeatureList{4} {trainingIDX});
    tdigits4 = vertcat(FeatureList{5} {trainingIDX});
    tdigits5 = vertcat(FeatureList{6} {trainingIDX});
    tdigits6 = vertcat(FeatureList{7} {trainingIDX});
    tdigits7 = vertcat(FeatureList{8} {trainingIDX});
    tdigits8 = vertcat(FeatureList{9} {trainingIDX});
    tdigits9 = vertcat(FeatureList{10}{trainingIDX});
    
    trainingSet = [tdigits0;tdigits1;tdigits2;tdigits3;tdigits4;...
                   tdigits5;tdigits6;tdigits7;tdigits8;tdigits9];
    
    [~,ncol]   = size(trainingSet);
    Ztraining  = zscore(trainingSet);
    meanTrain  = mean(trainingSet);
    stdTrain   = std (trainingSet);
     
    %Loop for each Digit 0-9
    for k=0:9
        %Declare the zdigitX variable
        eval(strcat('zdigits',num2str(k),' = {};'));
        idx = 1;
        for m=trainingIDX
            [mrows,~] = size(FeatureList{k+1}{m}); 
            eval(strcat('zdigits',num2str(k),'{idx} = Ztraining(1:mrows,:);'));
            Ztraining(1:mrows,:) = []; 
            idx = idx+1;
        end
    end
       
    DTWModels  = {zdigits0,zdigits1,zdigits2,zdigits3,zdigits4,zdigits5,zdigits6,zdigits7,zdigits8,zdigits9};

    %Initialize the pairwise distance matrix for all the training samples
    %used for DTW. it means, length(trainingIDX) samples for each digit
    numDigits      = 10;
    distDTWMatrix  = zeros(numDigits*length(trainingIDX));
    numTrainSam    = length(trainingIDX);
    labelsDTW      = zeros(numDigits*length(trainingIDX),1);
    textLabels     = {};
    
    for k = 1:numDigits
        for m = 1:numTrainSam
            labelsDTW((k-1)*numTrainSam + m) = k-1;
            textLabels{(k-1)*numTrainSam + m} = strcat('(',num2str(k),',',num2str(m),')');
            for n = 1:numDigits
                for o = 1:numTrainSam
                    %Make it lower triangular to save half the computing
                    if((k-1)*numTrainSam + m > (n-1)*numTrainSam + o)
                        distDTWMatrix((k-1)*numTrainSam + m, (n-1)*numTrainSam + o ) = dtw(DTWModels{k}{m},DTWModels{n}{o});
                    end
                end
            end
        end
    end
    
    %Complete the pairwise distance matrix copying in the upper triangle
    distDTWMatrix = distDTWMatrix + distDTWMatrix';
    
    Y = mdscale(distDTWMatrix,2);
    
    %Visualize the points projected in 2D with their distance ratios
    figure(),
    hold on;
    %text(Y(:,1),Y(:,2),textLabels,'FontSize',8) %visualize the indexes
    gscatter(Y(:,1),Y(:,2),labelsDTW) 
      
    save('DTW_Model','DTWModels','distDTWMatrix','labelsDTW','meanTrain','stdTrain');

end