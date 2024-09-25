function y=vpp2dbm(x)
x1=x.*sqrt(2)/4;
y=10*log10(x1.*x1*1000/50);