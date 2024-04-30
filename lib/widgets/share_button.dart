import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  final void Function()? onTap;

  ShareButton({Key? key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.share,
        color: Colors.grey,
      ),
    );
  }
}
