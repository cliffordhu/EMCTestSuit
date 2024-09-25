function freq=linfreq(startfreq,stopfreq,points)

df=(stopfreq-startfreq)/(points-1);
freq=startfreq+[0:points-1]*df;
