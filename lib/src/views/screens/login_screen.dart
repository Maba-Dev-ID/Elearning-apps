import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms/src/features/auth/provider/auth_notifier.dart';
import 'package:lms/src/features/auth/provider/auth_state.dart';
import 'package:lms/src/views/components/snackbar_widget.dart';

import '../../core/style/theme.dart';
import '../components/form_input.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController usernameCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    usernameCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final state = ref.watch(authNotifierProvider).state;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        ListView(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg.png",
                ),
                fit: BoxFit.cover,
              )),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildHeader(),
                      const SizedBox(height: 15),
                      buildFormLogin(auth, state)
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }

  Column buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "E-learning",
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
        ),
        Text(
          "Layanan Digitalisasi Sekolah",
          style: TextStyle(fontSize: 16, color: Color(0xFF06283D)),
        ),
      ],
    );
  }

  Card buildFormLogin(AuthNotifier auth, AuthState state) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Selamat Datang",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              color: Color(0xff256D85),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextForm(
                      usernameCtrl,
                      "Masukkan Nim",
                      'Username',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Harap Isi Username";
                        }
                        return null;
                      },
                    ),
                    TextForm(
                      passCtrl,
                      'Masukkan Password',
                      "Password",
                      isObsecure: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Harap Isi Password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15),
                          backgroundColor: kGreenPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                            10,
                          ))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await auth.login(usernameCtrl.text, passCtrl.text);
                          if (state.isAuthenticated) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                buildSnackBar("Sukses Login", Colors.green));
                          }
                        } else {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              buildSnackBar("Gagal Login", Colors.red));
                        }
                      },
                      child: const Text("Masuk"),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}