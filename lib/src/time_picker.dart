import 'dart:math';
import 'package:flutter/material.dart';
import '../decoration/time_picker_sector_decoration.dart';
import '../decoration/time_picker_sweep_decoration.dart';
import '../decoration/time_picker_handler_decoration.dart';
import '../decoration/time_picker_decoration.dart';
import '../painters/time_picker_painter.dart';

/// Returns a widget which displays a circle to be used as a picker.
///
/// Required arguments are init and end to set the initial selection.
/// onSelectionChange is a callback function which returns new values as the user
/// changes the interval.
/// The rest of the params are used to change the look and feel.
///
class TimePicker extends StatefulWidget {
  /// The number of sections in which the circle will be divided for selection.
  /// the selection will be values between 0..divisions; max value is 300
  final int divisions;

  /// the initial value in the selection
  final int init;

  /// the end value in the selection
  final int end;

  /// the number of primary sectors to be painted
  /// will be painted using selectionColor
  final int? primarySectors;

  /// the number of secondary sectors to be painted
  /// will be painted using baseColor
  final int? secondarySectors;

  /// an optional widget that would be mounted inside the circle
  final Widget? child;

  /// height of the canvas, default at 220
  final double? height;

  /// width of the canvas, default at 220
  final double? width;

  /// callback function when init and end change
  /// (int init, int end) => void
  final SelectionChanged<int> onSelectionChange;

  /// callback function when init and end finish
  /// (int init, int end) => void
  final SelectionChanged<int> onSelectionEnd;

  /// used to decorate the our widget
  final TimePickerDecoration? decoration;

  TimePicker({
    required this.divisions,
    required this.init,
    required this.end,
    required this.onSelectionChange,
    required this.onSelectionEnd,
    this.child,
    this.decoration,
    this.height,
    this.width,
    this.primarySectors,
    this.secondarySectors,
  }) : assert(divisions >= 0 && divisions <= 300,
            'divisions has to be > 0 and <= 300');

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  int _init = 0;
  int _end = 0;

  @override
  void initState() {
    super.initState();

    _init = widget.init % widget.divisions;
    _end = widget.end % widget.divisions;
  }

  TimePickerDecoration getDefaultPickerDecorator() {
    var startBox = TimePickerHandlerDecoration(
      color: Colors.lightBlue[900]!.withOpacity(0.6),
      shape: BoxShape.circle,
      icon:
          Icon(Icons.filter_tilt_shift, size: 30, color: Colors.lightBlue[700]),
      useRoundedPickerCap: true,
    );

    var endBox = TimePickerHandlerDecoration(
      color: Colors.lightBlue[900]!.withOpacity(0.8),
      shape: BoxShape.circle,
      icon:
          Icon(Icons.filter_tilt_shift, size: 40, color: Colors.lightBlue[700]),
      useRoundedPickerCap: true,
    );

    var sweepDecoration = TimePickerSweepDecoration(
      pickerStrokeWidth: 12,
      pickerGradient: SweepGradient(
        startAngle: 3 * pi / 2,
        endAngle: 7 * pi / 2,
        tileMode: TileMode.repeated,
        colors: [Colors.red.withOpacity(0.8), Colors.blue.withOpacity(0.8)],
      ),
    );

    var primarySectorDecoration = TimePickerSectorDecoration(
        color: Colors.blue, width: 2, size: 8, useRoundedCap: false);

    var secondarySectorDecoration = primarySectorDecoration.copyWith(
      color: Colors.lightBlue.withOpacity(0.5),
      width: 1,
      size: 6,
    );

    return TimePickerDecoration(
      sweepDecoration: sweepDecoration,
      baseColor: Colors.lightBlue[200]!.withOpacity(0.2),
      primarySectorsDecoration: primarySectorDecoration,
      secondarySectorsDecoration: secondarySectorDecoration,
      initHandlerDecoration: startBox,
      endHandlerDecoration: endBox,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 220,
      width: widget.width ?? 220,
      child: TimePickerPainter(
        init: _init,
        end: _end,
        divisions: widget.divisions,
        primarySectors: widget.primarySectors ?? 0,
        secondarySectors: widget.secondarySectors ?? 0,
        child: widget.child ?? Container(),
        onSelectionChange: (newInit, newEnd) {
          widget.onSelectionChange(newInit, newEnd);
          setState(() {
            _init = newInit;
            _end = newEnd;
          });
        },
        onSelectionEnd: (newInit, newEnd) {
          widget.onSelectionEnd(newInit, newEnd);
        },
        pickerDecoration: widget.decoration ?? getDefaultPickerDecorator(),
      ),
    );
  }
}
