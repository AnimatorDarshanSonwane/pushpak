// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pushpak/di/service_locator.dart';
import 'package:pushpak/views/auth/auth_gate.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/ride_viewmodel.dart';
import '../ride/plan_ride_bottom_sheet.dart'; // 👈 ADD THIS

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  void _openPlanRideSheet(BuildContext context) {
    final rideVM = context.read<RideViewModel>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: rideVM,
        child: const PlanRideBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authVM = locator<AuthViewModel>();
    final rideVM = context.watch<RideViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pushpak'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authVM.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const AuthGate()),
                (_) => false,
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 WHERE TO SEARCH BAR (Uber style)
            InkWell(
              onTap: () => _openPlanRideSheet(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      "Where to?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🕘 RECENT SEARCHES (optional on home)
            if (rideVM.recentSearches.length >= 2) ...[
              const Text(
                "Recent searches",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: rideVM.recentSearches.length,
                  itemBuilder: (context, index) {
                    final item = rideVM.recentSearches[index];
                    return ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(item.title),
                      onTap: () {
                        _openPlanRideSheet(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
