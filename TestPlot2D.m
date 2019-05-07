% Plot the 2D diagram for demonstration
function TestPlot2D
    mX = [-1 1];
    mY = [2, 2];
    covX = [1.5 1.2; 1.2 2];
    covY = [2.5 1.5; 1.5 2];
    xSeq = mvnrnd(mX, covX, 40);
    ySeq = mvnrnd(mY, covY, 40);
    
    estimatedX = mean(xSeq);
    estimatedY = mean(ySeq);
    estimatedCovX = cov(xSeq);
    estimatedCovY = cov(ySeq);
    
    [a, b] = Core(estimatedX, estimatedY, estimatedCovX, estimatedCovY);
    
    plot(xSeq);
    plot(ySeq);
end