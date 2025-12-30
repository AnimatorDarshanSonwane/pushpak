import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/ride_viewmodel.dart';

class DestinationSearchView extends StatefulWidget {
  const DestinationSearchView({super.key});

  @override
  State<DestinationSearchView> createState() =>
      _DestinationSearchViewState();
}

class _DestinationSearchViewState extends State<DestinationSearchView> {
  @override
  void initState() {
    super.initState();
    context.read<RideViewModel>().loadRecentSearches();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RideViewModel>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    vm.addSearch(value);
                  }
                },
                decoration: InputDecoration(
                  hintText: "Where to?",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 🕘 Recent Searches
            if (vm.recentSearches.length >= 2)
              Expanded(
                child: ListView.builder(
                  itemCount: vm.recentSearches.length,
                  itemBuilder: (context, index) {
                    final item = vm.recentSearches[index];
                    return ListTile(
                      leading: const Icon(Icons.access_time),
                      title: Text(
                        item.title,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
