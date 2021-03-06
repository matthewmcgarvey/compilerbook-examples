
/*
Declare token types at the top of the bison file,
causing them to be automatically generated in parser.tab.h
for use by scanner.c.
*/

%token TOKEN_ID
%token TOKEN_INTEGER
%token TOKEN_INT
%token TOKEN_SEMI
%token TOKEN_PLUS
%token TOKEN_MINUS
%token TOKEN_MUL
%token TOKEN_DIV
%token TOKEN_LPAREN
%token TOKEN_RPAREN

%{

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

/*
Clunky: Manually declare the interface to the scanner generated by flex. 
*/

extern char *yytext;
extern int yylex();
extern int yyerror( char *str );

/*
Clunky: Keep the final result of the parse in a global variable,
so that it can be retrieved by main().
*/

int parser_result = 0;

%}

%%

/* Here is the grammar: program is the start symbol. */

program : expr TOKEN_SEMI
		{ parser_result = $1; return 0; }
	;

expr	: expr TOKEN_PLUS term
		{ $$ = $1 + $3; }
	| expr TOKEN_MINUS term
		{ $$ = $1 - $3; }
	| term
		{ $$ = $1; }
	;

term	: term TOKEN_MUL factor
		{ $$ = $1 * $3; }
	| term TOKEN_DIV factor
		{
			if($3==0) {
	 			printf("runtime error: divide by zero\n");
				exit(1);
			}
			$$ = $1 / $3;
		}
	| factor
		{ $$ = $1; }
	;

factor	: TOKEN_LPAREN expr TOKEN_RPAREN
		{ $$ = $2; }
	| TOKEN_MINUS factor
		{ $$ = -$2; }
	| TOKEN_INT
		{ $$ = atoi(yytext); }
	;

%%

/*
This function will be called by bison if the parse should
encounter an error.  In principle, "str" will contain something
useful.  In practice, it often does not.
*/

int yyerror( char *str )
{
	printf("parse error: %s\n",str);
	return 0;
}
