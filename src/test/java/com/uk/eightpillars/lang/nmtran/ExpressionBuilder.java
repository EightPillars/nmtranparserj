/*
 * Copyright (c) 2018 Eight Pillars Ltd.
 *
 * This file is part of the NMTRAN Parser.
 *
 * The NMTRAN Parser is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * The NMTRAN Parser Library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with The NMTRAN Parser.  If not, see <http://www.gnu.org/licenses/>.
 */

// Generated from com/uk/eightpillars/lang/nmtran/NmtranParser.g4 by ANTLR 4.7.1
package com.uk.eightpillars.lang.nmtran;

import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.TerminalNode;

/**
 * This class provides an empty implementation of {@link NmtranParserListener},
 * which can be extended to create a listener which only needs to handle a subset
 * of the available methods.
 */
public class ExpressionBuilder implements NmtranParserListener {
    private final StringBuilder treeRep = new StringBuilder();


    public String getExpressionTree(){
        return this.treeRep.toString();
    }

    /**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmModel(NmtranParser.NmModelContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmModel(NmtranParser.NmModelContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmOption(NmtranParser.NmOptionContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmOption(NmtranParser.NmOptionContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterOptionKwd(NmtranParser.OptionKwdContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitOptionKwd(NmtranParser.OptionKwdContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmOptionBlock(NmtranParser.NmOptionBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmOptionBlock(NmtranParser.NmOptionBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmStmtBlock(NmtranParser.NmStmtBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmStmtBlock(NmtranParser.NmStmtBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmStatement(NmtranParser.NmStatementContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmStatement(NmtranParser.NmStatementContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmClause(NmtranParser.NmClauseContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmClause(NmtranParser.NmClauseContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmThetaBlock(NmtranParser.NmThetaBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmThetaBlock(NmtranParser.NmThetaBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmMatrixBlock(NmtranParser.NmMatrixBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmMatrixBlock(NmtranParser.NmMatrixBlockContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmEquation(NmtranParser.NmEquationContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmEquation(NmtranParser.NmEquationContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterCallStmt(NmtranParser.CallStmtContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitCallStmt(NmtranParser.CallStmtContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterExitStmt(NmtranParser.ExitStmtContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitExitStmt(NmtranParser.ExitStmtContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmOdeInit(NmtranParser.NmOdeInitContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmOdeInit(NmtranParser.NmOdeInitContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmOdeDefn(NmtranParser.NmOdeDefnContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmOdeDefn(NmtranParser.NmOdeDefnContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmLimit(NmtranParser.NmLimitContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmLimit(NmtranParser.NmLimitContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmMatrix(NmtranParser.NmMatrixContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmMatrix(NmtranParser.NmMatrixContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmCompDefn(NmtranParser.NmCompDefnContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmCompDefn(NmtranParser.NmCompDefnContext ctx) { }

	@Override
	public void enterExpression(NmtranParser.ExpressionContext ctx) {
		treeRep.append("(");
	}

	@Override
	public void exitExpression(NmtranParser.ExpressionContext ctx) {
		treeRep.append(")");
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterOrexpression(NmtranParser.OrexpressionContext ctx) {
        if(ctx.OR() != null){
            treeRep.append("(");
        }
    }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitOrexpression(NmtranParser.OrexpressionContext ctx) {
        if(ctx.OR() != null){
            treeRep.append(ctx.OR());
            treeRep.append(")");
        }
    }

	@Override public void enterAndexpression(NmtranParser.AndexpressionContext ctx) {
        if(ctx.AND() != null){
            treeRep.append("(");
        }
    }

	@Override public void exitAndexpression(NmtranParser.AndexpressionContext ctx) {
        if(ctx.AND() != null){
            treeRep.append(ctx.AND());
            treeRep.append(")");
        }
    }

	@Override public void enterEqualityexpression(NmtranParser.EqualityexpressionContext ctx) {
        if(ctx.EQ() != null || ctx.NE() != null){
            treeRep.append("(");
        }
    }
	@Override public void exitEqualityexpression(NmtranParser.EqualityexpressionContext ctx) {
        if(ctx.EQ() != null || ctx.NE() != null){
            treeRep.append(ctx.EQ() != null ? ctx.EQ() : ctx.NE());
            treeRep.append(")");
        }
    }

	@Override public void enterRelationalexpression(NmtranParser.RelationalexpressionContext ctx) {
		if(ctx.GE() != null || ctx.GT() != null || ctx.LE() != null || ctx.LT() != null){
			treeRep.append("(");
		}
	}
	@Override public void exitRelationalexpression(NmtranParser.RelationalexpressionContext ctx) {
		if(ctx.GE() != null || ctx.GT() != null || ctx.LE() != null || ctx.LT() != null){
			treeRep.append(ctx.GE() != null ? ctx.GE() : ctx.GT() != null ? ctx.GT()
					: ctx.LE() != null ? ctx.LE() : ctx.LT());
			treeRep.append(")");
		}
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterRangeExpression(NmtranParser.RangeExpressionContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitRangeExpression(NmtranParser.RangeExpressionContext ctx) { }

	@Override public void enterAdditiveexpression(NmtranParser.AdditiveexpressionContext ctx) {
        if(ctx.MINUS() != null || ctx.PLUS() != null){
            treeRep.append("(");
        }

    }

	@Override public void exitAdditiveexpression(NmtranParser.AdditiveexpressionContext ctx) {
        if(ctx.MINUS() != null || ctx.PLUS() != null){
            treeRep.append(ctx.MINUS() != null ? ctx.MINUS() : ctx.PLUS());
            treeRep.append(")");
        }
    }

	@Override public void enterMultiplicativeexpression(NmtranParser.MultiplicativeexpressionContext ctx) {
        if(ctx.MUL() != null || ctx.DIV() != null){
            treeRep.append("(");
        }
    }
	@Override public void exitMultiplicativeexpression(NmtranParser.MultiplicativeexpressionContext ctx) {
        if(ctx.MUL() != null || ctx.DIV() != null){
            treeRep.append(ctx.MUL() != null ? ctx.MUL() : ctx.DIV());
            treeRep.append(")");
        }
    }

	@Override public void enterPowerexpression(NmtranParser.PowerexpressionContext ctx) {
	    if(ctx.POW() != null){
	        treeRep.append("(");
        }
    }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitPowerexpression(NmtranParser.PowerexpressionContext ctx) {
        if(ctx.POW() != null){
            treeRep.append(ctx.POW());
            treeRep.append(")");
        }

    }

	@Override
	public void enterUnaryexpression(NmtranParser.UnaryexpressionContext ctx) {
		if(ctx.PLUS() != null || ctx.MINUS() != null) {
			treeRep.append("(");
		}
	}

	@Override
	public void exitUnaryexpression(NmtranParser.UnaryexpressionContext ctx) {
		if(ctx.PLUS() != null || ctx.MINUS() != null) {
			if (ctx.MINUS() != null) {
				treeRep.append(ctx.MINUS());
			}
			if (ctx.PLUS() != null) {
				treeRep.append(ctx.PLUS());
			}
			treeRep.append(")");
		}
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterPrimaryexpression(NmtranParser.PrimaryexpressionContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitPrimaryexpression(NmtranParser.PrimaryexpressionContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterNmCondStmt(NmtranParser.NmCondStmtContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitNmCondStmt(NmtranParser.NmCondStmtContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterWhileLoop(NmtranParser.WhileLoopContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitWhileLoop(NmtranParser.WhileLoopContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterParenthesis(NmtranParser.ParenthesisContext ctx) {

    }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitParenthesis(NmtranParser.ParenthesisContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterCompAssign(NmtranParser.CompAssignContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitCompAssign(NmtranParser.CompAssignContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterSymbolReference(NmtranParser.SymbolReferenceContext ctx) { }

	@Override public void exitSymbolReference(NmtranParser.SymbolReferenceContext ctx) {
        if(ctx.ID() != null) {
            treeRep.append(ctx.ID().getText());
            treeRep.append(" ");
        }
    }

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterFunctionCall(NmtranParser.FunctionCallContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitFunctionCall(NmtranParser.FunctionCallContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterStringLiteral(NmtranParser.StringLiteralContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitStringLiteral(NmtranParser.StringLiteralContext ctx) {
        if(ctx.STRING() != null) {
            treeRep.append(ctx.STRING().getText());
            treeRep.append(" ");
        }
    }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterIntegerLiteral(NmtranParser.IntegerLiteralContext ctx) { }

	@Override
	public void exitIntegerLiteral(NmtranParser.IntegerLiteralContext ctx) {
		if(ctx.INT() != null) {
			treeRep.append(ctx.INT().getText());
            treeRep.append(" ");
		}
	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterRealLiteral(NmtranParser.RealLiteralContext ctx) { }

	@Override
	public void exitRealLiteral(NmtranParser.RealLiteralContext ctx) {
		if(ctx.REAL() != null || ctx.SCIENTIFIC() != null) {
			treeRep.append(ctx.REAL() != null ? ctx.REAL().getText() : ctx.SCIENTIFIC().getText());
			treeRep.append(" ");
		}
		else if(ctx.INT() != null) {
			treeRep.append(ctx.INT().getText());
			treeRep.append(".0");
			treeRep.append(" ");
		}

	}

	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void enterEveryRule(ParserRuleContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void exitEveryRule(ParserRuleContext ctx) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void visitTerminal(TerminalNode node) { }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation does nothing.</p>
	 */
	@Override public void visitErrorNode(ErrorNode node) { }
}