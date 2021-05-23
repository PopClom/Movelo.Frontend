import 'dart:async';
import 'package:rxdart/rxdart.dart';
import './auth_bloc.dart';
import '../resources/repository.dart';


class RegistrationBloc {
  Repository repository = Repository();

  final validateName = StreamTransformer<String,String>.fromHandlers(
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

  final validateLastname = StreamTransformer<String,String>.fromHandlers(
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

  final BehaviorSubject<String> _nameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _lastnameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _phoneController = BehaviorSubject<String>();
  final BehaviorSubject<String> _addressController = BehaviorSubject<String>();
  final BehaviorSubject<String> _genderController = BehaviorSubject<String>();
  final PublishSubject _loadingData = PublishSubject<bool>();

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeLastname => _lastnameController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changeAddress => _addressController.sink.add;
  Function(String) get changeGender => _genderController.sink.add;

  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get lastname => _lastnameController.stream.transform(validateLastname);
  Stream<String> get phone => _phoneController.stream.transform(validatePhone);
  Stream<String> get address => _addressController.stream;
  Stream<String> get gender => _genderController.stream;

  Stream<bool> get submitValid => Rx.combineLatest3(name, lastname, phone, _validate);
  Stream<bool> get loading => _loadingData.stream;

  bool _validate(String name, String lastname, String phone) {
    return identical(name, _nameController.value) &&
        identical(lastname, _lastnameController.value) &&
        identical(phone, _phoneController.value)
        ? true
        : null;
  }

  void submit() {
    final validEmail = _nameController.value;
    final validLastname = _lastnameController.value;
    _loadingData.sink.add(true);
    print("AKAAA");
    // login(validEmail, validLastname);
  }

  login(String email, String password) async {
    String token = await repository.login(email, password);
    _loadingData.sink.add(false);
    authBloc.openSession(token);
  }

  void dispose() {
    _nameController.close();
    _lastnameController.close();
    _phoneController.close();
    _addressController.close();
    _genderController.close();
    _loadingData.close();
  }
}