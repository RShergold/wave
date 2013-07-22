package
{
    import flash.display.Sprite;
	import flash.media.Microphone;
	import flash.events.SampleDataEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	[SWF(width='620', height='120', frameRate='30', backgroundColor='0xFFFFFF')]
	[Frame(factoryClass="wave")]
	public class wave extends Sprite {
		
		//class wide objects
		private var mic:Microphone; 
		private var buf:Array = new Array();
		private var writePos:uint = 0; 
		private var timer:Timer;
		
		public function wave():void{
			//setup microphone
			mic = Microphone.getMicrophone();
			mic.addEventListener( SampleDataEvent.SAMPLE_DATA, onMicSampleData );
			mic.rate = 1;
			//setup a timer to update the wave every X milliseconds 
			timer = new Timer(10);
            timer.addEventListener(TimerEvent.TIMER, updateWave);
            timer.start();
		}
		
		private function onMicSampleData( event:SampleDataEvent ):void {
			//save this input to the buffer
			var len:uint = event.data.length/4;
			for ( var i:uint = 0; i < len; i++ ) {
				buf[writePos] = event.data.readFloat();	
				writePos = (writePos + 1) % 600;
            }
		}
		
		private function updateWave( event:TimerEvent ):void {
			//draw border
			graphics.clear();
			graphics.lineStyle( 1, 0x000000 );
			graphics.drawRect( 9, 10, 602, 100 );
			//initial values
			var x:int = 10;
			var y:int = 60;
			var pos:uint = writePos;
			//change line colour and move to starting position
			graphics.lineStyle( 1, 0x66CCFF );
			graphics.moveTo(x,y);

			for ( var i:uint = 0; i < 600; i++ ) {
				//print the wave from the previous 600 data points in 
				//the buffer
				x++;
				y = 60;
				if (buf[pos]) y = (50.0 * buf[pos]) + 60;
				graphics.lineTo(x, y);
				pos = (pos + 1) % 600;
			}
		}
		
		
	}
}