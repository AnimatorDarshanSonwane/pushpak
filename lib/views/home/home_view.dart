import 'package:flutter/material.dart';
import '../../viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = HomeViewModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text("MVVM Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("You have pushed the button this many times:"),
            ValueListenableBuilder<int>(
              valueListenable: vm.counter,
              builder: (context, value, child) {
                return Text(
                  "$value",
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: vm.incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
