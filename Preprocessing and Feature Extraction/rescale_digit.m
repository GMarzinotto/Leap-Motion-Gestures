function [rescaledFileContent] = rescale_digit(fileContent)

    rescaledFileContent = fileContent;
    %Only rescale the X,Y,Z values
    %Do not rescale the pointing tool direction vector or the speeds
    
    %Rescale as discuss in class, scaling the Y coordinate between -1 and 1
    %And then applying the same scaling factor on the X, Z axis
    %This will only work in the case we write perpendicular to the sensor

    
    %TODO:
    %This scalingFactor is noise sensitive, consider taking more robust
    %measures than just the max and the min (see outlayer detection)
    %In order to remove points that are too above or really below the
    %corpus of the digit... However, if recording was done properly this
    %should work.
    scalingFactor = (max(fileContent(:,3)) - min(fileContent(:,3)));
    
    rescaledFileContent(:,2) = fileContent(:,2)/scalingFactor;
    rescaledFileContent(:,3) = fileContent(:,3)/scalingFactor;
    rescaledFileContent(:,4) = fileContent(:,4)/scalingFactor;
    
end