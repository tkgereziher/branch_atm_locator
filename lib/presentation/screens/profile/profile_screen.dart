import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/di/injection_container.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final service = sl<UserService>();
      final isLogged = await service.isLoggedIn();
      if (!isLogged) {
        setState(() => _isLoading = false);
        return;
      }
      
      final user = await service.getProfile();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await sl<UserService>().logout();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  // Profile Image
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: const Icon(Icons.person_rounded, size: 80, color: AppColors.primary),
                      ),
                      if (_user != null)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit_rounded, size: 20, color: Colors.white),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (_user != null) ...[
                    Text(
                      _user!.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      _user!.email,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                    ),
                  ] else ...[
                    const Text(
                      "Guest User",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text("Sign In or Register"),
                    ),
                  ],
                  
                  const SizedBox(height: 32),

                  // Settings Sections
                  _buildSettingsSection(
                    title: "Account Settings",
                    items: [
                      _buildSettingsItem(Icons.person_outline_rounded, "Personal Information"),
                      _buildSettingsItem(Icons.security_rounded, "Login & Security"),
                      _buildSettingsItem(Icons.notifications_none_rounded, "Notifications"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsSection(
                    title: "App Settings",
                    items: [
                      _buildSettingsItem(Icons.language_rounded, "Language Preference", "English (US)"),
                      _buildSettingsItem(Icons.dark_mode_outlined, "Dark Mode", "Off"),
                      _buildSettingsItem(Icons.location_on_outlined, "Precise Location", "On"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSettingsSection(
                    title: "Support",
                    items: [
                      _buildSettingsItem(Icons.help_outline_rounded, "Help Center"),
                      _buildSettingsItem(Icons.privacy_tip_outlined, "Privacy Policy"),
                      _buildSettingsItem(Icons.info_outline_rounded, "About Us"),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                  // Logout Button
                  if (_user != null)
                    OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text("Log Out"),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: const BorderSide(color: AppColors.error),
                        foregroundColor: AppColors.error,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSettingsSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.divider),
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String label, [String? value]) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 24),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.divider),
        ],
      ),
      onTap: () {},
    );
  }
}
