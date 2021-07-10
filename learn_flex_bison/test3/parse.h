#ifndef _PARSE_H
#define _PARSE_H

#ifdef __cplusplus
extern "C"{
#endif

int parse_string(const char* string);

int parse_file(const char* filename);

#ifdef __cplusplus
}
#endif

#endif