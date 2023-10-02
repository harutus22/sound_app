import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/model/MusicList.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  late Database _db;
  static const _databaseVersion = 1;
  static const String tableSound = 'sound_table';
  static const String tableFavourite = 'favourite_table';

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableSound (
            $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnList text not null
          )
          ''');

    await db.execute('''
    CREATE TABLE $tableFavourite (
    $favName text not null,
    $favImageUrl text not null,
    $favMusicUrl text not null,
    $favIs integer not null
    )
    ''');
  }

  Future<MusicList> insert(MusicList soundList) async {
    soundList.id = await _db.insert(tableSound, soundList.toMap());
    return soundList;
  }

  Future<List<MusicInfo>?> getFavourites() async{
    List<Map> maps = await _db.query(tableFavourite);
    if (maps.isNotEmpty) {
      List<MusicInfo> list = [];
      for(var a in maps){
        list.add(MusicInfo.fromJson(a));
      }
      return list;
    }
    return null;
  }

  void insertFav(MusicInfo musicInfo) async {
    await _db.insert(tableFavourite, musicInfo.toJson());
  }

  void deleteFavourite(String sound) async {
    await _db.delete(tableFavourite, where: '$favMusicUrl = ?', whereArgs: [sound]);
  }

  Future<List<MusicList?>?> getMySounds() async {
    List<Map> maps = await _db.query(tableSound);
    if (maps.isNotEmpty) {
      List<MusicList> list = [];
      for(var a in maps){
        list.add(MusicList.fromMap(a));
      }
      return list;
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableSound, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(MusicList todo) async {
    return await _db.update(tableSound, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => _db.close();
}
