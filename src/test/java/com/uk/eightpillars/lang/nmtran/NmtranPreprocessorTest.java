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

import org.apache.commons.io.output.StringBuilderWriter;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.*;
import java.util.Arrays;
import java.util.Collection;

import static org.junit.Assert.assertEquals;

@RunWith(Parameterized.class)
public class NmtranPreprocessorTest {
    private NmtranPreprocessor testInstance;

    @Before
    public void setUp(){
        this.testInstance = new NmtranPreprocessor();
    }

    @After
    public void tearDown(){
        this.testInstance = null;
    }

    @Parameterized.Parameters(name = "{index}: {0}")
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][]{
                { "Single Option", "IGNORE=@", "IGNORE=\"@\"\n" },
                { "MultiOptions", "IGNORE=@ FILE=akdhs.shs ", "IGNORE=\"@\" FILE=\"akdhs.shs\" \n" },
                {  "Data Block One Option", "$DATA ads.fh IGNORE=@", "$DATA \"ads.fh\" IGNORE=\"@\"\n" },
                {  "Quoted Data Block One Option", "$DATA \"ads.fh\" IGNORE=@", "$DATA \"ads.fh\" IGNORE=\"@\"\n" },


                { "Data Block multi options", "$DATA ads.fh IGNORE=@ FILE=akdhs.shs ", "$DATA \"ads.fh\" IGNORE=\"@\" FILE=\"akdhs.shs\" \n" },
                { "Problem Block", "$PROBLEM ads.fh kdjs sshs dhdh  ", "$PROBLEM \"ads.fh kdjs sshs dhdh\"  \n" },
                { "Quoted Problem Block", "$PROBLEM \"ads.fh kdjs sshs dhdh\"  ", "$PROBLEM \"ads.fh kdjs sshs dhdh\"  \n" },
                { "Data block split into 2 lines",
                        "$DATA drugX_PO_2occ_dataMDL_v1.csv\n"
                                + "IGNORE=@\n",
                        "$DATA \"drugX_PO_2occ_dataMDL_v1.csv\"\n"
                                + "IGNORE=\"@\"\n",
                },
                { "Multiple lines",
                        "$PROBLEM ads.fh kdjs sshs dhdh  \n"
                        + "$DATA ads.fh IGNORE=@ FILE=akdhs.shs \n"
                        + "$MODEL \n",
                        "$PROBLEM \"ads.fh kdjs sshs dhdh\"  \n"
                        + "$DATA \"ads.fh\" IGNORE=\"@\" FILE=\"akdhs.shs\" \n"
                        + "$MODEL \n",
                },
                { "Case insensitive",
                        "$PROBlem ads.fh kdjs sshs dhdh  \n"
                                + "$DATA ads.fh ignore=@ FILE=akdhs.shs \n"
                                + "$MODEL \n",
                        "$PROBlem \"ads.fh kdjs sshs dhdh\"  \n"
                                + "$DATA \"ads.fh\" ignore=\"@\" FILE=\"akdhs.shs\" \n"
                                + "$MODEL \n",
                }
        });
    }

    @Parameterized.Parameter(0)
    public String testName;

    @Parameterized.Parameter(1)
    public String testStr;

    @Parameterized.Parameter(2)
    public String expectedResult;



    @Test
    public void replacementTest() throws IOException {
        String actualResult = "";
        try(BufferedReader in = new BufferedReader(new StringReader(testStr))) {
            StringBuilderWriter stringWriter = new StringBuilderWriter();
            try(BufferedWriter out = new BufferedWriter(stringWriter)) {
                this.testInstance.preprocess(in, out);
                out.close();
            }
            actualResult = stringWriter.toString();
        }
        assertEquals(expectedResult, actualResult);
    }

}
