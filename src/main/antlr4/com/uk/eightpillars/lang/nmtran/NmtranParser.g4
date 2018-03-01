parser grammar NmtranParser;
options { tokenVocab=NmtranLexer; }

nmModel :
	EOL*
//	nmHeaderBlock
    (
	nmOptionBlock|
	nmThetaBlock|
	nmMatrixBlock|
	nmStmtBlock
	)*
	;

//nmProbBlock: STRING EOL*;

//nmDataSource:   DATA_BLOCK STRING nmOption* EOL+;

nmOption:	(optionKwd (ASSIGN expression)?
            | optionKwd '(' expression ')'
			| stringLiteral
			| nmCompDefn) EOL*
;

optionKwd: OPTION_KWD | ID ;

nmOptionBlock:
			OPTION_BLOCK_NAME EOL* nmOption* EOL+
            ;

nmStmtBlock:
            STMT_BLOCK_NAME EOL*
			(nmStatement)*
            ;

nmStatement:
			(nmEquation | nmCondStmt|nmOdeInit|nmOdeDefn|exitStmt) EOL+ //|nmLimit//|nmOdeInit | nmOdeDefn ||
;

nmThetaBlock: THETA_BLOCK EOL* nmLimit*;

nmMatrixBlock: MATRIX_BLOCK EOL* nmOption* nmMatrix*;

nmEquation:
	 ID (ASSIGN expression)?
;

exitStmt : ID integerLiteral integerLiteral;


nmOdeInit:
	 A_0  '(' integerLiteral ')' ASSIGN expression
;

nmOdeDefn:
	 DADT  '(' integerLiteral ')' ASSIGN expression
;

nmLimit :
	 (('(' expression ((','? expression ((','? expression)|',')? )|',')? ')' ID?)
			|  '(' (expression  ID?) ')'
			|  (expression  ID?) ) EOL+
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
	IF '(' expression ')' THEN EOL+ nmStatement+ (ELSE EOL+ nmStatement+ )? ((END IF)|ENDIF)
	| IF '(' expression ')' nmStatement+ (ELSE EOL+ nmStatement+ )?
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
