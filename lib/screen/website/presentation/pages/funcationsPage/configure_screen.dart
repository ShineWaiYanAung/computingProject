import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/constant/color.dart';
import '../../../data/models/bizmodel.dart';
import '../../bloc/businessSection.dart';
import '../../bloc/sales_service.dart';

class BusinessSelectionScreen extends StatelessWidget {
  const BusinessSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth < 600 ? 16 : 30),
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

              const SizedBox(height: 20),

              /// DATA
              Expanded(
                child: StreamBuilder<List<BusinessModel>>(
                  stream: getBusinesses(),
                  builder: (context, snapshot) {
                    /// LOADING
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
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

                    /// RESPONSIVE GRID
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = 1;

                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 4; // desktop
                        } else if (constraints.maxWidth > 800) {
                          crossAxisCount = 3; // tablet
                        } else if (constraints.maxWidth > 500) {
                          crossAxisCount = 2; // large phone
                        } else {
                          crossAxisCount = 1; // small phone
                        }

                        return GridView.builder(
                          itemCount: businesses.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.1,
                          ),
                          itemBuilder: (context, index) {
                            final business = businesses[index];

                            return GestureDetector(
                              onTap: () {
                                final businessProvider =
                                context.read<BusinessProvider>();

                                businessProvider
                                    .selectBusiness(business);

                                context
                                    .read<SalesProvider>()
                                    .startListening(
                                    business.businessId);
                              },

                              /// CARD
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.05),
                                      blurRadius: 10,
                                      offset:
                                      const Offset(0, 4),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    /// ICON
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.blue
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.store,
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    /// NAME (NO OVERFLOW)
                                    Flexible(
                                      child: Text(
                                        business.name,
                                        textAlign:
                                        TextAlign.center,
                                        maxLines: 2,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    const Text(
                                      "Tap to enter",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}