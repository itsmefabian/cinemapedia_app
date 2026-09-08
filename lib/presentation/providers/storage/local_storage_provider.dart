import 'package:cinemapedia_app/config/database/database.dart';
import 'package:cinemapedia_app/infrastructure/datasources/drift_datasource.dart';
import 'package:cinemapedia_app/infrastructure/repositories/local_storage_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageRepositoryProvider = Provider(
  (ref) => LocalStorageRepositoryImpl(
    datasource: DriftDatasource(database: AppDatabase()),
  ),
);
