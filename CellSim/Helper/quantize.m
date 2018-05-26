function output = quantize(input, num_bits)
% Quantize input [0, max] to output [0, 2*num_bits - 1]
min_in = min(input(:));
max_in = max(input(:));
min_out = 0;
max_out = 2^num_bits - 1;

output = round((max_out - min_out) ./ (max_in - min_in) .* (input - min_in) + min_out);
end