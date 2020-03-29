function [ y ] = atraso( x, delay )

    if delay == 0
        y = x;
    else
        tam = length(x);
        y = zeros(1,delay);
        y = [y x(1:(tam-delay))];
    end
end
