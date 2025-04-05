package gradientTrianglesOpenFL;
import lime.math.ARGB;

inline function ARGB_a( col: Int )
    return ( col >> 24 ) & 0xFF;
inline function ARGB_r( col: Int )
    return ( col >> 16 ) & 0xFF;
inline function ARGB_g( col: Int ) 
    return ( col >> 8 ) & 0xFF;
inline function ARGB_b( col: Int )
    return col & 0xFF;

inline function boundChannel(f: Float): Int {
    var i = Std.int(f);
    if (i > 0xFF) i = 0xFF;
    if (i < 0) i = 0;
    return i;
}

inline function alphaBlend( orig: Int, onTop: Int ): Int {
    var a1 = ARGB_a(orig);
    var r1 = ARGB_r(orig);
    var g1 = ARGB_g(orig);
    var b1 = ARGB_b(orig);
    var a2 = ARGB_a(onTop);
    var r2 = ARGB_r(onTop);
    var g2 = ARGB_g(onTop);
    var b2 = ARGB_b(onTop);
    return alphaBlendChannels( a1, r1, g1, b1, a2, r2, g2, b2 );
}
inline function alphaBlendWithChannels( orig, a2, r2, g2, b2 ){
    var a1 = ARGB_a(orig);
    var r1 = ARGB_r(orig);
    var g1 = ARGB_g(orig);
    var b1 = ARGB_b(orig);
    return alphaBlendChannels( a1, r1, g1, b1, a2, r2, g2, b2 );
}
inline function alphaBlendChannels( a1: Int, r1: Int, g1: Int, b1: Int, a2: Int, r2: Int, g2: Int, b2: Int ): Int {
    var a3 = a1 * (1 - a2);
    var r = colBlendFunc(r1, r2, a3, a2);
    var g = colBlendFunc(g1, g2, a3, a2);
    var b = colBlendFunc(b1, b2, a3, a2);
    var a = alphaBlendFunc(a3, a2);
    return ARGB.create(a, r, g, b);
}
inline function colBlendFunc(x1: Float, x2: Float, a3: Float, a2: Float): Int {
    return Std.int(255 * (x1 * a3 + x2 * a2));
}

inline function alphaBlendFunc(a3: Float, a2: Float): Int {
    return Std.int(255 * (a3 + a2));
}
