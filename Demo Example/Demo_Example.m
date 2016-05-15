%%%%%%%%%% Preview a Preprocessing Example %%%%%%%%%

A = read_database_file('/DB Samples/PointingToolFile.lmr');
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

%%%%%%%%%%%% Define Train & Test Set %%%%%%%%%%%%%%%

TrainingSamples = [1 2,3,4,6,7,10,13,14,15,16,17,18,19,20,22,23,24];
TestSamples     = setdiff(1:25,TrainingSamples);

%%%%%%%%%%%% Load all Training Files %%%%%%%%%%%%%%%

allTrainDigits = {};
for k=1:10

    daux = {};
    idx = 1;
    for m=TrainingSamples
        path = strcat('E:\Dropbox\Leap Motion Tutorial\Database\Samples',num2str(k-1),'\file',num2str(k-1),'n',num2str(m),'.lmr');
        daux{idx}  = read_preprocess_and_feature_extract_digit(path);
        idx = idx +1;
    end

    allTrainDigits{k} = daux;
    
end

%%%%%%%%%%%%%%% Train all the Models %%%%%%%%%%%%%%%%%

train_gmm_model(allTrainDigits);

train_hmm_model(allTrainDigits);

train_dtw_model(allTrainDigits);



%%%%%%%%%%%%%%% Load all Test Files %%%%%%%%%%%%%%%%%%

allTestDigits = {};
for k=1:10

    daux = {};
    idx = 1;
    for m=TestSamples
        path = strcat('E:\Dropbox\Leap Motion Tutorial\Database\Samples',num2str(k-1),'\file',num2str(k-1),'n',num2str(m),'.lmr');
        daux{idx}  = read_preprocess_and_feature_extract_digit(path);
        idx = idx +1;
    end
    
    allTestDigits{k} = daux;
    
end

%%%%%%%%%%%%%%% Test all the Models %%%%%%%%%%%%%%%%%

[confusion_m_gmm,gmmProbs] = test_gmm_model(allTestDigits);

[confusion_m_hmm,hmmProbs] = test_hmm_model(allTestDigits);

[confusion_m_dtw,dtwProbs] = test_dtw_model(allTestDigits);

%%%%%%%%%%%%%%%% Apply Fusion Rule %%%%%%%%%%%%%%%%%%

[confusion_m_final,finalProbs] = apply_fusion_rule(gmmProbs,hmmProbs,dtwProbs);

%%%%%%%%%%%%%%%%%%% Some Plots %%%%%%%%%%%%%%%%%%%%%%

figure(),
subplot(2,3,1), imagesc(confusion_m_gmm),   title('Confusion Matrix GMM'), colorbar();
subplot(2,3,2), imagesc(confusion_m_hmm),   title('Confusion Matrix HMM'), colorbar();
subplot(2,3,3), imagesc(confusion_m_dtw),   title('Confusion Matrix DTW'), colorbar();
subplot(2,3,5), imagesc(confusion_m_final), title('Final Confusion Matrix'), colorbar();


