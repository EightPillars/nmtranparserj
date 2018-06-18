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

package com.uk.eightpillars.converter.nmtranmdl;

import com.uk.eightpillars.lang.nmtran.CaseChangingCharStream;
import com.uk.eightpillars.lang.nmtran.NmtranLexer;
import com.uk.eightpillars.lang.nmtran.NmtranParser;
import com.uk.eightpillars.lang.nmtran.TestErrorListener;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@RunWith(Parameterized.class)
public class MdlAssignmentGenerationTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Collection<Object[]> data() {
        Object[][] testParams = new Object[][]{
                { "X = \"txt\"", "X = \"txt\"" },
//                { "anID", "anID" },
//                { "ff23s", "ff23s" },
//                { "a", "a" },
//                { "23", "23" },
//                { "23.2", "23.2" },
//                { "23.", "23.0" },
//                { "23.0e2", "23.0e2" },
//                { "-3.0e2.34", "-3.0e2.34" },
////                { "e2.0", "(-3.0e2.0 )", Boolean.FALSE },
//                { "23.0e2", "23.0e2" },
//                { "0.0", "0.0" },
//                { ".0", ".0" },
//                { ".23", ".23" },
//                { "-23.0", "-23.0" },
//                { "+1.0E-5", "+1.0E-5" },
//                { "23.0 + 10", "23.0 + 10" },
//                { "3.0 - 14", "3.0 - 14" },
//                { "23.0 * 34", "23.0 * 34" },
//                { "2.0 / 4", "2.0 / 4" },
//                { "2.0 ^ 4", "2.0 ^ 4" },
//                { "2.0 / 4 ^ -2", "2.0 / 4 ^ -2" },
//                { "+ 4", "+4" },
//                { "- 5", "-5" },
                { "X = 2.0 / 4 + -2", "X = 2.0 / 4 + -2" },
//                { "2.0.EQ.4 + -2", "2.0 == 4 + -2" },
//                { "2.0==4 + -2", "2.0 == 4 + -2" },
//                { "2.0.NE.4 + -2", "2.0 != 4 + -2" },
////                { "1 AND 0", "((1 0 AND))", Boolean.FALSE},
//                { "1.AND.0", "1 && 0" },
//                { "1:0", "1:0" },
//                { "1.OR.0", "1 || 0" },
//                { "2.0 * a / (4 + ff23s)", "2.0 * a / (4 + ff23s)" },
//                { "2.0 * 3 / (4 + 23)", "2.0 * 3 / (4 + 23)" },
                { "Y = 2.0 * 3 / EXP(4 + 23)", "Y = 2.0 * 3 / exp(4 + 23)" },
//                { "LOG(23,2)", "log(23, 2)" },
//                {
//                        "SWITCH1_DES.LT.0.AND.SWITCH2_DES.LT.0.AND.SWITCH2_DES.GE.-(DELTA_VMAX)",
//                        "SWITCH1_DES < 0 && SWITCH2_DES < 0 && SWITCH2_DES >= -(DELTA_VMAX)"
//                }
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
        ParseTree tree = parser.nmEquation();
//        ParseTreeWalker walker = new ParseTreeWalker();
//        ExpressionBuilder eb = new ExpressionBuilder();
//        walker.walk(eb, tree);
        MdlModelGenerationVisitor visitor = new MdlModelGenerationVisitor();
        String actualResult = visitor.visit(tree);
        assertEquals(expectValid, !errorListener.isErrorDetected());
        if(expectValid) {
            assertEquals(expectedExpr, actualResult);
//            assertEquals(expectedExpr, eb.getExpressionTree());
        }
    }
}