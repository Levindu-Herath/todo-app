// import 'package:flutter/material.dart';

// import '../../di/service_locator.dart';
// import '../../utils/constants/app_strings.dart';

// class SettingsScreen extends StatelessWidget {
//   const SettingsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final settingsViewModel = ServiceLocator.instance.settingsViewModel;
//     // final themeViewModel = ServiceLocator.instance.themeViewModel;

//     return Scaffold(
//       appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
//       body: AnimatedBuilder(
//        // animation: Listenable.merge([settingsViewModel, themeViewModel]),
//         builder: (context, _) {
//           return ListView(
//             children: [
//               SwitchListTile(
//                 title: const Text(AppStrings.darkModeLabel),
//                 value: themeViewModel.isDarkMode,
//                 onChanged: themeViewModel.setDarkMode,
//               ),
//               SwitchListTile(
//                 title: const Text(AppStrings.biometricLabel),
//                 value: settingsViewModel.biometricsEnabled,
//                 onChanged: settingsViewModel.setBiometricsEnabled,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
