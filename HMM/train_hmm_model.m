function [] = train_hmm_model(FeatureList)

    %FeatureList is a list of all the digits features organized
    %by two index FeatureList{1}{10} access to the 10th sample
    %of the 1st class (digit 0)
        
    tdigits0 = vertcat(FeatureList{1} {:});
    tdigits1 = vertcat(FeatureList{2} {:});
    tdigits2 = vertcat(FeatureList{3} {:});
    tdigits3 = vertcat(FeatureList{4} {:});
    tdigits4 = vertcat(FeatureList{5} {:});
    tdigits5 = vertcat(FeatureList{6} {:});
    tdigits6 = vertcat(FeatureList{7} {:});
    tdigits7 = vertcat(FeatureList{8} {:});
    tdigits8 = vertcat(FeatureList{9} {:});
    tdigits9 = vertcat(FeatureList{10}{:});
    
    trainingSet = [tdigits0;tdigits1;tdigits2;tdigits3;tdigits4;...
                   tdigits5;tdigits6;tdigits7;tdigits8;tdigits9];
    
    [~,ncol]   = size(trainingSet);
    Ztraining  = zscore(trainingSet);
    meanTrain  = mean(trainingSet);
    stdTrain   = std (trainingSet);
     

    %Loop for each Digit 0-9
    for k=0:9
        %Declare the zdigitX variable
        eval(strcat('zdigits',num2str(k),' = {};'));
        idx = 1;
        for m=1:length(FeatureList{k+1})
            [mrows,~] = size(FeatureList{k+1}{m}); 
            eval(strcat('zdigits',num2str(k),'{idx} = Ztraining(1:mrows,:)'';'));
            Ztraining(1:mrows,:) = []; 
            idx = idx+1;
        end
    end
   
        
    ZNormFeatureList  = {zdigits0,zdigits1,zdigits2,zdigits3,zdigits4,zdigits5,zdigits6,zdigits7,zdigits8,zdigits9};

    %HMM Parameters
    %TODO: Modify the architecture of the HMM Network
    %This means changing the number of states, gaussians
    %and also testing different architectures modifying the prior0
    %and transmat0 matrices.
    %transmat0 = mk_stochastic sets to be a fully connected HMM!
    %See doc of HMM All for more detailled information on architectures
    numParameters = ncol;
    numOfGaussians = 2;
    numOfStates = 3;
    cov_type = 'full';
    prior0 = normalise(rand(numOfStates,1)); %%% prior probabilities
    transmat0 = mk_stochastic(rand(numOfStates,numOfStates)); %%% transmission probabilities

    HMMModels = {};
    for j=1:10
       
        %GM Model Initialization
        [mu0, Sigma0] = mixgauss_init(numOfStates*numOfGaussians, ZNormFeatureList{j}{1}, cov_type);
        mu0 = reshape(mu0, [numParameters numOfStates numOfGaussians]);
        Sigma0 = reshape(Sigma0, [numParameters numParameters numOfStates numOfGaussians]);
        mixmat0 = mk_stochastic(rand(numOfStates,numOfGaussians));
        
        %Training HMM
        [LL, prior1, transmat1, mu1, sigma1,mixmat1] = mhmm_em(ZNormFeatureList{j}, ...
                                                               prior0, transmat0, mu0, Sigma0, mixmat0,...
                                                               'max_iter', 10,'cov_type',cov_type);
        %Storing a Model in the final structure
        HMMModels{j} = struct('prior',prior1,'transmat',transmat1,'mu',mu1,'sigma',sigma1,'mixmat',mixmat1);
    end

    figure(),
    for k = 1:10
        subplot(2,5,k)
        h = gca;
        hold on
        X = []; Y = []; C = [];
        for m=1:length(FeatureList{k})
            dataSample = ZNormFeatureList{k}{m};
            B = mixgauss_prob(dataSample, HMMModels{k}.mu, HMMModels{k}.sigma, HMMModels{k}.mixmat);
            [path] = viterbi_path(HMMModels{k}.prior, HMMModels{k}.transmat, B);
            X = [X dataSample(1,:)];
            Y = [Y dataSample(2,:)];
            C = [C path];
        end    
        gscatter(X,Y,C)
        title(sprintf('Digit - %i ;HMM - %i States',k-1,numOfStates));
        xlabel('X Position');
        ylabel('Y Position');
    end
      
    save('HMM_Model','HMMModels','meanTrain','stdTrain');


end