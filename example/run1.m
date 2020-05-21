
clear all
clc

data = trData('seu.tr0');

t = data.vectors{1}.t;
bit = data.vectors{1}.xsc_bit;
nbit = data.vectors{1}.xsc_nbit;
i = data.vectors{1}.iseu;

subplot(3,1,1);
plot(t, bit)

subplot(3,1,2);
plot(t, i)

subplot(3,1,3);
plot(t, nbit)