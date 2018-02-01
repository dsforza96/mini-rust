structure T = Tokens

type pos = int
type svalue = T.svalue
type ('a, 'b) token = ('a, 'b) T.token
type lexresult = (svalue, pos) token

val lineNum = ref 0;
val eof = fn () => T.EOF(!lineNum, !lineNum);

val perror = fn x => TextIO.output(TextIO.stdErr, x ^ "\n");

%%

%full
%header (functor RustLexFun(structure Tokens: Rust_TOKENS));

alpha = [A-Za-z_-];
digit = [0-9];
ws = [\ \t];
eol = (\r\n|\n|\r);

%%

eol+	                      => (lineNum := (!lineNum) + (String.size yytext); lex());
{ws}+	                      => (lex());

"+"                           => (PLUS(!lineNum, !lineNum));
"let"                         => (LET(!lineNum, !lineNum));
"fn"                          => (FUN(!lineNum, !lineNum));
"int"                         => (INT(!lineNum, !lineNum));
"="                           => (ASS(!lineNum, !lineNum));
":"                           => (COLON(!lineNum, !lineNum));
";"                           => (SEMI(!lineNum, !lineNum));
","                           => (COMMA(!lineNum, !lineNum));
"->"                          => (ARROW(!lineNum, !lineNum));
"("                           => (LPAR(!lineNum, !lineNum));
")"                           => (RPAR(!lineNum, !lineNum));
"{"                           => (LBRA(!lineNum, !lineNum));
"}"                           => (RBRA(!lineNum, !lineNum));
"<"                           => (LCHE(!lineNum, !lineNum));
">"                           => (RCHE(!lineNum, !lineNum));
"'"{alpha}({alpha}|{digit})*  => (LTIME(!lineNum, !lineNum));
"&"                           => (AMP(!lineNum, !lineNum));
"print!"                      => (PRINT(!lineNum, !lineNum));

{alpha}({alpha}|{digit})*   => (ID(yytext, !lineNum, !lineNum));
{digit}+                    => (CONST(valOf(Int.fromString yytext), !lineNum, !lineNum));

.                           => (perror("Ignoring bad character: " ^ yytext); lex());
