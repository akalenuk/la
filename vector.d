/*
Copyright 2013 Alexandr Kalenuk.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

// TODO refactor variable names and types

module vector;


import std.math : sqrt, pow;
import std.traits : isNumeric;

pure T[] add(T)(T[] a, T[] b) 
in {
    assert(a.length == b.length);
} body {
    T[] res = a.dup;
    foreach (i; 0 .. a.length) {
        res[i] +=  b[i];
    }
    return res;
}

pure T[] sub(T)(T[] a, T[] b) 
in {
    assert(a.length == b.length);
} body {
    T[] res = a.dup;
    foreach (i; 0 .. a.length) {
        res[i] -=  b[i];
    }
    return res;
}

pure nothrow S dot(S = real, T)(T[] a, T[] b) 
in {
    assert(a.length == b.length);
} body {
    S res = 0.0;
    foreach (i; 0 .. a.length) {
        res += a[i] * b[i];
    }
    return res;
}

pure nothrow S eu_norm(S = real, T)(T[] a) if (isNumeric!T) {
    S res = 0.0;
    foreach (i; 0 .. a.length) {
        res += pow(a[i], 2);
    }
    return sqrt(res);
}

pure S eu_distance(S = real, T)(T[] a, T[] b) {
    return eu_norm(sub(a, b));
}

pure T[] mul(S, T)(S s, T[] a) if (isNumeric!S) {
    T[] res = a.dup;
    foreach (i; 0 .. a.length) {
        res[i] *= s;
    }
    return res;
}

pure T[] mul(T, S)(T[] a, S s) if (isNumeric!S) {
    return mul(s, a);
}

// Levi-Civita symbol. a is a list of indices
private pure int levi_civita(size_t[] a) {
    int n = 0;
    size_t[] t = a.dup;
   
    foreach (i; 0 .. a.length) {
        foreach (j; 0 .. (a.length - i - 1)) {
            if (t[j] == t[j + 1]) {
                return 0;
            } else if (t[j] > t[j + 1]) {
                n += 1;
                size_t r = t[j];
                t[j] = t[j+1];
                t[j+1] = r;
            }
        }
    }
    if ( n % 2 == 0){
        return 1;
    }else{
        return -1;
    }
}

// This is a multidimentional cross product. A is an array of vectors, not a matrix
pure T[] cross(T)(T[][] A) 
in {
    assert(A.length >= 2);
    foreach (a; A) {
        assert(a.length == A.length + 1);
    }
} body {
    size_t N = A.length;
    size_t DIMM = A[0].length;

    T[] res;
    res.length = DIMM;
    foreach (i; 0 .. DIMM) {
        res[i] = 0;
        foreach (jk; 0 .. pow(DIMM, N)) {
            size_t[] v_ijk;
            v_ijk ~= [i];
            foreach (j; 0 .. N) {
                v_ijk ~= [((jk / (pow(DIMM, (N - j - 1)))) % DIMM)];
            }
            int sign = levi_civita(v_ijk);
            if (sign != 0) {
                T res_add = cast(T)sign;
                foreach (k; 0 .. N) {
                    res_add *= A[k][v_ijk[k + 1]];
                }
                res[i] += res_add;
            }
        }
    }
    return res;
}

// multidimensional "triple" product. A is an array of vectors
pure T nple(T)(T[][] A) 
in {  
    assert(A.length >= 3);
    foreach (a; A) {
        assert(a.length == A.length);
    }
} body {
    size_t N = A.length;
    size_t DIMM = A[0].length;

    T res = 0.0;
    foreach (jk; 0 .. pow(DIMM, N)) {
        size_t[] v_ijk;
        foreach (j; 0 .. N) {
            v_ijk ~= [(jk / pow(DIMM, N - j - 1)) % DIMM ];
        }
        int sign = levi_civita(v_ijk);
        if( sign != 0 ){
            T res_add = cast(T)sign;
            foreach (k; 0 .. N){
                res_add *= A[k][v_ijk[k]];
            }
            res += res_add;
        }
    }
    return res;
}

unittest{
    assert(add([1, 2, 3], [4, 5, 6]) == [5, 7, 9]);
    assert(sub([5, 7, 9], [1, 2, 3]) == [4, 5, 6]);
    assert(dot([1, 2, 3], [1, 2, 3]) == 14);
    assert(eu_norm([3.0, 4.0]) == 5.0);
    assert(eu_distance([4, 5], [1, 1]) == 5.0);
    assert(mul(5, [1, 2, 3]) == [5, 10, 15]);
    assert(mul([1.0, 2.0, 3.0], 5) == [5.0, 10.0, 15.0]);
    assert(cross([[3.0, -3.0, 1.0], [4.0, 9.0, 2.0]]) == [-15.0, -2.0, 39.0]);
    assert(nple([[-2.0, 3.0, 1.0], [0.0, 4.0, 0.0], [-1.0, 3.0, 3.0]]) == -20.0);
}

