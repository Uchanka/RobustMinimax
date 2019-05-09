% Plot the 2D diagram for demonstration
function TestPlot2D
    mX = [0.1 -1.8]';
    mY = [-0.1 1.8]';
    covX = [0.3 0.2; 0.2 0.3];
    covY = [0.4 0.0; 0.0 0.4];
    
    % Train with known distribution
    [a, b] = CoreCVX(mX, mY, covX, covY);
    
    % Testing
    sampleSize = 50000;
    xSeq = mvnrnd(mX', covX, sampleSize);
    ySeq = mvnrnd(mY', covY, sampleSize);
    %ySeq = mvtrnd(covY, 2, sampleSize);
    misClassifiedX = 0;
    misClassifiedY = 0;
    for i = 1 : sampleSize
        bX = a' * xSeq(i, :)';
        bY = a' * ySeq(i, :)';
        if bX < b
            misClassifiedX = misClassifiedX + 1;
        end
        if bY > b
            misClassifiedY = misClassifiedY + 1;
        end
    end
    misClassifiedRateX = misClassifiedX / (sampleSize);
    misClassifiedRateY = misClassifiedY / (sampleSize);
    worstMisClassifiedRate = max(misClassifiedRateX, misClassifiedRateY);
    disp('Actual misclassificatoin probablity:');
    disp(worstMisClassifiedRate);
    
    sz = 2.0;
    scatter(xSeq(:,1), xSeq(:,2), sz, 'MarkerEdgeColor',[.5 0 .5], 'MarkerFaceColor',[1 0 1],'LineWidth',1.5);
    hold on
    scatter(ySeq(:,1), ySeq(:,2), sz, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 1 1],'LineWidth',1.5);
    
    [maxEleX, ~] = max(abs(xSeq(:, 1)));
    [maxEleY, ~] = max(abs(ySeq(:, 1)));
    maxEle = max(maxEleX, maxEleY);
    xPlot = - maxEle : maxEle;
    plot(xPlot, -(a(1)/a(2)) * xPlot + (b / a(2)));
    daspect([1 1 1]);
end