function lambda = init_lambda( X, I_area, area, percentage )

max_idx = I_area(1);
max_area = area(max_idx);
split_area = max_area;
test_idx = max_idx;
%idx = 2;

while (split_area > max_area * percentage)
    test_idx = test_idx + 1;
    if (test_idx <= 255)
        % test_idx = I_area(idx);
        split_area = area(test_idx);
        % idx = idx + 1;
    else
        % in this case reach the boundary, skip explore this direction
        % that means set lambda2 to 0 and we achieve this by take the
        % disatnce from max_idx to itself.
        test_idx = max_idx;
        break;
    end
end

lambda1 = X(max_idx, test_idx);

split_area = max_area;
test_idx = max_idx;
while (split_area > max_area * percentage)
    test_idx = test_idx - 1;
    if (test_idx >= 1)
        split_area = area(test_idx);
    else
        % in this case reach the boundary, skip explore this direction
        % that means set lambda2 to 0 and we achieve this by take the
        % disatnce from max_idx to itself.
        test_idx = max_idx;
        break;
    end
end

lambda2 = X(max_idx, test_idx);

if (lambda1 == 0)
    lambda = lambda2;
elseif (lambda2 == 0)
    lambda = lambda1;
else
    lambda = (lambda1 + lambda2)/2;
end






