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

// TODO decent unit testing

module matrix;

import std.math : sqrt, pow;

pure nothrow bool isMatrix(T)(T[][] A) {
    foreach (i; 1 .. A.length){
        if(A[i].length != A[0].length){
            return false;
        }
    }
    return true;
}

pure nothrow bool isSquare(T)(T[][] A) {
    return isMatrix(A) && (A.length == A[0].length);
}


pure nothrow S eu_norm(S = real, T)(T[][] A) 
in {
    assert( isMatrix(A) );
} body {
    S res = 0.0;
    foreach (i; 0 .. A.length) {
        foreach (j; 0 .. A[0].length) {
            res += pow(A[i][j], 2);
        }
    }
    return sqrt(res);
}


pure nothrow T[][] transpose(T)(T[][] A) 
in {
    assert( isMatrix(A) );
} body {
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

pure nothrow T[][] mul(T)(T[][] A, T[][] B) 
in {
    assert(isMatrix(A));
    assert(isMatrix(B));
    assert(B.length == A[0].length);
} body {
    size_t AH = A.length;
    size_t AW = A[0].length;
    size_t BH = B.length;
    size_t BW = B[0].length;
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

pure nothrow T[] mul(T)(T[] a, T[][] B) {
    auto A = [a];
    auto mres = mul(A, B);
    return mres[0];
}

pure nothrow T[] mul(T)(T[][] A, T[] b) {
    return mul(b, transpose(A));
}

pure nothrow T[][] minor(T)(T[][] A, ulong the_i, ulong the_j) 
in {
    assert( isMatrix(A) );
    assert( A.length != 0 );
    assert( A[0].length != 0 );
} body {
    T[][] res;
    res.length = A.length - 1;
    foreach (i; 0 .. res.length) {
        res[i].length = A[0].length -1;
        foreach (j; 0 .. A[0].length -1) {
            res[i][j] = A[i + ((i >= the_i)?1:0)][j + ((j >= the_j)?1:0)];
        }
    }
    return res; 
}

pure nothrow T det(T)(T[][] A) 
in {
    assert( isSquare(A) );
} body {
    if( A.length == 1 ){
        return A[0][0];
    }else if( A.length == 2 ){
        return (A[0][0] * A[1][1]) - (A[0][1] * A[1][0]);
    }else{
        T res = 0;
        foreach (j; 0 .. A.length) {
            res += A[0][j] * det(minor(A, 0, j)) * ((j % 2 == 0)?(1):(-1));
        }
        return res;
    }
}



unittest{
    assert(mul([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]], [[7.0, 8.0], [9.0, 10.0], [11.0, 12.0]]) == [[58.0, 64.0], [139.0, 154.0]]);
    assert(mul([3.0, 4.0, 2.0], [[13.0, 9.0, 7.0, 15.0], [8.0, 7.0, 4.0, 6.0], [6.0, 4.0, 0.0, 3.0]]) == [83.0, 63.0, 37.0, 75.0]);
    assert(mul([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0], [7.0, 8.0, 9.0], [10.0, 11.0, 12.0]], [-2.0, 1.0, 0.0]) == [0.0, -3.0, -6.0, -9.0]);

    assert(minor([[1, 2, 3], [4, 5, 6], [7, 8, 9]], 2, 1) == [[1, 3], [4, 6]]);
    assert(det([[1, 2, 3], [3, 2, 1], [2, 1, 3]]) == -12);

    assert(eu_norm([[1.0, 1.0], [1.0, 1.0]]) == 2.0);
}
