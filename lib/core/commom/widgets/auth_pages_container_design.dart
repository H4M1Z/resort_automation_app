import 'package:flutter/material.dart';

class BackgroundContainerDesign extends StatelessWidget {
  const BackgroundContainerDesign({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return Center(
      child: Container(
        width: width,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(53, 97, 105, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              220,
            ),
            topRight: Radius.circular(
              220,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
