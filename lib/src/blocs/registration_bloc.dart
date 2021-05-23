import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/network/users_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';


class RegistrationBloc {
  final apiService = UsersAPI(Dio());

  final validateFirstName = StreamTransformer<String,String>.fromHandlers(
      handleData: (value,sink) {
        if (value.length < 2) {
          sink.addError("El nombre es muy corto");
        } else if (value.length > 30) {
          sink.addError("El nombre es muy largo");
        } else {
          sink.add(value);
        }
      }
  );

  final validateLastName = StreamTransformer<String,String>.fromHandlers(
      handleData: (value,sink) {
        if (value.length < 2) {
          sink.addError("El apellido es muy corto");
        } else if (value.length > 30) {
          sink.addError("El apellido es muy largo");
        } else {
          sink.add(value);
        }
      }
  );

  final validatePhone = StreamTransformer<String,String>.fromHandlers(
      handleData: (value,sink) {
        if (value.length < 8) {
          sink.addError("El número de celular es muy corto");
        } else if (value.length > 11) {
          sink.addError("El número de celular es muy largo");
        } else if (!RegExp(r"^[0-9]+$").hasMatch(value)) {
          sink.addError("El número de celular contiene caracteres inválidos");
        } else {
          sink.add(value);
        }
      }
  );

  final addressValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (value,sink) {
        if (value.length == 0) {
          sink.addError("El domicilio no puede estar vacío");
        } else {
          sink.add(value);
        }
      }
  );

  final BehaviorSubject<String> _firstNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _lastNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _phoneController = BehaviorSubject<String>();
  final BehaviorSubject<String> _addressController = BehaviorSubject<String>();
  final BehaviorSubject<String> _genderController = BehaviorSubject<String>();
  final PublishSubject<bool> _loadingData = PublishSubject<bool>();

  Function(String) get changeName => _firstNameController.sink.add;
  Function(String) get changeLastname => _lastNameController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changeAddress => _addressController.sink.add;
  Function(String) get changeGender => _genderController.sink.add;

  Stream<String> get firstName => _firstNameController.stream.transform(validateFirstName);
  Stream<String> get lastName => _lastNameController.stream.transform(validateLastName);
  Stream<String> get phone => _phoneController.stream.transform(validatePhone);
  Stream<String> get address => _addressController.stream;
  Stream<String> get gender => _genderController.stream;

  Stream<bool> get loading => _loadingData.stream;
  Stream<bool> get submitValid => Rx.combineLatest3(firstName, lastName, phone, _validate);

  bool _validate(String name, String lastname, String phone) {
    return identical(name, _firstNameController.value) &&
        identical(lastname, _lastNameController.value) &&
        identical(phone, _phoneController.value)
        ? true
        : null;
  }

  void submit() {
    _loadingData.sink.add(true);

     authBloc.signUp("ekeimel@hotmail.com", "12345678",
         "Ezequiel", "Keimel", "1130121188").whenComplete(() {
       _loadingData.sink.add(false);
     });
  }

  void dispose() {
    _firstNameController.close();
    _lastNameController.close();
    _phoneController.close();
    _addressController.close();
    _genderController.close();
    _loadingData.close();
  }
}