import 'dart:convert';

import 'package:brk_mobile/models/user.dart';
import 'package:brk_mobile/models/user_model.dart';
import 'package:brk_mobile/pages/home/home_page.dart';
import 'package:brk_mobile/pages/home/main_page.dart';
import 'package:brk_mobile/pages/register_page.dart';
import 'package:brk_mobile/providers/auth_provider.dart';
import 'package:brk_mobile/providers/new_auth_provider.dart';
import 'package:brk_mobile/providers/user_provider.dart';
import 'package:brk_mobile/theme.dart';
import 'package:brk_mobile/widgets/loading_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../networks/api.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  bool _isRememberMe = false;

  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');

  //KODINGAN BARU UNTUK LOGIN
  final formKey = new GlobalKey<FormState>();

  String? _username, _password;
  //BATAS KODINGAN BARU

  bool _isLoading = false;

  Future<void> checkLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var _login = localStorage.getBool('isLogin');
    if (_login == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    //KODINGAN BARU UNTUK LOGIN
    NewAuthProvider authNew = Provider.of<NewAuthProvider>(context);

    doLogin() async {
      // setState(() {
      //   _isLoading = true;
      // });
      if (emailController.text == '' || passwordController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Color.fromARGB(255, 244, 158, 54),
          content: Text(
            'username atau password harus diisi',
            textAlign: TextAlign.center,
          ),
        ));
      } else {
        final Future<Map<String, dynamic>> successfullMessage =
            authNew.login(emailController.text, passwordController.text);

        successfullMessage.then((response) {
          if (response['status']) {
            User user = response['user'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Gagal Login! \n username atau password salah!',
                textAlign: TextAlign.center,
              ),
            ));
          }
        });

        // setState(() {
        //   _isLoading = false;
        // });
      }
    }
    //BATAS KODINGAN BARU

    // Handle Login Old
    handleLoginOld() async {
      setState(() {
        _isLoading = true;
      });

      if (await authProvider.login(
        email: emailController.text,
        password: passwordController.text,
      )) {
        // UserModel userNow = authProvider.user;
        // print(userNow.token);
        // SharedPreferences localStorage = await SharedPreferences.getInstance();
        // await localStorage.setString('token', authProvider.user.token!);
        // localStorage.setBool('isLogin', true);
        // print(authProvider.user.token);
        // UserModel user = authProvider.user;
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Gagal Login!',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }

    // Handle Login New
    void handleLoginNew() async {
      setState(() {
        _isLoading = true;
      });

      var email = emailController.text.toString();
      var password = passwordController.text.toString();

      var data = {'email': email, 'password': password};

      var res = await Network().auth(data, '/login');
      var body = json.decode(res.body);
      if (body['meta']['code'] == 200) {
        UserModel.fromJson(body['data']['user']);
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        print(json.encode(body['data']['access_token']));
        localStorage.setBool('isLogin', true);
        Navigator.pushNamed(context, '/home');
      } else {
        print(body['meta']['code']);
        print("$email $password");
      }

      setState(() {
        _isLoading = false;
      });
    }

    // Header Image
    Widget buildHeaderImage() {
      return Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/logo_coffein.png'),
                ),
              ),
            ),
            // Text(
            //   'CoffeeIn',
            //   style: primaryTextStyle.copyWith(
            //     fontSize: 24,
            //     fontWeight: bold,
            //   ),
            // ),
          ],
        ),
      );
    }

    // Header Tittle
    Widget buildHeaderTittle() {
      return Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 12,
            ),
            Text(
              'Masuk',
              style: primaryTextStyle.copyWith(
                fontSize: 22,
                fontWeight: semiBold,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Silahkan masuk ke aplikasi menngunakan akun anda',
              style: subtitleTextStyle,
            ),
          ],
        ),
      );
    }

    // Form Email
    Widget buildEmailInput() {
      return Container(
        margin: const EdgeInsets.only(top: 24),
        child: Container(
          alignment: Alignment.centerLeft,
          height: 55,
          decoration: BoxDecoration(
            color: backgroundColor1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: emailController,
            showCursor: true,
            keyboardType: TextInputType.text,
            cursorColor: primaryColor,
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: primaryColor,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Masukkan Email',
                hintStyle: subtitleTextStyle.copyWith(fontSize: 14)),
          ),
        ),
      );
    }

    // Form Password
    Widget buildPasswordInput() {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Container(
          alignment: Alignment.centerLeft,
          height: 55,
          decoration: BoxDecoration(
            color: backgroundColor1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: passwordController,
            obscureText: !_passwordVisible,
            showCursor: true,
            cursorColor: primaryColor,
            keyboardType: TextInputType.visiblePassword,
            style: primaryTextStyle,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: primaryColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Masukkan Kata Sandi',
                hintStyle: subtitleTextStyle.copyWith(fontSize: 14)),
          ),
        ),
      );
    }

    // buttonFrogotPassword
    Widget buildForgotPassword() {
      return Container(
        margin: const EdgeInsets.only(top: 2),
        child: Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Lupa Password
            },
            child: Text(
              "Lupa Password?",
              textAlign: TextAlign.right,
              style: subtitleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: light,
                color: secondaryColor,
              ),
            ),
          ),
        ),
      );
    }

    // remember me
    Widget buildRememberMe() {
      return Container(
        height: 30,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: _isRememberMe,
              activeColor: primaryColor,
              checkColor: Colors.white,
              onChanged: ((value) {
                setState(
                  () {
                    _isRememberMe = value!;
                  },
                );
              }),
            ),
            Text(
              'Ingatkan saya',
              style: subtitleTextStyle.copyWith(
                fontSize: 14,
                fontWeight: light,
                color: secondaryColor,
              ),
            ),
          ],
        ),
      );
    }

    // buttonLogin
    Widget buildLoginButton() {
      return Container(
        height: 55,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        child: TextButton(
          onPressed: doLogin,
          style: TextButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            'Masuk',
            style: subtitleTextStyle.copyWith(
                fontSize: 16, fontWeight: bold, color: Colors.white),
          ),
        ),
      );
    }

    Widget buildDivider() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(children: <Widget>[
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: const Divider(
                color: Colors.black54,
                height: 36,
              ),
            ),
          ),
          Text(
            "atau",
            style: subtitleTextStyle.copyWith(
              fontSize: 16,
              fontWeight: light,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Container(
                margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                child: const Divider(
                  color: Colors.black54,
                  height: 36,
                )),
          ),
        ]),
      );
    }

    Widget buildOtherLoginMethodsSection() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              // splashColor: Colors.grey[700],
              onTap: () {},
              child: Image.asset(
                'assets/images/icon_google.png',
                height: 55,
                width: 55,
              ),
            ),
          ],
        ),
      );
    }

    // Footer
    Widget buildFooter() {
      return Container(
        margin: EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Belum punya akun? ',
              style: primaryTextStyle.copyWith(fontSize: 14),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                "Daftar Yuk",
                style: primaryTextStyle.copyWith(
                  fontSize: 14,
                  fontWeight: semiBold,
                  color: secondaryColor,
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderImage(),
                  buildHeaderTittle(),
                  buildEmailInput(),
                  buildPasswordInput(),
                  buildForgotPassword(),
                  buildRememberMe(),
                  // _isLoading ? LoadingButton() : buildLoginButton(),
                  authNew.loggedInStatus == Status.authenticating
                      ? LoadingButton()
                      : buildLoginButton(),
                  buildDivider(),
                  buildOtherLoginMethodsSection(),
                  const SizedBox(height: 25),
                  buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
