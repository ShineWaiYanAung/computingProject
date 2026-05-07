import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/constant/color.dart';
import '../../bloc/businessSection.dart';
import '../../bloc/mustcontrol_bloc.dart';
import '../../widgets/time_bar.dart';
import 'chart_screen.dart';
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
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

                },
              ),

               CircleAvatar(
                backgroundColor: AppColors.primary,
                child: InkWell(
                    onTap: (){
                      context
                          .read<BusinessProvider>()
                          .clearBusiness();

                    },
                    child: Icon(Icons.settings_backup_restore_rounded, color: Colors.white)),
              ),
            ],
          ),
        ),

        /// DASHBOARD CONTENT
        Expanded(
          child: ChartScreen(),
        ),
      ],
    );
  }
}
