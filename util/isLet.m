function [y] = isLet(x)
c = 'AaBbCcDdEeFfGgHhIiJjLlMmNnOoPpQqRrSsTtUuVvXxZzKkYyWw';
y = 0;
for i=1:52
    if x == c(1,i)
        y = 1;
        break
    end
end
