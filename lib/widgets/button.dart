import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  //final VoidCallback onTap;
  final String text;
  final Color color;
  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.color,
    
  });

  @override 
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
            
    
          ),
        ),
      ),
    );
  }
}