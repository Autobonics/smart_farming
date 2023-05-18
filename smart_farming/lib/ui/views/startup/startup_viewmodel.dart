import 'package:smart_farming/services/db_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/user_service.dart';

class StartupViewModel extends BaseViewModel {
  final log = getLogger('StartUpViewModel');

  final _navigationService = locator<NavigationService>();
  final _dbService = locator<DbService>();

  final _userService = locator<UserService>();

  // Place anything here that needs to happen before we get into the application
  Future runStartupLogic() async {
    if (_userService.hasLoggedInUser) {
      await _userService.fetchUser();
      _navigationService.replaceWithHomeView();
    } else {
      await Future.delayed(const Duration(seconds: 1));
      _navigationService.replaceWithLoginRegisterView();
    }
  }

  void handleStartupLogic() async {
    log.i('Startup');
    _dbService.setupNodeListening();
    runStartupLogic();
  }

  // void doSomething() {
  //   _navigationService.replaceWith(
  //     Routes.hostel,
  //     arguments: DetailsArguments(name: 'FilledStacks'),
  //   );
  // }

  // void getStarted() {
  //   _navigationService.replaceWith(
  //     Routes.details,
  //     arguments: DetailsArguments(name: 'FilledStacks'),
  //   );
  // }
}
