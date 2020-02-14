import 'package:flutter/material.dart';
import 'package:meetups_app/models/forms.dart';
import 'package:meetups_app/screens/meetup_home_screen.dart';
import 'package:meetups_app/screens/register_screen.dart';
import 'package:meetups_app/services/auth_api_provider.dart';


class LoginScreen extends StatefulWidget {
    final String message;
  static final String route = '/login';
  final AuthApiService authApi = AuthApiService();
   LoginScreen({this.message});
  BuildContext _scaffoldContext;

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _emailKey =
      GlobalKey<FormFieldState<String>>();

  LoginFormData _loginData = LoginFormData();
  bool _autovalidate = false;
  BuildContext _scaffoldContext;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForMessage());
  }

  void _checkForMessage() {
    if (widget.message != null && widget.message.isNotEmpty) {
      Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
        content: Text(widget.message)
      ));
    }
    // _emailController.addListener(() {
    //   print(_emailController.text);
    // });
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    widget.authApi.login(_loginData).then((data) {
      Navigator.pushNamed(context, MeetupHomeScreen.route);
    }).catchError((res) {
      Scaffold.of(_scaffoldContext)
          .showSnackBar(SnackBar(content: Text(res['errors']['message'])));
    });
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      // final password = _passwordKey.currentState.value;
      // final email = _emailKey.currentState.value;

      // final password = _passwordController.text;
      // final email = _emailController.text;
      form.save();
      _login();
    } else {
      setState(() => _autovalidate = true);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        _scaffoldContext = context;
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  key: _emailKey,
                  style: Theme.of(context).textTheme.headline,
                  validator: composeValidators('email',
                      [requiredValidator, minLengthValidator, emailValidator]),
                  onSaved: (value) => _loginData.email = value,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                TextFormField(
                  key: _passwordKey,
                  obscureText: true,
                  style: Theme.of(context).textTheme.headline,
                  validator: composeValidators(
                      'Contraseña', [requiredValidator, minLengthValidator]),
                  onSaved: (value) => _loginData.password = value,
                  decoration: InputDecoration(hintText: 'Contraseña'),
                ),
                _buildLinks(context),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    margin: EdgeInsets.only(top: 10.0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      child: const Text('Enviar'),
                      onPressed: _submit,
                    ))
              ],
            ),
          ),
        );
      }),
      // body: Padding(
      //   padding: EdgeInsets.all(hypotenuse(
      //       MediaQuery.of(context).size.height * 0.035,
      //       MediaQuery.of(context).size.width * 0.035)),
      //   child: Form(
      //     autovalidate: _autovalidate,
      //     key: _formKey,
      //     // Provide key
      //     child: ListView(
      //       children: [
      //         Container(
      //           margin: EdgeInsets.only(
      //               bottom: MediaQuery.of(context).size.height * 0.02),
      //           child: Text(
      //             'Iniciar sesión',
      //             style: TextStyle(
      //                 fontSize: 30.0 * MediaQuery.of(context).textScaleFactor,
      //                 fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //         TextFormField(
      //           key: _emailKey,
      //           onSaved: (value) => _loginData.email = value,
      //           //controller: _emailController,
      //           style: Theme.of(context).textTheme.headline,
      //           decoration: InputDecoration(hintText: 'Correo Electrónico'),
      //           validator: composeValidators('email',
      //               [requiredValidator, minLengthValidator, emailValidator]),
      //         ),
      //         TextFormField(
      //           key: _passwordKey,
      //           onSaved: (value) => _loginData.password = value,
      //           //controller: _passwordController,
      //           style: Theme.of(context).textTheme.headline,
      //           decoration: InputDecoration(hintText: 'Contraseña'),
      //           validator: composeValidators(
      //               'password', [requiredValidator, minLengthValidator]),
      //         ),
      //         _buildLinks(context),
      //         Container(
      //             alignment: Alignment(-1.0, 0.0),
      //             margin: EdgeInsets.only(
      //                 top: MediaQuery.of(context).size.height * 0.01),
      //             child: RaisedButton(
      //               textColor: Colors.white,
      //               color: Theme.of(context).primaryColor,
      //               child: const Text('Enviar'),
      //               onPressed: _submit,
      //             ))
      //       ],
      //     ),
      //   ),
      // ),
      appBar: AppBar(title: Text('Login')),
    );
  }

  Widget _buildLinks(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.025,
            bottom: MediaQuery.of(context).size.height * 0.008),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, RegisterScreen.route),
              child: Text('¿No tienes cuenta? Regístrate ahora!',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, MeetupHomeScreen.route),
              child: Text('Continuar a inicio',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            )
          ],
        ));
  }
}

String emailValidator(String value, String field) {
  final regex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  final hasMatch = regex.hasMatch(value);
  return hasMatch ? null : 'Please enter a valid email address';
}

String requiredValidator(String value, String field) {
  if (value.isEmpty) {
    return 'Please enter $field!';
  }

  return null;
}

String minLengthValidator(String value, String field) {
  if (value.length < 8) {
    return 'Minimum length of $field is 8 characters!';
  }

  return null;
}

Function(String) composeValidators(String field, List<Function> validators) {
  return (value) {
    if (validators != null && validators is List && validators.length > 0) {
      for (var validator in validators) {
        final errMessage = validator(value, field) as String;
        if (errMessage != null) {
          return errMessage;
        }
      }
    }

    return null;
  };
}
