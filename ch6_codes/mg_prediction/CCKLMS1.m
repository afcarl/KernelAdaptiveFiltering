function [expansionCoefficient,weightVector,biasTerm,learningCurve,dictionaryIndex] = ...
    CCKLMS1(trainInput,trainTarget,testInput,testTarget,typeKernel,paramKernel,...
    stepSizeFeatureVector,stepSizeWeightVector,stepSizeBias,toleranceCoherence,flagLearningCurve)
%Function CCKLMS1:   kernel least mean square with coherence criterion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input:
%trainInput:        input signal inputDimension*trainSize, inputDimension is the input dimension and trainSize is the number of
%                   training data
%trainTarget:       desired signal for training trainSize*1
%testInput:         testing input, inputDimension*testSize, testSize is the number of the test data
%testTarget:        desired signal for testing testSize*1
%typeKernel:        'Gauss', 'Poly'
%paramKernel:       h (kernel size) for Gauss and p (order) for poly
%stepSizeFeatureVector:     learning rate for kernel part
%stepSizeWeightVector:      learning rate for linear part, set to zero to disable
%stepSizeBias:              learning rate for bias term, set to zero to disable
%flagLearningCurve:         control if calculating the learning curve
%toleranceCoherence:        tolerance for the coherence measure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Output:
%expansionCoefficient:      onsisting of coefficients of the kernel
%                           expansion with the stepSizeFeatureVector
%weightVector:              the linear coefficients
%biasTerm:                  the bias term
%learningCurve:             trainSize*1 used for learning curve
%dictionaryIndex:           index of bases used in the kernel expansion in
%                               the training set


% memeory initialization
trainSize = length(trainTarget);
testSize = length(testTarget);

if flagLearningCurve
    learningCurve = zeros(trainSize,1);
    learningCurve(1) = mean(testTarget.^2); 
else
    learningCurve =[];
end

% n=1 init
predictionError = trainTarget(1);
expansionCoefficient = stepSizeFeatureVector*predictionError;
weightVector = stepSizeWeightVector*predictionError*trainInput(:,1);
biasTerm = stepSizeBias*predictionError;

% dictionary
dictionaryIndex = 1;
dictSize = 1;

% start
for n=2:trainSize
    % training
       
    % compute the coherence measure of the input
    coherence = max(ker_eval(trainInput(:,n),trainInput(:,dictionaryIndex),typeKernel,paramKernel));
    if (coherence > toleranceCoherence)
        if flagLearningCurve, learningCurve(n) = learningCurve(n-1); end
        continue;
    end
    networkOutput = expansionCoefficient*ker_eval(trainInput(:,n),trainInput(:,dictionaryIndex),typeKernel,paramKernel) + weightVector'*trainInput(:,n) + biasTerm;
    predictionError = trainTarget(n) - networkOutput;
    
    % updating
    dictSize = dictSize + 1;
    dictionaryIndex(dictSize) = n;
    expansionCoefficient(dictSize) = stepSizeFeatureVector*predictionError;
    
    weightVector = weightVector + stepSizeWeightVector*predictionError*trainInput(:,n);
    biasTerm = biasTerm + stepSizeBias*predictionError;
    
    if flagLearningCurve == 1
        % testing
        y_te = zeros(testSize,1);
        for jj = 1:testSize
            %ii = 1:dictSize;
            y_te(jj) = expansionCoefficient*ker_eval(testInput(:,jj),trainInput(:,dictionaryIndex),typeKernel,paramKernel) + weightVector'*testInput(:,jj) + biasTerm;
        end
        err = testTarget - y_te;
        learningCurve(n) = mean(err.^2);
    end
end

return

