import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/models/place_autocomplete_data.dart';
import 'package:fletes_31_app/src/utils/whatsapp.dart';
import 'dart:math';

import 'package:flutter/material.dart';

List<String> splitName(String fullName) {
  if (fullName == null)
    return ['', ''];

  List<String> splitFullName = fullName.split(' ');

  if (splitFullName.length == 1)
    return [splitFullName.first, ''];

  String lastName = splitFullName.removeLast();
  String firstName = splitFullName.join(' ');
  return [firstName, lastName];
}

bool is4xxError(error) {
  if (error is DioError &&
      error.type == DioErrorType.RESPONSE &&
      error.response != null &&
      error.response.statusCode >= 400 && error.response.statusCode < 500) {
      return true;
    }
  return false;
}

String generatePassword(bool _isWithLetters, bool _isWithUppercase,
    bool _isWithNumbers, bool _isWithSpecial, double _numberCharPassword) {

  String _lowerCaseLetters = 'abcdefghijklmnopqrstuvwxyz';
  String _upperCaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String _numbers = '0123456789';
  String _special = '@#=+!£\$%&?[](){}';

  String _allowedChars = '';

  _allowedChars += (_isWithLetters ? _lowerCaseLetters : '');
  _allowedChars += (_isWithUppercase ? _upperCaseLetters : '');
  _allowedChars += (_isWithNumbers ? _numbers : '');
  _allowedChars += (_isWithSpecial ? _special : '');

  int i = 0;
  String _result = '';

  while (i < _numberCharPassword.round()) {
    int randomInt = Random.secure().nextInt(_allowedChars.length);
    _result += _allowedChars[randomInt];
    i++;
  }

  return _result;
}

String booleanToWord(bool boolean) {
  return boolean != null && boolean ? 'Sí' : 'No';
}

String dateTimeToString(DateTime dateTime) {
  final String hour = dateTime.hour.toString();
  final String minute = dateTime.minute.toString().padLeft(2, '0');
  return '${dateTime.day}/${dateTime.month}/${dateTime.year} a las $hour.$minute';
}

String secondsToString(int seconds) {
  int minutes = (seconds / 60).floor();
  int hours = (minutes / 60).floor();
  minutes -= hours * 60;
  return hours == 0 ? '$minutes minutos' : '$hours horas y $minutes minutos';
}

String metersToString(int meters) {
  return '${(meters / 1000).toStringAsFixed(1)}km';
}

void showMovingDialog(context, origin, destination) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('¿Te querés mudar?'),
        content: Text('Ingresá acá y cotizá con nosotros al instante.\n'
            'Recordá que solo hacemos envíos dentro de CABA y GBA'),
        actions: <Widget>[
          TextButton(
            child: const Text('Ingresar'),
            onPressed: () => _movingRequestWhatsapp(origin, destination),
          ),
        ],
      );
    },
  );
}

_movingRequestWhatsapp(GooglePlacesDetails origin, GooglePlacesDetails destination) async {
  String message;

  if (origin != null && destination != null) {
    message = '¡Hola! Quisiera pedir un vehículo para mudanza desde *ORIGIN_ADDRESS* hasta *DESTINATION_ADDRESS*.'
        .replaceFirst('ORIGIN_ADDRESS', origin.formattedAddress)
        .replaceFirst('DESTINATION_ADDRESS', destination.formattedAddress);
  } else {
    message = '¡Hola! Quisiera pedir un vehículo para mudanza.';
  }

  message += '\n¡Muchas gracias!';

  return await sendWhatsAppMessage('5491158424244', message);
}
