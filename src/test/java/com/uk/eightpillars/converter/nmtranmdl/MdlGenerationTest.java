package com.uk.eightpillars.converter.nmtranmdl;

import com.uk.eightpillars.lang.nmtran.*;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import static junit.framework.TestCase.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;

@RunWith(Parameterized.class)
public class MdlGenerationTest {

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][]{
                { "UseCase1_focei.ctl", Boolean.TRUE },
//                { "test_example.ctl", Boolean.TRUE },
//                { "warf_allomCL.ctl", Boolean.TRUE },
//                { "Executable_Simulated_Dupilumab.ctl", Boolean.TRUE }
        });
    }

    @Parameterized.Parameter(0)
    public String nmTranFile;

    @Parameterized.Parameter(1)
    public Boolean expectValid;

    @Test
    public void test() throws IOException {
        Path tmpFile = Files.createTempFile("nmTranProcess", ".ctl");
        try(BufferedReader in = new BufferedReader(new InputStreamReader(this.getClass().getResourceAsStream("/" + nmTranFile)))) {
            try (BufferedWriter out = Files.newBufferedWriter(tmpFile, StandardOpenOption.CREATE)) {
                NmtranPreprocessor preprocessor = new NmtranPreprocessor();
                preprocessor.preprocess(in, out);
            }
            CharStream input = CharStreams.fromPath(tmpFile);
            // Use case insensitive lexer
            CaseChangingCharStream upper = new CaseChangingCharStream(input, true);
            TestErrorListener errorListener = new TestErrorListener();
            NmtranLexer lexer = new NmtranLexer(upper);
            // suppress error messages from default error handlers
            lexer.removeErrorListeners();
            // add out test handler to count errors
            lexer.addErrorListener(errorListener);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            NmtranParser parser = new NmtranParser(tokens);
//            parser.removeErrorListeners();
            parser.addErrorListener(errorListener);
            ParseTree tree = parser.nmModel();
            MdlModelGenerationVisitor visitor = new MdlModelGenerationVisitor();
            visitor.visit(tree);
            String actualResult = visitor.writeMdlBlock();
            assertEquals(expectValid, !errorListener.isErrorDetected());
            System.out.println(actualResult);
//            if(expectValid) {
//                assertEquals(expectedExpr, actualResult);
////            assertEquals(expectedExpr, eb.getExpressionTree());
//            }
        }
    }

//    @Test
//    public void testIntegerLiteral(){
//        CharStream input = CharStreams.fromString(testExpr);
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
//        ParseTree tree = parser.nmEquation();
////        ParseTreeWalker walker = new ParseTreeWalker();
////        ExpressionBuilder eb = new ExpressionBuilder();
////        walker.walk(eb, tree);
//        MdlModelGenerationVisitor visitor = new MdlModelGenerationVisitor();
//        String actualResult = visitor.visit(tree);
//        assertEquals(expectValid, !errorListener.isErrorDetected());
//        if(expectValid) {
//            assertEquals(expectedExpr, actualResult);
////            assertEquals(expectedExpr, eb.getExpressionTree());
//        }
//    }
}