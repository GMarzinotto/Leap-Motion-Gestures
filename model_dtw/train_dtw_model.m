function [] = train_dtw_model(FeatureList)

    %FeatureList is a list of all the digits features organized
    %by two index FeatureList{1}{10} access to the 10th sample
    %of the 1st class (digit 0)
    
    %DTW does not requiere training
    %This simply stores the training samples into a variable
    %To be used for the test and the evaluation
    
    tdigits0 = vertcat(FeatureList{1} {:});
    tdigits1 = vertcat(FeatureList{2} {:});
    tdigits2 = vertcat(FeatureList{3} {:});
    tdigits3 = vertcat(FeatureList{4} {:});
    tdigits4 = vertcat(FeatureList{5} {:});
    tdigits5 = vertcat(FeatureList{6} {:});
    tdigits6 = vertcat(FeatureList{7} {:});
    tdigits7 = vertcat(FeatureList{8} {:});
    tdigits8 = vertcat(FeatureList{9} {:});
    tdigits9 = vertcat(FeatureList{10}{:});
    
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
        for m=1:length(FeatureList{k+1})
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
    
    numTrainSample = [length(FeatureList{1}) length(FeatureList{2}) length(FeatureList{3}) ...
                      length(FeatureList{4}) length(FeatureList{5}) length(FeatureList{6}) ...
                      length(FeatureList{7}) length(FeatureList{8}) length(FeatureList{9}) ...
                      length(FeatureList{10}) ];
             
    totalSamples   = sum(numTrainSample);              
    labelsDTW      = zeros(totalSamples,1);
    distDTWMatrix  = zeros(totalSamples);
    textLabel     = {};
    
    for k = 1:numDigits
        for m = 1:numTrainSample(k)
            labelsDTW(sum(numTrainSample(1:(k-1))) + m) = k-1;
            textLabel{sum(numTrainSample(1:(k-1))) + m} = strcat('(',num2str(k),',',num2str(m),')');
            for n = 1:numDigits
                for o = 1:numTrainSample(k)
                    %Make it lower triangular to save half the computing
                    if(sum(numTrainSample(1:(k-1))) + m > (n-1)*numTrainSample(k) + o)
                        distDTWMatrix(sum(numTrainSample(1:(k-1))) + m, sum(numTrainSample(1:(n-1))) + o ) = dtw(DTWModels{k}{m},DTWModels{n}{o});
                    end
                end
            end
        end
    end
    
    %Complete the pairwise distance matrix copying in the upper triangle
    distDTWMatrix = distDTWMatrix + distDTWMatrix';
    
    Y = mdscale(distDTWMatrix,2,'Replicates',50);
    
    %Visualize the points projected in 2D with their distance ratios
    figure(),
    hold on;
    %text(Y(:,1),Y(:,2),textLabels,'FontSize',8) %visualize the indexes
    gscatter(Y(:,1),Y(:,2),labelsDTW) 
      
    save('DTW_Model','DTWModels','distDTWMatrix','labelsDTW','meanTrain','stdTrain','numTrainSample');

end