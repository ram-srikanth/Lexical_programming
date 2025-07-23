%{
#include <stdio.h>

int characters = 0, words = 0, spaces = 0, lines = 0;
%}

%%
[ \t]+          { spaces += yyleng; }         // Count spaces and tabs
\n              { lines++; characters++; }    // Count lines and character
[a-zA-Z0-9]+    { words++; characters += yyleng; }  // Count words and their chars
.               { characters++; }             // Count other characters
%%

int yywrap() {
    return 1;
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("Usage: ./cw <input_file>\n");
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }

    yylex();

    printf("Characters: %d\n", characters);
    printf("Words: %d\n", words);
    printf("Spaces: %d\n", spaces);
    printf("Lines: %d\n", lines);

    fclose(yyin);
    return 0;
}
