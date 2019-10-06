package 
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.accessibility.Accessibility;
	import com.freeactionscript.Scrollbar;
	import flash.system.Security;
	import com.greensock.easing.Back;
	import flash.display.StageDisplayState;
	import flash.media.Sound;
	import caurina.transitions.*;
	import flash.utils.setTimeout;
	import flash.external.ExternalInterface;
	import flash.ui.*;
	import flash.utils.*;
	import flash.system.Security;
	import flash.ui.Mouse;
	import caurina.transitions.*;
	import com.greensock.*;
	import com.freeactionscript.*;
	import com.greensock.*;
	import com.encryption.*;
	import com.greensock.easing.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.text.*;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.ui.*;


	public class MyGame extends MovieClip
	{
		var moveDist:Number;
		var tx:Number;
		var ty:Number;
		public var enemyArr:Array;
		public var randomShit = 0;
		public var randomShit1 = 0;
		public var enemySpeed:uint = 10;
		var dead:Boolean = false;
		public var intervalForAdding:uint;
		public var intervalIntervalForAdding:uint;
		public var mouseIsDown = false;
		public var speed = 0;
		public var score = 0;
		public var xp = 0;
		public var ma_coins = 0;
		private var vy:Number = 0;
		private var friction:Number = 0.90;
		private var maxspeed:Number = 5;
		private var numStars:int = 80;
		var rect:Rectangle;
		public var movingup:Boolean = false;
		public var movingdown:Boolean = false;
		public var notmoving:Boolean = true;
		public var booming:Boolean = false;
		public var enBallInterval:uint;
		public var enBallIntervalForAdding:uint;
		var nCount:Number = 30;
		var gravity:Number = 8;
		var jumpPower:Number = 0;
		var isJumping:Boolean = false;
		var isDouble:Boolean = false;
		var isGround:Boolean = false;
		var ground:Number = 690;
		public var enWall:MovieClip;
		public var enBall:MovieClip;
		public var enBall2:MovieClip;
        
		public var coin=0;
		private var alertnow:AlertNow;
		var leftKeyDown:Boolean = false;
		var upKeyDown:Boolean = false;
		var rightKeyDown:Boolean = false;
		var downKeyDown:Boolean = false;
		public var ingame = false;
		var mainSpeed:Number = 7;
		//public var mouseIsDown = false;
		//public var speed = 0;
		//public var score = 0;

		function MyGame()
		{
			stop();
			alert("Getting the required Parameters from the JS file");
			var snd:Sound = new Sound();
			var req:URLRequest = new URLRequest("https://d1490khl9dq1ow.cloudfront.net/audio/music/mp3preview/BsTwCwBHBjzwub4i4/bcc-031814-racing-game-intro-music-542_NWM.mp3");
			snd.load(req);
			var channel:SoundChannel = snd.play();
			channel.addEventListener(Event.SOUND_COMPLETE, onPlaybackComplete);
			function onPlaybackComplete(event:Event)
			{
				trace("The sound has finished playing.");
			}
			//ALERT
			function alert(mess:String):void
			{
				alertnow = new AlertNow();
				alertnow.x = stage.stageWidth / 2;
				alertnow.y = stage.stageWidth / 2;
				Tweener.addTween(alertnow,{x:stage.stageWidth / 2, y:stage.stageHeight / 2, alpha:1, time:0.4, transition:"easeOutSine"});
				addChild(alertnow);
				alertnow.message.text = String(mess);
				alertnow.understood.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
				removeChild(MovieClip(e.target.parent));
				});
			}

			//Login Btn
			wait.login.buttonMode = true;
			wait.login.useHandCursor = true;
			wait.login.mouseChildren = false;
			wait.login.addEventListener(MouseEvent.CLICK,on_click19);
			wait.login.addEventListener(MouseEvent.MOUSE_OVER, overFunction19);
			wait.login.addEventListener(MouseEvent.MOUSE_OUT, overFunction29);
			wait.login.addEventListener(MouseEvent.MOUSE_DOWN, overFunction39);
			function overFunction19(e:MouseEvent)
			{
				var snd1:Sound = new Sound();
				var req1:URLRequest = new URLRequest("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-35448/zapsplat_multimedia_button_press_plastic_click_002_36869.mp3");
				snd1.load(req1);
				var channel:SoundChannel = snd1.play();
				wait.login.gotoAndSctop(2);

			}
			function overFunction29(e:MouseEvent)
			{
				wait.login.gotoAndStop(1);
			}
			function overFunction39(e:MouseEvent)
			{
				wait.login.gotoAndStop(3);
			}
			function on_click19(e:MouseEvent)
			{
				var snd111:Sound = new Sound();
				var req111:URLRequest = new URLRequest("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-35448/zapsplat_multimedia_button_press_plastic_click_003_36870.mp3");
				snd111.load(req111);
				var channel:SoundChannel = snd111.play();
				alert("New Player: "+ExternalInterface.call("getMyVar2"));
				alert("Logged in as "+ExternalInterface.call("getMyVar"));
				wait.x = -825;
				//MovieClip(root).gotoAndStop(2);
				//frame2();
			}
			//Single Player Button;
			go.buttonMode = true;
			go.useHandCursor = true;
			go.mouseChildren = false;
			go.addEventListener(MouseEvent.CLICK,on_click1);
			go.addEventListener(MouseEvent.MOUSE_OVER, overFunction1);
			go.addEventListener(MouseEvent.MOUSE_OUT, overFunction2);
			go.addEventListener(MouseEvent.MOUSE_DOWN, overFunction3);
			function overFunction1(e:MouseEvent)
			{
				var snd1:Sound = new Sound();
				var req1:URLRequest = new URLRequest("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-35448/zapsplat_multimedia_button_press_plastic_click_002_36869.mp3");
				snd1.load(req1);
				var channel:SoundChannel = snd1.play();
				go.gotoAndStop(2);

			}
			function overFunction2(e:MouseEvent)
			{
				go.gotoAndStop(1);
			}
			function overFunction3(e:MouseEvent)
			{
				go.gotoAndStop(3);
			}
			function on_click1(e:MouseEvent)
			{
				var snd111:Sound = new Sound();
				var req111:URLRequest = new URLRequest("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-35448/zapsplat_multimedia_button_press_plastic_click_003_36870.mp3");
				snd111.load(req111);
				var channel:SoundChannel = snd111.play();
				MovieClip(root).gotoAndStop(2);
				frame2();
			}
			//Multiplayer Btn;
			multi.buttonMode = true;
			multi.useHandCursor = true;
			multi.mouseChildren = false;
			multi.addEventListener(MouseEvent.CLICK,on_click12);
			multi.addEventListener(MouseEvent.MOUSE_OVER, overFunction12);
			multi.addEventListener(MouseEvent.MOUSE_OUT, overFunction22);
			multi.addEventListener(MouseEvent.MOUSE_DOWN, overFunction32);
			function overFunction12(e:MouseEvent)
			{
				var snd11:Sound = new Sound();
				var req11:URLRequest = new URLRequest("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-35448/zapsplat_multimedia_button_press_plastic_click_002_36869.mp3");
				snd11.load(req11);
				var channel:SoundChannel = snd11.play();
				multi.gotoAndStop(2);
			}
			function overFunction22(e:MouseEvent)
			{
				multi.gotoAndStop(1);
			}
			function overFunction32(e:MouseEvent)
			{
				multi.gotoAndStop(3);
			}
			function on_click12(e:MouseEvent)
			{
				var snd1111:Sound = new Sound();
				var req1111:URLRequest = new URLRequest("https://www.zapsplat.com/wp-content/uploads/2015/sound-effects-35448/zapsplat_multimedia_button_press_plastic_click_003_36870.mp3");
				snd1111.load(req1111);
				var channel:SoundChannel = snd1111.play();
				//MovieClip(root).gotoAndStop(2);
				ExternalInterface.call("displayAlert", "lol");
				//var result:string = ExternalInterface.call("getMyVar");

				alert(ExternalInterface.call("getMyVar2"));
				//alert(ExternalInterface.call("getMyVar1"));
			}
		}

		public function frame2()
		{
			moveDist = 50;
			tx = hero.x - 3;
			ty = hero.y - 3;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, doJump);
			stage.addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.ENTER_FRAME, moveObject);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			dead = false;
			//booming = false;
			enemyArr = [];
			intervalIntervalForAdding = 50;
			enBallInterval = 0;
			enBallIntervalForAdding = 100;
			score = 0;
			//coins = 0; 
			score_txt.text = String(score);
			stage.addEventListener(Event.ENTER_FRAME,loop);
			trace("frame2 working!");
			function keyDownHandler(e:KeyboardEvent):void
			{
				if (e.keyCode == Keyboard.RIGHT)
				{
					trace("right");
					tx +=  moveDist;
				}
				else if (e.keyCode == Keyboard.LEFT)
				{
					trace("left");
					tx -=  moveDist;
				}
			}
			function e1RandomY()
			{
				return Math.random() * 0 + 750;
			}
			function loop(e: Event)
			{
				if (! dead)
				{
					score +=  1;
					
					if(score==100){
					coin+=1;
					}
					
					if(score==200){
					coin+=1;
					}
					coin_txt.text = String(coin);
					score_txt.text = String(score);
					enBallInterval +=  1;
					if (enBallInterval > enBallIntervalForAdding)
					{
						enBallInterval = 0;
						enBall = new Enemy1();
						var hehu1 = 1 + Math.floor(Math.random() * 6);
						trace(hehu1);
						enBall.gotoAndStop(hehu1);
						enBall.x = 1521;
						enBall.y = 731;
						enemyArr.push(enBall);
						addChild(enBall);
					}
					var en = 0;
					while (en < enemyArr.length)
					{
						enemyArr[en].x = enemyArr[en].x - enemySpeed;
						if (enemyArr[en].hitTestObject(hero.real))
						{
							randomShit = Math.ceil(Math.random() * 50);
							randomShit1 = Math.ceil(Math.random() * 500);
							dead = true;
							hero.gotoAndStop(2);
							Game_over.x = -5.30;
							Game_over.y = 6.70;
							Game_over.output.text = score_txt.text;
							ExternalInterface.call("Read",score_txt.text,coin_txt.text);

							//Game_over.coins2_txt.text = coins_txt.text;
							//Game_over.xp2_txt.text = XP_txt.text;
						}

						if (enemyArr[en].x < -55)
						{
							removeChild(enemyArr[en]);
							enemyArr.splice(en, 1);
						}
						en +=  1;
					}
				}
				else
				{
					//gameOver.gotoAndStop(2); 
					this.solid1.gotoAndStop(currentFrame);
					var nen = 0;
					while (nen < enemyArr.length)
					{
						removeChild(enemyArr[nen]);
						nen +=  1;
					}
					enemyArr = [];
					stage.removeEventListener(Event.ENTER_FRAME, loop);
				}
			}

			function loop1(e: Event)
			{
				if (! dead)
				{
					score +=  1;
					score_txt.text = String(score);
					enBallInterval +=  1;
					if (enBallInterval > enBallIntervalForAdding)
					{
						enBallInterval = 0;
						enBall = new Enemy1();
						var hehu1 = 1 + Math.floor(Math.random() * 3);
						trace(hehu1);
						enBall.gotoAndStop(hehu1);
						enBall.x = 764;
						enBall.y = 720;
						enemyArr.push(enBall);
						addChild(enBall);
					}
					var en = 0;
					while (en < enemyArr.length)
					{
						enemyArr[en].x = enemyArr[en].x - enemySpeed;
						if (enemyArr[en].hitTestObject(hero.real))
						{
							randomShit = Math.ceil(Math.random() * 50);
							randomShit1 = Math.ceil(Math.random() * 500);
							dead = true;
							hero.gotoAndStop(2);
							Game_over.x = -5.30;
							Game_over.y = 6.70;
							Game_over.output.text = score_txt.text;
							ExternalInterface.call("Read",score_txt.text,coin_txt.text);


							/*challenge_bar.stop();
							challenge_bar.fin.gotoAndStop(2);*/
							//Game_over.score_txt.text = String(score) + "Meters";

						}
						if (score == 2000)
						{


							trace("Marathon Finished,Move on");
							dead = true;
							hero.gotoAndStop(2);
							Game_over.x = -5.30;
							Game_over.y = 6.70;
							Game_over.output.text = score_txt.text;
							ExternalInterface.call("Read",score_txt.text,coin_txt.text);
							//ExternalInterface.call("ReadCoin",coin_txt.text);
						}

						if (enemyArr[en].x < -55)
						{
							removeChild(enemyArr[en]);
							enemyArr.splice(en, 1);
						}
						en +=  1;
					}
				}
				else
				{

					//gameOver.gotoAndStop(2); 
					this.solid1.gotoAndStop(currentFrame);
					var nen = 0;
					while (nen < enemyArr.length)
					{
						removeChild(enemyArr[nen]);
						nen +=  1;
					}
					enemyArr = [];
					stage.removeEventListener(Event.ENTER_FRAME, loop);
				}


			}
			function moveObject(e:Event):void
			{
				//this code moves the MC smoothly, the MC is moved to it's new cords, in 10 stages.
				hero.x +=  (tx - hero.x) / 50;
				hero.y +=  (ty - hero.y) / 50;
			}

			function doJump(e:KeyboardEvent):void
			{
				if (e.keyCode == Keyboard.SPACE)
				{
					trace("Success!");
					if (! isJumping)
					{
						jumpPower = 40;
						isJumping = true;
					}
				}
			}

			function update(evt:Event):void
			{
				if (isJumping)
				{
					hero.y -=  jumpPower;
					jumpPower -=  2;
					//hero.gotoAndStop("teset");

				}
				if (hero.y + gravity < ground)
				{
					hero.y +=  gravity;
				}
				else
				{
					isJumping = false;
					hero.y = ground;
					//hero.gotoAndStop("stand");

				}
			}

		}
	}
}