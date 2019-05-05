%Determine the orthogonal matrix F given expectation difference.
%@F: The generated matrix
%@xBarMyBar: \Bar{x} - \Bar{y}
function F = GenerateOrthogonal(xBarMyBar)
    [n, ~] = size(xBarMyBar);
    fCol = zeros(1, n - 1);
    [maxElement, maxIndex] = max(xBarMyBar);
    
    % The col for xBarMyBar
    for i = 1 : maxIndex - 1
        fCol(1, i) = -xBarMyBar(i) / maxElement;
    end
    for i = maxIndex : n - 1
        fCol(1, i) = -xBarMyBar(i + 1) / maxElement;
    end
    % The other cols are filled with unit basis
    Iden = eye(n - 1);
    F = [Iden(1 : maxIndex - 1, :); fCol; Iden(maxIndex : n - 1, :)];
end