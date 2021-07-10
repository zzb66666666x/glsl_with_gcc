%{
	#include "y.tab.h"
	void yyerror(char *);
%}


VAR 	[a-zA-Z_$]+[a-zA-Z_$0-9]*
INUM	[1-9]+[0-9]*|0

%%

"in"		return IN;
"out"		return OUT;
"layout"	return LAYOUT;
"location"	return LOC;
"("			return LB;
")"			return RB;
"="			return EQ;
";"			return END;
"\n"		return CR;
"vec3"		return VEC3;
"vec2"		return VEC2;
[ \t]+
{VAR}		return VAR;
{INUM}		return INT;

%%
