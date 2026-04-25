import 'package:flutter/material.dart';
import '../../../data/constant/color.dart';
import '../../../data/models/bizmodel.dart';
import '../../bloc/businessSection.dart';
import 'package:provider/provider.dart';

import '../../bloc/sales_service.dart';

// class ConfigureScreen extends StatelessWidget {
//   const ConfigureScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//
//           const Text(
//             "Welcome to One Clickz",
//             style: TextStyle(
//               fontSize: 34,
//               fontWeight: FontWeight.bold,
//               color: AppColors.primaryDark,
//             ),
//           ),
//
//           const SizedBox(height: 40),
//
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//
//               /// JSON BUTTON
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 18,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text("JSON"),
//               ),
//
//               const SizedBox(width: 30),
//
//               /// CSV BUTTON
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 30,
//                     vertical: 18,
//                   ),
//                   side: const BorderSide(
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: const Text(
//                   "CSV",
//                   style: TextStyle(
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
class BusinessSelectionScreen extends StatelessWidget {
  const BusinessSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F9FC),
      padding: const EdgeInsets.all(30),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          const Text(
            "Select Your Business",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Choose a business to continue",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),

          const SizedBox(height: 30),

          /// FIRESTORE DATA
          Expanded(
            child: StreamBuilder<List<BusinessModel>>(
              stream: getBusinesses(),
              builder: (context, snapshot) {
                /// LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                /// EMPTY
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Businesses Found",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final businesses = snapshot.data!;

                /// GRID
                return GridView.builder(
                  itemCount: businesses.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // tablet layout
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemBuilder: (context, index) {
                    final business = businesses[index];

                    return GestureDetector(

                      onTap: () {
                        print("Selected business: ${business.businessId}");

                        final businessProvider = context.read<BusinessProvider>();

                        // ✅ select business
                        businessProvider.selectBusiness(business);

                        // 🔥 START SALES LISTENER (THIS WAS MISSING)
                        context.read<SalesProvider>()
                            .startListening(business.businessId);
                      },

                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// ICON
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.store,
                                color: Colors.blue,
                                size: 30,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// NAME
                            Text(
                              business.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 10),

                            const Text(
                              "Tap to enter",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
