import 'package:flutter/material.dart';
import '../../../data/constant/color.dart';
class ConfigureScreen extends StatelessWidget {
  const ConfigureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text(
            "Welcome to One Clickz",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(height: 40),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// JSON BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text("JSON"),
              ),

              const SizedBox(width: 30),

              /// CSV BUTTON
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                  side: const BorderSide(
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "CSV",
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
