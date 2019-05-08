% A simple kernelization: (x1, x2) -> (x1x1, x1x2, x2x1, x2x2)
function TestKernel
    mX = [-2 -2]';
    mY = [2 2]';
    covX = [1.4 0.4; 0.4 1.2];
    covY = [1.2 1.15; 1.15 1.4];
    % Testing
    sampleSize = 50000;
    xSeq = mvnrnd(mX', covX, sampleSize);
    ySeq = mvnrnd(mY', covY, sampleSize);
    % High dimensional
    xHDSeq = zeros(4, sampleSize);
    yHDSeq = zeros(4, sampleSize);
    for i = 1 : sampleSize
        rX = xSeq(i, :)';
        rY = ySeq(i, :)';
    end
    
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
    scatter(xSeq(:,1), xSeq(:,2), sz, 'MarkerEdgeColor',[.5 0 .5], 'MarkerFaceColor',[.7 0 .7],'LineWidth',1.5);
    hold on
    scatter(ySeq(:,1), ySeq(:,2), sz, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    
    [maxEleX, ~] = max(abs(xSeq(:, 1)));
    [maxEleY, ~] = max(abs(ySeq(:, 1)));
    maxEle = max(maxEleX, maxEleY);
    xPlot = - maxEle : maxEle;
    plot(xPlot, -(a(1)/a(2)) * xPlot + (b / a(2)));
end