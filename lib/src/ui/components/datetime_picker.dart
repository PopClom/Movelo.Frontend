import 'package:flutter/material.dart';
import 'package:fletes_31_app/src/utils/flushbar.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';

class DatetimePickerWidget extends StatefulWidget {
  final Function(DateTime) changeDateTime;

  DatetimePickerWidget({
    this.changeDateTime,
  });

  @override
  _DatetimePickerWidgetState createState() => _DatetimePickerWidgetState();
}

class _DatetimePickerWidgetState extends State<DatetimePickerWidget> {
  DateTime dateTime;

  String getText() {
    if (dateTime == null) {
      return 'No programar';
    } else {
      return dateTimeToString(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: () => pickDateTime(context),
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Text(getText(), style: TextStyle(color: Colors.black)),
      )
  );

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    final selectedTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (selectedTime.isBefore(DateTime.now().add(const Duration(hours: 4)))) {
      showErrorToast(
          Navigation.navigationKey.currentContext,
          'No pudimos programar tu envío',
          'Los envíos deben programarse con más de 4 horas de anticipación',
      );
      return;
    }

    widget.changeDateTime(selectedTime);

    setState(() {
      dateTime = selectedTime;
    });
  }

  Future<DateTime> pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime ?? initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime: dateTime != null
          ? TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
          : initialTime,
    );

    if (newTime == null) return null;

    if (newTime.hour > 21 || newTime.hour < 5) {
      showErrorToast(
          Navigation.navigationKey.currentContext,
          'No pudimos programar tu envío',
          'No se pueden programar envíos en este horario',
      );
      return null;
    }

    return newTime;
  }
}