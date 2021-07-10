
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     UNIFORM = 258,
     IN = 259,
     OUT = 260,
     LAYOUT = 261,
     LOC = 262,
     LB = 263,
     RB = 264,
     EQ = 265,
     END = 266,
     CR = 267,
     VEC4 = 268,
     VEC3 = 269,
     VEC2 = 270,
     MAT4 = 271,
     MAT3 = 272,
     MAT2 = 273,
     VAR = 274,
     INUM = 275
   };
#endif
/* Tokens.  */
#define UNIFORM 258
#define IN 259
#define OUT 260
#define LAYOUT 261
#define LOC 262
#define LB 263
#define RB 264
#define EQ 265
#define END 266
#define CR 267
#define VEC4 268
#define VEC3 269
#define VEC2 270
#define MAT4 271
#define MAT3 272
#define MAT2 273
#define VAR 274
#define INUM 275




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 30 "test.y"

	int inum;
	char* str;



/* Line 1676 of yacc.c  */
#line 99 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


