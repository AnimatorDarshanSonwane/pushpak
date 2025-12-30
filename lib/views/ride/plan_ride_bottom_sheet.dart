import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/ride_viewmodel.dart';

class PlanRideBottomSheet extends StatelessWidget {
  const PlanRideBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final rideVM = context.watch<RideViewModel>();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // 🔘 Drag handle
              Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 12),

              // 🔙 Header
              const Text(
                "Plan your ride",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // 📍 From / To box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: const [
                      _LocationRow(
                        icon: Icons.my_location,
                        text: "Current location",
                      ),
                      Divider(color: Colors.grey),
                      _LocationRow(
                        icon: Icons.location_on,
                        text: "Where to?",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 🕘 Recent searches
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: rideVM.recentSearches.length,
                  itemBuilder: (_, index) {
                    final item = rideVM.recentSearches[index];
                    return ListTile(
                      leading: const Icon(Icons.access_time, color: Colors.grey),
                      title: Text(
                        item.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        item.subtitle,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LocationRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
