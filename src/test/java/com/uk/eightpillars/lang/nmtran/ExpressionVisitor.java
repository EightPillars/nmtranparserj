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
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.TerminalNode;

/**
 * This class provides an empty implementation of {@link NmtranParserVisitor},
 * which can be extended to create a visitor which only needs to handle a subset
 * of the available methods.
 *
 */
public class ExpressionVisitor extends AbstractParseTreeVisitor<String> implements NmtranParserVisitor<String> {
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmModel(NmtranParser.NmModelContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmOption(NmtranParser.NmOptionContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitOptionKwd(NmtranParser.OptionKwdContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmOptionBlock(NmtranParser.NmOptionBlockContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmStmtBlock(NmtranParser.NmStmtBlockContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmStatement(NmtranParser.NmStatementContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmClause(NmtranParser.NmClauseContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmThetaBlock(NmtranParser.NmThetaBlockContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmMatrixBlock(NmtranParser.NmMatrixBlockContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmEquation(NmtranParser.NmEquationContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitCallStmt(NmtranParser.CallStmtContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitExitStmt(NmtranParser.ExitStmtContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmOdeInit(NmtranParser.NmOdeInitContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmOdeDefn(NmtranParser.NmOdeDefnContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmLimit(NmtranParser.NmLimitContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmMatrix(NmtranParser.NmMatrixContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmCompDefn(NmtranParser.NmCompDefnContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitExpression(NmtranParser.ExpressionContext ctx) {

		return treeNode(visit(ctx.orexpression()));
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitOrexpression(NmtranParser.OrexpressionContext ctx) {
        if(ctx.orexpression() != null){
            return treeNode(visit(ctx.orexpression()), visit(ctx.andexpression()),
                    getTerminal(ctx.OR()));
        }
        return visit(ctx.andexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitAndexpression(NmtranParser.AndexpressionContext ctx) {
        if(ctx.andexpression() != null){
            return treeNode(visit(ctx.andexpression()), visit(ctx.equalityexpression()),
                    getTerminal(ctx.AND()));
        }
        return visit(ctx.equalityexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitEqualityexpression(NmtranParser.EqualityexpressionContext ctx) {
        if(ctx.equalityexpression() != null){
            return treeNode(visit(ctx.equalityexpression()), visit(ctx.relationalexpression()),
                    getTerminal(ctx.EQ(), ctx.NE()));
        }
        return visit(ctx.relationalexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitRelationalexpression(NmtranParser.RelationalexpressionContext ctx) {
        if(ctx.relationalexpression() != null){
            return treeNode(visit(ctx.relationalexpression()), visit(ctx.rangeExpression()),
                    getTerminal(ctx.GE(), ctx.GT(), ctx.LE(), ctx.LT()));
        }
        return visit(ctx.rangeExpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitRangeExpression(NmtranParser.RangeExpressionContext ctx) {
        if(ctx.rangeExpression() != null){
            return treeNode(visit(ctx.rangeExpression()), visit(ctx.additiveexpression()),
                    getTerminal(ctx.COLON()));
        }
        return visit(ctx.additiveexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitAdditiveexpression(NmtranParser.AdditiveexpressionContext ctx) {
	    if(ctx.additiveexpression() != null){
	        return treeNode(visit(ctx.additiveexpression()), visit(ctx.multiplicativeexpression()),
                    getTerminal(ctx.MINUS(), ctx.PLUS()));
        }
	    return visit(ctx.multiplicativeexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitMultiplicativeexpression(NmtranParser.MultiplicativeexpressionContext ctx) {
        if(ctx.multiplicativeexpression() != null){
            return treeNode(visit(ctx.multiplicativeexpression()), visit(ctx.powerexpression()),
                    getTerminal(ctx.DIV(), ctx.MUL()));
        }
        return visit(ctx.powerexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitPowerexpression(NmtranParser.PowerexpressionContext ctx) {
        if(ctx.powerexpression() != null){
            return treeNode(visit(ctx.powerexpression()), visit(ctx.unaryexpression()),
                    getTerminal(ctx.POW()));
        }
        return visit(ctx.unaryexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitUnaryexpression(NmtranParser.UnaryexpressionContext ctx) {
	    String retVal = null;
	    if(ctx.MINUS() != null || ctx.PLUS() != null){
	        retVal = treeNode(visit(ctx.primaryexpression()),
                    getTerminal(ctx.MINUS(), ctx.PLUS()));
        }
        else{
	        retVal = visit(ctx.primaryexpression());
        }
	    return retVal;
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitPrimaryexpression(NmtranParser.PrimaryexpressionContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmCondStmt(NmtranParser.NmCondStmtContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitWhileLoop(NmtranParser.WhileLoopContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitParenthesis(NmtranParser.ParenthesisContext ctx) {
	    return visit(ctx.expression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitCompAssign(NmtranParser.CompAssignContext ctx) { return visitChildren(ctx); }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitSymbolReference(NmtranParser.SymbolReferenceContext ctx) {
	    return getLiteral(ctx.ID());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitFunctionCall(NmtranParser.FunctionCallContext ctx) {
	    StringBuilder buf = new StringBuilder();
	    buf.append("(");
	    for(NmtranParser.ExpressionContext e : ctx.expression()){
	        buf.append(visit(e));
        }
        buf.append(ctx.ID());
        buf.append(")");
	    return buf.toString();
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitStringLiteral(NmtranParser.StringLiteralContext ctx) {
	    return getLiteral(ctx.STRING());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitIntegerLiteral(NmtranParser.IntegerLiteralContext ctx) {
	    return getLiteral(ctx.INT());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitRealLiteral(NmtranParser.RealLiteralContext ctx) {
	    if(ctx.REAL() != null) return getLiteral(ctx.REAL());
        if(ctx.SCIENTIFIC() != null) return getLiteral(ctx.SCIENTIFIC());
        if(ctx.INT() != null) return getLiteral(ctx.INT().getText() + ".0");
        return null;
	}

	private String getTerminal(TerminalNode ... nodes){
	    for(TerminalNode t : nodes){
	        if(t != null) return t.getText();
        }
	    return "";
    }

    private String getLiteral(TerminalNode node){
	    return getLiteral(node.getText());
    }

    private String getLiteral(String termTxt){
        StringBuilder buf = new StringBuilder();
        buf.append(termTxt);
        buf.append(" ");
        return buf.toString();
    }

    private String treeNode(String ... nodeTxt){
        StringBuilder buf = new StringBuilder();
        buf.append("(");
        for(String txt : nodeTxt){
            buf.append(txt);
        }
        buf.append(")");
        return buf.toString();
    }
}