function [y] = getVector(data,variable)
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
    else
        y = data.Values(:,vector);
    end
end

