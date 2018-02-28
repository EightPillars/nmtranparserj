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

nmDataSource:   DATA_BLOCK RAW_STRING IGNORE RAW_ASSIGN RAW_STRING EOL+;

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
	 (('(' realLiteral ((',' realLiteral ((',' lower = realLiteral)|',')? )|',')? ')' ID?)
			|  '(' (realLiteral  ID) ')'
			|  (realLiteral  ID) ) EOL+
;

nmMatrix:
    (realLiteral+ ID*
    | '(' realLiteral+ ID* ')' ) EOL+
    ;

nmCompDefn :
	 COMP '(' ID ID? ')' //( ASSIGN expression)?
;


expression: orexpression
;

orexpression :
	andexpression (({Orexpression.current} OR) andexpression)*;


andexpression :
	equalityexpression (({Andexpression.current} AND) equalityexpression)*;


equalityexpression :
	relationalexpression (({Equalityexpression.current} (EQ | NE))
	relationalexpression)*;


relationalexpression :
	additiveexpression
	(
	 ({Relationalexpression.current} (GE | LE | GT | LT)) additiveexpression)*;


additiveexpression :
					multiplicativeexpression ({Additiveexpression.current} ('+'|'-') multiplicativeexpression)*
;

multiplicativeexpression :
					powerexpression ({Multiplicativeexpression.current} ('*'|'/') powerexpression)*
;


powerexpression :
					unaryexpression ({Powerexpression.current} ('^') unaryexpression)*
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
