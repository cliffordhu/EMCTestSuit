classdef CI_obj
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        header='';
        configuration='';
        operator='';
        model='';
        sn='';
        stage='';
        conclusion='';
        table='';
        description='';
        date='';
        
       lfgenaddress=[];
       hfgenaddress=[];
       crossoverfreq=[];
       pwrmtraddress='';
       
       lfgain=[];
       hfgain=[];
       attenuation=[];
       
       
       lfgen=[];
       hfgen=[];
       pwrmtr=[];
       
       lfgenamp=5.6;
       hfgenamp=-27;
       
       currentfreq=[];
       freqlist=[];
       freqindex=[];
       freqstep=[];     
       run=0;
    end
    
    methods
        
        function me=CI_obj
        end
        
        
        function [lf hf pwr]=init(me)
        me.lfgen=gpib('agilent',7,me.lfgenaddress);
        me.hfgen=gpib('agilent',7,me.hfgenaddress);
        me.pwrmtr=visa('agilent',me.pwrmtraddress);
            a=instrfind;
            if ~isempty(a)
            fclose(a);
            end 
       try     
         fopen(me.lfgen);get(me.lfgen,'Status')
       catch err
         disp('Low Freuqeny Signal Generator is not ready to open')
       end
       try
           
         fopen(me.hfgen);get(me.hfgen,'Status')
       catch err
         disp('High Freuqeny Signal Generator is not ready to open')
       end
       try  
         fopen(me.pwrmtr);
         get(me.pwrmtr,'Status')
       catch err
         disp('USB Power Meter is not ready to open!')
       end
        
         lf=me.lfgen;
        hf=me.hfgen;
        pwr=me.pwrmtr;

       
        end
        
    end
    
end

