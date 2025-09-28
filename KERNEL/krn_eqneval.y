%{
#include <stdio.h>
#include <math.h>
#include "krn_eqn.h"
extern	double Pow();
extern int krn_lineno;
extern float krn_eqnResult;
extern int krn_bufferPtr;
extern char *krn_buffer;

%}
%union {
	float	val; 	/* Actual value */
	Symbol	*sym; 	/* Symbol table pointer */
}
%token 		<val>	NUMBER
%token		<sym> VAR BLTIN	UNDEF
%type 		<val>	expr asgn
%right		'='
%left '+' '-' 		/* left associative,same precedence */
%left '*' '/' '%'	/* left assoc., higher precedence */
%left UNARYMINUS
%right	'^' /* exponentiation */
%%
list:	/* nothing */
	| list '\n'
	| list	asgn	'\n'
	| list expr '\n' 	{ krn_eqnResult=$2; }
	| list error '\n' 	{yyerrok;}
	;
asgn:	VAR	'=' expr { $$=$1->u.val=$3; $1->type=VAR;}
	;

expr:	NUMBER	
	| VAR		{if ($1->type == UNDEF)
				execerror("undefined variable",$1->name);
			$$ = $1->u.val; }
	| asgn
	| BLTIN	'(' expr ')' { $$ = (float)(*($1->u.ptr))((double)$3); }
	| expr '+' expr { $$=$1 + $3;}
	| expr '-' expr { $$=$1 - $3;}
	| expr '*' expr { $$=$1 * $3;}
	| expr '/' expr { 
		if($3 == 0.0 )
			execerror("Division by zero","");
		$$=$1 / $3;}
	| expr '%' expr { $$=fmod($1 , $3);}
	| '(' expr ')'	{ $$=$2; }
	| '-' expr %prec UNARYMINUS { $$ = -$2; } 
	| expr '^' expr { $$ = Pow($1,$3); }
	;
%%
	/*
	 * end of grammer
	 */


yylex()
{
	int	c;
	while((c=krn_buffer[krn_bufferPtr]) == ' ' || c == '\t')
		krn_bufferPtr++;
	krn_bufferPtr++;
	if(c==NULL)
		return(0);
	if(c == '.' || isdigit(c)) {
		/*
		 * number
		 */
		krn_bufferPtr--;
		sscanf(&krn_buffer[krn_bufferPtr],"%f",&yylval.val);
		while(isdigit(c=krn_buffer[krn_bufferPtr]) || c == '.' ||
			c=='e' || c=='E') {
			if(c=='e' || c=='E') {
				krn_bufferPtr++;
				c=krn_buffer[krn_bufferPtr];
				if(c=='+' || c=='-') krn_bufferPtr++;
			}
			else
				krn_bufferPtr++;
		}
		return NUMBER;
	}
	if(isalpha(c)) {
		Symbol *s;
		char	sbuf[100], *p=sbuf;
	
		do {
			*p++ =c;
		} while ((c=krn_buffer[krn_bufferPtr++]) != NULL && isalnum(c));
		krn_bufferPtr--;
		*p =  '\0';
		if((s=KrnEqnLookup(sbuf)) == 0)
			s=KrnEqnInstall(sbuf,UNDEF,0.0);
		yylval.sym =s;
		return s->type == UNDEF ? VAR : s->type;
	}


	if (c == '\n')
		krn_lineno++;
	return c;
}
