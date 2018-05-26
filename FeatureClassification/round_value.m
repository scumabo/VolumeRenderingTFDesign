function out_value = round_value( in_value, numerator, denominator )
%rounds to a desired floating point precision

% example
% numerator = 25;
% denominator = 100;
% rounds to 0.25

a = in_value * denominator;
b = numerator / 2.0;
c = a + b;
d = floor(c);

e = mod(d, numerator);

f = d - e;
out_value = f / denominator;
