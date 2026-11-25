import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../theme/ct_theme.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  static final _passRe =
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$');

  String? _validateEmail(String? v) {
    final e = (v ?? '').trim().toLowerCase();
    if (e.isEmpty) return 'El correo es obligatorio';
    if (!RegExp(r'^[^\s@]+@tecdesoftware\.edu\.mx$').hasMatch(e)) {
      return 'Debe terminar en @tecdesoftware.edu.mx';
    }
    return null;
  }

  String? _validatePass(String? v) => _passRe.hasMatch(v ?? '')
      ? null
      : 'Mín. 8 caracteres con mayúscula, minúscula, número y símbolo';

  String? _validateConfirm(String? v) =>
      v == _pass.text ? null : 'Las contraseñas no coinciden';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim().toLowerCase(),
        password: _pass.text,
      );
      // createUser inicia sesión automáticamente: cerrarla y volver al login.
      await FirebaseAuth.instance.signOut();
      messenger.showSnackBar(
        const SnackBar(content: Text('Cuenta creada. Inicia sesión.')),
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      final msg = e.code == 'email-already-in-use'
          ? 'Ese correo ya está registrado'
          : 'No se pudo crear la cuenta';
      messenger.showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
              decoration: const InputDecoration(
                hintText: 'correo@tecdesoftware.edu.mx',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _pass,
              obscureText: true,
              validator: _validatePass,
              decoration: const InputDecoration(
                hintText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 6),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '• 8+ caracteres  • Mayúscula  • Minúscula  • Número  • Símbolo',
                style: TextStyle(fontSize: 12, color: CT.midnight),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirm,
              obscureText: true,
              validator: _validateConfirm,
              decoration: const InputDecoration(
                hintText: 'Confirmar contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Registrarme'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
