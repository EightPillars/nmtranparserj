package com.uk.eightpillars.lang;

import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;

public class TestErrorListener extends BaseErrorListener {

    private int errorsDetected = 0;

    public boolean isErrorDetected(){
        return errorsDetected > 0;
    }

    public int getNumErrors(){
        return errorsDetected;
    }

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
        this.errorsDetected++;
    }

}
