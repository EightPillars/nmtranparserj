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
            | optionKwd ASSIGN '(' expression (',' expression )* ')'
			| stringLiteral
			| '(' expression+ ')'
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
			(nmClause|nmCondStmt|whileLoop) EOL+ //|nmLimit//|nmOdeInit | nmOdeDefn ||
;

nmClause:
			(nmEquation |nmOdeInit|nmOdeDefn|exitStmt|callStmt)
;
nmThetaBlock: THETA_BLOCK EOL* nmLimit*;

nmMatrixBlock: MATRIX_BLOCK EOL* nmOption* nmMatrix*;

nmEquation:
	 ID ('(' expression ')' )? (ASSIGN expression)?
;

callStmt: CALL expression;

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
	 ID ('(' ID+ ')')? ( ASSIGN expression)?
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
		compAssign |
//		odeRef|
		parenthesis //|
//		SpecialVars
;

nmCondStmt :
	IF '(' expression ')' THEN EOL+ nmStatement+ (ELSE EOL+ nmStatement* )? ((END IF)|ENDIF)
	| IF '(' expression ')' nmClause //(ELSE EOL+ nmStatement+ )?
;


whileLoop :
	DO WHILE '(' expression ')' EOL+ nmStatement+ END DO
;



parenthesis :  '(' expression ')';

compAssign: '(' expression expression+ ')'
        ;

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
