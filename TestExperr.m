% Plot the 2D diagram for demonstration
function TestExperr
    % Estimation error
    % Error of expectation
    xyMu = 3.521;
    % Error of covariance
    xRho = 0.0;
    yRho = 0.0;
    
    mX = [-0.1 -3]';
    mY = [0.1 3]';
    covX = [1.0 0.025; 0.025 1.0];
    covY = [1.0 0.05; 0.05 1.0];
    % Add variation to expectation
    eigCovXInv = eig(inv(covX));
    eigCovYInv = eig(inv(covY));
    lMaxX = max(abs(eigCovXInv));
    lMaxY = max(abs(eigCovYInv));
    deltaX = sqrt(xyMu / lMaxX);
    deltaY = sqrt(xyMu / lMaxY);
    % Mislead our classifier on purpose
    mXShifted = mX - deltaX * [0 1]';
    mYShifted = mY - deltaY * [0 1]';
    
    % Train with known distribution
    [a, b] = CoreRobust(mXShifted, mYShifted, covX, covY, xyMu, xRho, yRho);
    
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
    daspect([1 1 1]);
end