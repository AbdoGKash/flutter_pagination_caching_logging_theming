import 'package:flutter_pagination_caching_logging_theming/data/model/movie_response.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataSource {
  static Database? _database;
  static const String _tableName = 'movies';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movie_cache.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            originalLanguage TEXT,
            popularity REAL,
            page INTEGER,
            sort_order INTEGER
          )
        ''');
      },
    );
  }

  Future<void> cacheMovies(int page, List<Movie> movies) async {
    final db = await database;
    await db.delete(_tableName, where: 'page = ?', whereArgs: [page]);

    for (int index = 0; index < movies.length; index++) {
      final movie = movies[index];
      await db.insert(_tableName, {
        'id': movie.id,
        'title': movie.title,
        'posterPath': movie.posterPath,
        'originalLanguage': movie.originalLanguage,
        'popularity': movie.popularity,
        'page': page,
        'sort_order': index,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // Future<void> cacheMovies(List<Movie> movies) async {
  //   final db = await database;
  //   await db.delete(_tableName);
  //   for (final movie in movies) {
  //     await db.insert(_tableName, {
  //       'id': movie.id,
  //       'title': movie.title,
  //       'posterPath': movie.posterPath,
  //       'originalLanguage': movie.originalLanguage,
  //       'popularity': movie.popularity,
  //     }, conflictAlgorithm: ConflictAlgorithm.replace);
  //   }
  // }
  Future<List<Movie>> getCachedMovies(int page) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: 'page = ?',
      whereArgs: [page],
      orderBy: 'sort_order ASC',
    );

    return List.generate(maps.length, (i) {
      return Movie(
        id: maps[i]['id'],
        title: maps[i]['title'],
        posterPath: maps[i]['posterPath'],
        originalLanguage: maps[i]['originalLanguage'],
        popularity: maps[i]['popularity'],
        adult: false,
        genreIds: [],
        originalTitle: '',
        overview: '',
        releaseDate: '',
        video: false,
        voteAverage: 0,
        voteCount: 0,
      );
    });
  }

  // Future<List<Movie>> getCachedMovies() async {
  //   final db = await database;
  //   final List<Map<String, dynamic>> maps = await db.query(_tableName);

  //   return List.generate(maps.length, (i) {
  //     return Movie(
  //       id: maps[i]['id'],
  //       title: maps[i]['title'],
  //       posterPath: maps[i]['posterPath'],
  //       originalLanguage: maps[i]['originalLanguage'],
  //       popularity: maps[i]['popularity'],
  //       adult: false,
  //       genreIds: [],
  //       originalTitle: '',
  //       overview: '',
  //       releaseDate: '',
  //       video: false,
  //       voteAverage: 0,
  //       voteCount: 0,
  //     );
  //   });
  // }

  Future<void> clearCache() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
