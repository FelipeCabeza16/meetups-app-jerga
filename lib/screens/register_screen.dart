import 'package:flutter/material.dart';
import 'package:meetups_app/models/arguments.dart';
import 'package:meetups_app/models/forms.dart';
import 'package:meetups_app/screens/login_screen.dart';
import 'package:meetups_app/services/auth_api_provider.dart';
import 'package:meetups_app/utils/hypotenuse.dart';

class RegisterScreen extends StatefulWidget {
  static final String route = '/register';
  final AuthApiService auth = AuthApiService();

  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  // 1. Create GlobalKey for form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // 2. Create autovalidate
  bool _autovalidate = false;
  BuildContext _scaffoldContext;
  // 3. Create instance of RegisterFormData
  RegisterFormData _registerData = RegisterFormData();
  // 4. Create Register function and print all of the data

  void _handleSuccess(data) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false,
        arguments: LoginScreenArguments(
            'Registrado éxitosamente (:'));
  }

  void _handleError(res) {
    Scaffold.of(_scaffoldContext)
        .showSnackBar(SnackBar(content: Text(res['errors']['message'])));
  }

  void _register() {
    widget.auth
        .register(_registerData)
        .then(_handleSuccess)
        .catchError(_handleError);
  }

  void _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _register();
    } else {
      setState(() => _autovalidate = true);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Registrarse')),
        body: Builder(builder: (context) {
          _scaffoldContext = context;

          return Padding(
              padding: EdgeInsets.all(hypotenuse(
                  MediaQuery.of(context).size.height * 0.035,
                  MediaQuery.of(context).size.width * 0.035)),
              child: Form(
                // 5. Form Key
                key: _formKey,
                autovalidate: _autovalidate,
                child: ListView(
                  children: [
                    _buildTitle(),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Nombre',
                      ),
                      // 6. Required Validator
                      validator:
                          composeValidators('nombre', [requiredValidator]),
                      // 7. onSaved - save data to registerFormData
                      onSaved: (value) => _registerData.name = value,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Username',
                      ),
                      validator:
                          composeValidators('username', [requiredValidator]),
                      onSaved: (value) => _registerData.username = value,
                    ),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                        validator: composeValidators(
                            'email', [requiredValidator, emailValidator]),
                        onSaved: (value) => _registerData.email = value,
                        keyboardType: TextInputType.emailAddress),
                    TextFormField(
                        style: Theme.of(context).textTheme.headline,
                        decoration: InputDecoration(
                          hintText: 'Avatar Url',
                        ),
                        onSaved: (value) => _registerData.avatar = value,
                        keyboardType: TextInputType.url),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                      ),
                      validator:
                          composeValidators('contraseña', [requiredValidator]),
                      onSaved: (value) => _registerData.password = value,
                      obscureText: true,
                    ),
                    TextFormField(
                      style: Theme.of(context).textTheme.headline,
                      decoration: InputDecoration(
                        hintText: 'Confirmar contraseña',
                      ),
                      validator: composeValidators(
                          'confirmar contraseña', [requiredValidator]),
                      onSaved: (value) =>
                          _registerData.passwordConfirmation = value,
                      obscureText: true,
                    ),
                    _buildLinksSection(),
                    _buildSubmitBtn()
                  ],
                ),
              ));
        }));
  }

  Widget _buildTitle() {
    return Container(
      margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.025),
      child: Text(
        'Registrate Hoy',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
        alignment: Alignment(-1.0, 0.0),
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          child: const Text('Enviar'),
          onPressed: _submit, 
        ));
  }

  Widget _buildLinksSection() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/login");
            },
            child: Text(
              'Ya te uníste? Ingresa ahora.',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/meetups");
              },
              child: Text(
                'Continuar a inicio',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ))
        ],
      ),
    );
  }
}
