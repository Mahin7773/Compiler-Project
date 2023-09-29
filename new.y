%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<math.h>
	int table[1000];
	int switchV;
	int switchF=1;
%}

/* declarations */

%token IDATA VARIABLE IF ELIF ELSE MAIN INT FLOAT SS SE SWITCH CASE DEFAULT BREAK 
%token  PRIME FOR OUT CMNT WHILE INC DEC CIN
%token ADD SUB MUL DIV POW MOD SQRT GCD LCM FIB EQUALS SIN COS TAN LOG LN
%nonassoc PRECIF
%nonassoc ELSE
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT
%left ILT IGT
%left ADD SUB
%left MUL DIV 

/* rules */
%%

program: 
	MAIN '(' ')' SS arg SE
	;

arg:
   | arg statement
   ;

statement: 
	';'	

    |CMNT  									{ printf("Comment Section\n");}

	|BREAK       							{ break;}

	|declaration ';'						{ printf("Variable Declared\n"); }

	|expression ';' 						{ printf("The value of expression= %d\n", $1); $$=$1;}

	|VARIABLE EQUALS expression ';' 		{ table[$1] = $3; printf("Value of the variable= %d\t\n",$3); $$=$3;} 
	
	|FOR '(' expression EQUALS expression ';' expression ILT expression ')' SS statement SE 
											{if($5>$9)
											{
												printf("Invalid condition: Infinite loop\n");
											}
									   		else
									   		{
	                                       		int i; for(i=$5 ; i<=$9 ; i++) {printf("value of the FOR: %d expression value: %d\n", i,$12);} 
											}
										}

    |FOR '(' expression EQUALS expression ';' expression IGT expression ')' SS statement SE {
										if($9>$5)
									   	{  
											printf("Invalid condition: Infinite loop\n");
									   	}
									   	else
									   	{
											int i; for(i=$5 ; i>=$9 ; i--) {printf("value of the FOR: %d expression value: %d\n", i,$12);} 
										}
									}
    
	|WHILE '(' expression IGT expression ')' SS statement SE {
	                                   if($5>$3)
									   {  
										printf("Invalid condition: Infinite loop\n");
									   }
									   else
									   {
	                                	int i; for(i=$3 ; i>=$5 ; i--) {printf("value of the while : %d\n", i);} 
										}
									}

	|WHILE '(' expression ILT expression ')' SS statement SE {
	                                   if($3>$5)
									   {  printf("Invalid condition: Infinite loop\n");
									   }
									   else
									   {
	                                int i; for(i=$3 ; i<=$5 ; i++) {printf("value of the while : %d\n", i);} }
									}

	|VARIABLE INC ';' { table[$1] = table[$1] + 1;}
	
	|VARIABLE DEC ';' { table[$1] = table[$1] - 1;}
	
	|SWITCH '(' expression ')' BLOCK    {switchV=$3;}

	|IF '(' expression ')' SS expression ';' SE %prec PRECIF {
								if($3){
									printf("\nThe value of expression in hoy: %d\n",$6);
								}
								else{
									printf("\nCondition is false\n");
								}
							}
	|IF '(' expression ')' SS expression ';' SE ELSE SS expression ';' SE {
								if($3){
									printf("\nThe value of expression in hoy: %d\n",$6);
								}
								else{
									printf("value of expression in nahole: %d\n",$11);
								}
							}
	|OUT '(' expression ')' ';' {printf("Value Output %d\n",$3);}

	|PRIME '(' expression ')' ';' { int c=1; for(int i=2;i*i<=$3;i++){ if($3 % i==0){ printf("\n%d is not prime\n",$3); c=0; break;}}
	                                    if(c){ printf("\n%d is prime\n",$3);}}

    |CIN '(' VARIABLE ',' IDATA ')' ';'   {  table[$3]=$5;
                                     printf("input done. Value =%d \n",table[$3]);   
    									 }
	|SQRT '(' expression ')' ';' {   printf("Value of root=%.4lf\n",sqrt($3*1.0)); }

	|GCD '(' expression ',' expression ')' ';'  { int n1=$3,n2=$5,g;
	                                            for(int i=1;i<=n1&&i<=n2;i++)
												{
												  if(n1%i==0&&n2%i==0)
												  {
												     g=i;
												
												 }
												 }
											printf("GCD of %d and %d = %d\n",$3,$5,g);
										}
										
    |LCM '(' expression ',' expression ')' ';' { int n1=$3,n2=$5,g;
	                                            for(int i=1;i<=n1&&i<=n2;i++)
												{
												  if(n1%i==0&&n2%i==0)
												  {
												     g=i;
												
												 }
												 }
												 int x=n1/g*n2;
											printf("LCM of %d and %d = %d\n",$3,$5,x);
										}
	|FIB '(' expression ')' ';' { int n=$3; int fibo[n+6]; fibo[0]=0; fibo[1]=1; 
	                              printf("The fibonacci series is= %d %d ",fibo[0],fibo[1]);
	                               for(int i=2;i<n;i++)
								   {
								     fibo[i]=fibo[i-1]+fibo[i-2];
									 printf("%d ",fibo[i]);
								   }
								   printf("\n");
								   
								   }
	|SIN '(' expression ')'		 { printf("\nThe value of sin(%d) is: %.2lf\n ", $3, sin($3*3.1416/180)); $$ = sin($3*3.1416/180); }

	|COS '(' expression ')'		 { printf("\nThe value of cos(%d) is: %.2lf\n", $3, cos($3*3.1416/180)); $$ = cos($3*3.1416/180); }

	|TAN '(' expression ')'		 { printf("\nThe value of tan(%d) is: %.2lf\n", $3, tan($3*3.1416/180)); $$ = tan($3*3.1416/180); }

	|LOG '(' expression ')'		 { if($3)
									{printf("\nValue of log10(%d) is %lf\n",$3,(log($3*1.0)/log(10.0))); $$=(log($3*1.0)/log(10.0));} 
								else{printf("\nillegal value as argument\n");} }

	|LN '(' expression ')'		 { if($3)
									{printf("\nValue of natural log, ln(%d) is %lf\n",$3,(log($3))); $$=(log($3));} 
								else{printf("\nillegal value as argument\n");} }
	;

BLOCK:
	SS SEGMENT SE

SEGMENT: 
	CS
	|CS DF
    ;
CS: 
	CS ';' CS

	|CASE IDATA ':' expression ';' BREAK ';' { if($2==switchV){printf("Case %d executed and the expression value is=%d\n",$2,$4);switchF=0;}}
	;
DF
	:DEFAULT ':' expression ';' BREAK ';' {if(switchF){printf("Default Case executed and the expression value=%d\n",$3);}}
	;
	
declaration:
	type id   
    ;


type:
	INT   
    |FLOAT    
    ;



id:
	id ',' VARIABLE  
    |VARIABLE  
    ;

expression: 
	IDATA				{ $$ = $1; 	}

	| VARIABLE						{ $$ = table[$1]; }
	
	| expression ADD expression	{ $$ = $1 + $3; }

	| expression SUB expression	{ $$ = $1 - $3; }

	| expression MUL expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ if($3){
				     					$$ = $1 / $3;
				  					}
				  					else{
										$$ = 0;
										printf("\ndividing by zero\t");
				  					} 	
				    			}
	| expression MOD expression	{ if($3){
				     					$$ = $1 % $3;
				  					}
				  					else{
										$$ = 0;
										printf("\nMOD by zero\t");
				  					} 	
				    			}
	| expression POW expression	{ $$ = pow($1 , $3);}

	| expression ILT expression	{ $$ = $1 < $3; }	

	| expression IGT expression	{ $$ = $1 > $3; }

	| '(' expression ')'		{ $$ = $2;	}
	
	;

%%

