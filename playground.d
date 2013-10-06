static import vector;
static import matrix;
import std.stdio;

// This doesn't belong to the library, but I'll just keep it for now.

void main()
{
    auto a = [1.0, 2.0, 3.0];
    auto b = [1.0, 2.0, 3.0];
    auto c = vector.add(a, b);
    assert(c == [2.0, 4.0, 6.0]);
    printf("add: %f, %f, %f\n", c[0], c[1], c[2]);
    printf("eu_norm: %f\n", cast(float)vector.eu_norm([3.0, 4.0]));
    auto d = vector.cross([[3.0, -3.0, 1.0], [4.0, 9.0, 2.0]]);
    printf("cross: %f, %f, %f\n", d[0], d[1], d[2]);

    auto e = matrix.mul([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]], [[7.0, 8.0], [9.0, 10.0], [11.0, 12.0]]); // [[58.0, 64.0], [139.0, 154.0]]
    printf("matrix mul1: %f, %f\n", e[0][0], e[0][1]);
    printf("matrix mul2: %f, %f\n", e[1][0], e[1][1]);
    auto f = matrix.mul([3.0, 4.0, 2.0], [[13.0, 9.0, 7.0, 15.0], [8.0, 7.0, 4.0, 6.0], [6.0, 4.0, 0.0, 3.0]]); // [83.0, 63.0, 37.0, 75.0]
    printf("vector-matrix mul: %f, %f, %f, %f\n", f[0], f[1], f[2], f[3]);
}
