import 'package:stronger/models/user_model.dart';
import 'package:stronger/provider/easy_notifier.dart';
import 'package:stronger/service/user_service.dart';

class UserProvider extends EasyNotifier {
  final userService = UserService();

  UserModel userModel = UserModel.empty();

  Future<void> getUserData(String uid) async {
    try {
      final userModel = await userService.getUserModel(uid);
      notify(() {
        this.userModel = this.userModel.copyWith(
              name: userModel.name,
              emailAddress: userModel.emailAddress,
              tools: userModel.tools,
              categories: userModel.categories,
              uid: userModel.uid,
              profileImage: userModel.profileImage,
            );
      });
    } catch (e) {
      throw Exception('getUserData: $e');
    }
  }
}
