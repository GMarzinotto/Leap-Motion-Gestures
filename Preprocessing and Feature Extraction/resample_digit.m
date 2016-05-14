function [resampledFileContent] = resample_digit(fileContent)

    %TODO: Test different resampling distances

    %Rasample Distance
    resampleDistance = 0.025;
    
    %Init the resampled digit with the first point of the input
    resampledFileContent = fileContent(1,:);
    
    [mrow,~] = size(fileContent);
    
    %Loop through the whole file
    for k=1:mrow-1
        PrevVal = resampledFileContent(end,:);
        highIDX = k+1;
        
        %Find the next point of the sequence at 
        %Reesampling distance or a larger distance
        %Distance is computed only using XYZ coordinates
        %This will remove all the points that too close
        if((highIDX<mrow)&&(norm(PrevVal([2:4])-fileContent(highIDX,[2:4]))<resampleDistance))
            continue;
        end
        
        %Interpolate between the two points to ensure exact distance
        %If it is equal there is nothing to do
        if(norm(PrevVal([2:4])-fileContent(highIDX,[2:4]))==resampleDistance)
            resampledFileContent = [resampledFileContent; fileContent(highIDX,:)];
            
        %If it is larger, we have to interpolate
        else
            %All the features have to be interpolated
            %But the distance to be considered is still in XYZ
            %We interpolate points untill we reach the resample distance
            while (highIDX<mrow)&&(norm(PrevVal([2:4])-fileContent(highIDX,[2:4]))>resampleDistance)
                distValue = norm(PrevVal([2:4])-fileContent(highIDX,[2:4]));
                AuxVector = (fileContent(highIDX,:) - PrevVal); 

                newPoint = PrevVal + AuxVector*(resampleDistance/distValue);
                resampledFileContent = [resampledFileContent; newPoint];  
                PrevVal = resampledFileContent(end,:);
            end       
        end   
    end

    %Make sure that after interpolate the direction vectors remain unitary
    for k=1:length(resampledFileContent(:,1))
        resampledFileContent(k,[5:7]) =   resampledFileContent(k,[5:7])/norm( resampledFileContent(k,[5:7]));
    end

end