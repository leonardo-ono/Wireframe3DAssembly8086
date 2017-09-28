/**
 *
 * @author leo
 */
public class Vec3 {

    public double x;
    public double y;
    public double z;

    public Vec3(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public Vec3(Vec3 v) {
        x = v.x;
        y = v.y;
        z = v.z;
    }

    public void set(Vec3 v) {
        x = v.x;
        y = v.y;
        z = v.z;
    }

    public void set(double x, double y, double z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public void translate(double dx, double dy, double dz) {
        x += dx;
        y += dy;
        z += dz;
    }

    public void rotateZ(double angle) {
        double s = Math.sin(angle);
        double c = Math.cos(angle);
        double nx = x * c + y * s;
        double ny = x * -s + y * c;
        x = nx;
        y = ny;
    }

    public void rotateX(double angle) {
        double s = Math.sin(angle);
        double c = Math.cos(angle);
        double nz = z * c + y * s;
        double ny = z * -s + y * c;
        z = nz;
        y = ny;
    }

    public void rotateY(double angle) {
        double s = Math.sin(angle);
        double c = Math.cos(angle);
        double nz = z * c + x * s;
        double nx = z * -s + x * c;
        z = nz;
        x = nx;
    }
    
    public Vec3 sub(Vec3 v) {
        return new Vec3(x - v.x, y - v.y, z - v.z);
    }

    public void doPerspectiveTransformation() {
        double d = 300;
        double nx = d * x / -z;
        double ny = d * y / -z;
        x = nx;
        y = ny;
    }

    // http://en.wikipedia.org/wiki/Cross_product
    // http://tutorial.math.lamar.edu/Classes/CalcII/CrossProduct.aspx
    // v1=(a1, a2, a3) e v2=(b1, b2, b3) formula: a x b = (a2*b3-a3*b2, a3*b1-a1*b3, a1*b2-a2*b1)
    public Vec3 cross(Vec3 v) {
        double a1 = x;
        double a2 = y;
        double a3 = z;
        double b1 = v.x;
        double b2 = v.y;
        double b3 = v.z;
        return new Vec3(a2 * b3 - a3 * b2, a3 * b1 - a1 * b3, a1 * b2 - a2 * b1);
    }

    public double getSize() {
        return Math.sqrt(x * x + y * y + z * z);
    }

}
