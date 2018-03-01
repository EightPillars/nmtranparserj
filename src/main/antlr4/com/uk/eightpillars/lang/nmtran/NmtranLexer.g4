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

THETA_BLOCK: '$THETA';

MATRIX_BLOCK: '$' ('OMEGA'|'SIGMA');

//IGNORE: 'IGNORE' -> pushMode(RAW_STRINGS);

//FILE: 'FILE' -> pushMode(RAW_STRINGS);

OPTION_BLOCK_NAME :	'$' ('INP' |'SUB'|'EST'|'TAB'|'COV'|'SUB'|'MOD'|'SIZ'|'PRO'|'DAT'|'MSF') [A-Z]*;

STMT_BLOCK_NAME: '$' ('PK'|'DES'|('ERR' [A-Z]*));

COMP:   'COMP';

A_0:    'A_0';

DADT:   'DADT';

//BLOCK_NAME :	'$' ID;

ID:  (('a'..'z')|('A'..'Z')) (('a'..'z')|('A'..'Z')|('0'..'9')|'_')*;

//IGNORE_CHAR: '£'|'#'|'@';

SL_COMMENT:	';' ~('\n'|'\r')* -> skip ;

STRING:		'"' (~('"'|'\n'|'\r'))* '"';

INT : ('0'..'9')+;

REAL: INT '.' INT ('E' '-'? (((INT '.')? INT))|(INT '.' INT?))? ;

WS:			(' '|'\t') -> skip;

NEWLINE:		('\r'? '\n');


//mode RAW_STRINGS;
//
//RAW_WS:			(' '|'\t') -> skip;
//
//RAW_ASSIGN: '=';
//
//RAW_STRING: (~('\r'|'\n'|' '|'\t'|'='))+(~('\r'|'\n'|' '|'\t'))* -> popMode;
//
//mode PROB_STRING;
//
//RAW_PROB_STR: WS* (.)+? WS* EOL -> popMode;