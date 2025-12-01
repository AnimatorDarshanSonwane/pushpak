import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel()..loadUserAddress(),
      child: Consumer<HomeViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(title: const Text("Uber Clone")),
            body: Center(
              child: vm.isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Address: ${vm.currentAddress}"),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: vm.testPayment,
                          child: const Text("Test Payment"),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
