import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/auth_failure.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});
  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _update() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent.updatePassword(newPassword: _passCtrl.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is PasswordUpdated) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(const SnackBar(content: Text('Password updated!')));
          const HomeRoute().go(ctx);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(
                state.failure.map(
                  serverError: (e) => e.message,
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) =>
                      'Invalid credentials',
                  weakPassword: (_) =>
                      'Password too weak — use at least 6 chars',
                  userNotFound: (_) => 'User not found',
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
        title: 'New password 🛡️',
        subtitle: 'Choose a strong password',
        canPop: false,
        child: Form(
          key: _formKey,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (ctx, state) {
              final loading = state is AuthLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthField(
                    controller: _passCtrl,
                    label: 'New password',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    enabled: !loading,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter a password';
                      if (v.length < 6) return 'At least 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AuthField(
                    controller: _confirmCtrl,
                    label: 'Confirm password',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _update(),
                    enabled: !loading,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Confirm your password';
                      }
                      if (v != _passCtrl.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: loading ? null : _update,
                    child: loading
                        ? const SmallSpinner()
                        : const Text('Update password'),
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
