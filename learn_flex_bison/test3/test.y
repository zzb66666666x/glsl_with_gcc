%{
#include <stdio.h>
#include <string.h>
extern int yylex(void);
extern void yyerror(char *);
extern int yyparse();
extern int yyrestart(FILE*);

typedef struct yy_buffer_state * YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char * str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

#include "parse.h"

%}
%token IN OUT LAYOUT LOC VAR INT LB RB EQ END CR VEC3 VEC2

%%

	linelist: linelist line {printf("line %s \n", $2);}
			| line {printf("line %s \n", $1);}
			;

	line: CExpression CR 
		| layoutdef iodef CExpression CR {printf("C expression %s \n", $3);}
		| iodef CExpression CR
		;

	layoutdef: LAYOUT LB LOC EQ INT RB {printf("layout %d \n", $5);}

	iodef: IN {printf("using input\n");}
		 | OUT
		 ; 

	CExpression: VEC3 VAR END {printf("using var name: %s\n", $2);}
			   | VEC2 VAR END
			   ;

%%

void yyerror(char *str){
    fprintf(stderr,"error:%s\n",str);
}

int yywrap(){
    return 1;
}

int parse_file(const char* filename)
{
	FILE* fp = fopen(filename, "r");
	printf("opening file: %s\n", filename);
	if (fp){
		yyrestart(fp);
	}
	printf("ready to parse\n");
    yyparse();
	fclose(fp);
	yywrap();
}

int parse_string(const char* string)
{
    YY_BUFFER_STATE buffer = yy_scan_string(string);
    yyparse();
    yy_delete_buffer(buffer);
	yywrap();
}