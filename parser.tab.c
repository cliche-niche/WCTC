/* A Bison parser, made by GNU Bison 3.5.1.  */

/* Bison implementation for Yacc-like parsers in C

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

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Undocumented macros, especially those whose name start with YY_,
   are private implementation details.  Do not rely on them.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.5.1"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* First part of user prologue.  */
#line 1 "parser.y"

    #include <cstdio> 
    #include <cstring>
    #include <iostream>
    #include <vector>
    #include <stdio.h>

    using namespace std;

    extern "C" int yylex();
    extern "C" int yylineno;
    void yyerror(const char* s);

#line 84 "parser.tab.c"

# ifndef YY_CAST
#  ifdef __cplusplus
#   define YY_CAST(Type, Val) static_cast<Type> (Val)
#   define YY_REINTERPRET_CAST(Type, Val) reinterpret_cast<Type> (Val)
#  else
#   define YY_CAST(Type, Val) ((Type) (Val))
#   define YY_REINTERPRET_CAST(Type, Val) ((Type) (Val))
#  endif
# endif
# ifndef YY_NULLPTR
#  if defined __cplusplus
#   if 201103L <= __cplusplus
#    define YY_NULLPTR nullptr
#   else
#    define YY_NULLPTR 0
#   endif
#  else
#   define YY_NULLPTR ((void*)0)
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 1
#endif

/* Use api.header.include to #include this header
   instead of duplicating it here.  */
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

#line 240 "parser.tab.c"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */



#ifdef short
# undef short
#endif

/* On compilers that do not define __PTRDIFF_MAX__ etc., make sure
   <limits.h> and (if available) <stdint.h> are included
   so that the code can choose integer types of a good width.  */

#ifndef __PTRDIFF_MAX__
# include <limits.h> /* INFRINGES ON USER NAME SPACE */
# if defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stdint.h> /* INFRINGES ON USER NAME SPACE */
#  define YY_STDINT_H
# endif
#endif

/* Narrow types that promote to a signed type and that can represent a
   signed or unsigned integer of at least N bits.  In tables they can
   save space and decrease cache pressure.  Promoting to a signed type
   helps avoid bugs in integer arithmetic.  */

#ifdef __INT_LEAST8_MAX__
typedef __INT_LEAST8_TYPE__ yytype_int8;
#elif defined YY_STDINT_H
typedef int_least8_t yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef __INT_LEAST16_MAX__
typedef __INT_LEAST16_TYPE__ yytype_int16;
#elif defined YY_STDINT_H
typedef int_least16_t yytype_int16;
#else
typedef short yytype_int16;
#endif

#if defined __UINT_LEAST8_MAX__ && __UINT_LEAST8_MAX__ <= __INT_MAX__
typedef __UINT_LEAST8_TYPE__ yytype_uint8;
#elif (!defined __UINT_LEAST8_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST8_MAX <= INT_MAX)
typedef uint_least8_t yytype_uint8;
#elif !defined __UINT_LEAST8_MAX__ && UCHAR_MAX <= INT_MAX
typedef unsigned char yytype_uint8;
#else
typedef short yytype_uint8;
#endif

#if defined __UINT_LEAST16_MAX__ && __UINT_LEAST16_MAX__ <= __INT_MAX__
typedef __UINT_LEAST16_TYPE__ yytype_uint16;
#elif (!defined __UINT_LEAST16_MAX__ && defined YY_STDINT_H \
       && UINT_LEAST16_MAX <= INT_MAX)
typedef uint_least16_t yytype_uint16;
#elif !defined __UINT_LEAST16_MAX__ && USHRT_MAX <= INT_MAX
typedef unsigned short yytype_uint16;
#else
typedef int yytype_uint16;
#endif

#ifndef YYPTRDIFF_T
# if defined __PTRDIFF_TYPE__ && defined __PTRDIFF_MAX__
#  define YYPTRDIFF_T __PTRDIFF_TYPE__
#  define YYPTRDIFF_MAXIMUM __PTRDIFF_MAX__
# elif defined PTRDIFF_MAX
#  ifndef ptrdiff_t
#   include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  endif
#  define YYPTRDIFF_T ptrdiff_t
#  define YYPTRDIFF_MAXIMUM PTRDIFF_MAX
# else
#  define YYPTRDIFF_T long
#  define YYPTRDIFF_MAXIMUM LONG_MAX
# endif
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif defined __STDC_VERSION__ && 199901 <= __STDC_VERSION__
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned
# endif
#endif

#define YYSIZE_MAXIMUM                                  \
  YY_CAST (YYPTRDIFF_T,                                 \
           (YYPTRDIFF_MAXIMUM < YY_CAST (YYSIZE_T, -1)  \
            ? YYPTRDIFF_MAXIMUM                         \
            : YY_CAST (YYSIZE_T, -1)))

#define YYSIZEOF(X) YY_CAST (YYPTRDIFF_T, sizeof (X))

/* Stored state numbers (used for stacks). */
typedef yytype_int16 yy_state_t;

/* State numbers in computations.  */
typedef int yy_state_fast_t;

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# if defined __GNUC__ && 2 < __GNUC__ + (96 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_PURE __attribute__ ((__pure__))
# else
#  define YY_ATTRIBUTE_PURE
# endif
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# if defined __GNUC__ && 2 < __GNUC__ + (7 <= __GNUC_MINOR__)
#  define YY_ATTRIBUTE_UNUSED __attribute__ ((__unused__))
# else
#  define YY_ATTRIBUTE_UNUSED
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && ! defined __ICC && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN                            \
    _Pragma ("GCC diagnostic push")                                     \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")              \
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END      \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif

#if defined __cplusplus && defined __GNUC__ && ! defined __ICC && 6 <= __GNUC__
# define YY_IGNORE_USELESS_CAST_BEGIN                          \
    _Pragma ("GCC diagnostic push")                            \
    _Pragma ("GCC diagnostic ignored \"-Wuseless-cast\"")
# define YY_IGNORE_USELESS_CAST_END            \
    _Pragma ("GCC diagnostic pop")
#endif
#ifndef YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_BEGIN
# define YY_IGNORE_USELESS_CAST_END
#endif


#define YY_ASSERT(E) ((void) (0 && (E)))

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yy_state_t yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (YYSIZEOF (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (YYSIZEOF (yy_state_t) + YYSIZEOF (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYPTRDIFF_T yynewbytes;                                         \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * YYSIZEOF (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / YYSIZEOF (*yyptr);                        \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, YY_CAST (YYSIZE_T, (Count)) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYPTRDIFF_T yyi;                      \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  4
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   1949

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  96
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  174
/* YYNRULES -- Number of rules.  */
#define YYNRULES  366
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  606

#define YYUNDEFTOK  2
#define YYMAXUTOK   350


/* YYTRANSLATE(TOKEN-NUM) -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, with out-of-bounds checking.  */
#define YYTRANSLATE(YYX)                                                \
  (0 <= (YYX) && (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex.  */
static const yytype_int8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53,    54,
      55,    56,    57,    58,    59,    60,    61,    62,    63,    64,
      65,    66,    67,    68,    69,    70,    71,    72,    73,    74,
      75,    76,    77,    78,    79,    80,    81,    82,    83,    84,
      85,    86,    87,    88,    89,    90,    91,    92,    93,    94,
      95
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_int16 yyrline[] =
{
       0,    57,    57,    57,    57,    57,    57,    58,    58,    62,
      62,    63,    63,    72,    74,    74,    75,    75,    81,    82,
      82,    93,    93,    94,    94,    95,    98,   101,   102,   102,
     103,   103,   123,   123,   124,   124,   124,   124,   124,   124,
     124,   124,   124,   124,   126,   131,   132,   132,   134,   135,
     135,   138,   139,   139,   141,   142,   142,   144,   144,   144,
     144,   145,   145,   147,   147,   147,   147,   149,   154,   155,
     155,   156,   157,   158,   158,   159,   159,   161,   161,   172,
     179,   181,   181,   183,   184,   186,   188,   190,   191,   191,
     193,   194,   194,   195,   195,   195,   196,   196,   199,   199,
     202,   202,   204,   205,   205,   208,   208,   210,   212,   214,
     219,   220,   222,   223,   224,   225,   226,   227,   228,   229,
     230,   231,   234,   254,   255,   255,   256,   256,   257,   258,
     258,   262,   264,   265,   268,   269,   272,   273,   274,   277,
     280,   283,   284,   287,   288,   291,   292,   293,   294,   295,
     296,   299,   300,   301,   302,   303,   306,   307,   308,   309,
     310,   311,   312,   313,   314,   315,   316,   319,   322,   325,
     328,   331,   332,   333,   334,   335,   336,   337,   340,   343,
     346,   349,   350,   354,   357,   360,   361,   364,   365,   368,
     371,   373,   374,   376,   377,   380,   381,   384,   387,   389,
     390,   393,   396,   399,   401,   402,   405,   408,   411,   413,
     414,   417,   420,   423,   424,   425,   427,   428,   431,   432,
     435,   437,   440,   441,   444,   449,   449,   451,   454,   456,
     457,   460,   461,   462,   465,   467,   468,   471,   472,   475,
     476,   479,   482,   488,   491,   492,   495,   496,   499,   500,
     503,   504,   507,   508,   511,   512,   515,   516,   519,   520,
     521,   524,   525,   526,   527,   528,   529,   532,   533,   534,
     535,   538,   539,   540,   543,   544,   545,   546,   549,   550,
     551,   552,   553,   556,   559,   562,   563,   564,   565,   566,
     569,   570,   571,   574,   575,   578,   579,   580,   581,   582,
     583,   584,   585,   586,   587,   589,   589,   589,   589,   589,
     589,   589,   591,   592,   593,   594,   595,   598,   599,   600,
     603,   610,   610,   611,   612,   612,   614,   615,   616,   619,
     620,   623,   624,   625,   626,   629,   630,   631,   632,   633,
     634,   635,   638,   639,   640,   641,   643,   644,   644,   646,
     647,   647,   648,   648,   650,   651,   652,   653,   654,   658,
     659,   660,   662,   663,   666,   667,   668
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "LITERAL_integer",
  "LITERAL_floatingpoint", "LITERAL_boolean", "LITERAL_char",
  "LITERAL_string", "LITERAL_textblock", "LITERAL_null", "KEYWORD_class",
  "KEYWORD_extends", "KEYWORD_super", "KEYWORD_public", "KEYWORD_private",
  "KEYWORD_abstract", "KEYWORD_static", "KEYWORD_final", "KEYWORD_sealed",
  "KEYWORD_nonsealed", "KEYWORD_strictfp", "KEYWORD_implements",
  "KEYWORD_permits", "KEYWORD_transient", "KEYWORD_volatile",
  "KEYWORD_synchronized", "KEYWORD_native", "KEYWORD_void", "KEYWORD_this",
  "KEYWORD_enum", "KEYWORD_if", "KEYWORD_else", "KEYWORD_assert",
  "KEYWORD_while", "KEYWORD_for", "KEYWORD_break", "KEYWORD_yield",
  "KEYWORD_continue", "KEYWORD_return", "KEYWORD_throw", "KEYWORD_try",
  "KEYWORD_catch", "KEYWORD_finally", "KEYWORD_boolean", "KEYWORD_new",
  "KEYWORD_instanceof", "KEYWORD_var", "KEYWORD_byte", "KEYWORD_short",
  "KEYWORD_int", "KEYWORD_long", "KEYWORD_char", "KEYWORD_float",
  "KEYWORD_double", "KEYWORD_protected", "KEYWORD_throws", "Identifier",
  "DELIM_semicolon", "DELIM_period", "DELIM_lpar", "DELIM_rpar",
  "DELIM_lsq", "DELIM_rsq", "DELIM_lcurl", "DELIM_rcurl", "DELIM_comma",
  "DELIM_ellipsis", "DELIM_proportion", "DELIM_attherate",
  "OPERATOR_equal", "OPERATOR_ternarycolon", "OPERATOR_assignment",
  "OPERATOR_bitwiseand", "OPERATOR_ternaryquestion", "OPERATOR_logicalor",
  "OPERATOR_logicaland", "OPERATOR_bitwiseor", "OPERATOR_xor",
  "OPERATOR_logicalequal", "OPERATOR_neq", "OPERATOR_lt", "OPERATOR_gt",
  "OPERATOR_leq", "OPERATOR_geq", "OPERATOR_leftshift",
  "OPERATOR_rightshift", "OPERATOR_unsignedrightshift", "OPERATOR_plus",
  "OPERATOR_minus", "OPERATOR_multiply", "OPERATOR_divide", "OPERATOR_mod",
  "OPERATOR_increment", "OPERATOR_decrement", "OPERATOR_bitwisecomp",
  "OPERATOR_not", "$accept", "IntegralType", "FloatingPointType",
  "PrimitiveType", "NumericType", "ArrayType", "Dims", "qDims",
  "AdditionalBound", "pAdditionalBound", "Name", "sCommaName", "NameList",
  "CompilationUnit", "OrdinaryCompilationUnit",
  "sTopLevelClassOrInterfaceDeclaration",
  "TopLevelClassOrInterfaceDeclaration", "Modifiers", "Modifier",
  "NormalClassDeclaration", "ClassExtends", "qClassExtends",
  "ClassImplements", "qClassImplements", "ClassPermits", "qClassPermits",
  "ClassBody", "qClassBody", "ClassBodyDeclaration",
  "sClassBodyDeclaration", "ClassMemberDeclaration", "FieldDeclaration",
  "VariableDeclaratorList", "sCommaVariableDeclarator",
  "VariableDeclarator", "VariableDeclaratorId",
  "qEqualVariableInitializer", "VariableInitializer", "UnannType",
  "MethodDeclaration", "MethodHeader", "Result", "MethodDeclarator",
  "ReceiverParameterComma", "ReceiverParameter", "IdentifierDot",
  "qIdentifierDot", "FormalParameterList", "qFormalParameterList",
  "FormalParameter", "sCommaFormalParameter", "VariableArityParameter",
  "pVariableModifier", "Throws", "qThrows", "MethodBody",
  "InstanceInitializer", "StaticInitializer", "ConstructorDeclaration",
  "ConstructorDeclarator", "ConstructorBody",
  "ExplicitConstructorInvocation", "PrimaryDot", "PrimaryDotSuper",
  "NameDot", "NameDotSuper", "BracketArgumentList", "ArrayInitializer",
  "qComma", "sCommaVariableInitializer", "VariableInitializerList",
  "qVariableInitializerList", "Block", "qBlockStatements",
  "BlockStatements", "BlockStatement", "LocalClassOrInterfaceDeclaration",
  "LocalVariableDeclarationStatement", "LocalVariableDeclaration",
  "LocalVariableType", "Statement", "StatementNoShortIf",
  "StatementWithoutTrailingSubstatement", "EmptyStatement",
  "LabeledStatement", "LabeledStatementNoShortIf", "ExpressionStatement",
  "StatementExpression", "IfThenStatement", "IfThenElseStatement",
  "IfThenElseStatementNoShortIf", "AssertStatement", "WhileStatement",
  "WhileStatementNoShortIf", "ForStatement", "ForStatementNoShortIf",
  "BasicForStatement", "BasicForStatementNoShortIf", "qForInit",
  "qForUpdate", "ForInit", "ForUpdate", "StatementExpressionList",
  "sCommaStatementExpression", "EnhancedForStatement",
  "EnhancedForStatementNoShortIf", "BreakStatement", "qIdentifier",
  "YieldStatement", "ContinueStatement", "ReturnStatement", "qExpression",
  "ThrowStatement", "SynchronizedStatement", "TryStatement", "qCatches",
  "pCatches", "Catches", "CatchClause", "CatchFormalParameter",
  "CatchType", "sOrName", "Finally", "TryWithResourcesStatement",
  "qFinally", "ResourceSpecification", "qsemicolon", "ResourceList",
  "ssemicolonResource", "Resource", "VariableAccess", "Pattern",
  "TypePattern", "Expression", "AssignmentExpression",
  "ConditionalExpression", "ConditionalOrExpression",
  "ConditionalAndExpression", "InclusiveOrExpression",
  "ExclusiveOrExpression", "AndExpression", "EqualityExpression",
  "RelationalExpression", "ShiftExpression", "AdditiveExpression",
  "MultiplicativeExpression", "UnaryExpression", "PreIncrementExpression",
  "PreDecrementExpression", "UnaryExpressionNotPlusMinus",
  "PostfixExpression", "Primary", "PrimaryNoNewArray", "Literal",
  "ClassLiteral", "ClassInstanceCreationExpression",
  "UnqualifiedClassInstanceCreationExpression", "qArgumentList",
  "ArgumentList", "sCommaExpression", "FieldAccess", "ArrayAccess",
  "MethodInvocation", "MethodReference", "ArrayCreationExpression",
  "DimExprs", "sDimExpr", "DimExpr", "PostIncrementExpression",
  "PostDecrementExpression", "CastExpression", "InstanceofExpression",
  "Assignment", "LeftHandSide", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_int16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308,   309,   310,   311,   312,   313,   314,
     315,   316,   317,   318,   319,   320,   321,   322,   323,   324,
     325,   326,   327,   328,   329,   330,   331,   332,   333,   334,
     335,   336,   337,   338,   339,   340,   341,   342,   343,   344,
     345,   346,   347,   348,   349,   350
};
# endif

#define YYPACT_NINF (-513)

#define yypact_value_is_default(Yyn) \
  ((Yyn) == YYPACT_NINF)

#define YYTABLE_NINF (-367)

#define yytable_value_is_error(Yyn) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int16 yypact[] =
{
    -513,    50,  -513,   442,  -513,  -513,  -513,  -513,  -513,  -513,
    -513,  -513,  -513,  -513,  -513,  -513,  -513,   714,  -513,  -513,
      28,  -513,    87,    66,  -513,   108,  -513,    97,   112,    66,
    -513,    81,  -513,  -513,    97,  -513,    66,  -513,    94,    96,
      97,  -513,  -513,    66,    96,   588,    97,   117,  -513,  1476,
    -513,  1893,  -513,  -513,  -513,  -513,  -513,  -513,  -513,  -513,
    -513,  -513,  -513,  -513,  -513,  -513,  -513,  -513,  -513,    82,
     584,   135,   138,  -513,   142,  1230,   149,   165,   182,  1230,
     182,  1230,  1230,   129,   154,   482,  -513,  -513,  -513,  -513,
    -513,  -513,  -513,  -513,   170,  -513,  1230,  1230,  1334,  1334,
    -513,  -513,  -513,   154,   179,   178,  -513,  -513,   861,     5,
      53,    98,  -513,   184,  -513,  1476,  -513,  -513,   195,   200,
    -513,  -513,  -513,  -513,  -513,   206,  -513,  -513,  -513,  -513,
    -513,  -513,  -513,  -513,  -513,  -513,  -513,  -513,  -513,  -513,
    -513,  -513,  -513,    52,   102,   199,  -513,  -513,   113,  -513,
     194,   207,   124,  -513,  -513,   208,   221,  -513,   209,  -513,
    -513,  -513,   218,   200,   -10,   229,   235,   255,   261,  1230,
     318,  1230,   278,  1307,  1334,  1334,  1334,  1334,   278,   178,
      -6,  -513,  -513,   250,   267,   268,   270,   281,  -513,   331,
     101,   249,   231,  -513,  -513,  -513,  -513,    52,  -513,  -513,
    -513,  -513,  -513,  -513,  -513,  1230,  1752,  -513,   299,   304,
     310,   311,  -513,   320,  1846,   338,   117,   316,  -513,   324,
     322,   225,  1616,   327,  -513,   105,  -513,  -513,  -513,  -513,
     330,    10,   380,  1230,  1104,    11,  -513,  -513,   172,  -513,
    -513,  -513,   162,   200,    66,   332,  -513,  -513,  -513,  -513,
     336,   339,  -513,  -513,  -513,   278,  -513,  -513,   325,  -513,
    -513,  -513,  -513,   340,  1230,  1230,   256,   341,  -513,  -513,
    -513,   334,   235,    66,  -513,   346,   332,  -513,   342,  -513,
     344,   355,    65,   628,  -513,  -513,  -513,  -513,   154,  -513,
    1230,  1230,  1334,  1334,  1334,  1334,  1334,  1004,  1334,  1334,
    1334,  1334,  1334,  1334,  1334,  1334,  1334,  1334,  1334,  1334,
    1334,  1334,   357,  -513,   329,  -513,   363,  -513,  -513,  -513,
    -513,  -513,  -513,  -513,   271,  -513,   365,  -513,  -513,   102,
     212,   364,   382,   338,   384,  -513,   338,   278,   417,  1104,
     366,   278,  -513,   366,    94,   278,   135,   105,  -513,  -513,
     418,  -513,  -513,  -513,   368,   370,  -513,   372,  -513,  -513,
     385,  -513,   291,  -513,   332,  -513,  -513,   379,  1200,  -513,
    -513,   387,  -513,    51,   256,   388,  -513,   403,  -513,  -513,
     389,  -513,   256,  -513,  -513,  1547,  -513,  -513,   117,  1685,
    1334,  1403,    66,  -513,    15,  1403,    41,   404,   402,   267,
     268,   270,   281,  -513,  -513,   203,  -513,  -513,  -513,  -513,
    -513,   101,   101,   101,   101,   249,   249,   249,   231,   231,
    -513,  -513,  -513,  1616,  1230,   406,  1230,  -513,   413,   419,
      24,   117,  -513,  -513,   382,  -513,  -513,  -513,   412,  1200,
    -513,  -513,   416,  -513,  -513,  -513,  -513,  -513,  1230,  -513,
    -513,  -513,   468,  -513,   200,  -513,  -513,  -513,  -513,   171,
     423,  -513,  -513,   453,    77,   426,  -513,  -513,   427,    86,
     256,   434,    47,   332,  1476,    60,   332,    69,   431,  -513,
     424,   441,   443,   433,  -513,   474,   477,  -513,  -513,  -513,
    -513,  -513,  -513,  -513,  -513,    97,  1403,  -513,  -513,  1403,
    -513,  1334,   454,  -513,   449,  1779,   455,  -513,  1846,    97,
      40,   451,   200,  -513,  -513,  -513,  -513,  -513,  -513,   448,
    1230,  -513,   368,  -513,  -513,  -513,  -513,  -513,  -513,   256,
     458,  -513,   457,   278,   466,   467,   472,  -513,   480,   487,
    -513,  1230,  1230,  1752,  1685,  1616,  -513,  -513,  -513,  1616,
    -513,  1779,  -513,   439,   200,   117,  -513,   481,  -513,   484,
    -513,  -513,  -513,   278,  -513,  -513,  -513,  -513,  -513,  -513,
     490,   491,   483,   497,  -513,  -513,  -513,   501,  -513,  -513,
      66,  -513,  -513,  1200,  -513,  -513,  1685,  1685,  1230,  1230,
    1616,    97,  -513,   524,  -513,   502,   511,  -513,  1685,  1685,
    1779,  -513,  -513,   509,  1685,  -513
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_int16 yydefact[] =
{
      28,     0,    26,    27,     1,    34,    35,    39,    37,    38,
      42,    43,    41,    40,    36,    31,    29,     0,    32,    30,
       0,    33,    46,     0,    47,    49,    22,    45,     0,     0,
      50,    52,   120,    21,    23,    48,     0,    53,     0,    25,
      23,    61,    44,     0,    51,     0,    24,    37,    66,   132,
      54,     0,    65,    62,    57,    63,    64,    58,    59,    60,
     107,   108,   305,   306,   307,   308,   309,   310,   311,     0,
      38,    41,     0,   297,     0,     0,     0,     0,   204,     0,
     204,   209,     0,     0,    10,     0,   144,     2,     3,     4,
       5,     6,     7,     8,    22,   167,     0,     0,     0,     0,
      11,    12,    77,     9,     0,    16,   139,   143,     0,     0,
       0,     0,   156,     0,   133,   134,   136,   137,     0,     0,
     138,   145,   157,   146,   158,     0,   147,   148,   159,   149,
     150,   185,   186,   160,   166,   161,   162,   164,   163,   165,
     215,   172,   173,     0,   290,   293,   295,   296,   300,   317,
     301,   302,   303,   304,   294,   174,   175,   171,     0,    82,
      10,     9,    16,     0,     0,     0,   103,     0,     0,     0,
       0,     0,    16,     0,     0,     0,     0,     0,    16,   285,
       0,   243,   244,   246,   248,   250,   252,   254,   256,   258,
     261,   267,   271,   274,   278,   279,   282,   286,   300,   303,
     291,   292,   289,   266,   245,     0,   191,   205,     0,     0,
       0,     0,   210,     0,     0,   216,     0,     0,    17,     0,
       0,     0,     0,     0,   363,   285,   283,   301,   302,   284,
       0,     0,   120,   321,     0,     0,   350,   352,    13,    78,
     331,   101,    16,     0,     0,   326,   319,   121,   298,   318,
       0,     0,   131,   135,   140,    16,   142,    69,    73,   170,
     351,   353,   118,     0,     0,     0,    91,     0,   106,    79,
     105,     0,   103,     0,   104,     0,   327,   338,     0,   316,
       0,     0,     0,   285,   280,   281,   287,   288,    13,   181,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,   100,   196,   199,     0,   192,   195,   203,
     206,   207,   208,   211,   239,   237,   232,   235,   238,     0,
     301,     0,     0,   220,   213,   218,   216,    14,     0,     0,
       0,    16,   347,     0,    55,    16,     0,   364,   168,   299,
       0,   341,   337,   312,   324,     0,   322,     0,   340,   335,
       0,   141,     0,   332,   328,   339,    72,    68,     0,    71,
     336,     0,   362,    88,    91,     0,    92,     0,    96,    94,
       0,    67,    91,    80,   102,   132,   109,   333,     0,     0,
       0,     0,     0,    19,     0,     0,     0,     0,     0,   249,
     251,   253,   255,   257,   359,   360,   242,   361,   241,   259,
     260,   262,   263,   264,   265,   268,   269,   270,   272,   273,
     275,   276,   277,     0,     0,   198,   209,   233,     0,   234,
       0,     0,   214,   219,   229,   217,    15,   315,     0,   129,
     344,   342,   346,   345,    56,   320,   343,   314,     0,   323,
     122,   329,     0,   334,     0,    74,    76,    75,   330,    16,
       0,    95,    89,     0,     0,     0,    85,   110,    90,     0,
      91,     0,     0,   297,   132,     0,     0,     0,     0,   212,
       0,     0,     0,    22,   178,     0,   145,   152,   153,   154,
     155,   187,   188,   354,   355,    18,     0,    20,   358,     0,
     182,     0,    13,   183,     0,     0,     0,   231,     0,   225,
       0,     0,     0,   227,   230,   228,   349,   126,   130,   124,
       0,   348,   324,   313,    70,    87,    99,    86,   111,     0,
       0,    93,     0,    16,     0,     0,     0,   119,     0,     0,
     112,     0,     0,   191,     0,     0,   356,   357,   247,     0,
     200,   193,   236,   224,     0,     0,   223,   128,   125,     0,
     325,    97,    98,    16,    83,   115,   114,   113,   117,   116,
       0,     0,   196,     0,   169,   179,   201,     0,   194,   197,
       0,   222,   221,     0,   123,    84,     0,     0,     0,   209,
       0,   226,   127,     0,   184,     0,     0,   189,     0,     0,
     193,   180,   202,     0,     0,   190
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -513,  -513,  -513,   -47,   -39,  -143,   -90,   -79,  -317,   287,
     -23,   531,   300,  -513,  -513,  -513,  -513,   527,    27,    45,
    -513,  -513,  -513,  -513,  -513,  -513,   230,  -513,  -513,  -513,
    -513,  -513,  -141,  -513,   125,  -354,  -513,  -421,   -49,  -513,
    -513,  -513,  -513,   202,  -513,  -513,  -513,  -513,  -347,    56,
    -513,  -513,  -235,  -513,   315,  -513,  -513,  -513,  -513,  -513,
    -513,  -513,   204,  -513,   -22,   213,  -185,  -272,  -513,  -513,
    -513,  -513,   -13,  -362,   473,  -513,  -513,  -513,  -189,   485,
     495,  -504,  -373,  -513,  -513,  -513,  -513,  -203,  -513,  -513,
    -513,  -513,  -513,  -513,  -513,  -513,  -513,  -513,    48,    -8,
    -513,  -513,  -512,  -513,  -513,  -513,  -513,   517,  -513,  -513,
    -513,  -415,  -513,  -513,  -513,   263,  -513,   272,   273,  -513,
     100,  -513,   181,  -513,  -513,  -513,  -513,  -513,  -513,   109,
    -513,  -513,  -513,   720,  -513,   115,  -513,   347,   328,   349,
     333,    -3,  -513,   -96,    59,    64,   -56,    -4,    75,  -358,
     104,  -210,  -513,  -513,  -513,   167,  -101,  -513,  -513,   116,
     671,   724,   240,  -513,  -513,   425,  -513,   180,   269,   337,
    -513,  -513,   401,  -513
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,   100,   101,   102,   178,   104,   218,   239,   393,   394,
     225,    39,    35,     1,     2,     3,    16,    17,    18,   106,
      24,    25,    30,    31,    37,    38,    42,   445,    53,    45,
      54,    55,   256,   367,   257,   258,   369,   455,   107,    56,
     164,   165,   272,   374,   375,   462,   463,   376,   377,   378,
     468,   379,   108,   274,   275,   269,    57,    58,    59,   166,
     386,   474,   109,   476,   110,   111,   240,   456,   559,   557,
     518,   519,   112,   113,   114,   115,   116,   117,   118,   119,
     120,   485,   121,   122,   123,   487,   124,   125,   126,   127,
     488,   128,   129,   489,   130,   490,   131,   491,   316,   577,
     317,   578,   318,   425,   132,   492,   133,   208,   134,   135,
     136,   211,   137,   138,   139,   332,   333,   334,   335,   511,
     512,   553,   432,   140,   515,   216,   428,   326,   429,   327,
     328,   407,   408,   212,   181,   182,   183,   184,   185,   186,
     187,   188,   189,   190,   191,   192,   193,   194,   195,   196,
     197,   144,   145,   146,   147,   198,   149,   355,   356,   449,
     150,   151,   199,   153,   154,   341,   442,   342,   200,   201,
     202,   203,   204,   158
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_int16 yytable[] =
{
      27,    28,   163,   315,   329,   219,    34,    28,   246,   249,
     103,   506,   161,    40,    28,   238,   486,   314,   517,   461,
      46,    28,   267,   478,   230,   325,   105,   465,   162,    28,
     282,   380,    60,   494,    61,   471,   344,   498,   220,   579,
     574,   313,   226,   229,    21,   141,   161,   268,    19,   244,
       4,   289,   179,    49,   351,   358,   179,   241,   179,   179,
     363,   245,   221,    28,   290,   247,   352,   359,   440,   161,
     215,   443,   537,   179,   179,   496,   103,   497,    21,   497,
      26,   248,   593,   594,    22,   242,    28,   392,   579,   288,
      52,   387,   105,   219,   601,   602,    26,   244,    23,   230,
     605,   499,   361,    36,   244,   167,   233,   459,   406,    33,
     461,   141,   536,   392,   168,   531,   245,   460,   284,   285,
     286,   287,    26,   532,   142,   391,   281,   250,   233,    29,
     340,   343,   231,   255,   103,   288,   251,   392,   546,   380,
     167,   547,   255,   460,   260,   261,   179,   380,   179,   168,
     283,   270,   530,   143,   404,    32,   250,    41,   556,   360,
     262,    43,   592,   232,   233,   251,   234,   103,    33,   263,
    -177,   486,   235,  -177,   596,   103,   366,   344,  -177,   453,
      49,  -176,   179,   105,  -176,   304,   305,   306,   214,  -176,
     142,   324,    49,   288,   169,   510,   170,   236,   237,   347,
     581,   171,   141,   336,   411,   412,   413,   414,   205,   360,
     179,   179,   -16,   486,   486,   217,   148,   373,   141,   143,
      32,   362,    28,   217,   206,   486,   486,   161,   -17,   525,
     -16,   486,   217,   217,   238,   380,   232,   233,   207,   234,
     222,   179,   179,   242,    28,   235,   231,   436,   252,  -364,
      34,    28,   254,   420,   421,   422,   255,   288,   161,   -16,
     264,    32,   441,   259,   217,  -365,   446,   179,   179,  -240,
     236,   237,  -240,   313,   405,    28,    32,   266,  -366,   217,
     265,   142,   148,    32,   233,   271,   339,   534,   535,   152,
     273,   538,   539,   403,   380,   409,   410,   142,   329,   160,
    -291,  -291,   550,    87,    88,    89,    90,    91,    92,    93,
     143,   276,    26,  -292,  -292,   502,   179,   277,   155,   325,
     309,   310,   311,   291,   292,   464,   143,   -16,   279,   232,
     233,   469,   234,   373,   493,   161,   307,   308,   235,   217,
     315,   161,   293,   161,   294,   179,   103,   295,   315,    32,
     233,   242,    28,   296,   572,   152,   319,   242,    28,   242,
      28,   320,   105,   415,   416,   417,   347,   321,   322,   495,
      28,   418,   419,   148,   246,   479,   297,   323,   337,   331,
     366,   141,   338,   339,   155,   141,   156,   349,   350,   148,
     353,   233,   364,   382,   368,   365,   370,   315,   381,   424,
     347,   179,   388,   179,   389,   298,   241,   509,    28,   385,
     299,   300,   301,   302,   303,   390,   179,   423,   513,   141,
     426,   464,   427,   430,   431,   179,  -217,   437,   447,   439,
     450,   161,   160,   448,   451,   103,    87,    88,    89,    90,
      91,    92,    93,   452,   454,    26,   152,   242,    28,   458,
     157,   105,   156,   466,   564,     5,     6,     7,     8,     9,
     142,   500,   152,   467,   142,    10,    11,    12,    13,   103,
     141,   505,   501,   507,   516,   155,   508,   520,   523,   526,
     464,   527,   347,   541,   585,   324,   528,   509,    28,   143,
     161,   155,   529,   143,   533,   540,    14,   179,   142,    15,
     542,   141,   543,   544,   103,   545,   242,    28,  -151,   549,
     -17,   555,   551,   558,   562,   580,   157,   563,   179,   179,
     105,   347,   347,   565,   566,   160,   347,   143,   347,    87,
      88,    89,    90,    91,    92,    93,   567,   568,    26,   141,
     141,   141,   582,   156,   569,   141,   583,   141,   584,   142,
     586,   587,   148,   588,   589,   598,   148,   591,    28,   156,
     179,   590,   599,   347,   347,   179,   179,   347,   600,   604,
     396,    44,    51,   384,   444,   347,   347,   347,   143,   524,
     142,   347,   141,   141,   470,   561,   141,   383,   253,   475,
     148,   573,   603,   243,   141,   141,   141,   210,   477,   434,
     141,     5,     6,     7,    47,     9,   433,   157,   435,   143,
     554,    10,    11,    12,    13,   514,   548,   552,   142,   142,
     142,   400,   521,   157,   142,   152,   142,  -100,   402,   152,
    -100,  -100,  -100,  -100,  -100,  -100,  -100,  -100,   560,   399,
    -100,   148,    14,   401,     0,    48,   345,   143,   143,   143,
       0,    49,    50,   143,   155,   143,     0,     0,   155,     0,
       0,   142,   142,   152,     0,   142,     0,     0,     0,     0,
       0,     0,   148,   142,   142,   142,     0,     0,     0,   142,
       0,     0,     0,     0,     0,     0,   232,   233,   395,   234,
     143,   143,   155,     0,   143,   235,     0,     0,     0,  -364,
     392,     0,   143,   143,   143,     0,     0,     0,   143,     0,
     148,   148,   148,     0,   152,     0,   148,   348,   148,     0,
     236,   237,   156,     0,    20,     0,   156,     5,     6,     7,
       8,     9,     0,     0,     0,     0,     0,    10,    11,    12,
      13,     0,     0,   155,     0,   152,     0,     0,     0,     0,
       0,     0,     0,   148,   148,     0,     0,   148,     0,     0,
     156,     0,     0,     0,     0,   148,   148,   148,    14,   227,
     227,   148,     0,     0,   155,     0,     0,     0,     0,     0,
       0,     0,     0,   152,   152,   152,   157,     0,     0,   152,
     157,   152,     0,     0,     0,   180,     0,     0,     0,   209,
       0,     0,   213,     0,     0,     0,     0,     0,     0,     0,
       0,   156,   155,   155,   155,     0,   223,   224,   155,     0,
     155,     0,   228,   228,   157,     0,   152,   152,     0,     0,
     152,     0,     0,     0,     0,     0,     0,     0,   152,   152,
     152,     0,   156,     0,   152,   227,   227,   227,   227,     0,
       0,     0,     0,     0,     0,   155,   155,     0,     0,   155,
       0,     0,     0,     0,     0,     0,     0,   155,   155,   155,
       0,     0,     0,   155,     0,   157,     0,     0,   241,     0,
     156,   156,   156,     0,   484,   330,   156,     0,   156,   278,
       0,   280,     0,   223,     0,     0,     0,     0,   228,   228,
     228,   228,     0,     0,   160,     0,   157,    86,    87,    88,
      89,    90,    91,    92,    93,     0,     0,    26,   503,     0,
       0,     0,     0,   156,   156,   312,     0,   156,     0,     0,
       0,     0,     0,     0,     0,   156,   156,   156,   228,     0,
       0,   156,     0,     0,   157,   157,   157,     0,     0,     0,
     157,     0,   157,   354,   357,     0,     0,     0,     0,     0,
       0,     0,     0,   227,   227,   227,   227,   227,     0,   227,
     227,   227,   227,   227,   227,   227,   227,   227,   227,   227,
     227,   227,   227,     0,   371,   372,     0,   157,   157,     0,
       0,   157,     0,     0,     0,     0,     0,     0,     0,   157,
     157,   157,     0,     0,     0,   157,     0,     0,     0,     0,
     397,   398,     0,     0,     0,     0,   228,   228,   228,   228,
     228,   313,   228,   228,   228,   228,   228,   228,   228,   228,
     228,   228,   228,   228,   228,   228,     0,     0,     0,   348,
     575,     0,     0,     0,   576,     0,     0,   160,     0,     0,
      86,    87,    88,    89,    90,    91,    92,    93,     0,   438,
      26,   227,   227,     0,     0,     0,   227,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   484,   503,     0,     0,   597,     0,     0,   457,     0,
       0,     0,     0,   575,   576,     0,     0,     0,     0,   597,
       0,     0,     0,     0,     0,     0,     0,    62,    63,    64,
      65,    66,    67,    68,   228,   228,    69,     0,     0,   228,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    72,    73,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,   504,     0,     0,   172,    85,     0,
       0,    87,    88,    89,    90,    91,    92,    93,     0,   457,
      26,     0,     0,   173,     0,     0,   337,   227,   522,     0,
     227,     0,   227,    97,     0,     0,     0,     0,     0,   330,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,   174,   175,     0,     0,     0,    98,    99,   176,   177,
       0,     0,     0,    62,    63,    64,    65,    66,    67,    68,
       0,     0,    69,     0,     0,     0,     0,     0,     0,     0,
     228,     0,     0,   228,     0,   228,     0,    72,    73,     0,
       0,     0,   228,    62,    63,    64,    65,    66,    67,    68,
     438,     0,    69,   172,    85,     0,     0,    87,    88,    89,
      90,    91,    92,    93,     0,     0,    26,    72,    73,   173,
       0,   570,   571,   439,     0,     0,     0,     0,     0,    97,
       0,     0,     0,   172,    85,     0,     0,    87,    88,    89,
      90,    91,    92,    93,     0,     0,    26,   174,   175,   173,
       0,     0,    98,    99,   176,   177,     0,     0,     0,    97,
       0,     0,     0,   457,     0,     0,     0,     0,   595,     0,
      62,    63,    64,    65,    66,    67,    68,   174,   175,    69,
       0,     0,    98,    99,   176,   177,     0,     0,     0,     0,
       0,     0,     0,     0,    72,    73,     0,    62,    63,    64,
      65,    66,    67,    68,     0,     0,    69,     0,     0,     0,
      84,    85,     0,     0,    87,    88,    89,    90,    91,    92,
      93,    72,    73,    26,     0,     0,   173,     0,     0,     0,
       0,     0,     0,     0,     0,     0,    97,   172,    85,     0,
       0,    87,    88,    89,    90,    91,    92,    93,     0,     0,
      26,     0,     0,   173,   174,   175,     0,     0,     0,    98,
      99,   176,   177,     0,     0,     0,    62,    63,    64,    65,
      66,    67,    68,     0,     0,    69,     0,     0,     0,     0,
       0,   174,   175,     0,     0,     0,    98,    99,   176,   177,
      72,    73,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   172,    85,     0,     0,
      87,    88,    89,    90,    91,    92,    93,     0,     0,    26,
       0,     0,   173,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    62,
      63,    64,    65,    66,    67,    68,     0,     0,    69,     5,
       6,     7,     8,    70,     0,     0,     0,   176,   177,    10,
      11,    71,    13,    72,    73,     0,    74,     0,    75,    76,
      77,    78,    79,    80,    81,    82,    83,     0,     0,    84,
      85,     0,    86,    87,    88,    89,    90,    91,    92,    93,
      14,     0,    94,    95,     0,    96,     0,     0,     0,    49,
       0,     0,     0,     0,     0,    97,     0,     0,     0,     0,
      62,    63,    64,    65,    66,    67,    68,     0,     0,   472,
       5,     6,     7,     8,    70,     0,     0,     0,    98,    99,
      10,    11,    71,    13,    72,   473,     0,    74,     0,    75,
      76,    77,    78,    79,    80,    81,    82,    83,     0,     0,
      84,    85,     0,    86,    87,    88,    89,    90,    91,    92,
      93,    14,     0,    94,    95,     0,    96,     0,     0,     0,
      49,     0,     0,     0,     0,     0,    97,     0,     0,    62,
      63,    64,    65,    66,    67,    68,     0,     0,    69,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    98,
      99,   346,     0,    72,    73,     0,    74,     0,    75,    76,
      77,    78,    79,    80,    81,    82,    83,     0,     0,   172,
      85,     0,     0,    87,    88,    89,    90,    91,    92,    93,
       0,     0,    94,    95,     0,    96,     0,     0,     0,    49,
       0,     0,     0,     0,     0,    97,     0,     0,    62,    63,
      64,    65,    66,    67,    68,     0,     0,    69,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,    98,    99,
     346,     0,    72,    73,     0,   480,     0,    75,   481,   482,
      78,    79,    80,    81,    82,    83,     0,     0,   172,    85,
       0,     0,    87,    88,    89,    90,    91,    92,    93,     0,
       0,   483,    95,     0,    96,     0,     0,     0,    49,     0,
       0,     0,     0,     0,    97,    62,    63,    64,    65,    66,
      67,    68,     0,     0,    69,     0,     0,     0,     0,   313,
       0,     0,     0,     0,     0,     0,     0,    98,    99,    72,
      73,     0,    62,    63,    64,    65,    66,    67,    68,     0,
       0,    69,     0,     0,     0,    84,    85,     0,    86,    87,
      88,    89,    90,    91,    92,    93,    72,    73,    26,     0,
       0,    96,     0,     0,     0,     0,     0,     0,     0,     0,
       0,    97,   172,    85,     0,     0,    87,    88,    89,    90,
      91,    92,    93,     0,     0,    26,     0,     0,    96,     0,
       0,     0,     0,     0,    98,    99,     0,     0,    97,    62,
      63,    64,    65,    66,    67,    68,     0,     0,    69,     0,
       0,     0,     0,   313,     0,     0,     0,     0,     0,     0,
       0,    98,    99,    72,    73,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    84,
      85,     0,    86,    87,    88,    89,    90,    91,    92,    93,
       0,     0,    26,    20,     0,    96,     5,     6,     7,     8,
       9,     0,     0,     0,     0,     0,    10,    11,    12,    13,
     159,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,     0,     0,   160,     0,     0,     0,
      87,    88,    89,    90,    91,    92,    93,    14,     0,    26
};

static const yytype_int16 yycheck[] =
{
      23,    23,    51,   206,   214,    84,    29,    29,   109,   110,
      49,   426,    51,    36,    36,   105,   389,   206,   439,   373,
      43,    43,   163,   385,   103,   214,    49,   374,    51,    51,
     173,   266,    45,   391,    47,   382,   221,   395,    85,   551,
     544,    17,    98,    99,    17,    49,    85,    57,     3,    44,
       0,    57,    75,    63,    44,    44,    79,    17,    81,    82,
     245,    56,    85,    85,    70,    12,    56,    56,   340,   108,
      83,   343,    12,    96,    97,    60,   115,   394,    51,   396,
      56,    28,   586,   587,    56,   108,   108,    72,   600,   179,
      45,   276,   115,   172,   598,   599,    56,    44,    11,   178,
     604,    60,   243,    22,    44,    58,    59,    56,   297,    56,
     464,   115,   474,    72,    67,   469,    56,    66,   174,   175,
     176,   177,    56,   470,    49,    60,   173,    58,    59,    21,
     220,   221,    67,    56,   173,   225,    67,    72,   496,   374,
      58,   499,    56,    66,    92,    93,   169,   382,   171,    67,
     173,   164,    66,    49,   297,    58,    58,    63,   512,   238,
      58,    65,   583,    58,    59,    67,    61,   206,    56,    67,
      57,   544,    67,    60,   589,   214,   255,   362,    65,   364,
      63,    57,   205,   206,    60,    84,    85,    86,    59,    65,
     115,   214,    63,   283,    59,   430,    58,    92,    93,   222,
     554,    59,   206,   216,   300,   301,   302,   303,    59,   288,
     233,   234,    58,   586,   587,    61,    49,   266,   222,   115,
      58,   244,   244,    61,    59,   598,   599,   266,    56,    58,
      58,   604,    61,    61,   324,   470,    58,    59,    56,    61,
      70,   264,   265,   266,   266,    67,    67,   337,    64,    71,
     273,   273,    57,   309,   310,   311,    56,   347,   297,    56,
      61,    58,   341,    57,    61,    71,   345,   290,   291,    57,
      92,    93,    60,    17,   297,   297,    58,    59,    71,    61,
      71,   206,   115,    58,    59,    56,    61,   472,   473,    49,
      55,   476,   477,   296,   529,   298,   299,   222,   508,    43,
      92,    93,   505,    47,    48,    49,    50,    51,    52,    53,
     206,    56,    56,    92,    93,   405,   339,    56,    49,   508,
      89,    90,    91,    73,    74,   374,   222,    56,    10,    58,
      59,   380,    61,   382,   390,   374,    87,    88,    67,    61,
     543,   380,    75,   382,    76,   368,   385,    77,   551,    58,
      59,   374,   374,    72,   543,   115,    57,   380,   380,   382,
     382,    57,   385,   304,   305,   306,   389,    57,    57,   392,
     392,   307,   308,   206,   475,   388,    45,    57,    62,    41,
     459,   385,    58,    61,   115,   389,    49,    60,    58,   222,
      10,    59,    56,    59,    69,    56,    56,   600,    57,    70,
     423,   424,    60,   426,    60,    74,    17,   430,   430,    63,
      79,    80,    81,    82,    83,    60,   439,    60,   431,   423,
      57,   470,    57,    59,    42,   448,    42,    10,    10,    63,
      60,   470,    43,    65,    62,   474,    47,    48,    49,    50,
      51,    52,    53,    58,    65,    56,   206,   470,   470,    62,
      49,   474,   115,    65,   533,    13,    14,    15,    16,    17,
     385,    57,   222,    60,   389,    23,    24,    25,    26,   508,
     474,    65,    70,    60,    62,   206,    57,    61,    10,    56,
     529,    28,   505,    59,   563,   508,    60,   510,   510,   385,
     529,   222,    65,   389,    60,    64,    54,   520,   423,    57,
      59,   505,    59,    70,   543,    31,   529,   529,    31,    60,
      56,    60,    57,    65,    56,    76,   115,    60,   541,   542,
     543,   544,   545,    57,    57,    43,   549,   423,   551,    47,
      48,    49,    50,    51,    52,    53,    64,    57,    56,   543,
     544,   545,   555,   206,    57,   549,    65,   551,    64,   474,
      60,    60,   385,    70,    57,    31,   389,   580,   580,   222,
     583,    60,    60,   586,   587,   588,   589,   590,    57,    60,
     283,    40,    45,   273,   344,   598,   599,   600,   474,   454,
     505,   604,   586,   587,   382,   529,   590,   272,   115,   385,
     423,   543,   600,   108,   598,   599,   600,    80,   385,   336,
     604,    13,    14,    15,    16,    17,   333,   206,   336,   505,
     510,    23,    24,    25,    26,   434,   501,   508,   543,   544,
     545,   293,   442,   222,   549,   385,   551,    43,   295,   389,
      46,    47,    48,    49,    50,    51,    52,    53,   522,   292,
      56,   474,    54,   294,    -1,    57,   221,   543,   544,   545,
      -1,    63,    64,   549,   385,   551,    -1,    -1,   389,    -1,
      -1,   586,   587,   423,    -1,   590,    -1,    -1,    -1,    -1,
      -1,    -1,   505,   598,   599,   600,    -1,    -1,    -1,   604,
      -1,    -1,    -1,    -1,    -1,    -1,    58,    59,    60,    61,
     586,   587,   423,    -1,   590,    67,    -1,    -1,    -1,    71,
      72,    -1,   598,   599,   600,    -1,    -1,    -1,   604,    -1,
     543,   544,   545,    -1,   474,    -1,   549,   222,   551,    -1,
      92,    93,   385,    -1,    10,    -1,   389,    13,    14,    15,
      16,    17,    -1,    -1,    -1,    -1,    -1,    23,    24,    25,
      26,    -1,    -1,   474,    -1,   505,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   586,   587,    -1,    -1,   590,    -1,    -1,
     423,    -1,    -1,    -1,    -1,   598,   599,   600,    54,    98,
      99,   604,    -1,    -1,   505,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   543,   544,   545,   385,    -1,    -1,   549,
     389,   551,    -1,    -1,    -1,    75,    -1,    -1,    -1,    79,
      -1,    -1,    82,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   474,   543,   544,   545,    -1,    96,    97,   549,    -1,
     551,    -1,    98,    99,   423,    -1,   586,   587,    -1,    -1,
     590,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   598,   599,
     600,    -1,   505,    -1,   604,   174,   175,   176,   177,    -1,
      -1,    -1,    -1,    -1,    -1,   586,   587,    -1,    -1,   590,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,   598,   599,   600,
      -1,    -1,    -1,   604,    -1,   474,    -1,    -1,    17,    -1,
     543,   544,   545,    -1,   389,   214,   549,    -1,   551,   169,
      -1,   171,    -1,   173,    -1,    -1,    -1,    -1,   174,   175,
     176,   177,    -1,    -1,    43,    -1,   505,    46,    47,    48,
      49,    50,    51,    52,    53,    -1,    -1,    56,   423,    -1,
      -1,    -1,    -1,   586,   587,   205,    -1,   590,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,   598,   599,   600,   214,    -1,
      -1,   604,    -1,    -1,   543,   544,   545,    -1,    -1,    -1,
     549,    -1,   551,   233,   234,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,   292,   293,   294,   295,   296,    -1,   298,
     299,   300,   301,   302,   303,   304,   305,   306,   307,   308,
     309,   310,   311,    -1,   264,   265,    -1,   586,   587,    -1,
      -1,   590,    -1,    -1,    -1,    -1,    -1,    -1,    -1,   598,
     599,   600,    -1,    -1,    -1,   604,    -1,    -1,    -1,    -1,
     290,   291,    -1,    -1,    -1,    -1,   292,   293,   294,   295,
     296,    17,   298,   299,   300,   301,   302,   303,   304,   305,
     306,   307,   308,   309,   310,   311,    -1,    -1,    -1,   544,
     545,    -1,    -1,    -1,   549,    -1,    -1,    43,    -1,    -1,
      46,    47,    48,    49,    50,    51,    52,    53,    -1,   339,
      56,   390,   391,    -1,    -1,    -1,   395,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,   586,   587,    -1,    -1,   590,    -1,    -1,   368,    -1,
      -1,    -1,    -1,   598,   599,    -1,    -1,    -1,    -1,   604,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,     4,     5,
       6,     7,     8,     9,   390,   391,    12,    -1,    -1,   395,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    27,    28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,   424,    -1,    -1,    43,    44,    -1,
      -1,    47,    48,    49,    50,    51,    52,    53,    -1,   439,
      56,    -1,    -1,    59,    -1,    -1,    62,   496,   448,    -1,
     499,    -1,   501,    69,    -1,    -1,    -1,    -1,    -1,   508,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    87,    88,    -1,    -1,    -1,    92,    93,    94,    95,
      -1,    -1,    -1,     3,     4,     5,     6,     7,     8,     9,
      -1,    -1,    12,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
     496,    -1,    -1,   499,    -1,   501,    -1,    27,    28,    -1,
      -1,    -1,   508,     3,     4,     5,     6,     7,     8,     9,
     520,    -1,    12,    43,    44,    -1,    -1,    47,    48,    49,
      50,    51,    52,    53,    -1,    -1,    56,    27,    28,    59,
      -1,   541,   542,    63,    -1,    -1,    -1,    -1,    -1,    69,
      -1,    -1,    -1,    43,    44,    -1,    -1,    47,    48,    49,
      50,    51,    52,    53,    -1,    -1,    56,    87,    88,    59,
      -1,    -1,    92,    93,    94,    95,    -1,    -1,    -1,    69,
      -1,    -1,    -1,   583,    -1,    -1,    -1,    -1,   588,    -1,
       3,     4,     5,     6,     7,     8,     9,    87,    88,    12,
      -1,    -1,    92,    93,    94,    95,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    27,    28,    -1,     3,     4,     5,
       6,     7,     8,     9,    -1,    -1,    12,    -1,    -1,    -1,
      43,    44,    -1,    -1,    47,    48,    49,    50,    51,    52,
      53,    27,    28,    56,    -1,    -1,    59,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    69,    43,    44,    -1,
      -1,    47,    48,    49,    50,    51,    52,    53,    -1,    -1,
      56,    -1,    -1,    59,    87,    88,    -1,    -1,    -1,    92,
      93,    94,    95,    -1,    -1,    -1,     3,     4,     5,     6,
       7,     8,     9,    -1,    -1,    12,    -1,    -1,    -1,    -1,
      -1,    87,    88,    -1,    -1,    -1,    92,    93,    94,    95,
      27,    28,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    43,    44,    -1,    -1,
      47,    48,    49,    50,    51,    52,    53,    -1,    -1,    56,
      -1,    -1,    59,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,     3,
       4,     5,     6,     7,     8,     9,    -1,    -1,    12,    13,
      14,    15,    16,    17,    -1,    -1,    -1,    94,    95,    23,
      24,    25,    26,    27,    28,    -1,    30,    -1,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    -1,    -1,    43,
      44,    -1,    46,    47,    48,    49,    50,    51,    52,    53,
      54,    -1,    56,    57,    -1,    59,    -1,    -1,    -1,    63,
      -1,    -1,    -1,    -1,    -1,    69,    -1,    -1,    -1,    -1,
       3,     4,     5,     6,     7,     8,     9,    -1,    -1,    12,
      13,    14,    15,    16,    17,    -1,    -1,    -1,    92,    93,
      23,    24,    25,    26,    27,    28,    -1,    30,    -1,    32,
      33,    34,    35,    36,    37,    38,    39,    40,    -1,    -1,
      43,    44,    -1,    46,    47,    48,    49,    50,    51,    52,
      53,    54,    -1,    56,    57,    -1,    59,    -1,    -1,    -1,
      63,    -1,    -1,    -1,    -1,    -1,    69,    -1,    -1,     3,
       4,     5,     6,     7,     8,     9,    -1,    -1,    12,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    92,
      93,    25,    -1,    27,    28,    -1,    30,    -1,    32,    33,
      34,    35,    36,    37,    38,    39,    40,    -1,    -1,    43,
      44,    -1,    -1,    47,    48,    49,    50,    51,    52,    53,
      -1,    -1,    56,    57,    -1,    59,    -1,    -1,    -1,    63,
      -1,    -1,    -1,    -1,    -1,    69,    -1,    -1,     3,     4,
       5,     6,     7,     8,     9,    -1,    -1,    12,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    92,    93,
      25,    -1,    27,    28,    -1,    30,    -1,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    -1,    -1,    43,    44,
      -1,    -1,    47,    48,    49,    50,    51,    52,    53,    -1,
      -1,    56,    57,    -1,    59,    -1,    -1,    -1,    63,    -1,
      -1,    -1,    -1,    -1,    69,     3,     4,     5,     6,     7,
       8,     9,    -1,    -1,    12,    -1,    -1,    -1,    -1,    17,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    92,    93,    27,
      28,    -1,     3,     4,     5,     6,     7,     8,     9,    -1,
      -1,    12,    -1,    -1,    -1,    43,    44,    -1,    46,    47,
      48,    49,    50,    51,    52,    53,    27,    28,    56,    -1,
      -1,    59,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    69,    43,    44,    -1,    -1,    47,    48,    49,    50,
      51,    52,    53,    -1,    -1,    56,    -1,    -1,    59,    -1,
      -1,    -1,    -1,    -1,    92,    93,    -1,    -1,    69,     3,
       4,     5,     6,     7,     8,     9,    -1,    -1,    12,    -1,
      -1,    -1,    -1,    17,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    92,    93,    27,    28,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    43,
      44,    -1,    46,    47,    48,    49,    50,    51,    52,    53,
      -1,    -1,    56,    10,    -1,    59,    13,    14,    15,    16,
      17,    -1,    -1,    -1,    -1,    -1,    23,    24,    25,    26,
      27,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,    -1,
      -1,    -1,    -1,    -1,    -1,    -1,    43,    -1,    -1,    -1,
      47,    48,    49,    50,    51,    52,    53,    54,    -1,    56
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_int16 yystos[] =
{
       0,   109,   110,   111,     0,    13,    14,    15,    16,    17,
      23,    24,    25,    26,    54,    57,   112,   113,   114,   115,
      10,   114,    56,    11,   116,   117,    56,   106,   160,    21,
     118,   119,    58,    56,   106,   108,    22,   120,   121,   107,
     106,    63,   122,    65,   107,   125,   106,    16,    57,    63,
      64,   113,   115,   124,   126,   127,   135,   152,   153,   154,
     168,   168,     3,     4,     5,     6,     7,     8,     9,    12,
      17,    25,    27,    28,    30,    32,    33,    34,    35,    36,
      37,    38,    39,    40,    43,    44,    46,    47,    48,    49,
      50,    51,    52,    53,    56,    57,    59,    69,    92,    93,
      97,    98,    99,   100,   101,   106,   115,   134,   148,   158,
     160,   161,   168,   169,   170,   171,   172,   173,   174,   175,
     176,   178,   179,   180,   182,   183,   184,   185,   187,   188,
     190,   192,   200,   202,   204,   205,   206,   208,   209,   210,
     219,   243,   244,   246,   247,   248,   249,   250,   251,   252,
     256,   257,   258,   259,   260,   264,   265,   268,   269,    27,
      43,   100,   106,   134,   136,   137,   155,    58,    67,    59,
      58,    59,    43,    59,    87,    88,    94,    95,   100,   106,
     229,   230,   231,   232,   233,   234,   235,   236,   237,   238,
     239,   240,   241,   242,   243,   244,   245,   246,   251,   258,
     264,   265,   266,   267,   268,    59,    59,    56,   203,   229,
     203,   207,   229,   229,    59,   168,   221,    61,   102,   103,
      99,   106,    70,   229,   229,   106,   242,   256,   257,   242,
     103,    67,    58,    59,    61,    67,    92,    93,   102,   103,
     162,    17,   106,   175,    44,    56,   252,    12,    28,   252,
      58,    67,    64,   170,    57,    56,   128,   130,   131,    57,
      92,    93,    58,    67,    61,    71,    59,   128,    57,   151,
     168,    56,   138,    55,   149,   150,    56,    56,   229,    10,
     229,    99,   101,   106,   242,   242,   242,   242,   102,    57,
      70,    73,    74,    75,    76,    77,    72,    45,    74,    79,
      80,    81,    82,    83,    84,    85,    86,    87,    88,    89,
      90,    91,   229,    17,   174,   183,   194,   196,   198,    57,
      57,    57,    57,    57,   106,   174,   223,   225,   226,   247,
     256,    41,   211,   212,   213,   214,   168,    62,    58,    61,
     102,   261,   263,   102,   162,   261,    25,   106,   176,    60,
      58,    44,    56,    10,   229,   253,   254,   229,    44,    56,
     103,   128,   106,   162,    56,    56,   103,   129,    69,   132,
      56,   229,   229,   134,   139,   140,   143,   144,   145,   147,
     148,    57,    59,   150,   108,    63,   156,   162,    60,    60,
      60,    60,    72,   104,   105,    60,   105,   229,   229,   233,
     234,   235,   236,   237,   101,   106,   174,   227,   228,   237,
     237,   239,   239,   239,   239,   240,   240,   240,   241,   241,
     242,   242,   242,    60,    70,   199,    57,    57,   222,   224,
      59,    42,   218,   214,   211,   213,   102,    10,   229,    63,
     163,   103,   262,   163,   122,   123,   103,    10,    65,   255,
      60,    62,    58,   162,    65,   133,   163,   229,    62,    56,
      66,   131,   141,   142,   134,   144,    65,    60,   146,   134,
     139,   144,    12,    28,   157,   158,   159,   161,   169,   168,
      30,    33,    34,    56,   176,   177,   178,   181,   186,   189,
     191,   193,   201,   242,   245,   106,    60,   104,   245,    60,
      57,    70,   102,   176,   229,    65,   207,    60,    57,   106,
     148,   215,   216,   168,   218,   220,    62,   133,   166,   167,
      61,   263,   229,    10,   130,    58,    56,    28,    60,    65,
      66,   131,   144,    60,   162,   162,   169,    12,   162,   162,
      64,    59,    59,    59,    70,    31,   245,   245,   231,    60,
     183,    57,   225,   217,   216,    60,   131,   165,    65,   164,
     255,   145,    56,    60,   103,    57,    57,    64,    57,    57,
     229,   229,   174,   194,   177,   176,   176,   195,   197,   198,
      76,   131,   168,    65,    64,   103,    60,    60,    70,    57,
      60,   106,   133,   177,   177,   229,   207,   176,    31,    60,
      57,   177,   177,   195,    60,   177
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_int16 yyr1[] =
{
       0,    96,    97,    97,    97,    97,    97,    98,    98,    99,
      99,   100,   100,   101,   102,   102,   103,   103,   104,   105,
     105,   106,   106,   107,   107,   108,   109,   110,   111,   111,
     112,   112,   113,   113,   114,   114,   114,   114,   114,   114,
     114,   114,   114,   114,   115,   116,   117,   117,   118,   119,
     119,   120,   121,   121,   122,   123,   123,   124,   124,   124,
     124,   125,   125,   126,   126,   126,   126,   127,   128,   129,
     129,   130,   131,   132,   132,   133,   133,   134,   134,   135,
     136,   137,   137,   138,   138,   139,   140,   141,   142,   142,
     143,   144,   144,   145,   145,   145,   146,   146,   147,   147,
     148,   148,   149,   150,   150,   151,   151,   152,   153,   154,
     155,   155,   156,   156,   157,   157,   157,   157,   158,   159,
     160,   161,   162,   163,   164,   164,   165,   165,   166,   167,
     167,   168,   169,   169,   170,   170,   171,   171,   171,   172,
     173,   174,   174,   175,   175,   176,   176,   176,   176,   176,
     176,   177,   177,   177,   177,   177,   178,   178,   178,   178,
     178,   178,   178,   178,   178,   178,   178,   179,   180,   181,
     182,   183,   183,   183,   183,   183,   183,   183,   184,   185,
     186,   187,   187,   188,   189,   190,   190,   191,   191,   192,
     193,   194,   194,   195,   195,   196,   196,   197,   198,   199,
     199,   200,   201,   202,   203,   203,   204,   205,   206,   207,
     207,   208,   209,   210,   210,   210,   211,   211,   212,   212,
     213,   214,   215,   215,   216,   217,   217,   218,   219,   220,
     220,   221,   222,   222,   223,   224,   224,   225,   225,   226,
     226,   227,   228,   229,   230,   230,   231,   231,   232,   232,
     233,   233,   234,   234,   235,   235,   236,   236,   237,   237,
     237,   238,   238,   238,   238,   238,   238,   239,   239,   239,
     239,   240,   240,   240,   241,   241,   241,   241,   242,   242,
     242,   242,   242,   243,   244,   245,   245,   245,   245,   245,
     246,   246,   246,   247,   247,   248,   248,   248,   248,   248,
     248,   248,   248,   248,   248,   249,   249,   249,   249,   249,
     249,   249,   250,   250,   250,   250,   250,   251,   251,   251,
     252,   253,   253,   254,   255,   255,   256,   256,   256,   257,
     257,   258,   258,   258,   258,   259,   259,   259,   259,   259,
     259,   259,   260,   260,   260,   260,   261,   262,   262,   263,
     264,   264,   265,   265,   266,   266,   266,   266,   266,   267,
     267,   267,   268,   268,   269,   269,   269
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_int8 yyr2[] =
{
       0,     2,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     2,     2,     3,     0,     1,     2,     1,
       2,     2,     1,     0,     3,     2,     1,     1,     0,     2,
       1,     1,     1,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     7,     2,     0,     1,     2,     0,
       1,     3,     0,     1,     3,     0,     1,     1,     1,     1,
       1,     0,     2,     1,     1,     1,     1,     4,     2,     0,
       3,     2,     2,     0,     2,     1,     1,     1,     2,     3,
       3,     1,     1,     5,     6,     2,     3,     2,     0,     1,
       2,     0,     1,     3,     1,     2,     0,     3,     4,     3,
       1,     2,     2,     0,     1,     1,     1,     1,     2,     4,
       4,     5,     3,     4,     3,     3,     3,     3,     2,     2,
       2,     2,     3,     4,     0,     1,     0,     3,     2,     0,
       1,     3,     0,     1,     1,     2,     1,     1,     1,     1,
       2,     3,     2,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     3,     3,
       2,     1,     1,     1,     1,     1,     1,     1,     5,     7,
       7,     3,     5,     5,     5,     1,     1,     1,     1,     9,
       9,     0,     1,     0,     1,     1,     1,     1,     2,     0,
       3,     7,     7,     3,     0,     1,     3,     3,     3,     0,
       1,     3,     5,     3,     4,     1,     0,     1,     1,     2,
       1,     5,     3,     2,     2,     0,     3,     2,     5,     0,
       1,     4,     0,     1,     2,     0,     3,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     5,     1,     3,
       1,     3,     1,     3,     1,     3,     1,     3,     1,     3,
       3,     1,     3,     3,     3,     3,     1,     1,     3,     3,
       3,     1,     3,     3,     1,     3,     3,     3,     1,     1,
       2,     2,     1,     2,     2,     1,     1,     2,     2,     1,
       1,     1,     1,     1,     1,     1,     1,     1,     2,     3,
       1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     3,     5,     4,     4,     3,     1,     2,     2,
       4,     0,     1,     2,     0,     3,     2,     3,     3,     4,
       4,     2,     3,     4,     4,     3,     3,     3,     3,     3,
       3,     3,     4,     4,     4,     4,     2,     0,     2,     3,
       2,     2,     2,     2,     4,     4,     5,     5,     4,     3,
       3,     3,     3,     2,     1,     1,     1
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                    \
  do                                                              \
    if (yychar == YYEMPTY)                                        \
      {                                                           \
        yychar = (Token);                                         \
        yylval = (Value);                                         \
        YYPOPSTACK (yylen);                                       \
        yystate = *yyssp;                                         \
        goto yybackup;                                            \
      }                                                           \
    else                                                          \
      {                                                           \
        yyerror (YY_("syntax error: cannot back up")); \
        YYERROR;                                                  \
      }                                                           \
  while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*-----------------------------------.
| Print this symbol's value on YYO.  |
`-----------------------------------*/

static void
yy_symbol_value_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyoutput = yyo;
  YYUSE (yyoutput);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyo, yytoknum[yytype], *yyvaluep);
# endif
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}


/*---------------------------.
| Print this symbol on YYO.  |
`---------------------------*/

static void
yy_symbol_print (FILE *yyo, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyo, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyo, yytype, yyvaluep);
  YYFPRINTF (yyo, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yy_state_t *yybottom, yy_state_t *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yy_state_t *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %d):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[+yyssp[yyi + 1 - yynrhs]],
                       &yyvsp[(yyi + 1) - (yynrhs)]
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen(S) (YY_CAST (YYPTRDIFF_T, strlen (S)))
#  else
/* Return the length of YYSTR.  */
static YYPTRDIFF_T
yystrlen (const char *yystr)
{
  YYPTRDIFF_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYPTRDIFF_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYPTRDIFF_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            else
              goto append;

          append:
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (yyres)
    return yystpcpy (yyres, yystr) - yyres;
  else
    return yystrlen (yystr);
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYPTRDIFF_T *yymsg_alloc, char **yymsg,
                yy_state_t *yyssp, int yytoken)
{
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat: reported tokens (one for the "unexpected",
     one per "expected"). */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Actual size of YYARG. */
  int yycount = 0;
  /* Cumulated lengths of YYARG.  */
  YYPTRDIFF_T yysize = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[+*yyssp];
      YYPTRDIFF_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
      yysize = yysize0;
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYPTRDIFF_T yysize1
                    = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
                    yysize = yysize1;
                  else
                    return 2;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
    default: /* Avoid compiler warnings. */
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    /* Don't count the "%s"s in the final size, but reserve room for
       the terminator.  */
    YYPTRDIFF_T yysize1 = yysize + (yystrlen (yyformat) - 2 * yycount) + 1;
    if (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM)
      yysize = yysize1;
    else
      return 2;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          ++yyp;
          ++yyformat;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    yy_state_fast_t yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yy_state_t yyssa[YYINITDEPTH];
    yy_state_t *yyss;
    yy_state_t *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYPTRDIFF_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYPTRDIFF_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;


/*------------------------------------------------------------.
| yynewstate -- push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;


/*--------------------------------------------------------------------.
| yysetstate -- set current state (the top of the stack) to yystate.  |
`--------------------------------------------------------------------*/
yysetstate:
  YYDPRINTF ((stderr, "Entering state %d\n", yystate));
  YY_ASSERT (0 <= yystate && yystate < YYNSTATES);
  YY_IGNORE_USELESS_CAST_BEGIN
  *yyssp = YY_CAST (yy_state_t, yystate);
  YY_IGNORE_USELESS_CAST_END

  if (yyss + yystacksize - 1 <= yyssp)
#if !defined yyoverflow && !defined YYSTACK_RELOCATE
    goto yyexhaustedlab;
#else
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYPTRDIFF_T yysize = yyssp - yyss + 1;

# if defined yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        yy_state_t *yyss1 = yyss;
        YYSTYPE *yyvs1 = yyvs;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * YYSIZEOF (*yyssp),
                    &yyvs1, yysize * YYSIZEOF (*yyvsp),
                    &yystacksize);
        yyss = yyss1;
        yyvs = yyvs1;
      }
# else /* defined YYSTACK_RELOCATE */
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yy_state_t *yyss1 = yyss;
        union yyalloc *yyptr =
          YY_CAST (union yyalloc *,
                   YYSTACK_ALLOC (YY_CAST (YYSIZE_T, YYSTACK_BYTES (yystacksize))));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
# undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YY_IGNORE_USELESS_CAST_BEGIN
      YYDPRINTF ((stderr, "Stack size increased to %ld\n",
                  YY_CAST (long, yystacksize)));
      YY_IGNORE_USELESS_CAST_END

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }
#endif /* !defined yyoverflow && !defined YYSTACK_RELOCATE */

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;


/*-----------.
| yybackup.  |
`-----------*/
yybackup:
  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);
  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  /* Discard the shifted token.  */
  yychar = YYEMPTY;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
  case 26:
#line 98 "parser.y"
                                             {
        cout << "mathced da!" << endl;
    }
#line 2214 "parser.tab.c"
    break;


#line 2218 "parser.tab.c"

      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */
  {
    const int yylhs = yyr1[yyn] - YYNTOKENS;
    const int yyi = yypgoto[yylhs] + *yyssp;
    yystate = (0 <= yyi && yyi <= YYLAST && yycheck[yyi] == *yyssp
               ? yytable[yyi]
               : yydefgoto[yylhs]);
  }

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = YY_CAST (char *, YYSTACK_ALLOC (YY_CAST (YYSIZE_T, yymsg_alloc)));
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:
  /* Pacify compilers when the user code never invokes YYERROR and the
     label yyerrorlab therefore never appears in user code.  */
  if (0)
    YYERROR;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;


/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;


#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif


/*-----------------------------------------------------.
| yyreturn -- parsing is finished, return the result.  |
`-----------------------------------------------------*/
yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[+*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 670 "parser.y"


void yyerror(const char *error)
{
    printf("Line Number:%d, Error:%s\n", yylineno, error);
    exit(0);
}

int main(int argc, char* argv[]) {
    // if(argc != 2) {
    //     cout << "Usage: ./a.out <filename>" << endl;
    //     exit(0);
    // }

    // freopen(argv[1], "r", stdin);
    yyparse();
}
