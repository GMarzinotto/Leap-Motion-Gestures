function [] = train_gmm_model(FeatureList)

    %FeatureList is a list of all the digits features organized
    %by two index FeatureList{1}{10} access to the 10th sample
    %of the 1st class (digit 0)
    num_gaussians = 50;
    replicates    = 50;
    regValue      = 0.25;

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
    
    %Replace digits with Z norm digits
    [mrows,~] = size(tdigits0); tdigits0  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits1); tdigits1  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits2); tdigits2  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits3); tdigits3  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits4); tdigits4  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits5); tdigits5  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits6); tdigits6  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits7); tdigits7  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits8); tdigits8  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];
    [mrows,~] = size(tdigits9); tdigits9  = Ztraining(1:mrows,:); Ztraining(1:mrows,:) = [];     
    
    
    trainDigits = {tdigits0,tdigits1,tdigits2,tdigits3,tdigits4,...
                   tdigits5,tdigits6,tdigits7,tdigits8,tdigits9}; 
      
    gm0 = fitgmdist(tdigits0,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm1 = fitgmdist(tdigits1,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm2 = fitgmdist(tdigits2,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm3 = fitgmdist(tdigits3,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm4 = fitgmdist(tdigits4,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm5 = fitgmdist(tdigits5,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm6 = fitgmdist(tdigits6,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm7 = fitgmdist(tdigits7,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm8 = fitgmdist(tdigits8,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    gm9 = fitgmdist(tdigits9,num_gaussians,'Replicates',replicates,'RegularizationValue',regValue);
    
    GMModels    = {gm0,gm1,gm2,gm3,gm4,gm5,gm6,gm7,gm8,gm9};

    % Plot the Training Results (Scatter + GMM Curves)
    % Over the first two principal components.
    figure(),
    for k = 1:10
        subplot(2,5,k)
        [eigVec,score,eigVal] = princomp(trainDigits{k});
        gscatter(score(:,1),score(:,2))
        h = gca;
        hold on
        Fgmm = @(x1,x2)pdf(GMModels{k},[x1*eigVec(:,1)' + x2*eigVec(:,2)' + mean(trainDigits{k})]);
        ezcontour(Fgmm,[h.XLim h.YLim],60);
        inertia = floor((eigVal(1)+eigVal(2))*100/sum(eigVal));
        title(sprintf('Digit - %i ;GMM - %i Comp; inertia: %i/100',k-1,num_gaussians,inertia));
        xlabel('1st principal component');
        ylabel('2nd principal component');
    end

    % Plot the Training Results (Scatter + GMM Curves)
    % Over the X and Y position. This graph is less
    % usefull to evaluate que quality of the model. 
    % But it is more didactic
    figure(),
    for k = 1:10
        subplot(2,5,k)
        score = trainDigits{k};
        gscatter(score(:,1),score(:,2))
        h = gca;
        hold on
        Fgmm = @(x1,x2)pdf(GMModels{k},[x1 x2 zeros(1,ncol-2)]);
        ezcontour(Fgmm,[h.XLim h.YLim],60);
        inertia = floor(2*100/ncol);
        title(sprintf('Digit - %i ;GMM - %i Comp; inertia: %i/100',k-1,num_gaussians,inertia));
        xlabel('X Position');
        ylabel('Y Position');
    end

    save('GMM_Model','GMModels','meanTrain','stdTrain');

end