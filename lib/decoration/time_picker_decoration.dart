import 'package:flutter/material.dart';
import '../decoration/time_picker_clock_number_decoration.dart';
import '../decoration/time_picker_clock_sector_decoration.dart';
import '../decoration/time_picker_handler_decoration.dart';
import '../decoration/time_picker_sweep_decoration.dart';

class TimePickerDecoration {
  /// defines the background color of the picker
  /// Default Value: [Colors.cyanAccent]
  final Color baseColor;

  /// to add extra padding for picker base or outer circle
  final double pickerBaseCirclePadding;

  /// Provides decoration options which will get applied to the internal clock's numbers when enable
  /// Default Value: NULL
  final TimePickerClockNumberDecoration? clockNumberDecoration;

  /// this optional decorator provides option which will get applied to the secondary Divider when enable
  /// if [primarySectors] is not defined then this setting are not needed
  /// when [primarySectors] is set, and secondaryDividerDecoration == null the dividers will use default values from [TimePickerClockSectorDecoration]
  /// Default Value: NULL
  ///
  /// See also:
  /// * TimePickerClockSectorDecoration
  final TimePickerClockSectorDecoration? primarySectorsDecoration;

  /// this optional decorator provides option which will get applied to the secondary Divider when enable
  /// if [secondarySectors] is not defined then this setting are not needed
  /// when [secondarySectors] is set, and secondaryDividerDecoration == null the dividers will use default values from [TimePickerClockSectorDecoration]
  /// Default Value: NULL
  ///
  /// See also:
  /// * TimePickerClockSectorDecoration
  final TimePickerClockSectorDecoration? secondarySectorsDecoration;

  /// See also: TimePickerSweepDecoration
  final TimePickerSweepDecoration sweepDecoration;

  /// See also: TimePickerHandlerDecoration
  final TimePickerHandlerDecoration initHandlerDecoration;

  /// See also: TimePickerHandlerDecoration
  final TimePickerHandlerDecoration endHandlerDecoration;

  TimePickerDecoration({
    required this.sweepDecoration,
    required this.initHandlerDecoration,
    required this.endHandlerDecoration,
    this.baseColor = Colors.cyanAccent,
    this.pickerBaseCirclePadding = 0.0,
    this.primarySectorsDecoration,
    this.secondarySectorsDecoration,
    this.clockNumberDecoration,
  });

  TimePickerDecoration copyWith({
    TimePickerSweepDecoration? sweepDecoration,
    TimePickerHandlerDecoration? initHandlerDecoration,
    TimePickerHandlerDecoration? endHandlerDecoration,
    Color? baseColor,
    double? radiusPadding,
    TimePickerClockSectorDecoration? primaryClockSectorDecoration,
    TimePickerClockSectorDecoration? secondaryClockSectorDecoration,
    TimePickerClockNumberDecoration? clockIndicatorDecoration,
  }) {
    return TimePickerDecoration(
      sweepDecoration: sweepDecoration ?? this.sweepDecoration,
      initHandlerDecoration:
          initHandlerDecoration ?? this.initHandlerDecoration,
      endHandlerDecoration: endHandlerDecoration ?? this.endHandlerDecoration,
      baseColor: baseColor ?? this.baseColor,
      pickerBaseCirclePadding: radiusPadding ?? this.pickerBaseCirclePadding,
      primarySectorsDecoration:
          primaryClockSectorDecoration ?? this.primarySectorsDecoration,
      secondarySectorsDecoration:
          secondaryClockSectorDecoration ?? this.secondarySectorsDecoration,
      clockNumberDecoration:
          clockIndicatorDecoration ?? this.clockNumberDecoration,
    );
  }
}
