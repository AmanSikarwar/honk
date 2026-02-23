import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/auth_failure.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _signIn() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthEvent.signInWithEmailAndPassword(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        ),
      );
    }
  }

  void _signInWithGoogle() =>
      context.read<AuthBloc>().add(const AuthEvent.signInWithGoogle());

  String _errorMsg(AuthFailure f) => f.map(
    serverError: (e) => e.message,
    emailAlreadyInUse: (_) => 'This email is already registered',
    invalidEmailAndPasswordCombination: (_) => 'Invalid email or password',
    weakPassword: (_) => 'Password is too weak',
    userNotFound: (_) => 'No account with that email',
    emailNotVerified: (_) => 'Please verify your email first',
    tooManyRequests: (_) => 'Too many attempts — try again later',
    networkError: (_) => 'No internet connection',
    cancelledByUser: (_) => 'Sign-in cancelled',
    unknown: (e) => e.message,
  );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(_errorMsg(state.failure)),
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
          );
        } else if (state is EmailVerificationRequired) {
          EmailVerificationRoute(email: state.email).push(ctx);
        }
      },
      child: AuthScaffold(
        title: 'Welcome back 👋',
        subtitle: 'Sign in to stay in sync',
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
                    controller: _emailCtrl,
                    label: 'Email',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !loading,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AuthField(
                    controller: _passCtrl,
                    label: 'Password',
                    prefixIcon: Icons.lock_outlined,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _signIn(),
                    enabled: !loading,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter your password' : null,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: loading
                          ? null
                          : () => const ForgotPasswordRoute().push(ctx),
                      child: const Text('Forgot password?'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  FilledButton(
                    onPressed: loading ? null : _signIn,
                    child: loading
                        ? const SmallSpinner()
                        : const Text('Sign in'),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const OrDivider(),
                  const SizedBox(height: AppSpacing.lg),
                  GoogleSignInButton(
                    onPressed: _signInWithGoogle,
                    enabled: !loading,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(ctx).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () => const SignUpRoute().push(ctx),
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'Enter your email';
    if (!RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
      return 'Enter a valid email';
    }
    return null;
  }
}
