function [probabilities] = eval_gmm_model(featuresTestDigit)


    load('GMM_Model');          
           
    [mrow,~] = size(featuresTestDigit(:,1));
    featuresTestDigit   = featuresTestDigit - repmat(meanTrain,mrow,1);
    featuresTestDigit   = featuresTestDigit./ repmat(stdTrain, mrow,1);
           
    [~,NLOG_0]=posterior(GMModels{1}, featuresTestDigit);
    [~,NLOG_1]=posterior(GMModels{2}, featuresTestDigit);
    [~,NLOG_2]=posterior(GMModels{3}, featuresTestDigit);
    [~,NLOG_3]=posterior(GMModels{4}, featuresTestDigit);
    [~,NLOG_4]=posterior(GMModels{5}, featuresTestDigit);
    [~,NLOG_5]=posterior(GMModels{6}, featuresTestDigit);
    [~,NLOG_6]=posterior(GMModels{7}, featuresTestDigit);
    [~,NLOG_7]=posterior(GMModels{8}, featuresTestDigit);
    [~,NLOG_8]=posterior(GMModels{9}, featuresTestDigit);
    [~,NLOG_9]=posterior(GMModels{10},featuresTestDigit);
        
    %Compute the Softmax Probabilities
    %ISSUE: Verify if this is the correct way of combining Negative
    %LogLikelihoods into a softmax. It seems to work very well.
    %However, I don't have a reference to justify this operation...
    
    %softConst determinates how strong is the probability discrimination
    %values near 0 attenuate the differences between classes and
    %the larger the softConst value the more we highlight the maximum 
    softConst = 0.1; 
    probabilities = softmax((-1*softConst*[NLOG_0,NLOG_1,NLOG_2,NLOG_3,NLOG_4,NLOG_5,NLOG_6,NLOG_7,NLOG_8,NLOG_9])');
           

end