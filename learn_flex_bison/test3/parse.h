#ifndef _PARSE_H
#define _PARSE_H

#ifdef __cplusplus
extern "C"{
#endif

// macros share
#define MAX_VARIABLE_LEN	80
#define CODE_BUFFER_LEN		300

// for user
int parse_string(const char* filename, char** output_buffer, int* buf_size);
int parse_file(const char* filename, char** output_buffer, int* buf_size);

// for parser
#define FAILURE -1
#define SUCCESS 0

typedef struct{
	char* buf;
	int size;
	int usage;
}output_t;

extern void init_parser_out();
extern int make_buffer(int target_size);
extern int register_variable_declaration(const char* type_str, const char* var_name, int layout_status, int io_status);

// global variables
extern int line_cnt;
extern output_t parser_out;

#ifdef __cplusplus
}
#endif

#endif