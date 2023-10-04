import 'package:dartz/dartz.dart';
import '../../services/error/failure.dart';
import '../../services/repository/repository.dart';
import '../../services/usecases/usecase.dart';
import '../../src/features/screens/signin_screen/usecases/send_login.dart';

/// This method returns the remote user account type
/// Input: [String] is the access token of the user
/// Output : [UserData] contains user details
/// if unsuccessful the response will be [Failure]
class GetCurrentUserDetails implements UseCase<UserDetailResponse, NoParams> {
  final Repository repository;

  GetCurrentUserDetails(this.repository);

  @override
  Future<Either<Failure, UserDetailResponse>> call(NoParams token) {
    return repository.getCurrentUserDetails();
  }
}
