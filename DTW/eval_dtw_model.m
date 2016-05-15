function [KNNProbabilities] = eval_dtw_model(featuresTestDigit)

    load('DTW_Model');          
           
    [mrow,~] = size(featuresTestDigit(:,1));
    featuresTestDigit   = featuresTestDigit - repmat(meanTrain,mrow,1);
    featuresTestDigit   = featuresTestDigit./ repmat(stdTrain, mrow,1);
    
    numDigits = 10;
    [totalSamples,~] = size(distDTWMatrix);
    distances        = zeros(totalSamples,1);
    numTrainSam      = totalSamples/numDigits;
    
    for k = 1:numDigits
        for m = 1:numTrainSam
            distances((k-1)*numTrainSam + m) = dtw(DTWModels{k}{m},featuresTestDigit);
        end
    end
    
    
    %Apply KNN to decide a Class.
    %TODO: Different number of KNeighbors should be tested
    KNeighbors    = 20;
    distAndLabels = [distances labelsDTW];
    sortDistLabel = sortrows(distAndLabels);
      
    
    %To Compute the probabilities for each class you can use softmax
    %once again there is no reference that justifies this
    
    %softConst determinates how strong is the probability discrimination
    %values near 0 attenuate the differences between classes and
    %the larger the softConst value the more we highlight the maximum 
    softConst = 0.01; 
    Ndist_lab = sortDistLabel([1:KNeighbors],:);
    softProb  = softmax(-1*softConst*Ndist_lab(:,1));
    KNNProbabilities = zeros(numDigits,1);
    
    for k=1:KNeighbors
        KNNProbabilities(Ndist_lab(k,2)+1) = KNNProbabilities(Ndist_lab(k,2)+1) + softProb(k)';
    end
    
    
end