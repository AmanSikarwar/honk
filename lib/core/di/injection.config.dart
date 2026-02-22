// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:firebase_messaging/firebase_messaging.dart' as _i892;
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as _i163;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/auth/data/repositories/auth_repository_impl.dart'
    as _i153;
import '../../features/auth/domain/repositories/auth_repository.dart' as _i787;
import '../../features/auth/presentation/bloc/auth_bloc.dart' as _i797;
import '../../features/friends/data/repositories/friend_repository_impl.dart'
    as _i766;
import '../../features/friends/domain/repositories/i_friend_repository.dart'
    as _i129;
import '../../features/friends/presentation/cubit/friend_management_cubit.dart'
    as _i280;
import '../../features/honk/data/repositories/honk_repository_impl.dart'
    as _i1038;
import '../../features/honk/domain/repositories/i_honk_repository.dart' as _i31;
import '../../features/honk/presentation/bloc/honk_feed_bloc.dart' as _i86;
import '../../features/honk/presentation/cubit/create_honk_cubit.dart' as _i535;
import '../../features/honk/presentation/cubit/honk_details_cubit.dart'
    as _i351;
import '../../features/honk/presentation/cubit/join_honk_cubit.dart' as _i473;
import '../../features/notifications/data/repositories/notification_repository_impl.dart'
    as _i361;
import '../../features/notifications/data/services/notification_runtime_service.dart'
    as _i51;
import '../../features/notifications/domain/repositories/i_notification_repository.dart'
    as _i809;
import '../../features/notifications/domain/services/i_notification_runtime_service.dart'
    as _i111;
import '../../features/notifications/presentation/cubit/notification_sync_cubit.dart'
    as _i559;
import '../deep_link/deep_link_handler.dart' as _i633;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i633.DeepLinkHandler>(() => _i633.DeepLinkHandler());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabase);
    gh.lazySingleton<_i454.GoTrueClient>(() => registerModule.auth);
    gh.lazySingleton<_i116.GoogleSignIn>(() => registerModule.googleSignIn);
    gh.lazySingleton<_i892.FirebaseMessaging>(
      () => registerModule.firebaseMessaging,
    );
    gh.lazySingleton<_i163.FlutterLocalNotificationsPlugin>(
      () => registerModule.flutterLocalNotificationsPlugin,
    );
    gh.lazySingleton<_i129.IFriendRepository>(
      () => _i766.FriendRepositoryImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i809.INotificationRepository>(
      () => _i361.NotificationRepositoryImpl(
        gh<_i892.FirebaseMessaging>(),
        gh<_i454.SupabaseClient>(),
      ),
    );
    gh.lazySingleton<_i111.INotificationRuntimeService>(
      () => _i51.NotificationRuntimeService(
        gh<_i892.FirebaseMessaging>(),
        gh<_i163.FlutterLocalNotificationsPlugin>(),
      ),
    );
    gh.factory<_i559.NotificationSyncCubit>(
      () => _i559.NotificationSyncCubit(gh<_i809.INotificationRepository>()),
    );
    gh.factory<_i280.FriendManagementCubit>(
      () => _i280.FriendManagementCubit(gh<_i129.IFriendRepository>()),
    );
    gh.lazySingleton<_i31.IHonkRepository>(
      () => _i1038.HonkRepositoryImpl(
        gh<_i454.SupabaseClient>(),
        gh<_i129.IFriendRepository>(),
      ),
    );
    gh.lazySingleton<_i787.AuthRepository>(
      () => _i153.AuthRepositoryImpl(
        gh<_i454.GoTrueClient>(),
        gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.factory<_i797.AuthBloc>(
      () => _i797.AuthBloc(gh<_i787.AuthRepository>()),
    );
    gh.factory<_i86.HonkFeedBloc>(
      () => _i86.HonkFeedBloc(gh<_i31.IHonkRepository>()),
    );
    gh.factory<_i535.CreateHonkCubit>(
      () => _i535.CreateHonkCubit(gh<_i31.IHonkRepository>()),
    );
    gh.factory<_i351.HonkDetailsCubit>(
      () => _i351.HonkDetailsCubit(gh<_i31.IHonkRepository>()),
    );
    gh.factory<_i473.JoinHonkCubit>(
      () => _i473.JoinHonkCubit(gh<_i31.IHonkRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
