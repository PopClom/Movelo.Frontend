import 'dart:math';
import 'package:fletes_31_app/src/ui/login_page.dart';
import 'package:fletes_31_app/src/utils/sign_up_args.dart';
import 'package:flutter/material.dart';
import 'package:fletes_31_app/src/blocs/registration_bloc.dart';

class RegistrationPage extends StatefulWidget {
  static const routeName = '/register';

  RegistrationPage({ Key key }) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final RegistrationBloc bloc = RegistrationBloc();

  String _initialFirstName = '';
  String _initialLastName = '';

  Widget _entryField(String title, stream, onChanged,
      {bool isPassword = false, keyboardType = TextInputType.text, String initialValue = ''}) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snap) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: TextFormField(
            obscureText: isPassword,
            initialValue: initialValue,
            decoration: InputDecoration(
              isDense: true,
              labelText: title,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1.5, color: Colors.orange),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1.5, color: Colors.red),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              errorText: snap.error,
            ),
            onChanged: onChanged,
            keyboardType: keyboardType,
            style: new TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        );
      },
    );
  }

  Widget _dropdownField(String title, List<String> options, stream, onChanged) {
    return StreamBuilder<String>(
      stream: stream,
      builder: (context, snap) {
        return Container(
          height: 50,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            hint: Text(title),
            value: snap.data,
            decoration: InputDecoration(
              isDense: true,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(width: 1.5, color: Colors.orange),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
            ),
            onChanged: onChanged,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _inputFieldsWidget() {
    return Column(
      children: <Widget>[
        _entryField('Nombre', bloc.firstName, bloc.changeFirstName, initialValue: _initialFirstName),
        _entryField('Apellido', bloc.lastName, bloc.changeLastName, initialValue: _initialLastName),
        _entryField('Celular', bloc.phone, bloc.changePhone, keyboardType: TextInputType.phone),
        _entryField('Domicilio (opcional)', bloc.address, bloc.changeAddress),
        _dropdownField('Género (opcional)', ['Femenino', 'Masculino', 'No binario'], bloc.gender, bloc.changeGender),
      ],
    );
  }

  Widget _submitButton() {
    return StreamBuilder<bool>(
      stream: bloc.submitValid,
      builder: (context, snap) {
        return TextButton(
            onPressed: (!snap.hasData) ? null : bloc.submit,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  color: snap.hasData ? Colors.orange : Colors.grey.shade300),
              child: Text(
                'Continuar',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
        );
      },
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('Moto'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width * 0.75, 360.0);

    try {
      final args = ModalRoute.of(context).settings.arguments as SignUpArgs;
      bloc.changeEmail(args.email);
      bloc.changePassword(args.password);
      if (args.firstName != null) {
        bloc.changeFirstName(args.firstName);
        _initialFirstName = args.firstName;
      }
      if (args.lastName != null) {
        bloc.changeLastName(args.lastName);
        _initialLastName = args.lastName;
      }
    } catch (err) {
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(
          context,
          LoginPage.routeName,
        );
      });
    }

    return Container(
          alignment: Alignment.center,
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                          'images/logo-fletes31-inverted.png',
                          width: MediaQuery.of(context).size.width * 0.75
                      ),
                      Text(
                        'Completá tu registro',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 15),
                      _inputFieldsWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
