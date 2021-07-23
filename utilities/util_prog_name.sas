/****************************************************************/
/* This macro utility will be used to get your current          */
/* SAS program name and its physical location                   */
/* This utility works only in Batch Mode, not in EG or Studio   */
/***************************************************************/
%MACRO util_prog_name;
  %GLOBAL prog_long prog_sas prog prog_lcycl;
  /* This utility works only in batch (UNIX) Mode*/

  /* &PROG's are local macro vars */
  /* first, get the long name including location */
  /* then, delete location by scanning from end */
  /* last, delete .sas*/
  /* and return value */
  %IF %SYMEXIST(_clientapp) %THEN %DO;
    %IF &_clientapp = 'SAS Studio' %THEN %DO;
      %PUT Program Running within SAS Studio;
    %END;
  %END;
  %ELSE %IF %INDEX(&sysprocessname,Program) %THEN %DO;
     %LET prog_long = %sysfunc(getoption(sysin)) ;
     %LET prog_sas  = %scan(&PROG_LONG, -1, '/') ; 
     %LET prog      = %scan(&PROG_SAS, 1, '.') ; 
     %LET prog_lcycl  = %scan(&PROG_LONG, -2, '/') ;     
     %PUT Program location: &prog_long.. Program Name: &PROG.. Program Life Cycle: &prog_lcycl..;
  %END;
%MEND util_prog_name;

/*Uncomment this to quickly check above utility*/
/*%util_prog_name;*/
