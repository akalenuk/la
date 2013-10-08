module operators;

import types;

import std.traits : isNumeric;

//struct Mat(T, int rows, int cols){

    Mat!(T, rows, cols) opUnary(string op)() if (op == "+" || op == "-") {
        auto res = Mat!(T, rows, cols)();

        foreach (i; 0 .. v.length) {
            res.guts[i] = mixin(op~"v[i]");
        }

        return res;
    }

    Mat!(T, rows, cols) opBinary(string op)(ref Mat!(T, rows, cols) A) if (op == "+" || op == "-") {
        auto res = Mat!(T, rows, cols)();

        foreach (i; 0 .. v.length) {
            res.guts[i] = mixin("v[i] "~op~" A.guts[i]");
        }

        return res;
    }

    Mat!(T, rows, cols) opOpAssign(string op)(ref Mat!(T, rows, cols) A) if (op == "+" || op == "-") {
        this = opBinary!op(A);

        return this;
    }

    Mat!(T, rows, A_cols) opBinary(string op, int A_cols)(ref Mat!(T, cols, A_cols) A) if (op == "*") {
        auto res = Mat!(T, rows, A_cols)();

        foreach (i; 0 .. rows) {
            foreach (j; 0 .. A_cols) {
                res.guts[j * rows + i] = 0;
                foreach (k; 0 .. cols) {
                    res.guts[j * rows + i] += v[k * rows + i] * A.guts[j * cols + k];
                }
            }
        }

        return res;
    }

    Mat!(T, rows, cols) opBinary(string op, S)(S s) if ((op == "+" || op == "-" || op == "*" || op == "/") && isNumeric!S) {
        auto res = Mat!(T, rows, cols)();

        foreach (i; 0 .. v.length) {
            res.guts[i] = mixin("v[i] "~op~" s");
        }

        return res;
    }

    Mat!(T, rows, cols) opOpAssign(string op, S)(S s) if ((op == "+" || op == "-" || op == "*" || op == "/") && isNumeric!S) {
        this = opBinary!op(A);

        return this;
    }
//}
/*
alias Mat!(double, 2, 2) Mat22d;
alias Mat!(double, 3, 3) Mat33d;
alias Mat!(double, 3, 4) Mat34d;
alias Mat!(double, 4, 4) Mat44d;
alias Mat!(double, 2, 1) Vec2d;
alias Mat!(double, 3, 1) Vec3d;
alias Mat!(double, 4, 1) Vec4d;

unittest {
    auto a = Mat33d([[1, 2, 3],
                     [4, 5, 6],
                     [7, 8, 9]]);
    auto b = Vec3d([1, 2, 3]);

    assert((a * b).guts == [14, 32, 50]);
    assert((a * a).guts == [30, 66, 102, 36, 81, 126, 42, 96, 150]);
    assert((a + a).guts == [2, 8, 14, 4, 10, 16, 6, 12, 18]);
    assert((a * 2).guts == [2, 8, 14, 4, 10, 16, 6, 12, 18]);
    assert((a / 2).guts == [0.5, 2, 3.5, 1, 2.5, 4, 1.5, 3, 4.5]);
    assert((a + 10).guts == [11, 14, 17, 12, 15, 18, 13, 16, 19]);

    a += a;
    assert(a.guts == [2, 8, 14, 4, 10, 16, 6, 12, 18]);

    a -= a;
    assert(a.guts == [0, 0, 0, 0, 0, 0, 0, 0, 0]);
}*/
