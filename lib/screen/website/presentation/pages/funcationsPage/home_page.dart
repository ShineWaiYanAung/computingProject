import 'package:a_web_based_managing_and_report_portal/screen/website/presentation/pages/funcationsPage/chart_screen.dart';
import 'package:flutter/material.dart';
import '../../../data/constant/color.dart';
import '../../bloc/mustcontrol_bloc.dart';
import '../../bloc/sales_service.dart';
import '../../widgets/time_bar.dart';
import 'package:provider/provider.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<SalesProvider>().startListening(context);
    });
  }
  bool isSidebarOpen = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.background.withOpacity(0.5),
      body: Row(
        children: [
          /// SIDEBAR
          InkWell(
            onTap: (){
              setState(() {
                isSidebarOpen = !isSidebarOpen;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSidebarOpen ? 220 : 80,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  /// LOGO
                  if (isSidebarOpen)
                    const Text(
                      "One Clickz",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 40),
                  /// MENU ITEMS
                  _menuItem(Icons.person, "Profile"),
                  _menuItem(Icons.folder, "Projects"),
                  _menuItem(Icons.settings, "Settings"),

                  const Spacer(),

                  /// LOGOUT

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: const Center(
                      child: Icon(Icons.logout, color: Colors.red),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          /// MAIN CONTENT
          Expanded(
            child: Column(
              children: [

                /// TOP BAR
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("DashBoard",style: TextStyle(color: AppColors.primaryDark,fontSize: 25),),


                      TimeFilterBar(
                        onChanged: (filter) {
                          context.read<DashboardProvider>().setFilter(filter);
                          // 🔥 connect to your dashboard logic
                          // example:
                          // provider.setFilter(filter);
                        },
                      ),

                      const CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                /// DASHBOARD CONTENT
                Expanded(
                  child: ChartScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// SIDEBAR MENU ITEM
  Widget _menuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: isSidebarOpen
              ? Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
              : Center(
            child: Tooltip(
              message: title,
              child: Icon(icon, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}