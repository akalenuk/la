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

// TODO assertions for all invariants

module matrix;

import std.stdio;

pure T[][] mul(T)(T[][] A, T[][] B) {
    ulong AH = A.length;
    ulong AW = A[0].length;
    foreach (a; A){
        assert(a.length == AW);
    }
    ulong BH = B.length;
    ulong BW = B[0].length;
    foreach (b; B){
        assert(b.length == BW);
    }
    assert(AW == BH);
    T[][] C;
    C.length = AH;
    foreach (i; 0 .. AH) {
        C[i].length = BW;
        foreach (j; 0 .. BW) {
            C[i][j] = 0;
            foreach (k; 0 .. AW) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    return C;
}

pure T[] mul(T)(T[] a, T[][] B) {
    T[][] A = [a];
    T[][] mres = mul(A, B);
    return mres[0];
}

pure T[] mul(T)(T[][] A, T[] b) {
    return mul(b, transpose(A));
}

pure T[][] transpose(T)(T[][] A) {
    T[][] C;
    C.length = A[0].length;
    foreach (i; 0 .. A[0].length) {
        C[i].length = A.length;
        foreach (j; 0 .. A.length) {
            C[i][j] = A[j][i];
        }
    }
    return C;
}

unittest{
    assert(mul([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]], [[7.0, 8.0], [9.0, 10.0], [11.0, 12.0]]) == [[58.0, 64.0], [139.0, 154.0]]);
    assert(mul([3.0, 4.0, 2.0], [[13.0, 9.0, 7.0, 15.0], [8.0, 7.0, 4.0, 6.0], [6.0, 4.0, 0.0, 3.0]]) == [83.0, 63.0, 37.0, 75.0]);
    assert(mul([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0], [10.0, 11.0, 12.0]], [-2.0, 1.0, 0.0]) == [0.0, -3.0, -6.0, -9.0]);
}
