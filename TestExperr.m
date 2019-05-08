% Plot the 2D diagram for demonstration
function TestExperr
    % Estimation error
    % Error of expectation
    xyMu = 2.7;
    % Error of covariance
    xRho = 0.0;
    yRho = 0.0;
    
    mX = [-0.2 0.01]';
    mY = [0.2 -0.01]';
    covX = [0.2 -0.198; -0.198 0.2];
    covY = [0.2 0.197; 0.197 0.2];
    % Add variation
    eigCovXInv = eig(inv(covX));
    eigCovYInv = eig(inv(covY));
    lMaxX = max(abs(eigCovXInv));
    lMaxY = max(abs(eigCovYInv));
    deltaX = sqrt(xyMu / lMaxX);
    deltaY = sqrt(xyMu / lMaxY);
    % Mislead our method on purpose
    mXShifted = mX + deltaX * [1 0]';
    mYShifted = mY - deltaY * [1 0]';
    
    % Train with known distribution
    [a, b] = RobustCore(mXShifted, mYShifted, covX, covY, xyMu, xRho, yRho);
    
    % Testing
    sampleSize = 20000;
    xSeq = mvnrnd(mX, covX, sampleSize);
    ySeq = mvnrnd(mY, covY, sampleSize);
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
    disp('Actual misclassification probablity:');
    disp(worstMisClassifiedRate);
    
    sz = 2.0;
    scatter(xSeq(:,1), xSeq(:,2), sz, 'MarkerEdgeColor',[.5 0 .5], 'MarkerFaceColor',[.7 0 .7],'LineWidth',1.5);
    hold on
    scatter(ySeq(:,1), ySeq(:,2), sz, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    
    [maxEleX, ~] = max(abs(xSeq(:, 1)));
    [maxEleY, ~] = max(abs(ySeq(:, 1)));
    maxEle = ceil(max(maxEleX, maxEleY));
    xPlot = - maxEle : maxEle;
    plot(xPlot, -(a(1)/a(2)) * xPlot + (b / a(2)));
end