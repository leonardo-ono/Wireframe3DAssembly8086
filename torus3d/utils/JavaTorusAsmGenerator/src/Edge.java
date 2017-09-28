/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author leonardo
 */
public class Edge {
    
    public int p1;
    public int p2;

    public Edge(int p1, int p2) {
        this.p1 = p1;
        this.p2 = p2;
    }

    @Override
    public int hashCode() {
        int hash = 5;
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final Edge other = (Edge) obj;
        if (p1 == other.p1 && p2 == other.p2) {
            return true;
        }
        else if (p1 == other.p2 && p2 == other.p1) {
            return true;
        }
        return false;
    }
    
}
