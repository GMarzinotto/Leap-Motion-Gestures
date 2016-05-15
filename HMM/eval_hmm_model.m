function [probabilities] = eval_hmm_model(featuresTestDigit)

    load('HMM_Model');
    loglik = zeros(1,10);
    
    [mrow,~] = size(featuresTestDigit(:,1));
    featuresTestDigit   = featuresTestDigit - repmat(meanTrain,mrow,1);
    featuresTestDigit   = featuresTestDigit./ repmat(stdTrain, mrow,1);
    
    for k=1:10
        loglik(k) = mhmm_logprob(featuresTestDigit', HMMModels{k}.prior, HMMModels{k}.transmat, HMMModels{k}.mu, HMMModels{k}.sigma, HMMModels{k}.mixmat);
    end

    probabilities = loglik;
    
end