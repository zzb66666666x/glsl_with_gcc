%{
	#include "y.tab.h"
	#include <string.h>
	#include <stdio.h>
	void yyerror(char *);
%}


VAR 	[a-zA-Z_$]+[a-zA-Z_$0-9]*
INUM	[1-9]+[0-9]*|0

%%

"in"		return IN;
"out"		return OUT;
"layout"	return LAYOUT;
"location"	return LOC;
"uniform"	return UNIFORM;
"mat4"		return MAT4;
"mat3"		return MAT3;
"mat2"		return MAT2;
"vec4"		return VEC4;
"vec3"		return VEC3;
"vec2"		return VEC2;
"("			return LB;
")"			return RB;
"="			return EQ;
";"			return END;
"\n"		return CR;
[ \t\n]+

{VAR}		{yylval.str = strdup(yytext); return VAR;}
{INUM}		{sscanf(yytext,"%d",&yylval.inum); return INUM;}

%%
