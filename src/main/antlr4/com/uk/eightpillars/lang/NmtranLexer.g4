lexer grammar NmtranLexer;

ASSIGN: '=';

MUL: '*';

DIV: '/';

PLUS: '+';

MINUS: '-';

POW: '^'|'**';

EOL: NEWLINE;

IF: 'IF';

THEN: 'THEN';

ELSE: 'ELSE';

ENDIF: 'ENDIF';

EQ: '.EQ.'|'==';

NE: '.NE.';

GT: '.GT.'|'>';

LT: '.LT.'|'<';

GE: '.GE.'|'>=';

LE: '.LE.'|'<=';

OR: '.OR.';

AND: '.AND.';

COMMA: ',';

LPAREN: '(';

RPAREN: ')';

COLON:  ':';

DATA_BLOCK: '$' ('DATA'|'MSFI') -> pushMode(RAW_STRINGS);

PROB_BLOCK: '$'('PRO'|'PROB'|'PROBL'|'PROBLE'|'PROBLEM') -> pushMode(PROB_STRING) ;

THETA_BLOCK: '$THETA';

MATRIX_BLOCK: '$' ('OMEGA'|'SIGMA');

//IGNORE: 'IGNORE' -> pushMode(RAW_STRINGS);

FILE: 'FILE' -> pushMode(RAW_STRINGS);

OPTION_BLOCK_NAME :	'$' ('INPUT'|'SUBS'|'EST'|'TABLE'|'COV'|'SUBR'|'MODEL'|'SIZES');

STMT_BLOCK_NAME: '$' ('PK'|'DES'|'ERROR');

COMP:   'COMP';

A_0:    'A_0';

DADT:   'DADT';

//BLOCK_NAME :	'$' ID;

ID:  (('a'..'z')|('A'..'Z')) (('a'..'z')|('A'..'Z')|('0'..'9')|'_')*;

IGNORE_CHAR: '£'|'#'|'@';

SL_COMMENT:	';' ~('\n'|'\r')* -> skip ;

STRING:		'"' (~('"'|'\n'|'\r'))* '"';

INT : ('0'..'9')+;

REAL: INT '.' INT ('E' '-'? (((INT '.')? INT))|(INT '.' INT?))? ;

WS:			(' '|'\t') -> skip;

NEWLINE:		('\r'? '\n');


mode RAW_STRINGS;

RAW_WS:			(' '|'\t') -> skip;

RAW_ASSIGN: '=';

RAW_STRING: (~('\r'|'\n'|' '|'\t'|'='))+(~('\r'|'\n'|' '|'\t'))* -> popMode;

mode PROB_STRING;

RAW_PROB_STR: WS* (.)+? WS* EOL -> popMode;