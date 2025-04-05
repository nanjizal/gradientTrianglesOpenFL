# gradientTrianglesOpenFL
OpenFL's Graphics class does not support gradient Triangles. This aims to provide a BitmapData implementation.  
   
![image](https://github.com/user-attachments/assets/8f5fd5ea-b9b9-404a-8783-878b4bf65be9)  
  
Example use:   
  
```Haxe
package;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import gradientTrianglesOpenFL.BitmapDataTriangles;// abstract type
class Main extends Sprite
{
 public function new()
 {
  super();
  var bd = new BitmapData ( 150, 150, false, 0x00000000 );
  var triangle = new BitmapDataTriangles( bd );
  triangle.drawGradientTriangle( 10, 140, 0xFF00FFF, 90, 10,  0xFFFF00FF, 140,130, 0xFFFFFF00 );
  var bm = new Bitmap( triangle );
  addChild( bm );
 }
}
```
  
This is a gradient quad.  
  
![image](https://github.com/user-attachments/assets/5f79c59f-05c6-43ce-8146-d53d7356f2d9)
  
```Haxe
package;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import gradientTrianglesOpenFL.BitmapDataTriangles;// abstract type
import gradientTrianglesOpenFL.BitmapDataQuads;
class Main extends Sprite
{
	public function new()
	{
		super();
		var bd = new BitmapData ( 500, 500, false, 0x00000000 );
        var quad = new BitmapDataQuads( bd );
        quad.drawGradientQuad( 60 + 30, 30, 0xFF00FFFF
                             , 240, 90, 0xFFFF00FF
                             , 210, 270, 0xFFFFFF00
                             , 30 - 30 , 210 - 30, 0xFF0000FF );
        var bm = new Bitmap( quad );
		addChild( bm );
	}
}
```
  
Library subject to restructuring and further testing.

