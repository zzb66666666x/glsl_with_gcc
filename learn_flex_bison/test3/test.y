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
extern void yy_delete_buffer(YY_BUFFER_STATE yy_buffer);

#include "parse.h"

#define LAYOUT_UNDEF	-1;
#define NORMAL_VAR		0
#define INPUT_VAR		1
#define OUTPUT_VAR		2
#define UNIFORM_VAR		3

static int layout_status = LAYOUT_UNDEF;
static int io_status = NORMAL_VAR;

%}

/* terminal symbols: %token */
%token IN;
%token OUT;
%token LAYOUT;
%token LOC;
%token UNIFORM;
%token MAT4;
%token MAT3;
%token MAT2;
%token VEC4;
%token VEC3;
%token VEC2;
%token LEFT_PAREN;
%token RIGHT_PAREN;
%token LEFT_BRACE;
%token RIGHT_BRACE;
%token EQ;
%token SEMICOLON;
%token DOT;
%token COMMA;
%token FLOAT;
%token DOUBLE;
%token INT;
%token VOID;
%token BOOL;

/* define yylval dtypes */
%union{
	char* str;
	buffer_t* buf;
	int intval;
	float floatval;
	/* double doubleval; */
	/* unsigned int uintval; */
}

%token<str> IDENTIFIER
%token<intval> INTCONSTANT
%token<floatval> FLOATCONSTANT
%token<str>	FUNCTION_CODE_BODY
/* %token<doubleval> DOUBLECONSTANT */
/* %token<uintval> UINTCONSTANT */

/* non-terminal symbols, the %type, they finally get reduced to %token */
%type<str> variable_name
%type<str> function_name
%type<intval> layout_val
%type<str> type_specifier
%type<str> full_type
%type<str> compound_statement
%type<buf> function_header
%type<buf> function_prototype
%type<buf> parameter_declaration
%type<buf> params_list
%type<buf> def_function
%type<buf> decl_expression

%%

root: translation_unit{
	/* init some variables here */
	printf("////////// translation unit finished //////////\n\n");
}	

translation_unit: glsl_code {
					printf("\n");
				}
				| translation_unit glsl_code {
					printf("\n");
				}
				;

glsl_code: decl_expression {
			/* translate glsl code and append to output code buffer */ 
			register_code(&parser_out, $1->data);
			free_buffer($1);
			free($1);
		 }
		 | def_function {
			register_code(&parser_out, $1->data);
			free_buffer($1);
			free($1);
		 }
		 ;

decl_expression: function_prototype SEMICOLON{
					buffer_t * tmp_buf = $1;
					register_code(tmp_buf, ";\n");
					$$ = tmp_buf;
				}
			   	| full_type variable_name SEMICOLON {
				   	buffer_t * tmp_buf = (buffer_t*)malloc(sizeof(buffer_t));
				   	init_buffer(tmp_buf, 300);
				   	register_code(tmp_buf, $1);
				   	register_code(tmp_buf, $2);
					register_code(tmp_buf, " ;\n");
				   	/* free the allocated space by strdup */
					free($2);
					$$ = tmp_buf;
			   	}
			   	;

def_function: function_prototype compound_statement{
				buffer_t * tmp_buf = $1;
				register_code(tmp_buf, $2);
				free($2);
				$$ = tmp_buf;
			}
			;

function_prototype: function_header RIGHT_PAREN {
						buffer_t* tmp_buf = $1;
						register_code(tmp_buf, ")");
						$$ = tmp_buf;
						printf("\nend functional without params\n");
					}
				  | function_header params_list RIGHT_PAREN {
					  	printf("\nend functional with params\n");
						buffer_t * tmp_buf1 = $1;
						buffer_t * tmp_buf2 = $2;
						register_code(tmp_buf1, tmp_buf2->data);
						register_code(tmp_buf1, ")");
						$$ = tmp_buf1;
						free_buffer(tmp_buf2);
						free(tmp_buf2);
					}
				  ;
				   
function_header: full_type function_name LEFT_PAREN {
					printf("begin functional: \n    ");
					buffer_t* tmp_buf = (buffer_t*)malloc(sizeof(buffer_t));
					init_buffer(tmp_buf, 300);
					register_code(tmp_buf, $1);
					if (!strcmp($2, "main")){
						register_code(tmp_buf, " glsl_");
					}
					register_code(tmp_buf, $2);
					register_code(tmp_buf, " ( ");
					/* pass the collected code buffer up */
					$$ = tmp_buf; 
					/* free the allocated space by strdup */
					free($2);
				}

params_list : parameter_declaration{
				/* pass it directly */
				$$ = $1; 
			}
			| params_list COMMA parameter_declaration{
				buffer_t* tmp_buf1 = $1;
				buffer_t* tmp_buf2 = $3;
				register_code(tmp_buf1, " , ");
				register_code(tmp_buf1, tmp_buf2->data);
				$$ = tmp_buf1;
				free_buffer(tmp_buf2);
				free(tmp_buf2);
			}
			;

parameter_declaration: type_specifier variable_name {
							buffer_t* tmp_buf = (buffer_t*)malloc(sizeof(buffer_t));
							init_buffer(tmp_buf, 300);
							register_code(tmp_buf, $1);
							register_code(tmp_buf, $2);
							printf("%s\t", $2);
							free($2);
							$$ = tmp_buf;
						}
					 | type_specifier{
						 	buffer_t* tmp_buf = (buffer_t*)malloc(sizeof(buffer_t));
							init_buffer(tmp_buf, 300);
							register_code(tmp_buf, $1);
							$$ = tmp_buf;
					 	}
					 ;

/* compound_statement: LEFT_BRACE RIGHT_BRACE {printf("function body but empty\t");}
				  | LEFT_BRACE statements_list RIGHT_BRACE {printf("function body\t");}
				  ; */

compound_statement: FUNCTION_CODE_BODY {printf("%s", $1); $$ = $1;}

full_type: type_specifier {$$ = $1;}
		 | type_descriptors_list type_specifier {$$ = $2;}
		 ;

type_specifier: VOID 	{printf("void \t"); $$ = " void ";}
			  | FLOAT 	{printf("float \t"); $$ = " float ";}
			  | DOUBLE	{printf("double \t"); $$ = " double ";}
			  | INT   	{printf("int \t"); $$ = " int ";}
			  | BOOL 	{printf("bool \t"); $$ = " bool ";}
			  | MAT4 	{printf("mat4 \t"); $$ = " mat4 ";}
			  | MAT3 	{printf("mat3 \t"); $$ = " mat3 ";}
			  | MAT2 	{printf("mat2 \t"); $$ = " mat2 ";}
			  | VEC4 	{printf("vec4 \t"); $$ = " vec4 ";}
			  | VEC3 	{printf("vec3 \t"); $$ = " vec3 ";}
			  | VEC2 	{printf("vec2 \t"); $$ = " vec2 ";}
			  ;

type_descriptors_list: type_descriptor
					 | type_descriptors_list type_descriptor
					 ;

type_descriptor: io_decl
			   | layout_decl
			   ;

io_decl: IN {printf("input var\t");}
	   | OUT {printf("output var\t");}
	   | UNIFORM {printf("uniform var\t");}
	   ;

layout_decl: LAYOUT LEFT_PAREN LOC EQ layout_val RIGHT_PAREN {printf("layout num %d\t", $5);}
		   ;

variable_name: IDENTIFIER{$$ = $1; printf("var name %s\t", $1);}

function_name: IDENTIFIER{$$ = $1; printf("func name %s\t", $1);}

layout_val: INTCONSTANT{$$ = $1;}


%%

void yyerror(char *str){
    fprintf(stderr,"error:%s\n",str);
}

int yywrap(){
    return 1;
}

int parse_file(const char* filename, char** output_buffer, int* buf_size)
{
	FILE* fp = fopen(filename, "r");
	/* printf("opening file: %s\n", filename); */
	if (fp){
		yyrestart(fp);
	}
	init_buffer(&parser_out, 1000);
	/* printf("ready to parse\n\n"); */
    yyparse();
	fclose(fp);
	*output_buffer = parser_out.data;
	*buf_size = parser_out.size;
	free_lexer_buffer();
	yywrap();
}

int parse_string(const char* string, char** output_buffer, int* buf_size)
{
    YY_BUFFER_STATE yy_buffer = yy_scan_string(string);
	init_buffer(&parser_out, 1000);
    yyparse();
    yy_delete_buffer(yy_buffer);
	*output_buffer = parser_out.data;
	*buf_size = parser_out.size;
	free_lexer_buffer();
	yywrap();
}