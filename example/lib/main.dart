import 'package:flutter/material.dart';
import 'package:mpris_service/mpris_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyService service;

  @override
  void initState() {
    super.initState();

    service = MyService();
  }

  @override
  void dispose() {
    super.dispose();
    service.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example MPRIS Server'),
        ),
        body: const Center(child: Text("Hello World!")),
      ),
    );
  }
}

class MyService extends MPRISService {
  MyService()
      : super(
          "test",
          identity: "Test Media Player",
          canGoPrevious: true,
          canGoNext: true,
        );

  @override
  Future<void> doPrevious() async {
    debugPrint("previous");
  }

  @override
  Future<void> doNext() async {
    debugPrint("next");
  }
}
