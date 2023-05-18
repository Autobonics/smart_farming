import 'package:smart_farming/services/db_service.dart';
import 'package:smart_farming/services/firestore_service.dart';
import 'package:smart_farming/services/user_service.dart';
import 'package:smart_farming/ui/views/control/control_view.dart';
import 'package:smart_farming/ui/views/login/login_view.dart';
import 'package:smart_farming/ui/views/login_register/login_register_view.dart';
import 'package:smart_farming/ui/views/register/register_view.dart';
import 'package:smart_farming/ui/views/soil/soil_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/views/home/home_view.dart';
import '../ui/views/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: ControlView, path: '/control'),
    MaterialRoute(page: SoilView, path: '/soil'),
    MaterialRoute(page: LoginRegisterView, path: '/login-register'),
    MaterialRoute(page: LoginView, path: '/login'),
    MaterialRoute(page: RegisterView, path: '/register'),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: DbService),
    LazySingleton(classType: FirestoreService),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: UserService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
