import 'package:a_web_based_managing_and_report_portal/screen/DATATESTPUSH.DART.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/bloc/businessSection.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/bloc/mustcontrol_bloc.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/bloc/sales_service.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/pages/authentication/login.dart';
import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/pages/funcationsPage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> BusinessProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_)=> DashboardProvider()),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: "title"),
      home:
      HomePage()
       // LoginPage()
    );
  }
}

// class SeedScreen extends StatefulWidget {
//   const SeedScreen({super.key});
//
//   @override
//   State<SeedScreen> createState() => _SeedScreenState();
// }
//
// class _SeedScreenState extends State<SeedScreen> {
//   bool isLoading = false;
//
//   Future<void> _runSeed() async {
//     setState(() => isLoading = true);
//
//     try {
//       await SeedData().run();
//
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("✅ Firebase data updated")));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
//     }
//
//     if (mounted) {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Update Firebase Data")),
//       body: Center(
//         child: isLoading
//             ? const CircularProgressIndicator()
//             : ElevatedButton(
//           onPressed: _runSeed,
//           style: ElevatedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 24,
//               vertical: 14,
//             ),
//           ),
//           child: const Text(
//             "Update / Re-generate Data",
//             style: TextStyle(fontSize: 16),
//           ),
//         ),
//       ),
//     );
//   }
// }
