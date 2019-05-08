% A simple kernelization: (x1, x2) -> (x1x1, x1x2, x2x1, x2x2)
function TestSingle
    % Testing
    sampleSize = 50000;
    mXGen = [0 0]';
    covXGen = [1.0 0.5; 0.5 1.0];
    xSeq = mvnrnd(mXGen, covXGen, sampleSize); 
    inSeq = zeros(sampleSize, 2);
    outSeq = zeros(sampleSize, 2);
    inSeqCount = 0;
    outSeqCount = 0;
    for i = 1 : sampleSize
        pt = xSeq(i, :);
        ptX = pt(1);
        ptY = pt(2);
        if ptX + 0.4 > ptY
            inSeqCount = inSeqCount + 1;
            inSeq(inSeqCount, :) = pt;
        else
            outSeqCount = outSeqCount + 1;
            outSeq(outSeqCount, :) = pt;
        end
    end
    inSeq = inSeq(1 : inSeqCount, :);
    outSeq = outSeq(1 : outSeqCount, :);
    
    alpha = inSeqCount / sampleSize;
    
    mX = mean(inSeq)';
    covX = cov(inSeq);
    
    [a, b] = CoreSingle(mX, covX, alpha);
    %[a, b] = Core(mX, zeros(2, 1), covX, zeros(2));
    % Original
    misClassifiedIn = 0;
    for i = 1 : inSeqCount
        bIn = a' * inSeq(i, :)';
        if bIn >= b
            misClassifiedIn = misClassifiedIn + 1;
        end
    end
    
    misClassifiedRateIn = misClassifiedIn / (inSeqCount);
    disp('Actual misclassification probablity:');
    disp(misClassifiedRateIn);
    
    sz = 2.0;
    scatter(inSeq(:,1), inSeq(:,2), sz, 'MarkerEdgeColor',[.5 0 .5], 'MarkerFaceColor',[.7 0 .7],'LineWidth',1.5);
    hold on
    scatter(outSeq(:,1), outSeq(:,2), sz, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    
    [maxEleIn, ~] = max(abs(inSeq(:, 1)));
    [maxEleOut, ~] = max(abs(outSeq(:, 1)));
    maxEle = ceil(max(maxEleIn, maxEleOut));
    xPlot = - maxEle : maxEle;
    plot(xPlot, -(a(1)/a(2)) * xPlot + (b / a(2)));
    daspect([1 1 1]);
end
