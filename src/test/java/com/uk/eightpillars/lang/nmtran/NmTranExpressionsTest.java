package com.uk.eightpillars.lang.nmtran;

import com.sun.org.apache.xpath.internal.operations.Bool;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.TerminalNode;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@RunWith(Parameterized.class)
public class NmTranExpressionsTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Collection<Object[]> data() {
        Object[][] testParams = new Object[][]{
                { "\"txt\"", "(\"txt\" )" },
                { "anID", "(anID )" },
                { "ff23s", "(ff23s )" },
                { "a", "(a )" },
                { "23", "(23 )" },
                { "23.2", "(23.2 )" },
                { "23.", "(23.0 )" },
                { "23.0e2", "(23.0e2 )" },
                { "-3.0e2.34", "((3.0e2.34 -))" },
//                { "e2.0", "(-3.0e2.0 )", Boolean.FALSE },
                { "23.0e2", "(23.0e2 )" },
                { "0.0", "(0.0 )" },
                { ".0", "(.0 )" },
                { ".23", "(.23 )" },
                { "-23.0", "((23.0 -))" },
                { "+1.0E-5", "((1.0E-5 +))" },
                { "23.0 + 10", "((23.0 10 +))" },
                { "3.0 - 14", "((3.0 14 -))" },
                { "23.0 * 34", "((23.0 34 *))" },
                { "2.0 / 4", "((2.0 4 /))" },
                { "2.0 ^ 4", "((2.0 4 ^))" },
                { "2.0 / 4 ^ -2", "((2.0 (4 (2 -)^)/))" },
                { "+ 4", "((4 +))" },
                { "- 5", "((5 -))" },
                { "2.0 / 4 + -2", "(((2.0 4 /)(2 -)+))" },
                { "2.0.EQ.4 + -2", "((2.0 (4 (2 -)+).EQ.))" },
                { "2.0==4 + -2", "((2.0 (4 (2 -)+)==))" },
                { "2.0.NE.4 + -2", "((2.0 (4 (2 -)+).NE.))" },
//                { "1 AND 0", "((1 0 AND))", Boolean.FALSE},
                { "1.AND.0", "((1 0 .AND.))" },
                { "1:0", "((1 0 :))" },
                { "1.OR.0", "((1 0 .OR.))" },
                { "2.0 * a / (4 + ff23s)", "(((2.0 a *)((4 ff23s +))/))" },
                { "2.0 * 3 / (4 + 23)", "(((2.0 3 *)((4 23 +))/))" },
                { "2.0 * 3 / EXP(4 + 23)", "(((2.0 3 *)(((4 23 +))EXP)/))" },
                { "LOG(23,2)", "(((23 )(2 )LOG))" },
                {
                    "SWITCH1_DES.LT.0.AND.SWITCH2_DES.LT.0.AND.SWITCH2_DES.GE.-(DELTA_VMAX)",
                    "((((SWITCH1_DES 0 .LT.)(SWITCH2_DES 0 .LT.).AND.)(SWITCH2_DES ((DELTA_VMAX )-).GE.).AND.))"
                }
        };
        List<Object[]> retVal = new ArrayList<Object[]>();
        for(Object[] row : testParams){
            Object putRow[] = new Object[3];
            putRow[0] = row[0];
            if(row.length > 2){
                putRow[1] = row[1];
                putRow[2] = row[2];
            }
            else{
                putRow[1] = row[1];
                putRow[2] = Boolean.TRUE;
            }
            retVal.add(putRow);
        }
        return retVal;
    }

    @Parameterized.Parameter(0)
    public String testExpr;

    @Parameterized.Parameter(1)
    public String expectedExpr;

    @Parameterized.Parameter(2)
    public Boolean expectValid;

    @Test
    public void testIntegerLiteral(){
        CharStream input = CharStreams.fromString(testExpr);
        // Use case insensitive lexer
        CaseChangingCharStream upper = new CaseChangingCharStream(input, true);
        TestErrorListener errorListener = new TestErrorListener();
        NmtranLexer lexer = new NmtranLexer(upper);
        // suppress error messages from default error handlers
//        lexer.removeErrorListeners();
        // add out test handler to count errors
        lexer.addErrorListener(errorListener);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        NmtranParser parser = new NmtranParser(tokens);
//            parser.removeErrorListeners();
        parser.addErrorListener(errorListener);
        ParseTree tree = parser.expression();
//        ParseTreeWalker walker = new ParseTreeWalker();
//        ExpressionBuilder eb = new ExpressionBuilder();
//        walker.walk(eb, tree);
        NmtranParserVisitor<String> visitor = new ExpressionVisitor();
        String actualResult = visitor.visit(tree);
        assertEquals(expectValid, !errorListener.isErrorDetected());
        if(expectValid) {
            assertEquals(expectedExpr, actualResult);
//            assertEquals(expectedExpr, eb.getExpressionTree());
        }
    }

//    @Test
//    void testRealLiteral(){
//        CharStream input = CharStreams.fromString("23.3");
//        // Use case insensitive lexer
//        CaseChangingCharStream upper = new CaseChangingCharStream(input, true);
//        TestErrorListener errorListener = new TestErrorListener();
//        NmtranLexer lexer = new NmtranLexer(upper);
//        // suppress error messages from default error handlers
////        lexer.removeErrorListeners();
//        // add out test handler to count errors
//        lexer.addErrorListener(errorListener);
//        CommonTokenStream tokens = new CommonTokenStream(lexer);
//        NmtranParser parser = new NmtranParser(tokens);
////            parser.removeErrorListeners();
//        parser.addErrorListener(errorListener);
//        final StringBuilder expectedResult = new StringBuilder();
//        parser.addParseListener(new NmtranParserBaseListener(){
//
//            @Override
//            public void exitIntegerLiteral(NmtranParser.IntegerLiteralContext ctx) {
//                if(ctx.INT() != null) {
//                    expectedResult.append(ctx.INT().getText());
//                }
//            }
//
//
//            @Override
//            public void exitRealLiteral(NmtranParser.RealLiteralContext ctx) {
//                if(ctx.REAL() != null) {
//                    expectedResult.append(ctx.REAL().getText());
//                }
//            }
//        });
//        ParseTree tree = parser.realLiteral();
//        assertEquals(0, errorListener.getNumErrors());
//        assertEquals("23.3", expectedResult.toString());
//    }

}
