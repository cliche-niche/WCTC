# WCTC: Who Compiles the Compiler
A compiler made as a part of the course project for the course [CS335: Compiler Design](https://www.cse.iitk.ac.in/users/swarnendu/courses/spring2023-cs335/) at IIT-K in 2022-23 II Sem. in a team of three (Soham [CrypthiccCrypto](https://github.com/CrypthiccCrypto) Samaddar, Janhvi [Janhvi-Rochwani](https://github.com/Janhvi-Rochwani) Rochwani, and me, Aditya [cliche-niche](cliche-niche) Tanwar).

### Introduction
For all your <b>integral only java</b> needs (rounded to the nearest 8 bytes, {using only this class [no object arrays]}), we present to you WCTC, a compiler that compiles Java code to x86_64 assembly code. <br>
A complete summary of the functionalities provided can be found in [Milestone 4's report](./docs/Milestone4_WCTC_Report.pdf), and the final presentation of the project is available [here](./docs/WCTC).

### Running
```bash
cd src
make
./WCTC.o -h
```
This will let you know how to run `WCTC.o`, however, you can also use [run.sh](./scripts/run.sh) to run the `WCTC.o` against an input java file.

### Dependencies
The source code is written in `Flex`, `Bison` (C++ used) and `C++`. `Dot` is used to construct the syntax trees. `gcc` is used to compile the generated assembly code.

## Functionalities

### Basic Functionalities
+ Primitive data types (int-like data types, booleans too, as long as `true` and `false` are not used explicitly)
+ Multi-dimensional arrays 
+ Printing integers
+ All basic operators
+ Control flow using `if-else`, and `for`/`while` loops
+ Methods and method calls (both static and non-static)
+ Recursion
+ Classes and objects (using `this` pointer only)
+ Declarative and Non-declarative statements

### Bonus Features Implemented
+ Arrays can have any number of dimensions, and size can be resolved at run-time
+ Support for default constructors
+ Static polymorphism (Method overloading)
+ Passing arrays as function arguments
+ Passing objects as function arguments
+ Passing by reference
+ Primitive Typecasting
+ 3AC optimizations
    + Removed redundant temporaries
    + Renamed temporaries and jump instructions
    + Constant Folding
    + Constant Propagation
    + Algebraic Simplification

### Unsupported Functionalities
+ Accessing an object's member variables without using `this` pointer
+ `static` and `final` not supported

### Miscellaneous ~~bug~~ feature
Variable name `l` is not supported as <u>the WCTC compiler does not take any L's</u>. (We really do not know why there is undefined behaviour on using the variable name `l`, we tried to debug it a lot.)

<br>

## Milestones

### Milestone 1
Make a lexer and a parser for [Java 17](https://docs.oracle.com/javase/specs/jls/se7/html/index.html) which can generate ASTs for correct Java programs. <br>
98/100. Minor edge case missed

### Milestone 2
Extend the compiler to generate [3AC (three address code)](https://en.wikipedia.org/wiki/Three-address_code) for correct Java programs. Report errors like type errors, if any. <br>
100/100.

### Milestone 3
Extend the 3AC to include stack pointer manipulations. <br>
70/100. Static and final not supported (should have been 80/100).

### Milestone 4
Extend the compiler to generate x86_64 assembly code which can be compiled using gcc. <br>
98/100. No feedback provided.

### Project Implementation
Awarded 3/3 for implementation and bonus (mean was 0.6).

## Parting Comments
To a stressful four months, and being one of the last few batches to ever have to do ['cs335'](https://www.cse.iitk.ac.in/users/swarnendu/courses/spring2023-cs335/). We are very proud of what we have built, no matter how rudimentary, or how buggy, even if it led to a lot of sleepless nights and missing (cs335) classes. <br>- JAZ Hands