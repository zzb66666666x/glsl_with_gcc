#ifndef _PARSE_H
#define _PARSE_H

#ifdef __cplusplus
extern "C"{
#endif

// for user
int parse_string(const char* filename, char** output_buffer, int* buf_size);
int parse_file(const char* filename, char** output_buffer, int* buf_size);

// for parser
#define FAILURE -1
#define SUCCESS 0

typedef struct{
	char* data;
	int size;
	int usage;
}buffer_t;

extern int init_buffer(buffer_t* buf, int target_size);
extern void reset_buffer(buffer_t * buf);
extern void free_buffer(buffer_t * buf);
extern int register_code(buffer_t * buf, const char* code);
extern void free_lexer_buffer();

// global variables
extern buffer_t parser_out;

#ifdef __cplusplus
}
#endif

#endif