
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author leonardo
 */
public class AsmConverter {
    
    public static void main(String[] args) {
        printEdges();
        printVerticesLocal();
        printVerticesWorld();
        printVerticesScreen();
    }
    
    private static void printEdges() {
        List<Edge> edges = new ArrayList<>();
        
        for (int[] indexes : Torus.faces) {
            for (int i = 0; i < indexes.length; i++) {
                int p1 = indexes[i + 0];
                int p2 = indexes[(i + 1) % indexes.length];
                Edge edge = new Edge(p1, p2);
                if (!edges.contains(edge)) {
                    edges.add(edge);
                }
            }
        }
        
        System.out.println("\t\tedges:");
        int index = 0;
        for (Edge edge : edges) {
            String xs = "    " + edge.p1;
            String ys = "    " + edge.p2;
            xs = xs.substring(xs.length() - 3, xs.length());
            ys = ys.substring(ys.length() - 3, ys.length());
            System.out.println("\t\t\tdb " + xs + ", " + ys + " ; " + index++);
        }
        System.out.println("");
        System.out.println("\t\tedges_count	dw " + index);
        System.out.println("");
    }
    
    private static void printVerticesLocal() {
        System.out.println("\t\tvertices_local:");
        int index = 0;
        for (Vec3 point : Torus.vertices) {
            String xs = "          " + new BigDecimal("" + point.x).setScale(4, RoundingMode.HALF_UP).toPlainString();
            String ys = "          " + new BigDecimal("" + point.y).setScale(4, RoundingMode.HALF_UP).toPlainString();
            String zs = "          " + new BigDecimal("" + point.z).setScale(4, RoundingMode.HALF_UP).toPlainString();
            xs = xs.substring(xs.length() - 10, xs.length());
            ys = ys.substring(ys.length() - 10, ys.length());
            zs = zs.substring(zs.length() - 10, zs.length());
            System.out.println("\t\t\tdq " + xs + ", " + ys + ", " + zs + " ; " + index++);
        }
        System.out.println("");
        System.out.println("\t\tvertices_count	dw " + index);
        System.out.println("");
    }
    
    private static void printVerticesWorld() {
        System.out.println("\t\tvertices_world:");
        int index = 0;
        for (Vec3 point : Torus.vertices) {
            String xs = "          " + new BigDecimal("" + 0.0).setScale(4, RoundingMode.HALF_UP).toPlainString();
            String ys = "          " + new BigDecimal("" + 0.0).setScale(4, RoundingMode.HALF_UP).toPlainString();
            String zs = "          " + new BigDecimal("" + 0.0).setScale(4, RoundingMode.HALF_UP).toPlainString();
            xs = xs.substring(xs.length() - 10, xs.length());
            ys = ys.substring(ys.length() - 10, ys.length());
            zs = zs.substring(zs.length() - 10, zs.length());
            System.out.println("\t\t\tdq " + xs + ", " + ys + ", " + zs + " ; " + index++);
        }
        System.out.println("");
    }
    
    private static void printVerticesScreen() {
        System.out.println("\t\tvertices_screen:");
        int index = 0;
        for (Vec3 point : Torus.vertices) {
            String xs = "          " + new BigDecimal("" + 0.0).setScale(4, RoundingMode.HALF_UP).toPlainString();
            String ys = "          " + new BigDecimal("" + 0.0).setScale(4, RoundingMode.HALF_UP).toPlainString();
            xs = xs.substring(xs.length() - 10, xs.length());
            ys = ys.substring(ys.length() - 10, ys.length());
            System.out.println("\t\t\tdw " + xs + ", " + ys + " ; " + index++);
        }
        System.out.println("");
    }
        
    
}
