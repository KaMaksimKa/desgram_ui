import 'dart:async';

import 'package:desgram_ui/domain/entities/db_entity.dart';
import 'package:desgram_ui/domain/entities/hashtag_post.dart';
import 'package:desgram_ui/domain/entities/interesting_post.dart';
import 'package:desgram_ui/domain/entities/partial_user.dart';
import 'package:desgram_ui/domain/entities/partial_user_avatar.dart';
import 'package:desgram_ui/domain/entities/post.dart';
import 'package:desgram_ui/domain/entities/post_content.dart';
import 'package:desgram_ui/domain/entities/post_content_candidate.dart';
import 'package:desgram_ui/domain/entities/search_string.dart';
import 'package:desgram_ui/domain/entities/subscription_post.dart';
import 'package:desgram_ui/domain/entities/user.dart';
import 'package:desgram_ui/domain/entities/user_avatar.dart';
import 'package:desgram_ui/domain/entities/user_avatar_candidate.dart';
import 'package:desgram_ui/domain/entities/user_post.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:synchronized/synchronized.dart';
import 'package:uuid/uuid.dart';

class DB {
  DB._();
  static final DB instanse = DB._();
  static late Database _database;
  static bool _isInit = false;
  final Lock _lock = Lock();

  Future init() async {
    if (!_isInit) {
      var dbPath = await getDatabasesPath();
      var path = join(dbPath, "db_v1.0.40.db");
      _database = await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          db.execute("PRAGMA foreign_keys=ON");
        },
      );
      _isInit = true;
    }
  }

  Future _onCreate(Database db, int version) async {
    var dbInitScript = await rootBundle.loadString('assets/db_init.sql');
    dbInitScript.split(';').forEach((element) async {
      if (element.isNotEmpty) {
        await db.execute(element);
      }
    });
  }

  static final _factories = <Type, Function(Map<String, dynamic> map)>{
    PartialUser: (map) => PartialUser.fromMap(map),
    PartialUserAvatar: (map) => PartialUserAvatar.fromMap(map),
    Post: (map) => Post.fromMap(map),
    PostContent: (map) => PostContent.fromMap(map),
    PostContentCandidate: (map) => PostContentCandidate.fromMap(map),
    User: (map) => User.fromMap(map),
    UserAvatar: (map) => UserAvatar.fromMap(map),
    UserAvatarCandidate: (map) => UserAvatarCandidate.fromMap(map),
    SearchString: (map) => SearchString.fromMap(map),
    UserPost: (map) => UserPost.fromMap(map),
    InterestingPost: (map) => InterestingPost.fromMap(map),
    SubscriptionPost: (map) => SubscriptionPost.fromMap(map),
    HashtagPost: (map) => HashtagPost.fromMap(map),
  };

  String _dbName(Type type) {
    if (type == DbEntity) {
      throw Exception("Type is REQUIRED");
    }
    return "t_$type";
  }

  Future<Iterable<T>> getRange<T extends DbEntity>(
      {Map<String, dynamic>? whereMap, int? take, int? skip}) async {
    Iterable<Map<String, dynamic>> query;

    if (whereMap != null) {
      var whereBuilder = <String>[];
      var whereArgs = <dynamic>[];
      whereMap.forEach((key, value) {
        if (value is Iterable<dynamic>) {
          whereBuilder
              .add("$key IN (${List.filled(value.length, '?').join(',')})");
          whereArgs.addAll(value.map((e) => "$e"));
        } else {
          whereBuilder.add("$key = ?");
          whereArgs.add(value);
        }
      });
      query = await _database.query(
        _dbName(T),
        offset: skip,
        limit: take,
        where: whereBuilder.join(' and '),
        whereArgs: whereArgs,
      );
    } else {
      query = await _database.query(_dbName(T), offset: skip, limit: take);
    }
    var resList = query.map((e) => _factories[T]!(e)).cast<T>();

    return resList;
  }

  Future<T?> getFirstOrDefault<T extends DbEntity>(
      {required Map<String, dynamic>? whereMap}) async {
    var res = await getRange<T>(whereMap: whereMap);
    return res.isNotEmpty ? res.first : null;
  }

  Future<int> insert<T extends DbEntity>(T model) async {
    if (model.id == "") {
      var modelmap = model.toMap();
      modelmap["id"] = const Uuid().v4();
      model = _factories[T]!(modelmap);
    }
    return await _database.insert(_dbName(T), model.toMap());
  }

  Future<int> update<T extends DbEntity>(T model) async =>
      await _database.update(_dbName(T), model.toMap(),
          where: 'id = ?', whereArgs: [model.id]);

  Future<int> delete<T extends DbEntity>(T model) async => await _database
      .delete(_dbName(T), where: 'id = ?', whereArgs: [model.id]);

  Future<int> cleanTable<T extends DbEntity>() async =>
      await _database.delete(_dbName(T));

  Future cleanAllTable() async {
    for (var t in _factories.keys) {
      await _database.delete(_dbName(t));
    }
  }

  Future<int> createUpdate<T extends DbEntity>(T model) async {
    return await _lock.synchronized(() async {
      var dbItem = await getFirstOrDefault<T>(whereMap: {"id": model.id});
      var res = dbItem == null ? insert(model) : update(model);
      return await res;
    });
  }

  Future inserRange<T extends DbEntity>(Iterable<T> values) async {
    var batch = _database.batch();
    for (var row in values) {
      var data = row.toMap();
      if (row.id == "") {
        data["id"] = const Uuid().v4();
      }
      batch.insert(_dbName(T), data);
    }
    await batch.commit(noResult: true);
  }

  Future<void> createUpdateRange<T extends DbEntity>(Iterable<T> values,
      {bool Function(T oldItem, T newItem)? updateCond}) async {
    await _lock.synchronized(() async {
      var batch = DB._database.batch();
      for (var row in values) {
        var dbItem = await getFirstOrDefault<T>(whereMap: {"id": row.id});
        var data = row.toMap();
        if (row.id == "") {
          data["id"] = const Uuid().v4();
        }

        if (dbItem == null) {
          batch.insert(_dbName(T), data);
        } else if (updateCond == null || updateCond(dbItem, row)) {
          batch.update(_dbName(T), data, where: "id = ?", whereArgs: [row.id]);
        }
      }

      await batch.commit(noResult: true);
    });
  }
}
