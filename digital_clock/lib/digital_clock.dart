// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Replace shadow with margin color
enum _Element {
  background,
  text,
  margin,
  shadow,
}

// Define constant theme - mid century modern x himalayan salt lamp
final _calmTheme = {
  _Element.background: Color(0xDDEA9A71),
  _Element.text: Color(0xFF6B300D),
  _Element.margin: Color(0xDDFFE3B2),
  _Element.shadow: Color(0xDDEA9A71),
};

//final _darkTheme = {
//  _Element.background: Colors.black,
//  _Element.text: Colors.white,
//  _Element.shadow: Color(0xFF174EA6),
//};

/// A basic digital clock.
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  // Initialize everything and get the functions started
  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  // The widget updated, compare the current version to the old version
  // and take the appropriate actions depending if they are still the same.
  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  // Close up shop and release the resources
  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  // Called so that setState will destroy the display and rebuild it
  // for the next frame to be displayed
  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  // Use the milliseconds timer to see if we are toggling a new
  // time increment. You can use a minute, or a second. Your choice.
  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      //
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  // Ye old build method
  @override
  Widget build(BuildContext context) {
    // Set the visual theme using if/else construct
//    final colors = Theme.of(context).brightness == Brightness.light
//        ? _lightTheme
//        : _darkTheme;

    // Set the visual theme to be constant
    final colors = _calmTheme;
    // Format the hour and minute according to user preferences
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    // set clock container height and font size
    final containerHeight = MediaQuery.of(context).size.shortestSide / 2;
    final containerWidth = MediaQuery.of(context).size.shortestSide / 10;
    final fontSize = MediaQuery.of(context).size.shortestSide /3.5;
    // set weather container height
    final weatherHeight = MediaQuery.of(context).size.shortestSide;
    final weatherWidth = MediaQuery.of(context).size.shortestSide / 1.6;
    // align time display
//    final timePadding = widget.model.is24HourFormat
//        ? const EdgeInsets.fromLTRB(15, 0, 0, 0)
//        : const EdgeInsets.fromLTRB(10, 0, 0, 0);
    // weather icon logic
    // temperature bar logic


    // Font Style Definition
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Lato',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 1,
          color: colors[_Element.shadow],
          offset: Offset(1, 0),
        ),
      ],
    );

    // Creating the UI
    return SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors[_Element.margin],
        ),
        child: Container(
          color: colors[_Element.background],
          height: containerHeight,
          width: containerWidth,
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                '$hour:$minute',
                style: defaultStyle,
                    textAlign: TextAlign.center,
              ),
              ),
            Container(
              alignment: Alignment.centerLeft,
//                  color: colors[_Element.background],
              height: weatherHeight,
              width: weatherWidth,
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    color: colors[_Element.margin],
                    height: weatherHeight,
                    width: 12.0,
                  ),
                  // placeholder for weather condition icon
                  Expanded(
                    flex: 100,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.ac_unit,
                        color: Colors.white60,
                        size: 90.0,
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 30,
                  ),
                  // placeholder for temperature gauge
                  Expanded(
                    flex: 40,
                    child: Container(
                      height: weatherHeight-80,
                      width: 20.0,
                      color: Colors.amberAccent,
                    ),
                  ),
                  const Spacer(
                    flex: 30,
                  ),

                ],
              ),
            ),

            ],
          ),
        ),
      ),
    );
  }
}
