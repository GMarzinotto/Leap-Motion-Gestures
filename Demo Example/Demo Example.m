A = read_database_file('PointingToolFile.lmr');
B = center_digit(A);
C = principal_components_digit(B);
D = rescale_digit(C);
E = filter_digit(D);
F = resample_digit(E);
G = principal_components_digit(F);

figure(),
subplot(2,3,1), hold on; plot(B(:,2),B(:,3)); scatter(B(:,2),B(:,3)); axis equal; title('Step 1: Centred   Digit');
subplot(2,3,2), hold on; plot(C(:,2),C(:,3)); scatter(C(:,2),C(:,3)); axis equal; title('Step 2: Rescaled  Digit');
subplot(2,3,3), hold on; plot(D(:,2),D(:,3)); scatter(D(:,2),D(:,3)); axis equal; title('Step 3: PCA  Digit');
subplot(2,3,4), hold on; plot(E(:,2),E(:,3)); scatter(E(:,2),E(:,3)); axis equal; title('Step 4: Filtered  Digit');
subplot(2,3,5), hold on; plot(F(:,2),F(:,3)); scatter(F(:,2),F(:,3)); axis equal; title('Step 5: Resampled Digit');
subplot(2,3,6), hold on; plot(G(:,2),G(:,3)); scatter(G(:,2),G(:,3)); axis equal; title('Step 6: Another PCA');
