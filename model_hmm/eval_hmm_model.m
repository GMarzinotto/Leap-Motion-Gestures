function [probabilities] = eval_hmm_model(featuresTestDigit)

    load('HMM_Model');
    loglik = zeros(1,10);
    
    [mrow,~] = size(featuresTestDigit(:,1));
    featuresTestDigit   = featuresTestDigit - repmat(meanTrain,mrow,1);
    featuresTestDigit   = featuresTestDigit./ repmat(stdTrain, mrow,1);
    
    for k=1:10
        loglik(k) = mhmm_logprob(featuresTestDigit', HMMModels{k}.prior, HMMModels{k}.transmat, HMMModels{k}.mu, HMMModels{k}.sigma, HMMModels{k}.mixmat);
    end

    %Compute the Softmax Probabilities
    %ISSUE: Verify if this is the correct way of combining 
    %LogLikelihoods into a softmax. It seems to work very well.
    %However, I don't have a reference to justify this operation...
    
    %softConst determinates how strong is the probability discrimination
    %values near 0 attenuate the differences between classes and
    %the larger the softConst value the more we highlight the maximum 
    softConst = 0.1; 
    probabilities = softmax((softConst*loglik)');
    
end