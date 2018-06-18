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

import org.stringtemplate.v4.ST;

import java.util.*;

public class BlockTemplates {
    private final String blkName;
    private final List<ST> eqns = new ArrayList<ST>();
    private final Map<Integer, ST> thetas = new HashMap<Integer, ST>();
    private final Map<Integer, ST> odes = new HashMap<Integer, ST>();

    public BlockTemplates(String blkName){
        this.blkName = blkName;
    }

    public String getBlkName() {
        return blkName;
    }

    public Map<Integer, ST> getThetas() {
        return thetas;
    }

    public void addTheta(int posn, ST tmpl){
        this.thetas.put(posn, tmpl);
    }

    public Map<Integer, ST> getOdes() {
        return odes;
    }

    public void addOdes(int posn, ST tmpl){
        this.odes.put(posn, tmpl);
    }

    public List<ST> getEqns() {
        return eqns;
    }

    public void addEqns(ST eqnSt){
        this.eqns.add(eqnSt);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BlockTemplates that = (BlockTemplates) o;
        return Objects.equals(blkName, that.blkName);
    }

    @Override
    public int hashCode() {

        return Objects.hash(blkName);
    }
}
