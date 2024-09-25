% sample program to talk to HI-3114p
fclose(s)
s = serial('COM4');
set(s,'BaudRate',9600)
set(s,'StopBits',1)
set(s,'Parity','odd')
set(s,'DataBits',7)
set(s,'Terminator','CR')
fopen(s)
fprintf(s,'I')
fscanf(s)
fprintf(s,'M')
fscanf(s)
fprintf(s,'TF')
fscanf(s)
fprintf(s,'BP')
fscanf(s)
fprintf(s,'S')
fscanf(s)
str=fscanf(s)
for i=1:100
    pause(0.5);
    fprintf(s,'S')
    str=fscanf(s)
    d1=hex2dec(str(12:13));
    d2=hex2dec(str(14:15));
    d3=hex2dec(str(16:17));
    
    x1=hex2dec(str(3:5));
    x=x1*0.1^(4-d1)*5.6
    y1=hex2dec(str(6:8));
    y=y1*0.1^(4-d2)*5.6
    z1=hex2dec(str(9:11));
    z=z1*0.1^(4-d3)*5.6  
end

    
    
fprintf(s,'FIELDX')
fscanf(s)


fprintf(s,'PEAK')
fscanf(s)

13C4 5.687 964 
153D 7.323 1341
14AF 6.101 1199

 5.687 964 
 7.323 1341
 
 S3924f847e010101N
 6.101 1199
 392 5.566
 4f8 7.131
 47e 6.038
 033 0.139
 06B 0.335
 02D 0.095
 
 
 

