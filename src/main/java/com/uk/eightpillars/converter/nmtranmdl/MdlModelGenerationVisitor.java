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
package com.uk.eightpillars.converter.nmtranmdl;
import com.uk.eightpillars.lang.nmtran.NmtranParser;
import com.uk.eightpillars.lang.nmtran.NmtranParserVisitor;
import org.antlr.v4.runtime.tree.AbstractParseTreeVisitor;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.stringtemplate.v4.ST;
import org.stringtemplate.v4.STGroup;
import org.stringtemplate.v4.STGroupFile;

import java.io.InputStream;
import java.net.URL;
import java.util.*;

/**
 * This class provides an empty implementation of {@link NmtranParserVisitor},
 * which can be extended to create a visitor which only needs to handle a subset
 * of the available methods.
 *
 */
public class MdlModelGenerationVisitor extends AbstractParseTreeVisitor<String> implements NmtranParserVisitor<String> {

    private STGroup stg;
    private final Map<String, BlockTemplates> blkTmplts;
    private BlockTemplates currentBlock;

	public MdlModelGenerationVisitor(){
		URL stgIn = this.getClass().getResource("/mdlModel.stg");
        stg = new STGroupFile(stgIn.getPath());
        this.blkTmplts = new HashMap<String, BlockTemplates>();
        this.currentBlock = null;
	}


    public String writeMdlBlock(){
	    ST mdlBlk = stg.getInstanceOf("mdlObj");
	    if(this.blkTmplts.containsKey("$PK")){
            BlockTemplates tmp = this.blkTmplts.get("$PK");
            tmp.getEqns().forEach((t) -> mdlBlk.add("modelStatements", t.render()));
        }
        mdlBlk.add("mdlId", "mdl1");
        return mdlBlk.render();
    }


	private void newBlock(String blkName){
	    if(currentBlock != null) {
            BlockTemplates oldBlock = currentBlock;
            blkTmplts.put(oldBlock.getBlkName(), oldBlock);
        }
	    this.currentBlock = new BlockTemplates(blkName);
    }

    private void addEquation(ST eqnST){
	    this.currentBlock.addEqns(eqnST);
    }


    private void addTheta(int posn, ST thetaST){
	    this.currentBlock.addTheta(posn, thetaST);
    }

    private ST createFunctionTmpl(TerminalNode id, List<NmtranParser.ExpressionContext> args){
        ST fc = this.stg.getInstanceOf("functionCall");
        fc.add("name", id.getText().toLowerCase());
        List<String> argList = new ArrayList<String>();
        for(NmtranParser.ExpressionContext e : args){
            argList.add(visit(e));
        }
        fc.add("args", argList);
        return fc;
    }

    private ST createThetaTmpl(TerminalNode id, List<NmtranParser.ExpressionContext> args){
	    return createParamFuncRefTmpl("theta", id, args);
    }

    private ST createEtaTmpl(TerminalNode id, List<NmtranParser.ExpressionContext> args){
        return createParamFuncRefTmpl("eta", id, args);
    }


    private ST createParamFuncRefTmpl(String paramName, TerminalNode id, List<NmtranParser.ExpressionContext> args){
	    if(args.size() > 1) throw new IllegalStateException("theta can't have more then one argument");

        ST fc = this.stg.getInstanceOf("paramFuncRef");
        String thetaPosn = visit(args.get(0));
        fc.add("paramName", paramName);
        fc.add("posn", thetaPosn);
        return fc;
    }


//    public String visit(ParseTree tree) {
//        return tree.accept(this);
//    }


    private String binOp(String op1, String op, String op2){
        ST binOpExpr = stg.getInstanceOf("binOpExpr");
        binOpExpr.add("op1", op1);
        binOpExpr.add("op", op);
        binOpExpr.add("op2", op2);
        return binOpExpr.render();
    }

    private String uniOp(String op, String opnd){
        ST binOpExpr = stg.getInstanceOf("uniOpExpr");
        binOpExpr.add("oper", op);
        binOpExpr.add("opnd", opnd);
        return binOpExpr.render();
    }

    private String paren(String expr){
        ST paren = stg.getInstanceOf("paren");
        paren.add("expr", expr);
        return paren.render();
    }

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
	@Override public String visitNmOptionBlock(NmtranParser.NmOptionBlockContext ctx) {
	    newBlock(ctx.OPTION_BLOCK_NAME().getText());
	    return visitChildren(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmStmtBlock(NmtranParser.NmStmtBlockContext ctx) {
        newBlock(ctx.STMT_BLOCK_NAME().getText());
	    return visitChildren(ctx);
	}
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
	@Override public String visitNmThetaBlock(NmtranParser.NmThetaBlockContext ctx) {
        newBlock(ctx.THETA_BLOCK().getText());
	    return visitChildren(ctx);
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmMatrixBlock(NmtranParser.NmMatrixBlockContext ctx) {
        newBlock(ctx.MATRIX_BLOCK().getText());
        return visitChildren(ctx);
    }
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitNmEquation(NmtranParser.NmEquationContext ctx) {
	    ST eqn = stg.getInstanceOf("equation");
        eqn.add("lhs", getLiteral(ctx.ID()));
	    if(ctx.expression().size() > 1) {
            eqn.add("param", visit(ctx.expression(0)));
            eqn.add("rhs", visit(ctx.expression(1)));
        }
        else{
            eqn.add("rhs", visit(ctx.expression(0)));
        }
        addEquation(eqn);
	    return null;
	}
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

		return visit(ctx.orexpression());
	}
	/**
	 * {@inheritDoc}
	 *
	 * <p>The default implementation returns the result of calling
	 * {@link #visitChildren} on {@code ctx}.</p>
	 */
	@Override public String visitOrexpression(NmtranParser.OrexpressionContext ctx) {
        if(ctx.orexpression() != null){
            return binOp(visit(ctx.orexpression()), "||", visit(ctx.andexpression()));
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
            return binOp(visit(ctx.andexpression()),
                    "&&",
                    visit(ctx.equalityexpression()));
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
            return binOp(visit(ctx.equalityexpression()),
                    ctx.EQ() != null ? "==" : "!=",
                    visit(ctx.relationalexpression()));
//            ST binOpExpr = stg.getInstanceOf("binOpExpr");
//            binOpExpr.add("op1", ctx.equalityexpression());
//            binOpExpr.add("op", ctx.EQ() != null ? "==" : "!=");
//            binOpExpr.add("op2", ctx.relationalexpression());
//            return binOpExpr.render();
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
            return binOp(visit(ctx.relationalexpression()),
                    ctx.GE() != null ? ">=" : ctx.GT() != null ? ">"
                        : ctx.LE() != null ? "<=" : "<",
                    visit(ctx.rangeExpression()));
//            return treeNode(visit(ctx.relationalexpression()), visit(ctx.rangeExpression()),
//                    getTerminal(ctx.GE(), ctx.GT(), ctx.LE(), ctx.LT()));
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
            ST rangeExpr = stg.getInstanceOf("rangeExpr");
            rangeExpr.add("op1", visit(ctx.rangeExpression()));
            rangeExpr.add("op2", visit(ctx.additiveexpression()));
            return rangeExpr.render();
//            return treeNode(visit(ctx.rangeExpression()), visit(ctx.additiveexpression()),
//                    getTerminal(ctx.COLON()));
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
	        return binOp(visit(ctx.additiveexpression()),
                    ctx.MINUS() != null ? "-" : "+",
                    visit(ctx.multiplicativeexpression()));
//            ST binOpExpr = stg.getInstanceOf("binOpExpr");
//            binOpExpr.add("op1", ctx.additiveexpression());
//            binOpExpr.add("op", ctx.MINUS() != null ? "-" : "+");
//            binOpExpr.add("op2", ctx.multiplicativeexpression());
//            return binOpExpr.render();
//	        return treeNode(visit(ctx.additiveexpression()), visit(ctx.multiplicativeexpression()),
//                    getTerminal(ctx.MINUS(), ctx.PLUS()));
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
            return binOp(visit(ctx.multiplicativeexpression()),
                    ctx.DIV() != null ? "/" : "*",
                    visit(ctx.powerexpression()));
//            return treeNode(visit(ctx.multiplicativeexpression()), visit(ctx.powerexpression()),
//                    getTerminal(ctx.DIV(), ctx.MUL()));
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
            return binOp(visit(ctx.powerexpression()),
                    "^",
                    visit(ctx.unaryexpression()));
//            return treeNode(visit(ctx.powerexpression()), visit(ctx.unaryexpression()),
//                    getTerminal(ctx.POW()));
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
            return uniOp(ctx.MINUS() != null ? "-" : "+",
                    visit(ctx.primaryexpression()));
//	        retVal = treeNode(visit(ctx.primaryexpression()),
//                    getTerminal(ctx.MINUS(), ctx.PLUS()));
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
	    return paren(visit(ctx.expression()));
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
        ST fc = null;
        if(ctx.ID().getText().equalsIgnoreCase("theta")){
            fc = createThetaTmpl(ctx.ID(), ctx.expression());
        }
        else if(ctx.ID().getText().equalsIgnoreCase("eta")){
            fc = createEtaTmpl(ctx.ID(), ctx.expression());
        }
        else{
            fc = createFunctionTmpl(ctx.ID(), ctx.expression());
        }
        return fc.render();
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
//        buf.append(" ");
        return buf.toString();
    }

//    private String treeNode(String ... nodeTxt){
//        StringBuilder buf = new StringBuilder();
//        buf.append("(");
//        for(String txt : nodeTxt){
//            buf.append(txt);
//        }
//        buf.append(")");
//        return buf.toString();
//    }
}