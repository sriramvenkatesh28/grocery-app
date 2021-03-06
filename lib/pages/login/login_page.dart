import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:grocery/data/database_helper.dart';
import 'package:grocery/models/user.dart';
import 'package:grocery/pages/login/login_presenter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginPageContract {
  BuildContext _ctx;
  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _username, _password;

  LoginPagePresenter _presenter;

  _LoginPageState() {
    _presenter = new LoginPagePresenter(this);
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() {
        _isLoading = true;
        form.save();
        _presenter.doLogin(_username, _password);
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var loginBtn = new CupertinoButton(
      child: new Text("Login"),
      onPressed: _submit,
      color: Color(0xff84CC83),
    );

    var registerBtn = new CupertinoButton(
        child: new Text("Register"),
        color: Color(0xff84CC83),
        onPressed: () {
          /*Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginPage()));*/
          Navigator.of(context).pushNamed("/register");
        });
    var loginForm = new Column(

      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: new Text(
            "If you don't know your username and password you can always register",
            textScaleFactor: 1.0,
          ),
        ),
        new Form(
          key: formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _username = val,
                  decoration: new InputDecoration(labelText: "Username"),
                ),
              ),
              new Padding(
                padding: const EdgeInsets.all(10.0),
                child: new TextFormField(
                  onSaved: (val) => _password = val,
                  decoration: new InputDecoration(labelText: "Password", fillColor: Color(0xff84CC83)),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        loginBtn,
        SizedBox(
          height: 20,
        ),
        registerBtn
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login Page"),
        backgroundColor: Color(0xff84CC83),
      ),
      key: scaffoldKey,
      body: new Container(
        child: new Center(
          child: loginForm,
        ),
      ),
    );
  }

  @override
  void onLoginError(String error) {
    // TODO: implement onLoginError
    _showSnackBar(error);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess(User user) async {
    // TODO: implement onLoginSuccess
    _showSnackBar(user.toString());
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed("/home");
  }
}
