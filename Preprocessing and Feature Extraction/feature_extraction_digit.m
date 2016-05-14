function [Features]=feature_extraction_digit(fileContent)

    %TODO: Veryfy if all features are usefull or eventually add more
    %features

    [mrow,~] = size(fileContent);

    %Position XYZ Features are straighforward as they
    %are already centered, resized, filtered and resampled
    %at this point PCA is already performed
    PositionsXYZ = fileContent(:,[2,3,4]);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %The unitary pointing direction vector is already computed
    pointingDirectionVector = fileContent(:,[5:7]);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    %Compute Polar Coordinates Transformation
    [azimuth,elevation,radio] = cart2sph(fileContent(:,2),fileContent(:,3),fileContent(:,4));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Normalize speed vectors to make them unitary (Direction Vector)
    Speeds = fileContent(:,8:10);
    for k=1:length(Speeds)
        movementDirectionVector(k,:) = Speeds(k,:)/norm(Speeds(k,:));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Compute acceleration as the derivative of speed XYZ
    AceleracionX = (fileContent([2:end],8)  - fileContent([1:end-1],8)) ./(fileContent([2:end],1) - fileContent([1:end-1],1));
    AceleracionY = (fileContent([2:end],9)  - fileContent([1:end-1],9)) ./(fileContent([2:end],1) - fileContent([1:end-1],1));
    AceleracionZ = (fileContent([2:end],10) - fileContent([1:end-1],10))./(fileContent([2:end],1) - fileContent([1:end-1],1));
    
    %Complete the acceleration matrixes as the acceleration in the last
    %point is missing, we repeat the last value.
    AceleracionX = [AceleracionX; AceleracionX(end)];
    AceleracionY = [AceleracionY; AceleracionY(end)];
    AceleracionZ = [AceleracionZ; AceleracionZ(end)];
    
    %Concatenate the Acceleration Matrix
    Acceleration = [AceleracionX AceleracionY AceleracionZ];
    
    %Normalize acceleration vectors to make them unitary (Curvature Vector)
    for k=1:length(Acceleration)
        curvatureVector(k,:) = Acceleration(k,:)/norm(Acceleration(k,:));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Compute local curvature on XY plane

    %Number of contiguous points used to compute the angles
    npoints = 4;
    
    %First we compute the slope angle for each pair 
    %of points separed by npoints
    XY1    = [fileContent(1:mrow-npoints,2) fileContent(1:mrow-npoints,3)];
    XY2    = [fileContent(npoints+1:mrow,2) fileContent(npoints+1:mrow,3)];
    XYDiff = XY2-XY1;
    slopeAngle = atan2(XYDiff(:,2),XYDiff(:,1));

    %We use the slope angles to compute the curvature
    DIR4=slopeAngle(1:end-npoints);
    DIR5=slopeAngle(npoints+1:end);
    COURB=cos(DIR4).*cos(DIR5)+sin(DIR4).*sin(DIR5);
    COURB=acos(COURB);

    %Complete the first and the last (npoints) values of the curvature
    init   = repmat (COURB(1)  ,(npoints),1);
    ending = repmat (COURB(end),(npoints),1);
    COURB  = [init; COURB; ending]; 

    %Convert to degrees
    COURBdeg=rad2deg(COURB);
    COURBdeg=180-COURBdeg;

    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Construction of the Final Feature Vector
    Features = [PositionsXYZ pointingDirectionVector movementDirectionVector ...
                  curvatureVector azimuth radio elevation COURBdeg ];
    

end