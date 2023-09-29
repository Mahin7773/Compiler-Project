%{
	#include<stdio.h>
	#include<string.h>
	#include "new.tab.h"
	#include<stdlib.h>
	#include<math.h>
	yyerror(char *s);
	
%}

variable			[a-zA-Z]
digit				[0-9]+
comment				[ ]*[!][!][^\n]*
header				[ ]*[#][i][n][s][e][r][t][ ]+[a-zA-Z]+[.h]*

%%

[ ]*	    			
[\n]*					
[\t]*
{header}   			{ printf("Header file section\n");}
{digit}				{ yylval = atoi(yytext); return IDATA; }
{variable}	    	{ yylval = *yytext - 'a'; return VARIABLE; }
{comment}			{ return CMNT; }
"NUMBER" 		 	return INT;
"FNUMBER"		 	return FLOAT;
"ADD"        		return ADD;
"SUB"    			return SUB;
"DIV"    			return DIV;
"MUL"   			return MUL;
"^"    				return POW;
"MOD"   			return MOD;
"SHIFT"   	 		return SWITCH;
"OUT"		 	 	return OUT; 
"VALUE"	     		return CASE; 
"GCD"           	return GCD;
"LCM"           	return LCM;
"FIB"             	return FIB;
"SIN"				return SIN;
"COS"				return COS;
"TAN"				return TAN;
"LOG"				return LOG;
"LN"				return LN;
"HOY"		 	 	return IF;
"NAHOY"		 		return ELIF;
"NAHOLE"  	 		return ELSE;
"END"  		 		return BREAK;
"cin"          		return CIN;
"ROOT"         		return SQRT;
"DEFAULT"     		return DEFAULT; 
"<" 		 		return SS;  
">"  		 		return SE;	
"JODI"		 		return FOR;
"JOKHON"	     	return WHILE;
"PRIME"        		return PRIME;
"INC"          		return INC;
"DEC"          		return DEC;
"ILT"				return ILT;
"IGT"				return IGT;
"EQUALS"			return EQUALS;
[,():;]     		{yylval = yytext[0];	return *yytext;	}
"master"	    	return MAIN; 					

%%

int yywrap(){
	return 1;
}

int main(){

	freopen("input.txt","r",stdin);
	freopen("output.txt","w",stdout);
	yyparse();
	return 0;
}

yyerror(char *s){
	printf( "%s\n", s);
}
