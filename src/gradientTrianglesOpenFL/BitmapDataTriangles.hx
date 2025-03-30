package gradientTrianglesOpenFL;
import openfl.display.BitmapData;
import gradientTrianglesOpenFL.IteratorRange;
import lime.math.ARGB;
import openfl.geom.Rectangle;
@:forward
abstract BitmapDataTriangles( BitmapData ) from BitmapData to BitmapData {
    public inline function new( bd: BitmapData ){
        this = bd;
    }
    public inline function drawGradientTriangle( ax: Float, ay: Float, colA: Int
                                                      , bx: Float, by: Float, colB: Int
                                                      , cx: Float, cy: Float, colC: Int, blend = false ): BitmapDataTriangles {
        var aA = ( colB >> 24 ) & 0xFF;
        var rA = ( colB >> 16 ) & 0xFF;
        var gA = ( colB >> 8 ) & 0xFF;
        var bA = colB & 0xFF;
        var aB = ( colA >> 24 ) & 0xFF;
        var rB = ( colA >> 16 ) & 0xFF;
        var gB = ( colA >> 8 ) & 0xFF;
        var bB = colA & 0xFF;
        var aC = ( colC >> 24 ) & 0xFF;
        var rC = ( colC >> 16 ) & 0xFF;
        var gC = ( colC >> 8 ) & 0xFF;
        var bC = colC & 0xFF;
        var bcx = bx - cx;
        var bcy = by - cy;
        var acx = ax - cx; 
        var acy = ay - cy;
        // Had to re-arrange algorithm to work so dot names may not quite make sense.
        var dot11 = dotSame( bcx, bcy );
        var dot12 = dot( bcx, bcy, acx, acy );
        var dot22 = dotSame( acx, acy );
        var denom1 = 1/( dot11 * dot22 - dot12 * dot12 );
        var xIter3: IteratorRange = boundIterator3( ax, bx, cx );
        var yIter3: IteratorRange = boundIterator3( ay, by, cy );
        for( px in xIter3 ){
            var pcx = px - cx;
            for( py in yIter3 ){
                var pcy = py - cy;
                var dot31 = dot( pcx, pcy, bcx, bcy );
                var dot32 = dot( pcx, pcy, acx, acy );
                var ratioA = (dot22 * dot31 - dot12 * dot32) * denom1;
                var ratioB = (dot11 * dot32 - dot12 * dot31) * denom1;
                var ratioC = 1.0 - ratioB - ratioA;
                if( ratioA >= 0 && ratioB >= 0 && ratioC >= 0 ){
                    var a = boundChannel( aA*ratioA + aB*ratioB + aC*ratioC );
                    var r = boundChannel( rA*ratioA + rB*ratioB + rC*ratioC );
                    var g = boundChannel( gA*ratioA + gB*ratioB + gC*ratioC );
                    var b = boundChannel( bA*ratioA + bB*ratioB + bC*ratioC );
                    var color = ARGB.create( a, r, g, b );
                    if( blend == false ){
                        this.setPixel32( px, py, color );
                    } else {
                        this.setPixel( alphaBlend( this.getPixel32( px, py ), color ) );
                    }
                }
            }
        }
        return this;
    }
    public inline function drawTileTriangle( ax: Float, ay: Float
                                           , bx: Float, by: Float
                                           , cx: Float, cy: Float, tileImage: BitmapData, blend = false ): BitmapDataTriangles {
        var s0 = ay*cx - ax*cy;
        var sx = cy - ay;
        var sy = ax - cx;
        var t0 = ax*by - ay*bx;
        var tx = ay - by;
        var ty = bx - ax;
        var A = -by*cx + ay*(-bx + cx) + ax*(by - cy) + bx*cy; 
        var xIter3: IteratorRange = boundIterator3( ax, bx, cx );
        var yIter3: IteratorRange = boundIterator3( ay, by, cy );
        var foundY = false;
        var s = 0.;
        var t = 0.;
        var sxx = 0.;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
        var txx = 0.;
        for( x in xIter3 ){
            sxx = sx*x;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
            txx = tx*x;
            foundY = false;
            for( y in yIter3 ){
                s = s0 + sxx + sy*y;
                t = t0 + txx + ty*y;
                if( s <= 0 || t <= 0 ){
                    // after filling break
                    if( foundY ) break;
                } else {
                    if( (s + t) < A ) {
                        // store first hit
                        var color = tileImage.getPixel32( x % (tileImage.width), y % (tileImage.height) );
                        if( blend == false ){
                            this.setPixel32( x, y, color );
                        } else {
                            this.setPixel( alphaBlend( this.getPixel32( x, y ), color ) );
                        }
                        foundY = true;
                    } else {
                        // after filling break
                        if( foundY ) break;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                    }
                }
            }                                                                                                                                                                                                                                                                                                                                                                                                                                
        }
        return this;
    }

    inline function drawUVTriangle( ax: Float, ay: Float, au: Float, av: Float
                                  , bx: Float, by: Float, bu: Float, bv: Float
                                  , cx: Float, cy: Float, cu: Float, cv: Float
                                  , texture: BitmapData, win: Rectangle, blend = false ): BitmapDataTriangles {
    // switch A B as per gradient ( consider xor's )
        var temp = au;
        au = bu;
        bu = temp;
        temp = av;
        av = bv;
        bv = temp;
        //
        var bcx = bx - cx;
        var bcy = by - cy;
        var acx = ax - cx; 
        var acy = ay - cy;
        // Had to re-arrange algorithm to work so dot names may not quite make sense.
        var dot11 = dotSame( bcx, bcy );
        var dot12 = dot( bcx, bcy, acx, acy );
        var dot22 = dotSame( acx, acy );
        var denom1 = 1/( dot11 * dot22 - dot12 * dot12 );
        var xIter3: IteratorRange = boundIterator3( ax, bx, cx );
        var yIter3: IteratorRange = boundIterator3( ay, by, cy );
        for( px in xIter3 ){
            var pcx = px - cx;
            for( py in yIter3 ){
                var pcy = py - cy;
                var dot31  = dot( pcx, pcy, bcx, bcy );
                var dot32  = dot( pcx, pcy, acx, acy );
                var ratioA = (dot22 * dot31 - dot12 * dot32) * denom1;
                var ratioB = (dot11 * dot32 - dot12 * dot31) * denom1;
                var ratioC = 1.0 - ratioB - ratioA;
                if( ratioA >= 0 && ratioB >= 0 && ratioC >= 0 ){
                    var u = au*ratioA + bu*ratioB + cu*ratioC;
                    var v = av*ratioA + bv*ratioB + cv*ratioC;
                    var x = Std.int( u*win.width + win.x );
                    var y = Std.int( v*win.height + win.y );
                    var col = texture.getPixel32( x, y );
                    if( blend == false ){
                        this.setPixel32( px, py, col );
                    } else {
                        this.setPixel( alphaBlend( this.getPixel32( px, py ), col ) );
                    }
                }
            }
        }
        return this;
    }
    
    private inline static function boundChannel( f: Float ): Int {
        var i = Std.int( f );
        if( i > 0xFF ) i = 0xFF;
        if( i < 0 ) i = 0;
        return i;
    }
    private inline static function cross2d( ax: Float, ay: Float, bx: Float, by: Float ): Float
        return ax * by - ay * bx;
    private inline static function dot( ax: Float, ay: Float, bx: Float, by: Float ): Float
        return ax * bx + ay * by;
    private inline static function dotSame( ax: Float, ay: Float ): Float
        return dot( ax, ay, ax, ay );
    private static inline function rotX( x: Float, y: Float, sin: Float, cos: Float ): Float
        return x * cos - y * sin;
    private static inline function rotY( x: Float, y: Float, sin: Float, cos: Float ): Float
        return y * cos + x * sin;
    
    public function alphaBlend( orig: Int, onTop: Int ): Int {
        var a1 = ( orig >> 24 ) & 0xFF;
        var r1 = ( orig >> 16 ) & 0xFF;
        var g1 = ( orig >> 8 ) & 0xFF;
        var b1 = orig & 0xFF;
        var a2 = ( onTop >> 24 ) & 0xFF;
        var r2 = ( onTop >> 16 ) & 0xFF;
        var g2 = ( onTop >> 8 ) & 0xFF;
        var b2 = onTop & 0xFF;
        var a3 = a1 * ( 1 - a2 );
        var r = boundChannels( colBlendFunc( r1, r2, a3, a2 ) );
        var g = boundChannels( colBlendFunc( g1, g2, a3, a2 ) );
        var b = boundChannels( colBlendFunc( b1, b2, a3, a2 ) );
        var a = boundChannels( alphaBlendFunc( a3, a2 ) );
        return ARGB.create( a, r, g, b );
    }
    inline static function colBlendFunc( x1: Float, x2: Float, a3: Float, a2: Float ): Int
        return Std.int( 255 * ( x1 * a3 + x2 * a2 ) );
    inline static function alphaBlendFunc( a3: Float, a2: Float ): Int
        return Std.int( 255 * ( a3 + a2 ) );

}
