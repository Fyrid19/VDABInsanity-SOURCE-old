package grafex.states;

import grafex.util.PlatformUtil;
import grafex.system.log.GrfxLogger;
import grafex.system.Paths;
import grafex.system.statesystem.MusicBeatState;
#if desktop
import external.Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import grafex.util.Utils;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;

using StringTools;

// this shit is TOO complicated
// also this is made by Fyrid 
// if you remove these credits you fucking suck (I ALREADY KNOW YALL GONNA TRY AND SNATCH THIS)

class Command
{
	public var command:String;
	public var parameters:Array<String>;

	public function new(command:String, parameters:Array<String>)
	{
		this.command = command;
		this.parameters = parameters;
	}
}

class Terminal extends MusicBeatState //BROKEN ATM..
{
    var username:String = PlatformUtil.getUsername();
    var baseText:String = '\nPS C: gameDirectory/bin>';
    var baseText2:String = "Morrow's Insanity (Terminal State) \nCopyright (C) MG Engine. All Rights Reserved";
    var terminalInputText:FlxText;
    var allowedKeys:String = 'abcdefghijklmnopqrstuvwxyz1234567890';
    var allowedKeysAlt:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
    var commands:Array<Command> = [ // command, parameter(s)
        new Command('help', ['']),
        new Command('characters', ['']),
        new Command('admin', ['grant']),
        new Command('clear', ['']),
        new Command('load', ['text', 'json'])
    ];
    
    override function create()
    {
        //PlatformUtil.sendWindowsNotification('Morrow.dat', "You're gonna regret coming here...", 0);
        //PlatformUtil.sendFakeMsgBox('testin', 0);
        //PlatformUtil.sendFakeMsgBox('hi ' + username, 0);

        FlxG.sound.music.stop();

        GrfxLogger.log('info', 'Switched state to: ' + Type.getClassName(Type.getClass(this)));

        terminalInputText = new FlxText(0, 0, FlxG.width, "", 16);
        terminalInputText.setFormat(Paths.font("pixel.otf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.NONE, FlxColor.TRANSPARENT);
        add(terminalInputText);

        terminalInputText.text = baseText2 + baseText;
        super.create();
    }

    override function update(elapsed:Float)
    {
        var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
	    var keyName:String = Std.string(keyPressed);
        //var capsLock:Bool = false;

        /*if (FlxG.keys.firstJustPressed() == FlxKey.SHIFT) {
            capsLock = !capsLock;
        }*/

		if (allowedKeys.contains(keyName) && FlxG.keys.firstJustPressed() != FlxKey.NONE) {
            terminalInputText.text += keyName;
        }
        
        // if (allowedKeysAlt.contains(keyName) && capsLock && FlxG.keys.firstJustPressed() != FlxKey.NONE) {
        //     terminalInputText.text += keyName;
        // }

        if(FlxG.keys.justPressed.ESCAPE) {
            FlxG.mouse.visible = false;
			MusicBeatState.switchState(new MainMenuState());
        }

        super.update(elapsed);
    }
}