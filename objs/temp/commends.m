fprintf(me.lfgen,'*RST')
fprintf(me.lfgen,'*CLS')
fprintf(me.hfgen,'UNIT:PO W')
fprintf(me.Lfgen,'VOLT 0 dBm')

fprintf(me.lfgen,'*RST')
fprintf(me.lfgen,'*CLS')
fprintf(me.lfgen,'APPL:SIN 5 KHZ, 3.0 VPP, 0V')
fprintf(me.lfgen,'AM:DEPT 20')
fprintf(me.lfgen,'AM:STAT ON')

fprintf(me.hfgen,'*RST')
fprintf(me.hfgen,'*CLS')
fprintf(me.hfgen,'Freq 100MHZ')
fprintf(me.hfgen,'POW:AMPL 10 dBm')
fprintf(me.hfgen,'AM:DEPT 20')
fprintf(me.hfgen,'AM:STAT ON')
fprintf(me.hfgen,'AM:STAT OFF')
fprintf(me.hfgen,':OUTP:STAT ON')
fprintf(me.hfgen,':OUTP:STAT OFF')


fprintf(me.pwrmtr,'*RST')
fprintf(me.pwrmtr,'*CLS')
fprintf(me.pwrmtr,'CALC:MATH:EXPR "(SENS1)"')
fprintf(me.pwrmtr,'POW:AC:RANG -50')
fprintf(me.pwrmtr,'INIT')
fprintf(me.pwrmtr,'FETC?')
fscanf(me.pwrmtr)




