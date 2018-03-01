parser grammar NmtranParser;
options { tokenVocab=NmtranLexer; }

nmModel :
	EOL*
//	nmHeaderBlock
    (nmProbBlock|
    nmDataSource|
	nmOptionBlock|
	nmThetaBlock|
	nmMatrixBlock|
	nmStmtBlock)*
	;

nmProbBlock: PROB_BLOCK RAW_PROB_STR EOL*;

nmDataSource:   DATA_BLOCK RAW_STRING (nmIgnore|nmOption)* EOL+;

nmIgnore: ID (ASSIGN IGNORE_CHAR)? ;

nmOption:	(ID (ASSIGN expression)?
            | ID '(' expression ')'
			| stringLiteral
			| FILE RAW_ASSIGN RAW_STRING
			| nmCompDefn) EOL*
;


nmOptionBlock:
			OPTION_BLOCK_NAME EOL* nmOption* EOL+
            ;

nmStmtBlock:
            STMT_BLOCK_NAME EOL*
			(nmStatement)*
            ;

nmStatement:
			(nmEquation | nmCondStmt|nmOdeInit|nmOdeDefn) EOL+ //|nmLimit//|nmOdeInit | nmOdeDefn ||
;

nmThetaBlock: THETA_BLOCK EOL* nmLimit*;

nmMatrixBlock: MATRIX_BLOCK EOL* nmOption* nmMatrix*;

nmEquation:
	 ID (ASSIGN expression)?
;

nmOdeInit:
	 A_0  '(' integerLiteral ')' ASSIGN expression
;

nmOdeDefn:
	 DADT  '(' integerLiteral ')' ASSIGN expression
;

nmLimit :
	 (('(' expression ((','? expression ((','? expression)|',')? )|',')? ')' ID?)
			|  '(' (expression  ID) ')'
			|  (expression  ID) ) EOL+
;

nmMatrix:
    (expression+ ID*
    | '(' expression+ ID* ')' ) EOL+
    ;

nmCompDefn :
	 COMP ('(' ID ID? ')')? ( ASSIGN expression)?
;


expression: orexpression
;

orexpression :
	andexpression ( OR andexpression)*;


andexpression :
	equalityexpression ( AND equalityexpression)*;


equalityexpression :
	relationalexpression ( (EQ | NE)
	relationalexpression)*;


relationalexpression :
	rangeExpression
	(
	 (GE | LE | GT | LT) rangeExpression)*;


rangeExpression:  additiveexpression (COLON additiveexpression)*
                ;

additiveexpression :
					multiplicativeexpression ( (PLUS|MINUS) multiplicativeexpression)*
;

multiplicativeexpression :
					powerexpression ((MUL|DIV) powerexpression)*
;


powerexpression :
					unaryexpression (POW unaryexpression)*
;

unaryexpression :
	(('-'|'+'))? primaryexpression
;

primaryexpression :
		stringLiteral|
		integerLiteral|
		realLiteral|
		functionCall|
//		UtilityReference|
//		EtaLiteral|
//		EpsLiteral|
//		ThetaLiteral|
		symbolReference|
//		odeRef|
		parenthesis //|
//		SpecialVars
;

nmCondStmt :
	IF '(' expression ')' THEN EOL+ nmStatement+ (ELSE EOL+ nmStatement+ )? ENDIF
;

parenthesis :  '(' expression ')';

symbolReference :  ID;

//odeRef :   'A' '(' dvIdx = integerLiteral ')' ;

functionCall :  ID '(' expression (',' expression)* ')' ;

//SpecialVars :		NAME;

//UtilityReference :  NAME '(' IntegerLiteral ')';

//EpsLiteral :  'EPS' '(' IntegerLiteral ')';
//
//ThetaLiteral :  'THETA' '(' IntegerLiteral ')';

stringLiteral:	STRING

;

integerLiteral:	INT

;


realLiteral: REAL|INT

;
