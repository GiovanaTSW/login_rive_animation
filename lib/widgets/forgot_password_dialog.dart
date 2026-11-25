import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> showForgotPasswordDialog(BuildContext context) {
  final ctrl = TextEditingController();
  final messenger = ScaffoldMessenger.of(context);
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Recuperar contraseña'),
      content: TextField(
        controller: ctrl,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(hintText: 'Correo electrónico'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () async {
            final email = ctrl.text.trim();
            if (email.isEmpty) return;
            Navigator.pop(ctx);
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
            } catch (_) {
              // Mensaje genérico: no revelar si el correo existe (OWASP).
            }
            messenger.showSnackBar(const SnackBar(
              content: Text('Si el correo existe, recibirás un enlace.'),
            ));
          },
          child: const Text('Enviar'),
        ),
      ],
    ),
  );
}
