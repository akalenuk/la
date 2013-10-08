module types;

import std.traits : isNumeric;


struct Mat(T, int rows, int cols) if (isNumeric!T && rows>0 && cols>0) {
    T[rows][cols] guts;
    
    this(ref Mat!(T, rows, cols) src)
    in {
    	assert(rows == guts.length);
    	assert(cols == guts[0].length);
    } body {
        guts[] = src.guts[];
    }
    
    this(T[rows][cols] src)
    in {
    	assert(rows == guts.length);
    	assert(cols == guts[0].length);
    } body {
        guts[] = src[];
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

