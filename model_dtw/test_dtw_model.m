function [confusion_matrix,dtwProbs] = test_dtw_model(FeatureList)

    confusion_matrix = zeros(10);
    dtwProbs = {};
    %FeatureList is a list of all the digits features organized
    %by two index FeatureList{1}{10} access to the 10th sample
    %of the 1st class (digit 0)
    for k=1:10
       for m=1:length(FeatureList{k})
           
            %Test a digit in the DTW
            [probabilities] = eval_dtw_model(FeatureList{k}{m}); 
            test_label      = find(probabilities==max(probabilities));
            
            confusion_matrix(k,test_label) = confusion_matrix(k,test_label) + 1;
            dtwProbs{k}{m} = probabilities;
            
       end
    end
    

end