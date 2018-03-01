package com.uk.eightpillars.lang.nmtran;

import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.WildcardFileFilter;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import java.io.*;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

import static junit.framework.TestCase.assertTrue;

@RunWith(Parameterized.class)
public class NmTranUseCaseTest {

    @Parameters(name = "{index}: {0}")
    public static Collection<Object[]> data() {
        try {
            URL url = System.class.getResource("/NH_UseCases");
            Path ucDir = Paths.get(url.toURI());
            Collection<File> files = FileUtils.listFiles(ucDir.toFile(), new WildcardFileFilter("*.ctl"), null);
            List<Object[]> retVal = new ArrayList<Object[]>();
            for(File f : files){
                retVal.add(new Object[] { f.getPath(), Boolean.TRUE });
            }
            return retVal;
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
//        return Arrays.asList(new Object[][]{
//                { "UseCase1_focei.ctl", Boolean.TRUE },
//                { "test_example.ctl", Boolean.TRUE },
//                { "warf_allomCL.ctl", Boolean.TRUE },
//                { "Executable_Simulated_Dupilumab.ctl", Boolean.TRUE }
//        });
    }

    @Parameterized.Parameter(0)
    public String nmTranFile;

    @Parameterized.Parameter(1)
    public Boolean expectValid;

    @Test
    public void test() throws IOException {
        Path tmpFile = Files.createTempFile("nmTranProcess", ".ctl");
//        try(BufferedReader in = new BufferedReader(new InputStreamReader(this.getClass().getResourceAsStream("/" + nmTranFile)))){
          try(BufferedReader in = new BufferedReader(new FileReader(nmTranFile))){
            try(BufferedWriter out = Files.newBufferedWriter(tmpFile, StandardOpenOption.CREATE)) {
                NmtranPreprocessor preprocessor = new NmtranPreprocessor();
                preprocessor.preprocess(in, out);
            }
            CharStream input = CharStreams.fromPath(tmpFile);
            // Use case insensitive lexer
            CaseChangingCharStream upper = new CaseChangingCharStream(input, true);
            TestErrorListener errorListener = new TestErrorListener();
            NmtranLexer lexer = new NmtranLexer(upper);
            // suppress error messages from default error handlers
//            lexer.removeErrorListeners();
            // add out test handler to count errors
            lexer.addErrorListener(errorListener);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            NmtranParser parser = new NmtranParser(tokens);
//            parser.removeErrorListeners();
            parser.addErrorListener(errorListener);
            ParseTree tree = parser.nmModel();
            ParseTreeWalker walker = new ParseTreeWalker();
            walker.walk(new NmtranParserBaseListener(), tree);
            assertTrue("validity expectation", expectValid != errorListener.isErrorDetected());
        }
        finally{
//            System.err.println(tmpFile);
            Files.deleteIfExists(tmpFile);
        }

    }

}
