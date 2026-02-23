import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/auth_failure.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _send() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent.sendPasswordResetEmail(email: _emailCtrl.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is PasswordResetEmailSent) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Reset link sent! Check your inbox.')),
          );
          Navigator.of(ctx).pop();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(
                state.failure.map(
                  serverError: (e) => e.message,
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) => 'Invalid email',
                  weakPassword: (_) => 'Weak password',
                  userNotFound: (_) => 'No account found',
                  emailNotVerified: (_) => 'Email not verified',
                  tooManyRequests: (_) => 'Too many attempts',
                  networkError: (_) => 'No internet connection',
                  cancelledByUser: (_) => 'Cancelled',
                  unknown: (e) => e.message,
                ),
              ),
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
          );
        }
      },
      child: AuthScaffold(
        title: 'Reset password 🔑',
        subtitle: "We'll email you a reset link",
        child: Form(
          key: _formKey,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (ctx, state) {
              final loading = state is AuthLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  AuthField(
                    controller: _emailCtrl,
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _send(),
                    enabled: !loading,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter your email';
                      if (!RegExp(
                        r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(v)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: loading ? null : _send,
                    child: loading
                        ? const SmallSpinner()
                        : const Text('Send reset link'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
