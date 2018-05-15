%{

//-----------------------------------------------------------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;
int nReg = 0;

void yyerror(const char* s);
%}

%union {
	int ival;
	float fval;
}

//-----------------------------------------------------------------------------------------------------------------------------

%token<ival> T_INT
%token<fval> T_FLOAT
%token T_NEWLINE T_QUIT
%left T_SOMA T_SUBT
%left T_MULT T_DIVIDE
%token T_ESQUE T_DIREITA

%type<ival> expr

%start calc

%%

calc: 
	   | calc line
;

//-----------------------------------------------------------------------------------------------------------------------------

line: T_NEWLINE	       
    | expr T_NEWLINE    { printf("STORE(R%d,R%d)\n", nReg++, nReg+1); 
			  printf("\n\nValor armazenado no registrador R%d: %d\n\n", nReg, $1);
			  nReg = 0;}
    
    | T_QUIT T_NEWLINE 	{ printf("Tchau, Beijos <3!\n"); exit(0); }
;

//-----------------------------------------------------------------------------------------------------------------------------

expr:     T_INT			       {printf("LOAD(%d, R%d) \n", $1, nReg++); 
					$$ = $1;}

 	  | expr T_SOMA expr	       {printf("ADD(R%d, R%d, R%d)\n", nReg-2, nReg-1, nReg);
					$$ = $1 + $3;}

	  | expr T_SUBT expr	       {printf("SUB(R%d, R%d, R%d)\n", nReg-2, nReg-1, nReg); 
					$$ = $1 - $3; }

	  | expr T_MULT expr	       {printf("MULT(R%d, R%d, R%d) \n", nReg-2, nReg-1, nReg); 
					$$ = $1 * $3; }

	  | expr T_DIVIDE expr         {printf("DIV(R%d, R%d, R%d) \n", nReg-2, nReg-1, nReg);
					$$ = $1 / $3; }
 
	  | T_ESQUE expr T_DIREITA	{ $$ = $2; }
;

//-----------------------------------------------------------------------------------------------------------------------------

%%
int main() {
	yyin = stdin;

	do { 
		yyparse();
	} while(!feof(yyin));

	return 0;
}

void yyerror(const char* s) {
	printf("Erooooou: %s\nTente novamente!\n", s);
}
