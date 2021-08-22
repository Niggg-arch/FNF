package;

import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class EndScreen extends MusicBeatState {
    public static var whereGo:Int;

    var mainTxt:FlxText;
    var pressEnter:FlxText;

    public override function create() {
        transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

        mainTxt = new FlxText(5, 5, 0, '', 32);
        mainTxt.text = '${PlayState.isStoryMode ? 'WEEK' : 'SONG'} CLEARED!\n\nSTATS:\nSicks: ${PlayState.sicks}\nGoods: ${PlayState.goods}\nBads: ${PlayState.bads}\nShits: ${PlayState.shits}\nMisses: ${PlayState.misses}\n\n${whereGo != 0 ? '${PlayState.SONG.song}:${PlayState.difString}' : 'Week ${PlayState.storyWeek}:${PlayState.difString}'}';

        pressEnter = new FlxText(0, FlxG.height - 50, 0, 'Press ENTER to Continue', 32);
        pressEnter.screenCenter(X);
        new FlxTimer().start(1, (thing:FlxTimer) -> {
            pressEnter.visible = !pressEnter.visible;
        }, 0);

        add(mainTxt);
        add(pressEnter);
    }

    public override function update(elapsed:Float) {
        if (FlxG.keys.justPressed.ENTER) {
            PlayState.sicks = 0;
            PlayState.goods = 0;
            PlayState.bads = 0;
            PlayState.shits = 0;
            PlayState.misses = 0;

            switch (whereGo) {
                case 0:
                    FlxG.switchState(new StoryMenuState());
                case 1:
                    FlxG.switchState(new FreeplayState());
            }
        }
    }
}