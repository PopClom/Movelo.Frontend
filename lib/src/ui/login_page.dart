import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fletes_31_app/src/ui/registration_page.dart';
import 'package:fletes_31_app/src/blocs/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:fletes_31_app/src/network/users_api.dart';


const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginPage extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: 1500);

  Future<String> _authUser(LoginData data) async {
    print('Name: ${data.name}, Password: ${data.password}');
    try {
      await authBloc.logIn(data.name, data.password);
      return null;
    } catch(error) {
      return "El usuario o la contraseña son incorrectos";
    }
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'El usuario no existe';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: 'images/logo-fletes31.png',
      onLogin: _authUser,
      onSignup: _authUser,
      messages: LoginMessages(
        usernameHint: 'Usuario',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'Iniciar sesión',
        signupButton: 'Registrarse',
        forgotPasswordButton: '¿Olvidaste tu contraseña?',
        recoverPasswordButton: 'Recuperar',
        goBackButton: 'Volver',
        confirmPasswordError: '¡Las contraseñas no coinciden!',
        recoverPasswordSuccess: 'Password rescued successfully',
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => RegistrationPage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
    );
  }

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
          scopes: [
            'profile',
            'email',
          ]
      );
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final String accessToken = (await googleUser.authentication).accessToken;
      print(_googleSignIn.currentUser.displayName);
      print(accessToken);
    } catch(error) {
      print(error);
    }
    return "No se pudo iniciar sesión con Google";
  }

  Future<String> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
        ]
    );
    if (result.status == LoginStatus.success) {
      final String accessToken = result.accessToken.token;
      final userData = await FacebookAuth.instance.getUserData();
      print(userData['name']);
      print(accessToken);
    } else {
      print('error');
    }
    return "No se pudo iniciar sesión con Facebook";
  }
}