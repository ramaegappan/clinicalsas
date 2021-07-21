/****************************************************************/
/* This macro utility will be used to check log file for        */
/* non acceptable log notes within the log                      */
/***************************************************************/
%MACRO util_logcheck(log=,level=16);
OPTIONS MPRINT;

%PUT ;
%PUT *** SCANNING LOG=&log (level=&level) ***;
%PUT ;
%PUT *** %sysfunc(date(),worddate.)***;
%PUT;
%LET N_=0;
%IF &level= %THEN %LET level=16;

%IF %SYSFUNC(fileexist(&log)) GT 0 %THEN %DO;
	%*----------------------------------
	Add words to parse for, based on level
	------------------------------------;
	%LET i_=0;
	%LET string_=;
	%LET errstr= _\bError\b uninitialized \bwarning\b duplicate missing_values not_found invalid_argument lost_card has_not_been_compiled fatal invalid converted  More_than_one overwritten truncated repeats_of_by note;
	%DO %UNTIL (%eval(&i_=&level));
		%LET i_= %eval(&i_+1);
		%IF %SCAN(&errstr,&i_) NE %THEN %LET string_=&string_.|%SCAN(&errstr,&i_);
	%END;

	%LET string_=%SYSFUNC(TRANSLATE(&string_,' ','_'));

	%LET string_=%SUBSTR(&string_,2);
	%PUT &string_;

	%*---------------------------------
	use PRXPARSE to find log problems
	-----------------------------------;

	DATA _null_;
		INFILE "&log" LRECL=10000 END=EOF;
		INPUT;
		IF _n_= 1 THEN DO;
	   		RETAIN patternID n_ 0;
	         /* The i option specifies a case insensitive search. */
	      	pattern = "/&string_/i";
	      	PUT;
	      	PUT 'Search pattern = ' ;
	      	PUT pattern;
	      	PUT;
	      	patternID = PRXPARSE(pattern);
    	END;
 		CALL PRXSUBSTR(patternID, _INFILE_, position, length);
		if position ^= 0 then   do;
	  		match = SUBSTR(_INFILE_, position, length);
	  		infile=TRIM(LEFT(_INFILE_));
	 		PUT  "line:" _n_  "--->  " infile: $QUOTE.;
   	  		n_=n_+1;
  		END; 
    	CALL SYMPUT('N_',TRIM(LEFT(PUT(n_,BEST.))));
		IF EOF THEN DO;
       		CALL PRXFREE(patternid);
       		PUT;
       		PUT;
		  END;
	  RUN;

  %END;

  %PUT;
  %PUT Completed SCAN of &log: there were &N_ occurrences;
  %PUT;
  %*USAGE: scanlog(log=logfilename.log,level=6);
%NMEND;
%util_logcheck(log=<YOUR file path>/<log file name>.log,level=6);
