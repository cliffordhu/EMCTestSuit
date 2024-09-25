a=instrfind
fclose(a)
a=gpib('agilent',7,1);
fopen(a)
fprintf(a,'*IDN?')
fscanf(a)