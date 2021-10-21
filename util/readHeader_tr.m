function [inf] = readHeader_tr(str)
tam = size(str);
estado = 0;
ind = 1;
indc = 1;
num = 0;
flag = 0;
for i=1:tam(1,2)
    k = str(1,i);
    if estado == 0
        if k == '*'
            inf.Version = aux;
            estado = 1;
            aux = [];
        else
            aux(1,ind) = k;
            ind = ind + 1;
        end
    elseif estado == 1
        if isNum(k)
            ind = 1;
            aux(1,ind) = k;
            ind = ind + 1;
            estado = 2;
        end
    elseif estado == 2
        if k == 'C'
            data = sprintf("%s", aux);
            inf.Date = datetime(data, 'InputFormat','MM/dd/uuuu HH:mm:ss');
            inf.Date.Format = 'dd/MM/uuuu HH:mm:ss';
            estado = 3;
            aux = [];
            ind = 1;
        else
            aux(1,ind) = k;
            ind = ind + 1;
        end
    elseif estado == 3
        if k == '.'
            estado = 4;
            aux = [];
        end
    elseif estado == 4
        if isNum(k)
            ind = 1;
            aux(1,ind) = k;
            ind = ind + 1;
            estado = 5;
        end
    elseif estado == 5
        if isNum(k)
            aux(1,ind) = k;
            ind = ind + 1;
        else
            inf.Sweep = str2num(char(aux));
            estado = 6;
            aux = [];
        end
    elseif estado == 6
        if isNum(k)
            num = num + 1;
        elseif isLet(k)
            ind = 1;
            aux(1,ind) = k;
            ind = ind + 1;
            if inf.Sweep > 0
                num = num +1;
            end
            estado = 7;
        end
    elseif estado == 7
        if (not(k == ' '))&&(num > 0)
            aux(1,ind) = k;
            ind = ind + 1;
            flag = 1;
        elseif (flag == 1)&&(num > 0)
            num = num - 1;
            inf.Variables{indc,1} = char(aux);
            if contains(inf.Variables{indc,1},"v(")
                inf.Variables{indc,1} = horzcat(inf.Variables{indc,1}...
                    , ')');
            elseif contains(inf.Variables{indc,1},"i(")
                inf.Variables{indc,1} = horzcat(inf.Variables{indc,1}...
                    , ')');
            end
            aux = [];
            indc = indc + 1;
            ind = 1;
            flag = 0;
        end
    end
end
end

