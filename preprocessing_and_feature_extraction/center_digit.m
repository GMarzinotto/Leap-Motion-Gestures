function [centredFileContent] = center_digit(fileContent)

    centredFileContent = fileContent;
    %Only Center the X,Y,Z values
    %Do not center the pointing tool direction vector or the speeds
    centredFileContent(:,2) = fileContent(:,2) - mean(fileContent(:,2));
    centredFileContent(:,3) = fileContent(:,3) - mean(fileContent(:,3));
    centredFileContent(:,4) = fileContent(:,4) - mean(fileContent(:,4));
    

end