%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calc.tab.h"

%}

%%

[ \t]	; // ignore all whitespace
[0-9]+\.[0-9]+ 	{yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+		{yylval.ival = atoi(yytext); return T_INT;}
\n		{return T_NEWLINE;}
"+"		{return T_SOMA;}
"-"		{return T_SUBT;}
"*"		{return T_MULT;}
"/"		{return T_DIVIDE;}
"("		{return T_ESQUE;}
")"		{return T_DIREITA;}
"sair"		{return T_QUIT;}

%%
