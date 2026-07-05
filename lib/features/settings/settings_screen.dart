import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../di/service_locator.dart';
import '../../utils/theme/app_colors.dart';
import '../theme/theme_viewmodel.dart';
import 'settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsViewModel>(
      create: (_) => getIt<SettingsViewModel>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  Future<void> _confirmLogOut(BuildContext context, SettingsViewModel viewModel) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCard : AppColors.lightBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out?', textAlign: TextAlign.center),
        content: Text(
          'You\'ll need to sign in again to see your tasks.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightCard,
              foregroundColor: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await viewModel.logOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeViewModel = context.watch<ThemeViewModel>();
    final settingsViewModel = context.watch<SettingsViewModel>();

    final initials = (settingsViewModel.userDisplayName?.isNotEmpty == true
            ? settingsViewModel.userDisplayName!
            : settingsViewModel.userEmail ?? '?')
        .trim()
        .split(RegExp(r'\s+'))
        .map((w) => w.isNotEmpty ? w[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: themeViewModel.accentColor,
                    child: Text(initials,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          settingsViewModel.userDisplayName ?? 'User',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          settingsViewModel.userEmail ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _SectionLabel(text: 'APPEARANCE', isDark: isDark),
            const SizedBox(height: 8),

            _SettingsRow(
              isDark: isDark,
              icon: Icons.dark_mode_outlined,
              title: 'Dark mode',
              trailing: Switch(
                value: themeViewModel.isDarkMode,
                activeColor: Colors.white,
                activeTrackColor: AppColors.accent600,
                onChanged: (value) => themeViewModel.toggleDarkMode(value),
              ),
            ),
            Divider(color: isDark ? AppColors.darkBorder : AppColors.lightBorder, height: 1),
            _SettingsRow(
              isDark: isDark,
              icon: Icons.palette_outlined,
              title: 'Accent color',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AccentDot(
                    color: const Color(0xFF1B6EC2),
                    selected: themeViewModel.accentTheme == AccentTheme.ocean,
                    onTap: () => themeViewModel.setAccentTheme(AccentTheme.ocean),
                  ),
                  const SizedBox(width: 8),
                  _AccentDot(
                    color: const Color(0xFFC25533),
                    selected: themeViewModel.accentTheme == AccentTheme.coral,
                    onTap: () => themeViewModel.setAccentTheme(AccentTheme.coral),
                  ),
                  const SizedBox(width: 8),
                  _AccentDot(
                    color: const Color(0xFF2B7A4B),
                    selected: themeViewModel.accentTheme == AccentTheme.forest,
                    onTap: () => themeViewModel.setAccentTheme(AccentTheme.forest),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _SectionLabel(text: 'SECURITY', isDark: isDark),
            const SizedBox(height: 8),
            _SettingsRow(
              isDark: isDark,
              icon: Icons.fingerprint,
              title: 'Biometric lock',
              subtitle: 'Require fingerprint on open',
              trailing: Switch(
                value: settingsViewModel.isBiometricLockEnabled,
                activeColor: Colors.white,
                activeTrackColor: AppColors.accent600,
                onChanged: (value) => settingsViewModel.toggleBiometricLock(value),
              ),
            ),

            const SizedBox(height: 20),
            _SectionLabel(text: 'ACCOUNT', isDark: isDark),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _confirmLogOut(context, settingsViewModel),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 18, color: AppColors.error),
                    const SizedBox(width: 8),
                    const Text('Log out',
                        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionLabel({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        letterSpacing: 0.5,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;

  const _SettingsRow({
    required this.isDark,
    required this.icon,
    required this.title,
    required this.trailing,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                if (subtitle != null)
                  Text(subtitle!,
                      style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

class _AccentDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _AccentDot({required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: selected ? Border.all(color: color, width: 2) : null,
          boxShadow: selected
              ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 0, spreadRadius: 2)]
              : null,
        ),
      ),
    );
  }
}