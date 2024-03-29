import 'package:fletes_31_app/src/ui/landing_page.dart';
import 'package:fletes_31_app/src/utils/helpers.dart';
import 'package:fletes_31_app/src/utils/navigation.dart';
import 'package:fletes_31_app/src/utils/sign_up_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fletes_31_app/src/ui/registration_page.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';


class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  LoginPage({ Key key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Duration get loginTime => Duration(milliseconds: 1500);

  String _email;
  String _password;
  String _firstName;
  String _lastName;

  Future<String> _loginUser(LoginData data) async {
    try {
      await authBloc.logIn(data.name, data.password);
      return null;
    } catch(err) {
      if (is4xxError(err)) {
        return 'El usuario o la contraseña son incorrectos';
      }
      return 'No pudimos realizar esta operación';
    }
  }

  Future<String> _signupUser(LoginData data) async {
    authBloc.closeSession(); //ToDo: Borrar esta linea
    try {
      bool isAvailable = await authBloc.isEmailAvailable(data.name);
      if (!isAvailable) {
        return 'La dirección de correo no está disponible';
      }
      _email = data.name;
      _password = data.password;
      return null;
    } catch(err) {
      return 'No pudimos realizar esta operación';
    }
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  static final FormFieldValidator<String> _passwordValidator = (value) {
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    } else if (value.length > 30) {
      return 'La contraseña es muy larga';
    } else if (!RegExp(r'[a-zA-Z]').hasMatch(value)) {
      return 'La contraseña debe tener al menos una letra';
    } else if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'La contraseña debe tener al menos un número';
    } else {
      return null;
    }
  };

  static final FormFieldValidator<String> _emailValidator = (value) {
    if (value.isEmpty || !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value)) {
      return 'Correo inválido';
    }
    return null;
  };

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: 'assets/images/logos/logo-movelo-white.png',
      onLogin: _loginUser,
      onSignup: _signupUser,
      emailValidator: _emailValidator,
      passwordValidator: _passwordValidator,
      messages: LoginMessages(
        usernameHint: 'Correo electrónico',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar',
        forgotPasswordButton: '¿Olvidaste tu contraseña?',
        loginButton: 'Iniciar sesión',
        signupButton: 'Registrarse',
        recoverPasswordButton: 'Recuperar',
        recoverPasswordIntro: 'Escribí tu correo electrónico',
        recoverPasswordDescription: 'Vas a recibir un correo para que recuperes tu contraseña',
        goBackButton: 'Volver',
        confirmPasswordError: '¡Las contraseñas no coinciden!',
        recoverPasswordSuccess: 'Verificá la casilla de tu correo electrónico',
        flushbarTitleError: 'Error',
        flushbarTitleSuccess: 'Listo',
      ),
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          callback: signInWithGoogle,
        ),
        LoginProvider(
          icon: FontAwesomeIcons.facebookF,
          callback: signInWithFacebook,
        ),
      ],
      onSubmitAnimationCompleted: () {
        if (authBloc.isSessionValid.hasValue && authBloc.isSessionValid.value) {
          if (Navigator.canPop(Navigation.navigationKey.currentContext)) {
            Navigator.pop(Navigation.navigationKey.currentContext);
          } else {
            Navigator.pushReplacementNamed(
              Navigation.navigationKey.currentContext,
              LandingPage.routeName,
            );
          }
        } else {
          Navigator.pushReplacementNamed(
            Navigation.navigationKey.currentContext,
            RegistrationPage.routeName,
            arguments: SignUpArgs(_email, _password, _firstName, _lastName),
          );
        }
      },
      onRecoverPassword: _recoverPassword,
    );
  }

  Future<String> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ]
    );

    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final String accessToken = (await googleUser.authentication).accessToken;
      await authBloc.logInGoogle(accessToken);
      return null;
    } catch(err) {
      if (is4xxError(err)) {
        List<String> firstAndLastName = splitName(_googleSignIn.currentUser.displayName);
        _email = _googleSignIn.currentUser.email;
        _password = '1a' + generatePassword(true, true, true, true, 12);
        _firstName = firstAndLastName.first;
        _lastName = firstAndLastName.last;
        return null;
      }
    }
    return 'No se pudo iniciar sesión con Google';
  }

  Future<String> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
        ]
    );

    if (result.status == LoginStatus.success) {
      try {
        final String accessToken = result.accessToken.token;
        await authBloc.logInFacebook(accessToken);
        return null;
      } catch(err) {
        if (is4xxError(err)) {
          final userData = await FacebookAuth.instance.getUserData();
          List<String> firstAndLastName = splitName(userData['name']);
          _email = userData['email'];
          _password = '1a' + generatePassword(true, true, true, true, 12);
          _firstName = firstAndLastName.first;
          _lastName = firstAndLastName.last;
          return null;
        }
      }
    }
    return 'No se pudo iniciar sesión con Facebook';
  }
}