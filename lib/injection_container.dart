import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/network/network_info.dart';
import 'core/network/dio_client.dart';

// Features - Pokemon
import 'features/pokemon/data/datasources/pokemon_local_data_source.dart';
import 'features/pokemon/data/datasources/pokemon_local_data_source_impl.dart';
import 'features/pokemon/data/datasources/pokemon_remote_data_source.dart';
import 'features/pokemon/data/datasources/pokemon_remote_data_source_impl.dart';
import 'features/pokemon/data/repositories/pokemon_repository_impl.dart';
import 'features/pokemon/domain/repositories/pokemon_repository.dart';
import 'features/pokemon/domain/usecases/get_pokemon.dart';
import 'features/pokemon/domain/usecases/get_pokemon_by_name.dart';
import 'features/pokemon/domain/usecases/get_pokemon_list.dart';
import 'features/pokemon/presentation/bloc/bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Pokemon
  // Bloc
  sl.registerFactory(
    () => PokemonBloc(
      getPokemon: sl(),
      getPokemonByName: sl(),
      getPokemonList: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetPokemon(sl()));
  sl.registerLazySingleton(() => GetPokemonByName(sl()));
  sl.registerLazySingleton(() => GetPokemonList(sl()));

  // Repository
  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(sl()),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
