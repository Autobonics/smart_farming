import 'package:smart_farming/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';

class LoginRegisterViewModel extends BaseViewModel {
  final log = getLogger('LoginRegisterViewModel');
  // final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  void openLoginView() {
    _navigationService.navigateTo(Routes.loginView);
  }

  void openRegisterView() {
    _navigationService.navigateTo(Routes.registerView);
  }
}
