module types;

import std.traits : isNumeric;


struct Mat(T, int rows, int cols) if (isNumeric!T && rows>0 && cols>0) {
    T[cols][rows] guts;
    
    this(ref Mat!(T, rows, cols) src) {
        guts[] = src.guts[];
    }
    

    this(T[cols][rows] src){
        guts[] = src[];
    }

/*    this(T[][] src)
    in {
    	assert(rows == guts.length);
    	assert(cols == guts[0].length);
    } body {
        foreach (i; 0 .. guts.length) {
            foreach (j; 0 .. guts[i].length) {
                guts[i][j] = src[i][j];
            }
        }
    }*/

    Mat!(T, rows, cols) opUnary(string op)() if (op == "-") {
        auto res = Mat!(T, rows, cols)();
        foreach (i; 0 .. guts.length) {
            foreach (j; 0 .. guts[i].length) {
                res.guts[i][j] = -guts[i][j];
            }
        }
        return res;
    }

    Mat!(T, rows, cols) opBinary(string op)(ref Mat!(T, rows, cols) A) if (op == "+" || op == "-") {
        auto res = Mat!(T, rows, cols)();
        foreach (i; 0 .. guts.length) {
            foreach (j; 0 .. guts[i].length) {
                res.guts[i][j] = mixin("guts[i][j]"~op~"A.guts[i][j]");
            }
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
                res.guts[i][j] = 0;
                foreach (k; 0 .. cols) {
                    res.guts[i][j] += guts[i][k] * A.guts[k][j];
                }
            }
        }
        return res;
    }

    Mat!(T, rows, cols) opBinary(string op, S)(S s) if ((op == "*" || op == "/") && isNumeric!S) {
        auto res = Mat!(T, rows, cols)();
        foreach (i; 0 .. guts.length) {
            foreach (j; 0 .. guts[1].length) {
                res.guts[i][j] = mixin("guts[i][j] "~op~" s");
            }
        }
        return res;
    }

}


struct Vec(T, int size) if (isNumeric!T && size>0) {
    T[size] guts;

    this(ref Vec!(T, size) src)
    in {
    	assert(size == guts.length);
    } body {
    	guts[] = src.guts[];
    }
    
    this(T[size] src)
    in {
    	assert(size == guts.length);
    } body {
    	guts[] = src[];
    }
}

unittest{
    auto pm1 = Mat!(float, 2, 3)( [[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]] );
    auto pm2 = Mat!(float, 3, 2)( [[7.0, 8.0], [9.0, 10.0], [11.0, 12.0]] );
    auto pm3 = Mat!(float, 2, 2)( [[58.0, 64.0], [139.0, 154.0]] );
    assert( pm1 * pm2 == pm3 );
}


