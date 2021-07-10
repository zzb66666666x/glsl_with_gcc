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

int line_cnt = 0;

%}
%token IN OUT LAYOUT LOC LB RB EQ END CR VEC3 VEC2

%union{
	int inum;
	char* str;
}

%token<str> VAR;
%token<inum> INUM;
%type<inum> layout_id;
%type<str> var_name;

%%

	linelist: linelist line {line_cnt++; printf("$> processed line #%d \n\n", line_cnt);}
			| line {line_cnt++; printf("$> processed line #%d \n\n", line_cnt);}
			;

	line: glsl_code 
		| glsl_code CR;

	glsl_code: cpp_expression 
			 | layoutdef iodef cpp_expression
			 | iodef cpp_expression {printf("declare only io attribute \n");}
			 ;

	layoutdef: LAYOUT LB LOC EQ layout_id RB {printf("layout %d \n", $5);}

	iodef: IN {printf("using input\n");}
		 | OUT
		 ; 

	cpp_expression: VEC3 var_name END {printf("using var name: %s with vec3\n", $2);}
			   	  | VEC2 var_name END {printf("using var name: %s with vec2\n", $2);}
			      ;

	layout_id: INUM {$$ = $1;}

	var_name: VAR {$$ = $1;}

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
	printf("ready to parse\n\n");
    yyparse();
	fclose(fp);
}

int parse_string(const char* string)
{
    YY_BUFFER_STATE buffer = yy_scan_string(string);
    yyparse();
    yy_delete_buffer(buffer);
}