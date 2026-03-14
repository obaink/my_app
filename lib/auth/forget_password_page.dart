// lib/auth/forgot_password_page.dart
//
// A self-contained Flutter "Forgot Password" page for "CareBridge" (Orphanage Management).
// - Complete, compile-ready widget (no external packages required).
// - Responsive layout, email validation, loading simulation, and callbacks.
// - Replace `fakeSendResetEmail()` with real backend call to send password reset emails.

import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  // Optional callbacks so parent (router) can handle navigation after reset email is sent.
  final VoidCallback? onResetEmailSent;
  final VoidCallback? onGoToLogin;

  const ForgotPasswordPage({super.key, this.onResetEmailSent, this.onGoToLogin});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  String? _statusMessage;
  bool _isError = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<bool> fakeSendResetEmail({required String email}) async {
    // Simulate network delay and basic success/failure cases.
    await Future.delayed(const Duration(seconds: 2));
    // Simulate failure for a specific email to demonstrate error handling.
    if (email.toLowerCase() == 'unknown@example.com') return false;
    return true;
  }

  void _submit() async {
    setState(() {
      _statusMessage = null;
      _isError = false;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final email = _emailController.text.trim();
    final success = await fakeSendResetEmail(email: email);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      setState(() {
        _isError = false;
        _statusMessage = 'Password reset email sent. Please check your inbox.';
      });
      widget.onResetEmailSent?.call();
    } else {
      setState(() {
        _isError = true;
        _statusMessage = 'No account found with that email address.';
      });
    }
  }

  Widget _buildHeader(double width) {
    final isNarrow = width < 600;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: isNarrow ? 36 : 44,
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.lock_reset, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 12),
        Text(
          'CareBridge',
          style: TextStyle(
            fontSize: isNarrow ? 22 : 28,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Orphanage Management — Reset password',
          style: TextStyle(fontSize: isNarrow ? 12 : 14, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  InputDecoration _inputDecoration({required String label, String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isWide = width >= 900;
            final cardWidth = isWide
                ? 700.0
                : (width * 0.92).clamp(300.0, 700.0);

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: cardWidth,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 22,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHeader(width),
                        if (_statusMessage != null) ...[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: _isError
                                  ? Colors.red[50]
                                  : Colors.green[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isError
                                      ? Icons.error_outline
                                      : Icons.check_circle_outline,
                                  color: _isError
                                      ? Colors.redAccent
                                      : Colors.green,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _statusMessage!,
                                    style: TextStyle(
                                      color: _isError
                                          ? Colors.redAccent
                                          : Colors.green[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Enter the email associated with your account and we\'ll send instructions to reset your password.',
                                style: TextStyle(color: Colors.grey[700]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 14),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.done,
                                decoration: _inputDecoration(
                                  label: 'Email address',
                                  hint: 'Enter your email',
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  final email = v.trim();
                                  final emailRegex = RegExp(
                                    r'^[^@]+@[^@]+\.[^@]+',
                                  );
                                  if (!emailRegex.hasMatch(email)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => _submit(),
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Colors.deepPurple,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.2,
                                          ),
                                        )
                                      : const Text('Send reset email'),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed:
                                    widget.onGoToLogin ??
                                    () {
                                      Navigator.of(context).maybePop();
                                    },
                                child: const Text('Back to sign in'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
