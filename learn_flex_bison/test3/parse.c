#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include "parse.h"

int line_cnt = 0;
output_t parser_out;

void init_parser_out(){
	parser_out.buf = NULL;
	parser_out.size = 0;
	parser_out.usage = 0;
}

int make_buffer(int target_size){
	char* buf = (char *)malloc(target_size);
	if (buf == NULL)
		return FAILURE;
	if (parser_out.buf != NULL)
		free(parser_out.buf);
	parser_out.buf = buf;
	parser_out.size = target_size;
	parser_out.usage = 0;
	return SUCCESS;
}

int register_variable_declaration(const char* type_str, const char* var_name, int layout_status, int io_status){
	if (var_name == NULL)
		return FAILURE;
	assert(strlen(var_name)<MAX_VARIABLE_LEN);
	char str[CODE_BUFFER_LEN] = {0};
	memcpy(str, type_str, strlen(type_str));
	strcat(str, " ");
	strcat(str, var_name);
	strcat(str, ";\n");
	int length = strlen(str);
	if (parser_out.usage + length > parser_out.size){
		int new_size = parser_out.size;
		int minimum_size = parser_out.usage + length;
		while (new_size < minimum_size){
			new_size *= 2;
		}
		char * buf = (char *) malloc(new_size);
		if (buf == NULL)
			return FAILURE;
		memcpy(buf, parser_out.buf, parser_out.usage);
		free(parser_out.buf);
		parser_out.buf = buf;
		parser_out.size = new_size;
	}
	memcpy(parser_out.buf + parser_out.usage, str, length);
	parser_out.usage += length;
	return SUCCESS;
}



