classdef IMDObj <handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       data
       freq
       peak
       h
       ax1
       ax2
       avg
    end
    
    methods
        %% Create Object
        function s=IMDObj    
        end
        % search all highest N peaks above the moving average (20) spectrum
        function findpeak(s,N)
            % find the moving average of the spectrum
            s.avg=movmean(s.data,20);
            % find the variance of spectrum to the moving average
            diffp=s.data-s.avg;
            % sort the variance from largest peak to smallest
            [B,I] = sort(diffp,'descend'); 
            % find the top N peaks from the list. the peak is 2d in s.peak
            % struct
            s.peak.freq=s.freq(I(1:N));
            s.peak.amp=s.data(I(1:N));
            % plot the spectrum and these peaks 
            s.h=figure
            s.ax1=subplot(2,1,1)
            line1=plot(s.freq,s.data);
            line1.Tag='base';
            hold on
            line2=plot(s.peak.freq,s.peak.amp,'r+');
            line2.Tag='peak';
            
            hold on
            line3=plot(s.freq,s.avg);
            line3.Tag='avg1';
            s.ax2=subplot(2,1,2)
            line=plot(s.freq,s.avg);
            line.Tag='avg2';
            hold(s.ax2,'on');
            linkaxes([s.ax1 s.ax2],'x');
            
        end
        % Find the f1 and f2 IMD of order N with relax factor, the
        % muplitple of minimum spectrum resolution df. 
        function  [result1 result2]=IMD(s,N,f1,f2,f3,relax)
            % find df, the freuqency resolution 
            df=s.freq(2)-s.freq(1);
            % create the container to save the Inter modulation Frequencies
            % IMF
            IMF=[];
            % create the modulation m*f1+n*f2  m,n =[-N:N]
            for m=-N:N
                for n=-N:N
                      for k=-N:N
                            if abs(m*f1+n*f2+k*f3)<=1e9 && abs(m*f1+n*f2+k*f3)>=30e6
                              IMF=[IMF;abs(m*f1+n*f2+k*f3)];
                            end
                      end
                      
                end
            end
            
            % find the IMF match in the spectrum's peak list
            
            IMFs=sort(unique(IMF));
            [freqs, Ia]=sort(s.peak.freq);
            amps=s.peak.amp(Ia);
            n=1; I=[];
            % loop each element in the IMF
            while n<length(IMFs)
                % find the frequency match in the list of all peaks 
                % step 1. add offset 
                % setp 2: take absoutle value 
                % step 3: find the minimum of the sequence with the index 
                [tmp If]=min(abs(freqs-IMFs(n)));
                % Step 4: decide if the minimum is within the range +-df 
                % relax is the mutple of the minimum freq resolution 
                % if the condition is met, save the element index in the
                % IMF and location index in the spectrum frequenc list. 
               % adjust the relax factor range according to the freuqency range. 
               if IMFs(n)<500e6
                   tmp1=relax;
               elseif IMFs(n)<700e6
                    tmp1=relax*2;
               else 
                    tmp1=relax*4;
               end
               
               if tmp<=tmp1*df
                  I=[I;n If];
                end
               
                n=n+1;
            end
            
            % save the matched frequencies and amplitudes into result variable
            result1=[freqs(I(:,2));amps(I(:,2));]';
            result2=[IMFs zeros(length(IMFs),1) ones(length(IMFs),1)];
            result2(I(:,1),2)=1;
            
            % Caulate the ratio of succesfuul match= matched IMF /total IMF
            weight=[ length(result1) length(IMF) length(result1)/length(IMF)]
        end
        function result=removeIMD(s,result1)
         freqIMD=result1(:,1);
         result=s.data;
         avg=s.avg;
         relax=3;
         for i=1:length(freqIMD)
           I=find(s.freq==freqIMD(i));
           try
            avg([I-relax: I+relax])=result([I-relax: I+relax]);
            result([I-relax: I+relax])=s.avg([I-relax: I+relax]);
           
           catch
             continue    
           end
           
         end
         
         tmp={s.ax1.Children.Tag}
         Index = find(contains(tmp,'base'));
         s.ax1.Children(Index).YData=result;
         tmp={s.ax2.Children.Tag}
         Index = find(contains(tmp,'avg2'));
         s.ax2.Children(Index).YData=avg;
         
         
        end
        
        
        
    end
end

 