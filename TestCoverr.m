% Plot the 2D diagram for demonstration
function TestCoverr
    % Estimation error
    % Error of expectation
    xyMu = 0.0;
    % Error of covariance
    xRho = 1.0;
    yRho = 1.0;
    
    mX = [-0.1 -2.5]';
    mY = [0.1 2.5]';
    covX = [1.0 0.0; 0.0 1.0];
    covY = [1.0 0.0; 0.0 1.0];
    % Add variation to matrix
    %randMat = rand(2, 2);
    %randOneFrob = sqrtm(randMat * randMat) \ randMat;
    randOneFrob = [0.5 0.5; 0.5 0.5];
    % Mislead our classifier on purpose
    covXShifted = covX - xRho * randOneFrob;
    covYShifted = covY + yRho * randOneFrob;
    
    % Train with known distribution
    [aRob, bRob] = RobustCore(mX, mY, covXShifted, covYShifted, xyMu, xRho, yRho);
    [a, b] = Core(mX, mY, covXShifted, covYShifted);
    
    % Testing
    sampleSize = 20000;
    xSeq = mvnrnd(mX, covX, sampleSize);
    ySeq = mvnrnd(mY, covY, sampleSize);
    misClassifiedX = 0;
    misClassifiedY = 0;
    for i = 1 : sampleSize
        bX = aRob' * xSeq(i, :)';
        if bX < bRob
            misClassifiedX = misClassifiedX + 1;
        end
    end
    for i = 1 : sampleSize
        bY = aRob' * ySeq(i, :)';
        if bY > bRob
            misClassifiedY = misClassifiedY + 1;
        end
    end
    misClassifiedRateX = misClassifiedX / (sampleSize);
    misClassifiedRateY = misClassifiedY / (sampleSize);
    worstMisClassifiedRate = max(misClassifiedRateX, misClassifiedRateY);
    disp('Actual robust misclassification probablity:');
    disp(worstMisClassifiedRate);
    
    % Testing the non-robust one
    misClassifiedX = 0;
    misClassifiedY = 0;
    for i = 1 : sampleSize
        bX = a' * xSeq(i, :)';
        if bX < b
            misClassifiedX = misClassifiedX + 1;
        end
    end
    for i = 1 : sampleSize
        bY = a' * ySeq(i, :)';
        if bY > b
            misClassifiedY = misClassifiedY + 1;
        end
    end
    misClassifiedRateX = misClassifiedX / (sampleSize);
    misClassifiedRateY = misClassifiedY / (sampleSize);
    worstMisClassifiedRate = max(misClassifiedRateX, misClassifiedRateY);
    disp('Actual non-robust misclassification probablity:');
    disp(worstMisClassifiedRate);
    
    sz = 2.0;
    scatter(xSeq(:,1), xSeq(:,2), sz, 'MarkerEdgeColor',[.5 0 .5], 'MarkerFaceColor',[.7 0 .7],'LineWidth',1.5);
    hold on
    scatter(ySeq(:,1), ySeq(:,2), sz, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    
    [maxEleX, ~] = max(abs(xSeq(:, 1)));
    [maxEleY, ~] = max(abs(ySeq(:, 1)));
    maxEle = ceil(max(maxEleX, maxEleY));
    xPlot = - maxEle : maxEle;
    plot(xPlot, -(aRob(1)/aRob(2)) * xPlot + (bRob / aRob(2)), 'b');
    plot(xPlot, -(a(1)/a(2)) * xPlot + (b / a(2)), 'r');
    daspect([1 1 1]);
end