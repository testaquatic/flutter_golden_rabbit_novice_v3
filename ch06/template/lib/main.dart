import 'package:flutter/material.dart';

void main() {
  runApp(ColumnWidgetExample());
}

class ColumnWidgetExample extends StatelessWidget {
  const ColumnWidgetExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Container(height: 300, width: 300, color: Colors.red),
              Container(height: 250, width: 250, color: Colors.yellow),
              Container(height: 200, width: 200, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}
