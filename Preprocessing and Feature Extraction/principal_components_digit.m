function [PCAfileContent]=principal_components_digit(fileContent)


    %TODO:
    %This code should be tested more to ensure it is robust
    
    %TODO:
    %Other approaches may be tested like using SNE.
    
    %ISSUES:
    %Beware that PCA may mirror or rotate the figures
    %And for this I see no obvious solution.
    
    %Prealocate for the result
    PCAfileContent = zeros(size(fileContent));
    
    %Apply PCA only on the XYZ coordinates to find the main axes
    [eig_vector,proyections,eig_values] = princomp(fileContent(:,[2,3,4]));
    
    %Time remains unchanged
    PCAfileContent(:,1) = fileContent(:,1);
    
    %The first  Principal Component will be redifined as the Y axis
    PCAfileContent(:,3) = proyections(:,1);
    
    %The second Principal Component will be redifined as the X axis
    PCAfileContent(:,2) = proyections(:,2);
    
    %The third  Principal Component will be redifined as the Z axis
    PCAfileContent(:,4) = proyections(:,1);
    
    %The speed and the direction also need to be adapted acordingly
    %We're consistent 1st PC => Y axis; 2nd PC => X axis; 3rd PC => Z axis
    PCAfileContent(:,5)  = fileContent(:,[5:7])*eig_vector(:,2);
    PCAfileContent(:,6)  = fileContent(:,[5:7])*eig_vector(:,1);
    PCAfileContent(:,7)  = fileContent(:,[5:7])*eig_vector(:,3);
    
    PCAfileContent(:,8)  = fileContent(:,[8:10])*eig_vector(:,2);
    PCAfileContent(:,9)  = fileContent(:,[8:10])*eig_vector(:,1);
    PCAfileContent(:,10) = fileContent(:,[8:10])*eig_vector(:,3);
    

end