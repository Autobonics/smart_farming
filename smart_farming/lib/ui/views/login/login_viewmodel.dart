import 'package:smart_farming/ui/setup_snackbar_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/user_service.dart';
import 'login_view.form.dart';

class LoginViewModel extends FormViewModel {
  final log = getLogger('LoginViewModel');

  final FirebaseAuthenticationService? _firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _navigationService = locator<NavigationService>();
  // final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final _userService = locator<UserService>();
  final _snackbarService = locator<SnackbarService>();

  void onModelReady() {}

  void authenticateUser() async {
    if (isFormValid && emailValue != null && passwordValue != null) {
      setBusy(true);
      log.i("email and pass valid");
      log.i(emailValue!);
      log.i(passwordValue!);
      FirebaseAuthenticationResult result =
          await _firebaseAuthenticationService!.loginWithEmail(
        email: emailValue!,
        password: passwordValue!,
      );
      if (result.user != null) {
        _userService.fetchUser();
        _navigationService.pushNamedAndRemoveUntil(Routes.homeView);
      } else {
        log.i("Error: ${result.errorMessage}");
        _snackbarService.showCustomSnackBar(
            message: result.errorMessage ?? "Enter valid credentials",
            variant: SnackbarType.error);
      }
    }
    setBusy(false);
  }
}
