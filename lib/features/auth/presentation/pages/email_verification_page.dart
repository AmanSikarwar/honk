import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/auth_failure.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_widgets.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key, required this.email});
  final String email;
  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  final _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  void _verify() {
    if (_otpCtrl.text.length == 8) {
      context.read<AuthBloc>().add(
        AuthEvent.verifyOtp(
          email: widget.email,
          token: _otpCtrl.text,
          type: 'signup',
        ),
      );
    }
  }

  void _resend() {
    context.read<AuthBloc>().add(
      AuthEvent.resendVerificationEmail(email: widget.email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, state) {
        if (state is Authenticated) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(const SnackBar(content: Text('Email verified!')));
        } else if (state is EmailVerificationRequired) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Verification email sent!')),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(
                state.failure.map(
                  serverError: (e) => e.message,
                  emailAlreadyInUse: (_) => 'Email already in use',
                  invalidEmailAndPasswordCombination: (_) => 'Invalid code',
                  weakPassword: (_) => 'Weak password',
                  userNotFound: (_) => 'User not found',
                  emailNotVerified: (_) => 'Verification failed',
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
        title: 'Check your email 📬',
        subtitle: 'Enter the 8-digit code we sent you',
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (ctx, state) {
            final loading = state is AuthLoading;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.statusPurpleBg,
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.email_outlined,
                        color: AppColors.brandPurple,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          widget.email,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: AppColors.brandPurple),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AuthField(
                  controller: _otpCtrl,
                  label: 'Verification code',
                  hint: '00000000',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _verify(),
                  enabled: !loading,
                  maxLength: 8,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 6,
                  ),
                  onChanged: (v) {
                    if (v.length == 8) _verify();
                  },
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: loading ? null : _verify,
                  child: loading ? const SmallSpinner() : const Text('Verify'),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive it? ",
                      style: Theme.of(ctx).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: loading ? null : _resend,
                      child: const Text('Resend'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          "Check your spam folder if you don't see the email.",
                          style: Theme.of(ctx).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
