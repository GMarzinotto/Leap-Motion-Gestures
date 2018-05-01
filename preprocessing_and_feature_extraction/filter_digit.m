function [filteredFileContent] = filter_digit(fileContent)

    %TODO: You might want to use a better filter (more coefficients)
    %      or a lower cut frequency. However, it should be tested
    %      to ensure it is not affecting the rest of the system
    
    
    
    %Define the Filter Parameters
    
    %Number of coefficients has to be even.
    %More Coefficients => More Precission => More Time Consumption
    numberOfCoeff   = 63;   
    support         = [-1*floor(numberOfCoeff/2):1:floor(numberOfCoeff/2)];
    
    %normFreq is in the interval [0-1]. Where 0 is 0Hz and 1 is 120Hz
    normCutFreq = 0.05;
    fourierCoef     = normCutFreq*sinc(normCutFreq*support);
    hamminWindow    = hamming(numberOfCoeff);
    Filter          = hamminWindow.*fourierCoef';
    
    
    %Apply the Filter to the data
    [n,m]=size(fileContent);
    for j=1:m
        filteredFileContent(:,j) = conv(fileContent(:,j),Filter);
    end

    %Remove the first and last points of the result sequence where 
    %the filter is not supposed to work
    filteredFileContent([1:numberOfCoeff-1],:) = [];
    filteredFileContent([end-(numberOfCoeff-1):end],:) = [];

end