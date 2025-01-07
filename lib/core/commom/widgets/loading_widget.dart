import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.child, this.event});
  final Widget child;
  final VoidCallback? event;
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        if (event != null) {
          event!();
        } else {
          log('message:null function is paased');
          return;
        }
      },
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        const Center(
          child: CupertinoActivityIndicator(),
        )
      ],
    );
  }
}
