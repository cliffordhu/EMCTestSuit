function freq=logfreq(startfreq,stopfreq,points)

x1=log10(startfreq);
x2=log10(stopfreq);

dx=(x2-x1)/(points-1);

freq=10.^(x1+[0:points-1]*dx);