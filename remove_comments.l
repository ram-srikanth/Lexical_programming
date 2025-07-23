%{
#include <stdio.h>
int com = 0;
FILE *fp;
%}

%x COMMENT
%%
"/*"                 { BEGIN(COMMENT); com++; }    // Start of multi-line comment
<COMMENT>"*/"        { BEGIN(INITIAL); }           // End of comment, return to normal
<COMMENT>.|\n        { /* Ignore comment content */ }

.|\n                 { fputc(yytext[0], fp); }     // Write non-comment content to output
%%

int yywrap() {
    return 1;
}
int main(int argc, char *argv[]) {
    FILE *in;
    if (argc != 3) {
        printf("Usage: ./rc <input.c> <output.c>\n");
        return 1;
    }
    in = fopen(argv[1], "r");
    if (!in) {
        perror("Cannot open input file");
        return 1;
    }
    fp = fopen(argv[2], "w");
    if (!fp) {
        perror("Cannot open output file");
        return 1;
    }
    yyin = in;
    yylex();
    printf("Total number of comments removed: %d\n", com);
    fclose(fp);
    fclose(in);
    return 0;
}

