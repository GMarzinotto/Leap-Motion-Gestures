function [] = train_hmm_model()

    %FeatureList is a list of all the digits features organized
    %by two index FeatureList{1}{10} access to the 10th sample
    %of the 1st class (digit 0)
    
        
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
     

    
   
        
    DTWModels  = {zdigits0,zdigits1,zdigits2,zdigits3,zdigits4,zdigits5,zdigits6,zdigits7,zdigits8,zdigits9};

 
    %Complete the pairwise distance matrix copying in the upper triangle
    distDTWMatrix = distDTWMatrix + distDTWMatrix';
    
    Y = mdscale(distDTWMatrix,2);
    
    %Visualize the points projected in 2D with their distance ratios
    figure(),
    hold on;
    %text(Y(:,1),Y(:,2),textLabels,'FontSize',8) %visualize the indexes
    gscatter(Y(:,1),Y(:,2),labelsDTW) 
      
    save('HMM_Model','HMMModels','meanTrain','stdTrain');


end