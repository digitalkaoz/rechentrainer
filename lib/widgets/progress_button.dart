import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProgressButton extends StatefulWidget {
  final Widget child;
  final Function? preCallback;
  final Function? postCallback;
  final Function callback;
  final double? width;

  const ProgressButton({
    Key? key,
    required this.child,
    required this.callback,
    this.preCallback,
    this.postCallback,
    this.width,
  }) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton> {
  bool isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: PlatformElevatedButton(
        child: isGenerating
            ? const SpinKitThreeInOut(
                size: 14,
                color: Colors.white,
              )
            : widget.child,
        onPressed: () async {
          if (widget.preCallback != null) {
            await widget.preCallback!();
          }

          setState(() {
            isGenerating = !isGenerating;
            try {
              widget.callback();
              isGenerating = !isGenerating;
            } catch (e) {
              // ignore: avoid_print
              print(e);
            }
          });

          if (widget.postCallback != null) {
            await widget.postCallback!();
          }
        },
      ),
    );
  }
}
