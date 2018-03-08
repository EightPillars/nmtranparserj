package com.uk.eightpillars.lang.nmtran;

import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public class NmTranLanguageParser<T> {

    private NmtranParserVisitor<T>  nmtranParserVisitor;
    private ANTLRErrorListener errorListener;

    public NmtranParserVisitor<T> getNmtranParserVisitor() {
        return nmtranParserVisitor;
    }

    public void setNmtranParserVisitor(NmtranParserVisitor<T> nmtranParserVisitor) {
        this.nmtranParserVisitor = nmtranParserVisitor;
    }

    public ANTLRErrorListener getErrorListener() {
        return errorListener;
    }

    public void setErrorListener(ANTLRErrorListener errorListener) {
        this.errorListener = errorListener;
    }


    public void parseFile(Path nmTranFile) throws IOException {
        Path tmpFile = Files.createTempFile("nmTranProcess", ".ctl");
        try (BufferedReader in = new BufferedReader(new FileReader(nmTranFile.toFile()))) {
            try (BufferedWriter out = Files.newBufferedWriter(tmpFile, StandardOpenOption.CREATE)) {
                NmtranPreprocessor preprocessor = new NmtranPreprocessor();
                preprocessor.preprocess(in, out);
            }
            CharStream input = CharStreams.fromPath(tmpFile);
            // Use case insensitive lexer
            CaseChangingCharStream upper = new CaseChangingCharStream(input, true);
            NmtranLexer lexer = new NmtranLexer(upper);
            // suppress error messages from default error handlers
            lexer.removeErrorListeners();
            // add out test handler to count errors
            lexer.addErrorListener(errorListener);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            NmtranParser parser = new NmtranParser(tokens);
            parser.removeErrorListeners();
            parser.addErrorListener(errorListener);
            ParseTree tree = parser.nmModel();
            this.nmtranParserVisitor.visit(tree);
        }
    }
}

