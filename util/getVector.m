function [y] = getVector(data,variable,a)
    if nargin == 2
        flag = 0;
    elseif nargin == 3
        flag = 1;
    end
    vector = -1;
    tam = size(data.Variables);
    for i=1:tam(1,1)
        if strcmp(data.Variables{i,1}, variable)
            vector = i;
            break
        end
    end
    if vector == -1
        y = -1; %caso a variavel informada não exista
    elseif flag == 0
        y = data.Values(:,vector);
    elseif flag == 1
        aux = data.Values{a,1};
        y = aux(:,vector);
    end
end

