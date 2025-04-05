package gradientTrianglesOpenFL;

import openfl.display.BitmapData;
import gradientTrianglesOpenFL.IteratorRange;
import lime.math.ARGB;
import gradientTrianglesOpenFL.AlphaBlends;
import openfl.geom.Rectangle;

@:forward
abstract BitmapDataQuads(BitmapData) from BitmapData to BitmapData {
    public inline function new(bd: BitmapData) {
        this = bd;
    }

    public inline function drawGradientQuad(ax: Float, ay: Float, colA: Int,
                                            bx: Float, by: Float, colB: Int,
                                            cx: Float, cy: Float, colC: Int,
                                            dx: Float, dy: Float, colD: Int, blend = false): BitmapDataQuads {
        var aA = (colA >> 24) & 0xFF;
        var rA = (colA >> 16) & 0xFF;
        var gA = (colA >> 8) & 0xFF;
        var bA = colA & 0xFF;

        var aB = (colB >> 24) & 0xFF;
        var rB = (colB >> 16) & 0xFF;
        var gB = (colB >> 8) & 0xFF;
        var bB = colB & 0xFF;

        var aC = (colC >> 24) & 0xFF;
        var rC = (colC >> 16) & 0xFF;
        var gC = (colC >> 8) & 0xFF;
        var bC = colC & 0xFF;

        var aD = (colD >> 24) & 0xFF;
        var rD = (colD >> 16) & 0xFF;
        var gD = (colD >> 8) & 0xFF;
        var bD = colD & 0xFF;
        var xIter4: IteratorRange = boundIterator4(ax, bx, cx, dx);
        var yIter4: IteratorRange = boundIterator4(ay, by, cy, dy);
        for( px in xIter4) {
            var dx1 = bx - ax;
            var dx2 = dx - ax;
            var dx3 = px - ax;
            for( py in yIter4 ) {
                var dy1 = by - ay;
                var dy2 = dy - ay;
                var dy3 = py - ay;
                var denom = dx1 * dy2 - dy1 * dx2;
                var u = (dx3 * dy2 - dy3 * dx2) / denom;
                var v = (dx1 * dy3 - dy1 * dx3) / denom;
                if (u >= 0 && u <= 1 && v >= 0 && v <= 1) {
                    var invU = 1 - u;
                    var invV = 1 - v;
                    var invUV = invU*invV;
                    var invUv = invU*v;
                    var invVu = invV*u;
                    var a = boundChannel( aA * invUV + aB * invVu + aC * u * v + aD * invUv );
                    var r = boundChannel( rA * invUV + rB * invVu + rC * u * v + rD * invUv );
                    var g = boundChannel( gA * invUV + gB * invVu + gC * u * v + gD * invUv );
                    var b = boundChannel( bA * invUV + bB * invVu + bC * u * v + bD * invUv );
                    var color = ARGB.create(a, r, g, b);
                    if (blend == false) {
                        this.setPixel32(px, py, color);
                    } else {
                        this.setPixel(px, py, alphaBlendWithChannels(this.getPixel32(px, py), a,r,g,b));
                    }
                }
            }
        }
        return this;
    }
}
