import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/providers/auth_providers.dart';
import 'package:nice/features/auth/data/auth_state.dart';
import 'package:nice/features/auth/ui/profile_completion_screen.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  Timer? _resendTimer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });
    
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String _getOtpCode() {
    return _controllers.map((c) => c.text).join();
  }

  bool _isOtpComplete() {
    return _getOtpCode().length == 6;
  }

  Future<void> _verifyOtp() async {
    if (!_isOtpComplete()) return;

    final otp = _getOtpCode();
    await ref.read(authControllerProvider.notifier).verifyOtp(widget.email, otp);
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    await ref.read(authControllerProvider.notifier).resendOtp(widget.email);
    _startResendTimer();
    
    // Clear OTP fields
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    if (_isOtpComplete()) {
      _verifyOtp();
    }
  }

  void _onBackspace(int index) {
    if (index > 0 && _controllers[index].text.isEmpty) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        if (next.isNewUser) {
          // Navigate to profile completion
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const ProfileCompletionScreen(),
            ),
          );
        } else {
          // Navigate to main screen
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else if (next is OtpError) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${next.message}\nTentativas restantes: ${next.attemptsRemaining}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next is OtpLocked) {
        // Show lockout message
        final remaining = next.lockedUntil.difference(DateTime.now());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Muitas tentativas. Aguarde ${remaining.inMinutes} minutos.',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      } else if (next is OtpSent) {
        // Show resend confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Código reenviado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });

    final isLoading = authState is AuthLoading || authState is OtpVerifying;
    final isLocked = authState is OtpLocked;
    final attemptsExceeded = authState is OtpError && authState.attemptsRemaining == 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              const Text(
                'Verificação de Código',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              
              // Subtitle with email
              Text(
                'Digite o código enviado para\n${widget.email}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      enabled: !isLoading && !isLocked && !attemptsExceeded,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      onChanged: (value) => _onOtpChanged(value, index),
                      onTap: () {
                        _controllers[index].selection = TextSelection.fromPosition(
                          TextPosition(offset: _controllers[index].text.length),
                        );
                      },
                      onEditingComplete: () {
                        if (index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              
              // Resend Button
              if (!isLocked && !attemptsExceeded)
                TextButton(
                  onPressed: _canResend && !isLoading ? _resendOtp : null,
                  child: Text(
                    _canResend
                        ? 'Reenviar código'
                        : 'Reenviar código em $_resendCountdown s',
                    style: TextStyle(
                      fontSize: 16,
                      color: _canResend ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              
              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              
              const SizedBox(height: 16),
              
              // Info Text
              if (authState is OtpError && authState.attemptsRemaining > 0)
                Text(
                  'Tentativas restantes: ${authState.attemptsRemaining}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              if (attemptsExceeded)
                const Text(
                  'Limite de tentativas excedido.\nSolicite um novo código.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
