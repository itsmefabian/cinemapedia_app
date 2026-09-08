// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoritesMoviesTable extends FavoritesMovies
    with TableInfo<$FavoritesMoviesTable, FavoritesMovy> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesMoviesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _movieIdMeta = const VerificationMeta(
    'movieId',
  );
  @override
  late final GeneratedColumn<int> movieId = GeneratedColumn<int>(
    'movie_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backdropPathMeta = const VerificationMeta(
    'backdropPath',
  );
  @override
  late final GeneratedColumn<String> backdropPath = GeneratedColumn<String>(
    'backdrop_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterPathMeta = const VerificationMeta(
    'posterPath',
  );
  @override
  late final GeneratedColumn<String> posterPath = GeneratedColumn<String>(
    'poster_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalTitleMeta = const VerificationMeta(
    'originalTitle',
  );
  @override
  late final GeneratedColumn<String> originalTitle = GeneratedColumn<String>(
    'original_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _voteAverageMeta = const VerificationMeta(
    'voteAverage',
  );
  @override
  late final GeneratedColumn<double> voteAverage = GeneratedColumn<double>(
    'vote_average',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    movieId,
    backdropPath,
    posterPath,
    originalTitle,
    title,
    voteAverage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites_movies';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoritesMovy> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('movie_id')) {
      context.handle(
        _movieIdMeta,
        movieId.isAcceptableOrUnknown(data['movie_id']!, _movieIdMeta),
      );
    } else if (isInserting) {
      context.missing(_movieIdMeta);
    }
    if (data.containsKey('backdrop_path')) {
      context.handle(
        _backdropPathMeta,
        backdropPath.isAcceptableOrUnknown(
          data['backdrop_path']!,
          _backdropPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_backdropPathMeta);
    }
    if (data.containsKey('poster_path')) {
      context.handle(
        _posterPathMeta,
        posterPath.isAcceptableOrUnknown(data['poster_path']!, _posterPathMeta),
      );
    } else if (isInserting) {
      context.missing(_posterPathMeta);
    }
    if (data.containsKey('original_table')) {
      context.handle(
        _originalTitleMeta,
        originalTitle.isAcceptableOrUnknown(
          data['original_table']!,
          _originalTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalTitleMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('vote_average')) {
      context.handle(
        _voteAverageMeta,
        voteAverage.isAcceptableOrUnknown(
          data['vote_average']!,
          _voteAverageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FavoritesMovy map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritesMovy(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      movieId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}movie_id'],
      )!,
      backdropPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}backdrop_path'],
      )!,
      posterPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_path'],
      )!,
      originalTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_table'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      voteAverage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}vote_average'],
      )!,
    );
  }

  @override
  $FavoritesMoviesTable createAlias(String alias) {
    return $FavoritesMoviesTable(attachedDatabase, alias);
  }
}

class FavoritesMovy extends DataClass implements Insertable<FavoritesMovy> {
  final int id;
  final int movieId;
  final String backdropPath;
  final String posterPath;
  final String originalTitle;
  final String title;
  final double voteAverage;
  const FavoritesMovy({
    required this.id,
    required this.movieId,
    required this.backdropPath,
    required this.posterPath,
    required this.originalTitle,
    required this.title,
    required this.voteAverage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['movie_id'] = Variable<int>(movieId);
    map['backdrop_path'] = Variable<String>(backdropPath);
    map['poster_path'] = Variable<String>(posterPath);
    map['original_table'] = Variable<String>(originalTitle);
    map['title'] = Variable<String>(title);
    map['vote_average'] = Variable<double>(voteAverage);
    return map;
  }

  FavoritesMoviesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesMoviesCompanion(
      id: Value(id),
      movieId: Value(movieId),
      backdropPath: Value(backdropPath),
      posterPath: Value(posterPath),
      originalTitle: Value(originalTitle),
      title: Value(title),
      voteAverage: Value(voteAverage),
    );
  }

  factory FavoritesMovy.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritesMovy(
      id: serializer.fromJson<int>(json['id']),
      movieId: serializer.fromJson<int>(json['movieId']),
      backdropPath: serializer.fromJson<String>(json['backdropPath']),
      posterPath: serializer.fromJson<String>(json['posterPath']),
      originalTitle: serializer.fromJson<String>(json['originalTitle']),
      title: serializer.fromJson<String>(json['title']),
      voteAverage: serializer.fromJson<double>(json['voteAverage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'movieId': serializer.toJson<int>(movieId),
      'backdropPath': serializer.toJson<String>(backdropPath),
      'posterPath': serializer.toJson<String>(posterPath),
      'originalTitle': serializer.toJson<String>(originalTitle),
      'title': serializer.toJson<String>(title),
      'voteAverage': serializer.toJson<double>(voteAverage),
    };
  }

  FavoritesMovy copyWith({
    int? id,
    int? movieId,
    String? backdropPath,
    String? posterPath,
    String? originalTitle,
    String? title,
    double? voteAverage,
  }) => FavoritesMovy(
    id: id ?? this.id,
    movieId: movieId ?? this.movieId,
    backdropPath: backdropPath ?? this.backdropPath,
    posterPath: posterPath ?? this.posterPath,
    originalTitle: originalTitle ?? this.originalTitle,
    title: title ?? this.title,
    voteAverage: voteAverage ?? this.voteAverage,
  );
  FavoritesMovy copyWithCompanion(FavoritesMoviesCompanion data) {
    return FavoritesMovy(
      id: data.id.present ? data.id.value : this.id,
      movieId: data.movieId.present ? data.movieId.value : this.movieId,
      backdropPath: data.backdropPath.present
          ? data.backdropPath.value
          : this.backdropPath,
      posterPath: data.posterPath.present
          ? data.posterPath.value
          : this.posterPath,
      originalTitle: data.originalTitle.present
          ? data.originalTitle.value
          : this.originalTitle,
      title: data.title.present ? data.title.value : this.title,
      voteAverage: data.voteAverage.present
          ? data.voteAverage.value
          : this.voteAverage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesMovy(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('posterPath: $posterPath, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('title: $title, ')
          ..write('voteAverage: $voteAverage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    movieId,
    backdropPath,
    posterPath,
    originalTitle,
    title,
    voteAverage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritesMovy &&
          other.id == this.id &&
          other.movieId == this.movieId &&
          other.backdropPath == this.backdropPath &&
          other.posterPath == this.posterPath &&
          other.originalTitle == this.originalTitle &&
          other.title == this.title &&
          other.voteAverage == this.voteAverage);
}

class FavoritesMoviesCompanion extends UpdateCompanion<FavoritesMovy> {
  final Value<int> id;
  final Value<int> movieId;
  final Value<String> backdropPath;
  final Value<String> posterPath;
  final Value<String> originalTitle;
  final Value<String> title;
  final Value<double> voteAverage;
  const FavoritesMoviesCompanion({
    this.id = const Value.absent(),
    this.movieId = const Value.absent(),
    this.backdropPath = const Value.absent(),
    this.posterPath = const Value.absent(),
    this.originalTitle = const Value.absent(),
    this.title = const Value.absent(),
    this.voteAverage = const Value.absent(),
  });
  FavoritesMoviesCompanion.insert({
    this.id = const Value.absent(),
    required int movieId,
    required String backdropPath,
    required String posterPath,
    required String originalTitle,
    required String title,
    this.voteAverage = const Value.absent(),
  }) : movieId = Value(movieId),
       backdropPath = Value(backdropPath),
       posterPath = Value(posterPath),
       originalTitle = Value(originalTitle),
       title = Value(title);
  static Insertable<FavoritesMovy> custom({
    Expression<int>? id,
    Expression<int>? movieId,
    Expression<String>? backdropPath,
    Expression<String>? posterPath,
    Expression<String>? originalTitle,
    Expression<String>? title,
    Expression<double>? voteAverage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (movieId != null) 'movie_id': movieId,
      if (backdropPath != null) 'backdrop_path': backdropPath,
      if (posterPath != null) 'poster_path': posterPath,
      if (originalTitle != null) 'original_table': originalTitle,
      if (title != null) 'title': title,
      if (voteAverage != null) 'vote_average': voteAverage,
    });
  }

  FavoritesMoviesCompanion copyWith({
    Value<int>? id,
    Value<int>? movieId,
    Value<String>? backdropPath,
    Value<String>? posterPath,
    Value<String>? originalTitle,
    Value<String>? title,
    Value<double>? voteAverage,
  }) {
    return FavoritesMoviesCompanion(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      originalTitle: originalTitle ?? this.originalTitle,
      title: title ?? this.title,
      voteAverage: voteAverage ?? this.voteAverage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (movieId.present) {
      map['movie_id'] = Variable<int>(movieId.value);
    }
    if (backdropPath.present) {
      map['backdrop_path'] = Variable<String>(backdropPath.value);
    }
    if (posterPath.present) {
      map['poster_path'] = Variable<String>(posterPath.value);
    }
    if (originalTitle.present) {
      map['original_table'] = Variable<String>(originalTitle.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (voteAverage.present) {
      map['vote_average'] = Variable<double>(voteAverage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesMoviesCompanion(')
          ..write('id: $id, ')
          ..write('movieId: $movieId, ')
          ..write('backdropPath: $backdropPath, ')
          ..write('posterPath: $posterPath, ')
          ..write('originalTitle: $originalTitle, ')
          ..write('title: $title, ')
          ..write('voteAverage: $voteAverage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritesMoviesTable favoritesMovies = $FavoritesMoviesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favoritesMovies];
}

typedef $$FavoritesMoviesTableCreateCompanionBuilder =
    FavoritesMoviesCompanion Function({
      Value<int> id,
      required int movieId,
      required String backdropPath,
      required String posterPath,
      required String originalTitle,
      required String title,
      Value<double> voteAverage,
    });
typedef $$FavoritesMoviesTableUpdateCompanionBuilder =
    FavoritesMoviesCompanion Function({
      Value<int> id,
      Value<int> movieId,
      Value<String> backdropPath,
      Value<String> posterPath,
      Value<String> originalTitle,
      Value<String> title,
      Value<double> voteAverage,
    });

class $$FavoritesMoviesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesMoviesTable> {
  $$FavoritesMoviesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get voteAverage => $composableBuilder(
    column: $table.voteAverage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritesMoviesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesMoviesTable> {
  $$FavoritesMoviesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get movieId => $composableBuilder(
    column: $table.movieId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get voteAverage => $composableBuilder(
    column: $table.voteAverage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritesMoviesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesMoviesTable> {
  $$FavoritesMoviesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get movieId =>
      $composableBuilder(column: $table.movieId, builder: (column) => column);

  GeneratedColumn<String> get backdropPath => $composableBuilder(
    column: $table.backdropPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get posterPath => $composableBuilder(
    column: $table.posterPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalTitle => $composableBuilder(
    column: $table.originalTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<double> get voteAverage => $composableBuilder(
    column: $table.voteAverage,
    builder: (column) => column,
  );
}

class $$FavoritesMoviesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesMoviesTable,
          FavoritesMovy,
          $$FavoritesMoviesTableFilterComposer,
          $$FavoritesMoviesTableOrderingComposer,
          $$FavoritesMoviesTableAnnotationComposer,
          $$FavoritesMoviesTableCreateCompanionBuilder,
          $$FavoritesMoviesTableUpdateCompanionBuilder,
          (
            FavoritesMovy,
            BaseReferences<_$AppDatabase, $FavoritesMoviesTable, FavoritesMovy>,
          ),
          FavoritesMovy,
          PrefetchHooks Function()
        > {
  $$FavoritesMoviesTableTableManager(
    _$AppDatabase db,
    $FavoritesMoviesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesMoviesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesMoviesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesMoviesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> movieId = const Value.absent(),
                Value<String> backdropPath = const Value.absent(),
                Value<String> posterPath = const Value.absent(),
                Value<String> originalTitle = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<double> voteAverage = const Value.absent(),
              }) => FavoritesMoviesCompanion(
                id: id,
                movieId: movieId,
                backdropPath: backdropPath,
                posterPath: posterPath,
                originalTitle: originalTitle,
                title: title,
                voteAverage: voteAverage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int movieId,
                required String backdropPath,
                required String posterPath,
                required String originalTitle,
                required String title,
                Value<double> voteAverage = const Value.absent(),
              }) => FavoritesMoviesCompanion.insert(
                id: id,
                movieId: movieId,
                backdropPath: backdropPath,
                posterPath: posterPath,
                originalTitle: originalTitle,
                title: title,
                voteAverage: voteAverage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FavoritesMoviesTable, FavoritesMovy>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $FavoritesMoviesTable,
                    FavoritesMovy
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritesMoviesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesMoviesTable,
      FavoritesMovy,
      $$FavoritesMoviesTableFilterComposer,
      $$FavoritesMoviesTableOrderingComposer,
      $$FavoritesMoviesTableAnnotationComposer,
      $$FavoritesMoviesTableCreateCompanionBuilder,
      $$FavoritesMoviesTableUpdateCompanionBuilder,
      (
        FavoritesMovy,
        BaseReferences<_$AppDatabase, $FavoritesMoviesTable, FavoritesMovy>,
      ),
      FavoritesMovy,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritesMoviesTableTableManager get favoritesMovies =>
      $$FavoritesMoviesTableTableManager(_db, _db.favoritesMovies);
}
