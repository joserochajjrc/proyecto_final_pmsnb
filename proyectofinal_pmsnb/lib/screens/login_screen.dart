import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/services/email_authentication.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/responsive.dart';

EmailAuth emailAuth = EmailAuth();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  late StreamSubscription _subs;
  bool loader = false;

  @override
  void initState() {
    loader = false;
    _initDeepLinkListener();
    super.initState();
  }

  @override
  void dispose() {
    _disposeDeepLinkListener();
    super.dispose();
  }

  void _initDeepLinkListener() async {
    _subs = getLinksStream().listen((link) {
      _checkDeepLink(link!);
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      emailAuth.signInWithGithub(code).then((firebaseUser) {
        print(firebaseUser.email);
        print(firebaseUser.photoURL);
        print("LOGGED IN AS: ${firebaseUser.displayName}");
      }).catchError((e) {
        print("LOGIN ERROR: " + e.toString());
      });
    }
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
    }
  }

  void onClickGitHubLoginButton() async {
    const String url =
        "https://github.com/login/oauth/authorize?client_id=15b6215cdb2ddf501d02&scope=public_repo%20read:user%20user:email";

    if (await canLaunch(url)) {
      setState(() {
        loader = true;
      });
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      setState(() {
        loader = false;
      });
      print("CANNOT LAUNCH THIS URL!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtEmail = TextFormField(
      decoration: const InputDecoration(
          label: Text('Email User'), enabledBorder: OutlineInputBorder()),
    );

    final txtPass = TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
          label: Text('Password User'), enabledBorder: OutlineInputBorder()),
    );

    const spaceHorizontal = SizedBox(height: 15);

    final btnLogin = SocialLoginButton(
        buttonType: SocialLoginButtonType.generalLogin,
        onPressed: () {
          isLoading = true;
          setState(() {});
          Future.delayed(Duration(milliseconds: 3000)).then((value) {
            isLoading = false;
            setState(() {});
            Navigator.pushNamed(context, '/dash');
          });
        });

    final btnGoogle = SocialLoginButton(
        buttonType: SocialLoginButtonType.google,
        onPressed: () {
          emailAuth.signInWithGoogle(context);
          isLoading = true;
          setState(() {});
          Future.delayed(const Duration(milliseconds: 3000)).then((value) {
            isLoading = false;
            setState(() {});
            Navigator.pushNamed(context, '/dash');
          });
        });

    final btnFacebook = SocialLoginButton(
        buttonType: SocialLoginButtonType.facebook, onPressed: () {});

    final btngithub = SocialLoginButton(
        buttonType: SocialLoginButtonType.github,
        onPressed: () {
          onClickGitHubLoginButton();
        });

    final txtRegister = Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text('Crear cuenta :)',
              style: TextStyle(decoration: TextDecoration.underline))),
    );

    final btnForgot = TextButton(
      onPressed: () {},
      child: const Text(
        "Olvidaste la constraseña?",
        style: TextStyle(color: Color.fromARGB(255, 126, 173, 255)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: responsive(
              mobile: MobileLoginScreen(
                  spaceHorizontal: spaceHorizontal,
                  btnRegister: txtRegister,
                  txtEmail: txtEmail,
                  txtPass: txtPass,
                  btnLogin: btnLogin,
                  btnGoogle: btnGoogle,
                  btnFacebook: btnFacebook,
                  btngithub: btngithub),
              desktop: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 450,
                          child: Center(child: TopLoginImage()),
                        ),
                        SizedBox(
                            child: LoginScreenTopWidget(
                          spaceHorizontal: spaceHorizontal,
                          btnRegister: txtRegister,
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 450,
                          child: LoginForm(
                            txtEmail: txtEmail,
                            spaceHorizontal: spaceHorizontal,
                            txtPass: txtPass,
                            btnLogin: btnLogin,
                            btnGoogle: btnGoogle,
                            btnFacebook: btnFacebook,
                            btngithub: btngithub,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              tablet: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 450,
                          child: Center(child: TopLoginImage()),
                        ),
                        SizedBox(
                            child: LoginScreenTopWidget(
                          spaceHorizontal: spaceHorizontal,
                          btnRegister: txtRegister,
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 450,
                          child: LoginForm(
                            txtEmail: txtEmail,
                            spaceHorizontal: spaceHorizontal,
                            txtPass: txtPass,
                            btnLogin: btnLogin,
                            btnGoogle: btnGoogle,
                            btnFacebook: btnFacebook,
                            btngithub: btngithub,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({
    super.key,
    required this.spaceHorizontal,
    required this.txtEmail,
    required this.txtPass,
    required this.btnLogin,
    required this.btnGoogle,
    required this.btnFacebook,
    required this.btngithub,
    required this.btnRegister,
  });

  final SizedBox spaceHorizontal;
  final TextFormField txtEmail;
  final TextFormField txtPass;
  final SocialLoginButton btnLogin;
  final SocialLoginButton btnGoogle;
  final SocialLoginButton btnFacebook;
  final SocialLoginButton btngithub;
  final Padding btnRegister;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 100, child: TopLoginImage()),
            LoginScreenTopWidget(
                spaceHorizontal: spaceHorizontal, btnRegister: btnRegister),
            LoginForm(
              txtEmail: txtEmail,
              spaceHorizontal: spaceHorizontal,
              txtPass: txtPass,
              btnLogin: btnLogin,
              btnGoogle: btnGoogle,
              btnFacebook: btnFacebook,
              btngithub: btngithub,
            ),
          ]),
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.txtEmail,
    required this.spaceHorizontal,
    required this.txtPass,
    required this.btnLogin,
    required this.btnGoogle,
    required this.btnFacebook,
    required this.btngithub,
  });

  final TextFormField txtEmail;
  final SizedBox spaceHorizontal;
  final TextFormField txtPass;
  final SocialLoginButton btnLogin;
  final SocialLoginButton btnGoogle;
  final SocialLoginButton btnFacebook;
  final SocialLoginButton btngithub;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        txtEmail,
        spaceHorizontal,
        txtPass,
        spaceHorizontal,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
        ),
        btnLogin,
        spaceHorizontal,
        const Text(
          "or",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        spaceHorizontal,
        btnGoogle,
        spaceHorizontal,
        btnFacebook,
        spaceHorizontal,
        btngithub
      ],
    );
  }
}

class LoginScreenTopWidget extends StatelessWidget {
  const LoginScreenTopWidget({
    super.key,
    required this.spaceHorizontal,
    required this.btnRegister,
    //required this.btnAbout,
  });

  final SizedBox spaceHorizontal;
  final Padding btnRegister;
  //final Padding btnAbout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        spaceHorizontal,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            btnRegister,
            //btnAbout,
          ],
        ),
      ],
    );
  }
}

class TopLoginImage extends StatelessWidget {
  const TopLoginImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logoapp.png',
      height: 250,
    );
  }
}
