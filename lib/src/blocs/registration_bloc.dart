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
          sink.addError('El nombre es muy corto');
        } else if (value.length > 30) {
          sink.addError('El nombre es muy largo');
        } else {
          sink.add(value);
        }
      }
  );

  final validateLastName = StreamTransformer<String,String>.fromHandlers(
      handleData: (value,sink) {
        if (value.length < 2) {
          sink.addError('El apellido es muy corto');
        } else if (value.length > 30) {
          sink.addError('El apellido es muy largo');
        } else {
          sink.add(value);
        }
      }
  );

  final validatePhone = StreamTransformer<String,String>.fromHandlers(
      handleData: (value,sink) {
        if (value.length < 8) {
          sink.addError('El número de celular es muy corto');
        } else if (value.length > 11) {
          sink.addError('El número de celular es muy largo');
        } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
          sink.addError('El número de celular contiene caracteres inválidos');
        } else {
          sink.add(value);
        }
      }
  );

  final addressValidator = StreamTransformer<String,String>.fromHandlers(
      handleData: (value,sink) {
        if (value.length == 0) {
          sink.addError('El domicilio no puede estar vacío');
        } else {
          sink.add(value);
        }
      }
  );

  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _firstNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _lastNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _phoneController = BehaviorSubject<String>();
  final BehaviorSubject<String> _addressController = BehaviorSubject<String>();
  final BehaviorSubject<String> _genderController = BehaviorSubject<String>();
  final BehaviorSubject<bool> _loadingData = BehaviorSubject<bool>();

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeFirstName => _firstNameController.sink.add;
  Function(String) get changeLastName => _lastNameController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changeAddress => _addressController.sink.add;
  Function(String) get changeGender => _genderController.sink.add;

  Stream<String> get firstName => _firstNameController.stream.transform(validateFirstName);
  Stream<String> get lastName => _lastNameController.stream.transform(validateLastName);
  Stream<String> get phone => _phoneController.stream.transform(validatePhone);
  Stream<String> get address => _addressController.stream;
  Stream<String> get gender => _genderController.stream;

  Stream<bool> get loading => _loadingData.stream;
  Stream<bool> get submitValid => Rx.combineLatest4(firstName, lastName, phone, _loadingData, _validate);

  RegistrationBloc() {
    _loadingData.sink.add(false);
  }

  bool _validate(String firstName, String lastName, String phone, bool loading) {
    return identical(firstName, _firstNameController.value) &&
        identical(lastName, _lastNameController.value) &&
        identical(phone, _phoneController.value) &&
        !loading
        ? true
        : null;
  }

  void submit() async {
    _loadingData.sink.add(true);

    authBloc.signUp(
        _emailController.value,
        _passwordController.value,
        _firstNameController.value,
        _lastNameController.value,
        _phoneController.value,
    ).catchError((obj) {
      _loadingData.sink.add(false);
    });
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _firstNameController.close();
    _lastNameController.close();
    _phoneController.close();
    _addressController.close();
    _genderController.close();
    _loadingData.close();
  }
}