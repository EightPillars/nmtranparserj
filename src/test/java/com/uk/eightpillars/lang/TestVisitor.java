package com.uk.eightpillars.lang;

import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.tree.TerminalNode;

public class TestVisitor extends NmtranParserBaseListener {

    private final StringBuilder buf;

    public TestVisitor(){
        buf = new StringBuilder();
    }

    private void appendToken(TerminalNode tok){
        if(tok != null){
            buf.append(" ");
            buf.append(tok.getText());
            buf.append(" ");
        }
    }

    @Override
    public void enterNmEquation(NmtranParser.NmEquationContext ctx){
        appendToken(ctx.ID());
        appendToken(ctx.ASSIGN());
    }

    @Override
    public void exitNmEquation(NmtranParser.NmEquationContext ctx){
        buf.append("\n");
    }

    @Override
    public void enterParenthesis(NmtranParser.ParenthesisContext ctx){
        buf.append("(");
    }

    @Override
    public void exitParenthesis(NmtranParser.ParenthesisContext ctx){
        buf.append(")");
    }

    @Override
    public void enterFunctionCall(NmtranParser.FunctionCallContext ctx){
        appendToken(ctx.ID());
        buf.append("(");
    }

    @Override
    public void exitFunctionCall(NmtranParser.FunctionCallContext ctx){
        buf.append(")");
    }

    @Override
    public void enterSymbolReference(NmtranParser.SymbolReferenceContext ctx){
        appendToken(ctx.ID());
    }

    @Override
    public void enterMultiplicativeexpression(NmtranParser.MultiplicativeexpressionContext ctx){
//        buf.append(ctx..getText());
        appendToken(ctx.MUL(0));
        appendToken(ctx.DIV(0));
    }

    @Override
    public void enterAdditiveexpression(NmtranParser.AdditiveexpressionContext ctx){
//        buf.append(ctx..getText());
        appendToken(ctx.MINUS(0));
        appendToken(ctx.PLUS(0));
    }

//    @Override
//    public void exitIntegerLiteral(NmtranParser.IntegerLiteralContext ctx){
//        buf.append(",");
//    }

    @Override
    public void enterIntegerLiteral(NmtranParser.IntegerLiteralContext ctx){
        appendToken(ctx.INT());
    }

    @Override
    public void exitIntegerLiteral(NmtranParser.IntegerLiteralContext ctx){
//        buf.append(",");
    }
    @Override
    public void enterRealLiteral(NmtranParser.RealLiteralContext ctx){
        appendToken(ctx.REAL());
        appendToken(ctx.INT());
    }

    @Override
    public void exitRealLiteral(NmtranParser.RealLiteralContext ctx){
//        buf.append(",");
    }

    public String toString(){
        return this.buf.toString();
    }

}
