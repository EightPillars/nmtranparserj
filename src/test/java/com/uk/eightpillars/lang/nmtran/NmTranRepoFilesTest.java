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
import java.util.*;

import static junit.framework.TestCase.assertTrue;

@RunWith(Parameterized.class)
public class NmTranRepoFilesTest {

    // false if you want to see errors from failing tests
    private static final boolean SUPPRESS_ERROR_MSGS = false;

    private static String FAILING_FILES[] = {
//            "Executable_real_NONMEM_diabetes_progression_ORG.ctl",
//            "Simulate_P241.ctl",
//            "theopd.ctl",
//            "Executable_runEV2_105.ctl",
//            "theopd_est.ctl"
    };

    @Parameters(name = "{index}: {0}")
    public static Collection<Object[]> data() {
        try {
            Set<String> failingFiles = new HashSet<String>();
            failingFiles.addAll(Arrays.asList(FAILING_FILES));
            URL url = System.class.getResource("/repoModels");
            Path ucDir = Paths.get(url.toURI());
            Collection<File> files = FileUtils.listFiles(ucDir.toFile(), new WildcardFileFilter("*.ctl"), null);
            List<Object[]> retVal = new ArrayList<Object[]>();
            for(File f : files){
                Boolean valid = Boolean.TRUE;
                if(failingFiles.contains(f.getName())) valid = Boolean.FALSE;
                retVal.add(new Object[] { f.getName(), f.getPath(), valid });
            }
            return retVal;
        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

    @Parameterized.Parameter(0)
    public String testName;

    @Parameterized.Parameter(1)
    public String nmTranFile;

    @Parameterized.Parameter(2)
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
            if(SUPPRESS_ERROR_MSGS) lexer.removeErrorListeners();
            // add out test handler to count errors
            lexer.addErrorListener(errorListener);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            NmtranParser parser = new NmtranParser(tokens);
              if(SUPPRESS_ERROR_MSGS) parser.removeErrorListeners();
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
