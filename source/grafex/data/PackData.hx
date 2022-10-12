package grafex.data;

import grafex.system.Paths;
import grafex.states.PackSelectState;
import sys.FileSystem;
import sys.io.File;
import haxe.Json;
import grafex.util.ClientPrefs;
import grafex.util.Utils;
import openfl.utils.Assets;

using StringTools;

typedef PackFile =
{
	// JSON variables (might add more later)
    var name:String;
	var songs:Array<Dynamic>;
    var iconImage:String;
    var packSelectColor:Array<Int>;
    var freeplayColor:Array<Int>;
    var hidden:Bool;
}

class PackData { //im not adding mod support
	public static var packsLoaded:Map<String, PackData> = new Map<String, PackData>();
	public static var packsList:Array<String> = [];
	public var folder:String = '';
	
	// JSON variables
	public var name:String;
	public var songs:Array<Dynamic>;
    public var iconImage:String;
    public var packSelectColor:Array<Int>;
    public var freeplayColor:Array<Int>;
    public var hidden:Bool;

	public var fileName:String;


	public static function createPackFile():PackFile {
		var packFile:PackFile = {
            name: "Main",
			songs: [["Test", "face", [160, 160, 160]]],
			iconImage: "no-icon",
            packSelectColor: [146, 113, 253],
			freeplayColor: [146, 113, 253],
			hidden: false
		};
		return packFile;
	}

	public function new(packFile:PackFile, fileName:String) {
        name = packFile.name;
		songs = packFile.songs;
        packSelectColor = packFile.packSelectColor;
		freeplayColor = packFile.freeplayColor;
		hidden = packFile.hidden;

		this.fileName = fileName;
	}

	public static function reloadPackFiles()
	{
		packsList = [];
		packsLoaded.clear();
		var directories:Array<String> = [Paths.getPreloadPath()];
		var originalLength:Int = directories.length;

		var coolList:Array<String> = Utils.coolTextFile(Paths.getPreloadPath('packs/packList.txt'));
		for (i in 0...coolList.length) {
			for (j in 0...directories.length) {
				var fileToCheck:String = directories[j] + 'packs/' + coolList[i] + '.json';
				if(!packsLoaded.exists(coolList[i])) {
					var pack:PackFile = getPackFile(fileToCheck);
					if(pack != null) {
						var packFile:PackData = new PackData(pack, coolList[i]);

						if(packFile != null && (!packFile.hidden)) {
							packsLoaded.set(coolList[i], packFile);
							packsList.push(coolList[i]);
						}
					}
				}
			}
		}
	}

	private static function addPack(packToCheck:String, path:String, directory:String, i:Int, originalLength:Int)
	{
		if(!packsLoaded.exists(packToCheck))
		{
			var pack:PackFile = getPackFile(path);
			if(pack != null)
			{
				var packFile:PackData = new PackData(pack, packToCheck);
				if((!packFile.hidden))
				{
					packsLoaded.set(packToCheck, packFile);
					packsList.push(packToCheck);
				}
			}
		}
	}

	public static function getPackFileName():String {
		return packsList[PackSelectState.curCategory];
	}

	public static function getPackFile(path:String):PackFile {
		var rawJson:String = null;
		// if(OpenFlAssets.exists(path)) {
		// 	rawJson = Assets.getText(path);
		// }

		if(rawJson != null && rawJson.length > 0) {
			return cast Json.parse(rawJson);
		}
		return null;
	}
}