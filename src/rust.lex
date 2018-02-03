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
eol = ("\r\n"|"\n"|"\r");

%%

{eol}	                      => (lineNum := (!lineNum) + 1; lex());
{ws}+	                      => (lex());

"+"                           => (T.PLUS(!lineNum, !lineNum));
"let"                         => (T.LET(!lineNum, !lineNum));
"fn"                          => (T.FUN(!lineNum, !lineNum));
"int"                         => (T.INT(!lineNum, !lineNum));
"="                           => (T.ASS(!lineNum, !lineNum));
":"                           => (T.COLON(!lineNum, !lineNum));
";"                           => (T.SEMI(!lineNum, !lineNum));
","                           => (T.COMMA(!lineNum, !lineNum));
"->"                          => (T.ARROW(!lineNum, !lineNum));
"("                           => (T.LPAR(!lineNum, !lineNum));
")"                           => (T.RPAR(!lineNum, !lineNum));
"{"                           => (T.LBRA(!lineNum, !lineNum));
"}"                           => (T.RBRA(!lineNum, !lineNum));
"<"                           => (T.LCHE(!lineNum, !lineNum));
">"                           => (T.RCHE(!lineNum, !lineNum));
"&"                           => (T.AMP(!lineNum, !lineNum));
"println!"                      => (T.PRINT(!lineNum, !lineNum));

"'"{alpha}({alpha}|{digit})*  => (T.LTIME(yytext, !lineNum, !lineNum));
{alpha}({alpha}|{digit})*     => (T.ID(yytext, !lineNum, !lineNum));
{digit}+                      => (T.CONST(valOf(Int.fromString yytext), !lineNum, !lineNum));

.                             => (perror("Error, line " ^ (Int.toString (!lineNum))
                                         ^ ", ignoring bad character: " ^ yytext); lex());
