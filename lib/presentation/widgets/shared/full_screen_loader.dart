import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const new({super.key});

  Stream<String> getMessages() {
    final messages = <String>[
      'Initializing',
      'Fetching data',
      'Transform data',
      'Optimizing resources',
      'Loading',
    ];
    return Stream.periodic(const Duration(microseconds: 1200), (step) {
      return messages[step];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 2),
          SizedBox(height: 10),
          StreamBuilder(
            stream: getMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Text('Loading');

              return Text(snapshot.data!);
            },
          ),
        ],
      ),
    );
  }
}
