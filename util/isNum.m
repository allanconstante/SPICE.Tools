function [y] = isNum(x)
c = '0123456789';
y = 0;
for i=1:10
    if x == c(1,i)
        y = 1;
        break
    end
end

