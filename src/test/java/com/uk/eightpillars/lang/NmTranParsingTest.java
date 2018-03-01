package com.uk.eightpillars.lang;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collection;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class NmTranParsingTest {

    @Parameters(name = "{index}: {0}")
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][]{
                { "UseCase1_focei.ctl", Boolean.TRUE },
                { "test_example.ctl", Boolean.TRUE },
                { "warf_allomCL.ctl", Boolean.TRUE },
                { "Executable_Simulated_Dupilumab.ctl", Boolean.FALSE }
        });
    }

    @Parameterized.Parameter(0)
    public String nmTranFile;

    @Parameterized.Parameter(1)
    public Boolean expectValid;

//    public NmTranParsingTest(String file, Boolean expectation){
//        nmTranFile = file;
//        expectValid = expectation;
//    }

    @Test
    public void test() throws IOException {
        try(InputStream in = this.getClass().getResourceAsStream("/" + nmTranFile)){
            CharStream input = CharStreams.fromStream(in);
            TestErrorListener errorListener = new TestErrorListener();
            NmtranLexer lexer = new NmtranLexer(input);
            // suppress error messages from default error handlers
            lexer.removeErrorListeners();
            // add out test handler to count errors
            lexer.addErrorListener(errorListener);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            NmtranParser parser = new NmtranParser(tokens);
            parser.removeErrorListeners();
            parser.addErrorListener(errorListener);
            ParseTree tree = parser.nmModel();
            ParseTreeWalker walker = new ParseTreeWalker();
//            TestVisitor list = new TestVisitor();
//            walker.walk(list, tree);
            walker.walk(new NmtranParserBaseListener(), tree);
            assertTrue("validity expectation", expectValid != errorListener.isErrorDetected());
//            System.out.println(list.toString());
//            System.out.println(tree.toStringTree(parser));
        }

    }

}
