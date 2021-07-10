%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int yylex(void);
extern void yyerror(char *);
extern int yyparse();
extern int yyrestart(FILE*);

typedef struct yy_buffer_state * YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char * str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);

#include "parse.h"

#define LAYOUT_UNDEF	-1;
#define NORMAL_VAR		0
#define INPUT_VAR		1
#define OUTPUT_VAR		2
#define UNIFORM_VAR		3

static int layout_status = LAYOUT_UNDEF;
static int io_status;

%}
%token UNIFORM IN OUT LAYOUT LOC LB RB EQ END CR 
%token VEC4 VEC3 VEC2 MAT4 MAT3 MAT2

%union{
	int inum;
	char* str;
}

%token<str> VAR;
%token<inum> INUM;
%type<inum> layout_id;
%type<str> var_name;

%start linelist

%%

	linelist: linelist line
			{
				line_cnt++; 
				printf("$> processed line #%d \n\n", line_cnt);
				io_status = NORMAL_VAR;
				layout_status = LAYOUT_UNDEF;
			}
			| line
			{
				line_cnt++; 
				printf("$> processed line #%d \n\n", line_cnt); 
				io_status = NORMAL_VAR;
				layout_status = LAYOUT_UNDEF;
			}
			;

	line: glsl_code CR
		| glsl_code
		;

	glsl_code: cpp_expression 
			 | layoutdef iodef cpp_expression
			 | iodef cpp_expression 
			 ;

	layoutdef: LAYOUT LB LOC EQ layout_id RB {layout_status = $5;}

	iodef: IN {io_status = INPUT_VAR;}
		 | OUT {io_status = OUTPUT_VAR;}
		 | UNIFORM {io_status = UNIFORM_VAR;}
		 ; 

	cpp_expression: VEC4 var_name END
					{
						register_variable_declaration("vec4", $2, layout_status, io_status);
						printf("using var name: %s with vec4\n", $2);
					}
			   	  | VEC3 var_name END
					{
						register_variable_declaration("vec3", $2, layout_status, io_status);
						printf("using var name: %s with vec3\n", $2);
					}
			   	  | VEC2 var_name END
					{
						register_variable_declaration("vec2", $2, layout_status, io_status);
						printf("using var name: %s with vec2\n", $2);
					}
			   	  | MAT4 var_name END
					{
						register_variable_declaration("mat4", $2, layout_status, io_status);
						printf("using var name: %s with mat4\n", $2);
					}
			   	  | MAT3 var_name END
					{
						register_variable_declaration("mat3", $2, layout_status, io_status);
						printf("using var name: %s with mat3\n", $2);
					}
			   	  | MAT2 var_name END
					{
						register_variable_declaration("mat2", $2, layout_status, io_status);
						printf("using var name: %s with mat2\n", $2);
					}
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

int parse_file(const char* filename, char** output_buffer, int* buf_size)
{
	line_cnt = 0;
	FILE* fp = fopen(filename, "r");
	/* printf("opening file: %s\n", filename); */
	if (fp){
		yyrestart(fp);
	}
	init_parser_out();
	make_buffer(300);
	/* printf("ready to parse\n\n"); */
    yyparse();
	fclose(fp);
	*output_buffer = parser_out.buf;
	*buf_size = parser_out.size;
	yywrap();
}

int parse_string(const char* string, char** output_buffer, int* buf_size)
{
	line_cnt = 0;
    YY_BUFFER_STATE buffer = yy_scan_string(string);
	init_parser_out();
	make_buffer(300);
    yyparse();
    yy_delete_buffer(buffer);
	*output_buffer = parser_out.buf;
	*buf_size = parser_out.size;
	yywrap();
}