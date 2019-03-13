function  f0 = countf0( octave, layer, k)
%

% sum=0;
% for i=1:octave*layer
%     sum = k^(i-1)+sum;
% end
% f0=k^(octave*layer-1)/sum;

sum=0;
for i=1:octave*layer
    sum = k^(2*i-2)+sum;
end

f0=k^(2*octave*layer-2)/sum;
end

