% A simple kernelization: (x1, x2) -> (x1x1, x1x2, x2x1, x2x2)
function TestKernel
    % Testing
    sampleSize = 50000;
    xSeq = zeros(sampleSize, 2);
    ySeq = zeros(sampleSize, 2);
    
    countX = 0;
    countY = 0;
    while and(countX < sampleSize, countY < sampleSize)
        ptX = -2.0 + 4.0 * rand();
        ptY = -2.0 + 4.0 * rand();
        % y = 2 - x^2
        if (2 - ptX^2 > ptY)
            if countX < sampleSize
                countX = countX + 1;
                xSeq(countX, :) = [ptX ptY]';
            end
        else
            if countY < sampleSize
                countY = countY + 1;
                ySeq(countY, :) = [ptX ptY]';
            end
        end
    end
    
    % High dimensional
    [~, nHD] = size(getKernelized(xSeq(1, :)));
    xHDSeq = zeros(sampleSize, nHD);
    yHDSeq = zeros(sampleSize, nHD);
    for i = 1 : sampleSize
        cX = xSeq(i, :)';
        cY = ySeq(i, :)';
        xHDSeq(i, :) = getKernelized(cX)';
        yHDSeq(i, :) = getKernelized(cY)';
    end
    
    mX = mean(xSeq)';
    mY = mean(ySeq)';
    covX = cov(xSeq);
    covY = cov(ySeq);
    
    mXHD = mean(xHDSeq)';
    mYHD = mean(yHDSeq)';
    covXHD = cov(xHDSeq);
    covYHD = cov(yHDSeq);
    
    [a, b] = Core(mX, mY, covX, covY);
    % Original
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
    
    [aHD, bHD] = Core(mXHD, mYHD, covXHD, covYHD);
    % HD
    misClassifiedX = 0;
    misClassifiedY = 0;
    for i = 1 : sampleSize
        xRow = xSeq(i, :)';
        xRowHD = getKernelized(xRow);
        bXHD = aHD' * xRowHD';
        if bXHD < bHD
            misClassifiedX = misClassifiedX + 1;
        end
    end
    for i = 1 : sampleSize
        yRow = ySeq(i, :)';
        yRowHD = getKernelized(yRow);
        bYHD = aHD' * yRowHD';
        if bYHD > bHD
            misClassifiedY = misClassifiedY + 1;
        end
    end
    misClassifiedRateX = misClassifiedX / (sampleSize);
    misClassifiedRateY = misClassifiedY / (sampleSize);
    worstMisClassifiedRate = max(misClassifiedRateX, misClassifiedRateY);
    disp('Actual misclassification probablity in high dimension:');
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

function aKer = getKernelized(input)
    x1 = input(1);
    x2 = input(2);
    aKer = quadraticKer(x1, x2);
end

function aKer = quadraticKer(x1, x2)
    c = 1.0;
    sqrt2c = sqrt(2.0 * c);
    sqrt2 = sqrt(2.0);
    aKer = [x2^2 x1^2 sqrt2 * x2 * x1 sqrt2 * x1 * x2 sqrt2c * x2 sqrt2c * x1 c];
end