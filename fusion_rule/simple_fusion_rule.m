function [finalResult]=simple_fusion_rule(scoresGMM,scoresHMM,scoresDTW)

    finalResult = (scoresGMM + scoresHMM + scoresDTW)/3.0;
    

end