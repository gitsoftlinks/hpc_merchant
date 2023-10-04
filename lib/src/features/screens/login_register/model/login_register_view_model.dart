import 'package:happiness_club_merchant/utils/router/models/page_action.dart';

import '../../../../../utils/router/app_state.dart';
import '../../../../../utils/router/models/page_config.dart';

class LoginRegisterViewModel {
  final AppState _appState;

  LoginRegisterViewModel({required AppState appState}) : _appState = appState;

  void moveToSignInScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: SignInScreenConfig);
  }

  void moveToSignUpScreen() {
    _appState.currentAction =
        PageAction(state: PageState.addPage, page: SignUpScreenConfig);
  }
}
