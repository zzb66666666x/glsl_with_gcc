#ifndef _TRANSLATE_H
#define _TRANSLATE_H

#include <string>

#define TRANSLATE_SUCCESS   1
#define TRANSLATE_FAIL      0

int translate_to_cpp(std::string& glsl_src, std::string& output);

#endif