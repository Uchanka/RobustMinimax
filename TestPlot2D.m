% Plot the 2D diagram for demonstration
function TestPlot2D
    mX = [-2 -2];
    mY = [2 2];
    covX = [1.4 0.4; 0.4 1.2];
    covY = [1.2 1.15; 1.15 1.4];
    
    % Train with known distribution
    [a, b] = Core(mX', mY', covX, covY);
    
    % Testing
    sampleSize = 50000;
    xSeq = mvnrnd(mX, covX, sampleSize);
    ySeq = mvnrnd(mY, covY, sampleSize);
    misClassified = 0;
    for i = 1 : sampleSize
        bX = a' * xSeq(i, :)';
        bY = a' * ySeq(i, :)';
        if bX < b
            misClassified = misClassified + 1;
        end
        if bY > b
            misClassified = misClassified + 1;
        end
    end
    misClassifiedRate = misClassified / (2.0 * sampleSize);
    disp('Actual misclassificatoin probablity:');
    disp(misClassifiedRate);
    
    sz = 2.0;
    scatter(xSeq(:,1), xSeq(:,2), sz, 'MarkerEdgeColor',[.5 0 .5], 'MarkerFaceColor',[.7 0 .7],'LineWidth',1.5);
    hold on
    scatter(ySeq(:,1), ySeq(:,2), sz, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    
    [maxEleX, ~] = max(abs(xSeq(:, 1)));
    [maxEleY, ~] = max(abs(ySeq(:, 1)));
    maxEle = max(maxEleX, maxEleY);
    xPlot = - maxEle : maxEle;
    plot(xPlot, -(a(1)/a(2)) * xPlot + b);
end