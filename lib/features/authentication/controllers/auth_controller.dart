
import 'package:comic_app/features/authentication/models/profile_user.dart';
import 'package:get/get.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class AuthController extends GetxController {
  Rx<AuthResponse?> response = Rx<AuthResponse?>(null);
  final Rxn<Profile> userProfile = Rxn<Profile>();

  final supabase = Supabase.instance.client;

  void updateResponse(AuthResponse newResponse) {
    response.value = newResponse;
    loadCurrentUser();
  }

  @override
  void onInit() {
    super.onInit();
    final session = supabase.auth.currentSession;
    final user = supabase.auth.currentUser;
    loadCurrentUser();
    if (session != null && user != null) {
      response.value = AuthResponse(session: session, user: user);
    } else {
      response.value = null;
    }
  }

  Future<void> loadCurrentUser() async {
    final user = supabase.auth.currentUser;

    if (user != null) {
      final profile = await fetchUserInfo(user.id);
      userProfile.value = profile;
    }
  }

  void logout() async{
    await Supabase.instance.client.auth.signOut();
    userProfile.value = null;
    response.value = null;
  }

  // Hàm fetch Profile
  Future<Profile?> fetchUserInfo(String userId) async {
    try {
      final response = await supabase
          .from('Profile')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return Profile.fromMap(response);
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }
}