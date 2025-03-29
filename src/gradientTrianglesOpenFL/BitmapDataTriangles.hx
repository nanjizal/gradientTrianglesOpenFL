package gradientTrianglesOpenFL;
import openfl.display.BitmapData;
import gradientTrianglesOpenFL.IteratorRange;
import lime.math.ARGB;
@:forward
abstract BitmapDataTriangles( BitmapData ) from BitmapData to BitmapData {
    public inline function new( bd: BitmapData ){
        this = bd;
    }
    public static inline function drawGradientTriangle( ax: Float, ay: Float, colA: Int
                                                      , bx: Float, by: Float, colB: Int
                                                      , cx: Float, cy: Float, colC: Int ): BitmapDataTriangle {
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
                    this.setPixel32( px, py, ARGB.create( a, r, g, b ) );
                }
            }
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
}
