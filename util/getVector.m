function [y] = getVector(data,variable,a)
if nargin == 2
    a = 1;
end
vector = -1;
if strcmp(variable, 'dom')
    vector = 1;
else
    tam = size(data.Variables);
    for i=1:tam(1,1)
        if strcmp(data.Variables{i,1}, variable)
            vector = i;
            break
        end
    end
end
if vector == -1
    y = -1; %caso a variavel informada não exista
else
    aux = data.Values{a,1};
    y = aux(:,vector);
end
end

