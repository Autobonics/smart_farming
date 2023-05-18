import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../models/appuser.dart';
import '../../../services/user_service.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  // final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  AppUser? get user => _userService.user;

  void onModelReady() async {
    setBusy(true);
    if (user == null) {
      AppUser? user = await _userService.fetchUser();
      if (user != null) {
        log.i(user.fullName);
      } else {
        log.i("No user document");
      }
    }
    // if (user!.imgString != null) {
    //   _regulaService.setUserImage(user!.imgString!);
    // }
    setBusy(false);
  }

  void logout() {
    _userService.logout();
    _navigationService.replaceWithLoginRegisterView();
  }

  void openInControlView() {
    _navigationService.navigateTo(Routes.controlView);
  }

  void openAutomaticView() {
    _navigationService.navigateTo(Routes.soilView);
  }

  void openTrainView() {
    // _navigationService.navigateTo(Routes.trainView);
  }

  void openFaceTestView() {
    // _navigationService.navigateTo(Routes.faceTest);
  }
}
