package fmf.songs;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import fmf.characters.*;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import Song.SwagSong;

// base class execute song data
class SongPlayer
{
	public var bf:Boyfriend;
	public var gf:Character;
	public var dad:Character;

	public var playState:PlayState;
	public var dialogue:Array<String>;
	public var dialogueBox:DialogueBox;


	public var camPos:FlxPoint;

	public function new (){}

	public function createDialogue(callback:Void->Void):Void
	{
		var path = PlayState.CURRENT_SONG + '/' + PlayState.CURRENT_SONG + '-dialogue';
		dialogue = CoolUtil.coolTextFile(Paths.txt(path));		
		dialogueBox = new DialogueBox(false, dialogue);
		dialogueBox.scrollFactor.set();
		dialogueBox.finishThing = callback;
		dialogueBox.cameras = [playState.camHUD];
		trace("Create dialogue at path: " + path);
	
	}

	public function showDialogue():Void
	{
		
		playState.add(dialogueBox);
		trace('whee mai dialgue siht!');
	}

	public function init(playState:PlayState):Void
	{
		this.playState = playState;

		loadMap();
		createCharacters();
		initVariables();
	}

	function initVariables()
	{
		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		setCamPosition();

	}
	function loadMap():Void
	{
		playState.defaultCamZoom = 0.9;
		// curStage = 'stage';
		var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback'));
		bg.antialiasing = true;
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		playState.add(bg);

		var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront'));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.antialiasing = true;
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		playState.add(stageFront);

		var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains'));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.antialiasing = true;
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;

		playState.add(stageCurtains);
	}

	function createCharacters():Void
	{
		createGF();
		createBF();
		createDad();

		gf.scrollFactor.set(0.95, 0.95);
		
		playState.add(gf);
		playState.add(dad);
		playState.add(bf);

	}


	private function getBFTex():Void
	{
		var tex = Paths.getSparrowAtlas('characters/BoyFriend_Assets');
		bf.frames = tex;
		// tex = null;
	}

	private function setBF()
	{

		bf.dance();
		bf.flipX = !bf.flipX;

		// Doesn't flip for BF, since his are already in the right place???		{
		var oldRight = bf.animation.getByName('singRIGHT').frames;
		bf.animation.getByName('singRIGHT').frames = bf.animation.getByName('singLEFT').frames;
		bf.animation.getByName('singLEFT').frames = oldRight;

		// IF THEY HAVE MISS ANIMATIONS??
		if (bf.animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = bf.animation.getByName('singRIGHTmiss').frames;
			bf.animation.getByName('singRIGHTmiss').frames = bf.animation.getByName('singLEFTmiss').frames;
			bf.animation.getByName('singLEFTmiss').frames = oldMiss;
		}
		
	}

	private function createBFAnimations():Void
	{
		
		bf.animation.addByPrefix('idle', 'BF idle dance', 24, false);
		bf.animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
		bf.animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
		bf.animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
		bf.animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
		bf.animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
		bf.animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
		bf.animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
		bf.animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
		bf.animation.addByPrefix('hey', 'BF HEY', 24, false);


		bf.animation.addByPrefix('scared', 'BF idle shaking', 24);
	}

	
	private function createBFAnimationOffsets():Void
	{

		bf.addOffset('idle', -5);
		bf.addOffset("singUP", -29, 27);
		bf.addOffset("singRIGHT", -38, -7);
		bf.addOffset("singLEFT", 12, -6);
		bf.addOffset("singDOWN", -10, -50);
		bf.addOffset("singUPmiss", -29, 27);
		bf.addOffset("singRIGHTmiss", -30, 21);
		bf.addOffset("singLEFTmisss", 12, 24);
		bf.addOffset("singDOWNmiss", -11, -19);
		bf.addOffset("hey", 7, 4);
		bf.addOffset('scared', -4);

		bf.playAnim('idle');
		bf.flipX = true;
	}

	function getBFVersion():Boyfriend
	{
		return new Boyfriend(770, 450);
	}

	public function createBF():Void
	{
		bf = getBFVersion();
		getBFTex();
		createBFAnimations();
		createBFAnimationOffsets();

		setBF();
	}

	private function getGFTex()
	{
		var tex = Paths.getSparrowAtlas('gf/GF_tutorial');
		gf.frames = tex;
		// tex = null;
	}

	private function createGFAnimations():Void
	{
		var animation = gf.animation;
		animation.addByPrefix('cheer', 'GF Cheer', 24, false);
		animation.addByPrefix('singLEFT', 'GF left note', 24, false);
		animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
		animation.addByPrefix('singUP', 'GF Up Note', 24, false);
		animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
		animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
		animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
		animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
		animation.addByPrefix('scared', 'GF FEAR', 24);

		gf.animation = animation;

		// animation = null;//alloc
	}

	private function createGFAnimationOffsets():Void
	{
		gf.addOffset('cheer');
		gf.addOffset('sad', -2, -2);
		gf.addOffset('danceLeft', 0, -9);
		gf.addOffset('danceRight', 0, -9);

		gf.addOffset("singUP", 0, 4);
		gf.addOffset("singRIGHT", 0, -20);
		gf.addOffset("singLEFT", 0, -19);
		gf.addOffset("singDOWN", 0, -20);
		gf.addOffset('hairBlow', 45, -8);
		gf.addOffset('hairFall', 0, -9);

		gf.addOffset('scared', -2, -17);

		gf.playAnim('danceRight');
		gf.dance();
	}

	function getGfVersion():Character
	{
		return new GF(400, 250);
	}

	public function createGF()
	{
		gf = new GF(400, 250);

		getGFTex();
		createGFAnimations();
		createGFAnimationOffsets();
	
	}

	private function getDadTex()
	{
		var tex = Paths.getSparrowAtlas('gf/GF_tutorial');
		dad.frames = tex;
		// tex = null;
	}

	private function createDadAnimations()
	{
		var animation = dad.animation;
		animation.addByPrefix('cheer', 'GF Cheer', 24, false);
		animation.addByPrefix('singLEFT', 'GF left note', 24, false);
		animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
		animation.addByPrefix('singUP', 'GF Up Note', 24, false);
		animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
		animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
		animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
		animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
		animation.addByPrefix('scared', 'GF FEAR', 24);
		dad.animation = animation;

		// animation = null;//alloc
	}

	private function createDadAnimationOffsets()
	{

		dad.addOffset('cheer');
		dad.addOffset('sad', -2, -2);
		dad.addOffset('danceLeft', 0, -9);
		dad.addOffset('danceRight', 0, -9);

		dad.addOffset("singUP", 0, 4);
		dad.addOffset("singRIGHT", 0, -20);
		dad.addOffset("singLEFT", 0, -19);
		dad.addOffset("singDOWN", 0, -20);
		dad.addOffset('hairBlow', 45, -8);
		dad.addOffset('hairFall', 0, -9);

		dad.addOffset('scared', -2, -17);
				
		dad.playAnim('danceRight');
		dad.dance();
	}

	function getDadVersion():Character
	{
		return new Character(100, 100);
	}

	public function createDad()
	{
		dad = getDadVersion();
		getDadTex();
		createDadAnimations();
		createDadAnimationOffsets();

		dad.x = gf.x;
		dad.y = gf.y;
	}

	public function update(elapsed:Float):Void
	{
	}

	public function midSongEventUpdate(curBeat:Int):Void
	{
		
	}

	public function setCamPosition():Void
	{
	}

	public function updateCamFollow():Void
	{
		// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);
		// switch (dad().curCharacter)
		// {
		// 	case 'mom':
		// 		camFollow.y = dad().getMidpoint().y;
		// 	case 'senpai':
		// 		camFollow.y = dad().getMidpoint().y - 430;
		// 		camFollow.x = dad().getMidpoint().x - 100;
		// 	case 'senpai-angry':
		// 		camFollow.y = dad().getMidpoint().y - 430;
		// 		camFollow.x = dad().getMidpoint().x - 100;
		// }

		// if (dad().curCharacter == 'mom')
		// vocals.volume = 1;
	}

	public function applyCamPosition():Void
	{
		playState.camFollow = new FlxObject(0, 0, 1, 1);
		playState.camFollow.setPosition(camPos.x, camPos.y);
	}
		// switch (SONG.player2)
		// {
		// 	case 'gf':
		// 		dad().setPosition(gf().x, gf().y);
		// 		gf().visible = false;
		// 		if (isStoryMode)
		// 		{
		// 			camPos.x += 600;
		// 			tweenCamIn();
		// 		}

		// 	case "spooky":
		// 		dad().y += 200;
		// 	case "monster":
		// 		dad().y += 100;
		// 	case 'monster-christmas':
		// 		dad().y += 130;
		// 	case 'dad':
		// 		camPos.x += 400;
		// 	case 'pico':
		// 		camPos.x += 600;
		// 		dad().y += 300;
		// 	case 'parents-christmas':
		// 		dad().x -= 500;
		// 	case 'senpai':
		// 		dad().x += 150;
		// 		dad().y += 360;
		// 		camPos.set(dad().getGraphicMidpoint().x + 300, dad().getGraphicMidpoint().y);
		// 	case 'senpai-angry':
		// 		dad().x += 150;
		// 		dad().y += 360;
		// 		camPos.set(dad().getGraphicMidpoint().x + 300, dad().getGraphicMidpoint().y);
		// 	case 'spirit':
		// 		dad().x -= 150;
		// 		dad().y += 100;
		// 		camPos.set(dad().getGraphicMidpoint().x + 300, dad().getGraphicMidpoint().y);
		// }
	// }


	public function updateCameraOffset():Void
	{
		// switch (curStage)
		// {
		// 	case 'limo':
		// 		camFollow.x = boyfriend().getMidpoint().x - 300;
		// 	case 'mall':
		// 		camFollow.y = boyfriend().getMidpoint().y - 200;
		// 	case 'school':
		// 		camFollow.x = boyfriend().getMidpoint().x - 200;
		// 		camFollow.y = boyfriend().getMidpoint().y - 200;
		// 	case 'schoolEvil':
		// 		camFollow.x = boyfriend().getMidpoint().x - 200;
		// 		camFollow.y = boyfriend().getMidpoint().y - 200;
		// }
	}


}