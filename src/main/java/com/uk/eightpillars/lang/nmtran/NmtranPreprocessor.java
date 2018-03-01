package com.uk.eightpillars.lang.nmtran;

import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class NmtranPreprocessor {
    private static final String OPTION_KWDS[] = {
            "FILE", "IGNORE", "GRD", "MSFO", "FORMAT", "METHOD"
    };
    private static final String DATA_LIKE_BLOCKS[] = {
            "DAT\\w*", "MSF\\w*"
    };

    private final Pattern optionPattern;
    private final Pattern problemPattern;
    private final Pattern dataPattern;
    private BufferedWriter bout;

    public NmtranPreprocessor(){
        optionPattern = compPat(buildPattern("((?:", OPTION_KWDS, ")\\s*=\\s*)(\\S+)"));
//        optionPattern = Pattern.compile(buildOptionKwdPattern());
        problemPattern = compPat("(\\$PRO\\w*\\s+)(.+\\b)(\\s*)$");
//        dataPattern = Pattern.compile("(\\$DATA\\s+)(\\S+)");
        dataPattern = compPat(buildPattern("(\\$(?:", DATA_LIKE_BLOCKS, ")\\s+)(\\S+)"));
    }

    private static Pattern compPat(String pattern){
        return Pattern.compile(pattern, Pattern.CASE_INSENSITIVE);
    }

    private static String buildPattern(String prefix, String [] list, String suffix){
        StringBuilder buf = new StringBuilder(prefix);
        for(int i = 0; i < list.length; i++){
            buf.append(list[i]);
            if(i < list.length - 1){
                buf.append("|");
            }
        }
        buf.append(suffix);
        return buf.toString();
    }

//    private static String buildOptionKwdPattern(){
//        StringBuilder buf = new StringBuilder("((?:");
//        for(int i = 0; i < OPTION_KWDS.length; i++){
//            buf.append(OPTION_KWDS[i]);
//            if(i < OPTION_KWDS.length - 1){
//                buf.append("|");
//            }
//        }
//        buf.append(")\\s*=\\s*)(\\S+)");
//        return buf.toString();
//    }

    public void preprocess(BufferedReader bin, BufferedWriter bout) {
        try {
//            BufferedReader bin = new BufferedReader(new InputStreamReader(in));
//            this.bout = new BufferedWriter(new OutputStreamWriter(out));
            for(String buf = bin.readLine(); buf != null; buf = bin.readLine()){
                bout.write(processLine(processLine(processLine(buf, optionPattern, "$1\"$2\""),
                                                    problemPattern, "$1\"$2\"$3"),
                                        dataPattern, "$1\"$2\""));
                bout.newLine();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private String processLine(String line, Pattern pat, String replacementStr) throws IOException {
        Matcher mat = pat.matcher(line);
        if(mat.find()) {
            int cnt = mat.groupCount();
            String replacementVal = mat.replaceAll(replacementStr);
            return replacementVal;
        }
        return line;
    }
}
