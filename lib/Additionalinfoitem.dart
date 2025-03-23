import 'package:flutter/material.dart';

class Additionalinfoitems extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  const Additionalinfoitems({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 45,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 20),
        ),
        Text(
          value,
          style:
               const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
