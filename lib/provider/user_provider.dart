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

  //tool 삭제
  void removeToolData(String uid, String removeTool) {
    userModel.tools.remove(removeTool);
    List<String> userTools = userModel.tools;
    userService.removeTool(uid, userTools, removeTool);
    getUserData(uid);
  }

  //tool 추가
  void addToolData(String uid, String tool) {
    userModel.tools.add(tool);
    final List<String> userTools = userModel.tools;
    userService.addTool(uid, userTools);
    getUserData(uid);
  }

  //category 삭제
  void removeCategoryData(String uid, String removeCategory) {
    userModel.categories.remove(removeCategory);
    List<String> userCategories = userModel.categories;
    userService.removeCategory(uid, userCategories, removeCategory);
    getUserData(uid);
  }

  //category 추가
  void addCategoryData(String uid, String category) {
    userModel.categories.add(category);
    final List<String> userCategories = userModel.categories;
    userService.addCategory(uid, userCategories);
    getUserData(uid);
  }
}
