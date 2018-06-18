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

package com.uk.eightpillars.lang.nmtran;

import com.uk.eightpillars.lang.nmtran.NmtranParser;
import com.uk.eightpillars.lang.nmtran.NmtranParserBaseListener;
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
        appendToken(ctx.MUL());
        appendToken(ctx.DIV());
    }

    @Override
    public void enterAdditiveexpression(NmtranParser.AdditiveexpressionContext ctx){
//        buf.append(ctx..getText());
        appendToken(ctx.MINUS());
        appendToken(ctx.PLUS());
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
//        appendToken(ctx.INT());
    }

    @Override
    public void exitRealLiteral(NmtranParser.RealLiteralContext ctx){
//        buf.append(",");
    }

    public String toString(){
        return this.buf.toString();
    }

}
