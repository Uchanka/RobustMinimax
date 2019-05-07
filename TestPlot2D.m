% Plot the 2D diagram for demonstration
function TestPlot2D
    mX = [-1 1];
    mY = [2, 2];
    covX = [1.1 1.2; 1.2 1.4];
    covY = [1.2 1.1; 1.1 1.4];
    xSeq = mvnrnd(mX, covX, 40);
    ySeq = mvnrnd(mY, covY, 40);
    
    estimatedX = mean(xSeq);
    estimatedY = mean(ySeq);
    estimatedCovX = cov(xSeq);
    estimatedCovY = cov(ySeq);
    
    [a, b] = Core(estimatedX', estimatedY', estimatedCovX, estimatedCovY);
    
    sz = 2.0;
    scatter(xSeq(:,1), xSeq(:,2), sz, 'MarkerEdgeColor',[.5 0 .5], 'MarkerFaceColor',[.7 0 .7],'LineWidth',1.5);
    hold on
    scatter(ySeq(:,1), ySeq(:,2), sz, 'MarkerEdgeColor',[0 .5 .5], 'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5);
    
    x = -2 : 3;
    plot(x, -(a(1)/a(2)) * x + b);
end