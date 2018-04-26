function errorRatio = logisticRegression()
    % Set random seed
    rng('default');
    % Store data in matrix
    creditCardData = csvread('creditcard.csv');
    % Shuffle the data
    creditCardData = creditCardData(randsample(1:length(creditCardData),length(creditCardData)),:);
    [rows, ~] = size(creditCardData);
    % Split data into training and evaluation
    % 2/3 for training data
    trainingData = creditCardData(1:2*(floor(rows/3)), :);
    % 1/3
    testData = creditCardData(2*(floor(rows/3)): end, :);
    % Get the class label from the training data
    trainingClass = trainingData(:, 31);
    % Remove the class label from the training data
    trainingData = trainingData(:,1:30);
    % Get categori
    trainingSpecies = categorical(trainingClass);
    % Train data
    % B contains the Y intercep and the W vectro.
    [B, dev, stats] = mnrfit(trainingData, trainingSpecies);
    
    yIntercept = B(1,1);
    W = B(2:end,:);
    
    % Get the class lable and remove it from the test data
    testClass = testData(:, 31);
    testData = testData(:, 1:30);
    
    % Use the function from the logistic regression and predict the class
    % for the test set.
    testPredict = (testData*W) + yIntercept;
    
    error = [];
    for i = [testPredict';testClass']
        if sign(i(1)) == -1
            error = [error; 0 == i(2)];
        else
            error = [error; 1 == i(2)];
        end
    end
    disp("Error: " + sum(error(:) == 0))
    disp("Rights: " + sum(error(:) == 1))
    errorRatio = (sum(error(:) == 1) / (rows/3)) * 100;
    
end