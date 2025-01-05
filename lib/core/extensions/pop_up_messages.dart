import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension PopUpMessasges on BuildContext {
  //.......FUNCTION TO SHOW A MESSAGE
  showPopUpMsg(String message, {int seconds = 5}) {
    if (!mounted) return;
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ScaffoldMessenger.of(this)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.grey.shade800,
              content: Text(
                message,
              ),
              duration: Duration(
                seconds: seconds,
              ),
              showCloseIcon: true,
            ),
          );
      },
    );
  }
}
