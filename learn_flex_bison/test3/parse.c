#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <stdlib.h>
#include "parse.h"

buffer_t parser_out;

int init_buffer(buffer_t* buf, int target_size){
	if (buf == NULL) 
		return FAILURE;
	char* space = (char *)malloc(target_size);
	if (space == NULL)
		return FAILURE;
	buf->data = space;
	buf->size = target_size;
	buf->usage = 0;
	for (int i=0; i<buf->size; i++){
		buf->data[i] = '\0';
	}
	return SUCCESS;
}

void reset_buffer(buffer_t * buf){
	if (buf == NULL)
		return;
	if (buf->data == NULL){
		buf->size = 0;
		buf->usage = 0;
		return;
	}
	for (int i=0; i<buf->size; i++){
		buf->data[i] = '\0';
	}
	buf->usage = 0;	
}

void free_buffer(buffer_t * buf){
	if (buf == NULL)
		return;
	free(buf->data);
	buf->size = 0;
	buf->usage = 0;
}

extern int register_code(buffer_t * buf, const char* code){
	if (code == NULL || buf == NULL)
		return FAILURE;
	int length = strlen(code);
	if (buf->usage + length > buf->size){
		int new_size = buf->size;
		int minimum_size = buf->usage + length + 1;
		while (new_size < minimum_size){
			new_size *= 2;
		}
		char * space = (char *) malloc(new_size);
		if (space == NULL)
			return FAILURE;
		for (int i=0; i<new_size; i++){
			space[i] = '\0';
		}
		memcpy(space, buf->data, buf->usage);
		free(buf->data);
		buf->data = space;
		buf->size = new_size;
	}
	memcpy(buf->data + buf->usage, code, length);
	buf->usage += length;
	return SUCCESS;	
}


