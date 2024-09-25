%d=dataObj

s=IMDObj;
s.data=d.ph.maxhold;
s.freq=d.ph.freq;
s.findpeak(300);

n=1; 
f1=125044000/10;
f2=53941000;
f2=50880900;
f3=0;
% create the IMD from f1,f2,f3 and with relax factor of 2 and IMD order of N 
[result1 result2]=s.IMD(50,f1,f2,f3,2);

axes(s.ax1)
% display the spectrum hit freuquencies 
plot(result1(:,1),result1(:,2),'b*','Tag','peak2')

% display the IMF hit frequencies
plot(result2(:,1),result2(:,3)*20,'b*','Tag','hitL')
plot(result2(:,1),result2(:,2)*20,'r*','Tag','hitH')
% display the spectrum 
result=removeIMD(s,result1)

tmp={s.ax1.Children.Tag}
Index = find(matches(tmp,'peak'));
s.ax1.Children(Index).Visible='off';
Index = find(matches(tmp,'peak2'));
s.ax1.Children(Index).Visible='off';


     
 plot(I(:,1),I(:,2),'+r')



[w I]=s.rank(30,f1,f2)
 plot(I(:,1),I(:,2),'+r')

 hold on
 
f1=125044000/2;
f2=53941000
[w I]=s.rank(30,f1,f2)
 plot(I(:,1),I(:,2),'*m')

 
 hold on
 
f1=125044000;
f2=215108000
[w I]=s.rank(30,f1,f2)
 plot(I(:,1),I(:,2),'*k')
 
  hold on
 
f1=125044000;
f2=610704000
[w I]=s.rank(30,f1,f2)
 plot(I(:,1),I(:,2),'+k')
 