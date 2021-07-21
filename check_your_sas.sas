/****************************************************************/
/* This macro utility will be used to check your current        */
/* SAS session and its platform                                 */
/***************************************************************/
%MACRO check_your_sas;
   %IF %symexist(_clientapp) %THEN %DO;
    %IF &_clientapp = 'SAS Studio' %THEN %DO;
      %PUT Running SAS Studio;
   %END;
   %ELSE %IF &_clientapp= 'SAS Enterprise Guide' %THEN %DO;
    %PUT Running SAS Enterprise Guide; 
   %END;
  %END; 
  %ELSE %IF %index(&sysprocessname,DMS) %THEN %DO;
    %PUT Running in Display Manager;
  %END;
  %ELSE %IF %index(&sysprocessname,Program) %THEN %DO;
     %LET prog=%qscan(%superq(sysprocessname),2,%str( ));
     %PUT Running in batch and the program running is &prog;
  %END;
%MEND check_your_sas;
