import 'package:flutter/cupertino.dart';

import 'package:dailyvictory/providers/auth_provider.dart';

import 'package:dailyvictory/utils/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/auth/auth_wrapper.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        await ref.read(authProvider.notifier).signUp(
              _emailController.text,
              _passwordController.text,
              _displayNameController.text,
            );

        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
        requireAuth: false,
        child: CupertinoPageScaffold(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                    const SizedBox(height: 24),
                    // Logo and Welcome
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/dv-logo.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.activeBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Join DailyVictory today!',
                          style: TextStyle(
                            fontSize: 16,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Name Field
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey4.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CupertinoTextField(
                        controller: _displayNameController,
                        placeholder: 'Name',
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(CupertinoIcons.person,
                              color: CupertinoColors.systemGrey),
                        ),
                        decoration: null,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Email Field
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey4.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CupertinoTextField(
                        controller: _emailController,
                        placeholder: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(CupertinoIcons.mail,
                              color: CupertinoColors.systemGrey),
                        ),
                        decoration: null,
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Password Field
                    Container(
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: CupertinoColors.systemGrey4.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CupertinoTextField(
                        controller: _passwordController,
                        placeholder: 'Password',
                        obscureText: true,
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 12),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(CupertinoIcons.lock,
                              color: CupertinoColors.systemGrey),
                        ),
                        decoration: null,
                      ),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemRed.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                  CupertinoIcons.exclamationmark_triangle_fill,
                                  color: CupertinoColors.systemRed,
                                  size: 20),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                      color: CupertinoColors.systemRed,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 48,
                      child: CupertinoButton.filled(
                        borderRadius: BorderRadius.circular(12),
                        onPressed: _isLoading ? null : _handleSignup,
                        child: _isLoading
                            ? const CupertinoActivityIndicator()
                            : const Text('Sign Up',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?',
                            style: TextStyle(fontSize: 15)),
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, AppRoutes.login);
                          },
                          child: const Text('Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CupertinoColors.activeBlue)),
                        ),
                      ],
                    ),
                  ],
                    ),
                  ),
              ),
            ),
          ),
        ));
  }
}
