/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2020 Free Software Foundation,
   Inc.

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

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    LITERAL_integer = 258,
    LITERAL_floatingpoint = 259,
    LITERAL_boolean = 260,
    LITERAL_char = 261,
    LITERAL_string = 262,
    LITERAL_textblock = 263,
    LITERAL_null = 264,
    KEYWORD_class = 265,
    KEYWORD_extends = 266,
    KEYWORD_super = 267,
    KEYWORD_public = 268,
    KEYWORD_private = 269,
    KEYWORD_abstract = 270,
    KEYWORD_static = 271,
    KEYWORD_final = 272,
    KEYWORD_sealed = 273,
    KEYWORD_nonsealed = 274,
    KEYWORD_strictfp = 275,
    KEYWORD_implements = 276,
    KEYWORD_permits = 277,
    KEYWORD_transient = 278,
    KEYWORD_volatile = 279,
    KEYWORD_synchronized = 280,
    KEYWORD_native = 281,
    KEYWORD_void = 282,
    KEYWORD_this = 283,
    KEYWORD_enum = 284,
    KEYWORD_if = 285,
    KEYWORD_else = 286,
    KEYWORD_assert = 287,
    KEYWORD_while = 288,
    KEYWORD_for = 289,
    KEYWORD_break = 290,
    KEYWORD_yield = 291,
    KEYWORD_continue = 292,
    KEYWORD_return = 293,
    KEYWORD_throw = 294,
    KEYWORD_try = 295,
    KEYWORD_catch = 296,
    KEYWORD_finally = 297,
    KEYWORD_boolean = 298,
    KEYWORD_new = 299,
    KEYWORD_instanceof = 300,
    KEYWORD_var = 301,
    KEYWORD_byte = 302,
    KEYWORD_short = 303,
    KEYWORD_int = 304,
    KEYWORD_long = 305,
    KEYWORD_char = 306,
    KEYWORD_float = 307,
    KEYWORD_double = 308,
    KEYWORD_protected = 309,
    KEYWORD_throws = 310,
    Identifier = 311,
    DELIM_semicolon = 312,
    DELIM_period = 313,
    DELIM_lpar = 314,
    DELIM_rpar = 315,
    DELIM_lsq = 316,
    DELIM_rsq = 317,
    DELIM_lcurl = 318,
    DELIM_rcurl = 319,
    DELIM_comma = 320,
    DELIM_ellipsis = 321,
    DELIM_proportion = 322,
    DELIM_attherate = 323,
    OPERATOR_equal = 324,
    OPERATOR_ternarycolon = 325,
    OPERATOR_assignment = 326,
    OPERATOR_bitwiseand = 327,
    OPERATOR_ternaryquestion = 328,
    OPERATOR_logicalor = 329,
    OPERATOR_logicaland = 330,
    OPERATOR_bitwiseor = 331,
    OPERATOR_xor = 332,
    OPERATOR_logicalequal = 333,
    OPERATOR_neq = 334,
    OPERATOR_lt = 335,
    OPERATOR_gt = 336,
    OPERATOR_leq = 337,
    OPERATOR_geq = 338,
    OPERATOR_leftshift = 339,
    OPERATOR_rightshift = 340,
    OPERATOR_unsignedrightshift = 341,
    OPERATOR_plus = 342,
    OPERATOR_minus = 343,
    OPERATOR_multiply = 344,
    OPERATOR_divide = 345,
    OPERATOR_mod = 346,
    OPERATOR_increment = 347,
    OPERATOR_decrement = 348,
    OPERATOR_bitwisecomp = 349,
    OPERATOR_not = 350
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 16 "parser.y"

    long numval;
    long double realval;
    int boolval;
    char charval;
    char* strval;

#line 161 "parser.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
