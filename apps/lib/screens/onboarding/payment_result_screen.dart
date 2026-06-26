import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme.dart';
import '../../widgets/common/premium_button.dart';
import '../../widgets/common/cinematic_background.dart';

class PaymentResultScreen extends StatelessWidget {
  final String status; // 'success', 'failed', 'pending'
  
  const PaymentResultScreen({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = status == 'success';
    
    return Scaffold(
      body: CinematicBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeInDown(
                  child: Icon(
                    isSuccess ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
                    size: 80,
                    color: isSuccess ? EspyTheme.teal : EspyTheme.error,
                  ),
                ),
                const SizedBox(height: 32),
                FadeInUp(
                  child: Text(
                    isSuccess ? 'PROTOCOL ACTIVATED' : 'FUNDING FAILED',
                    style: GoogleFonts.cinzel(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: EspyTheme.platinum,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    isSuccess
                      ? 'Your tokens have been credited to your Espy Wallet.'
                      : 'The transaction was unsuccessful. You can retry from your wallet.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lora(
                      fontSize: 14,
                      color: EspyTheme.platinum.withValues(alpha: 0.7),
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                FadeInUp(
                  delay: const Duration(milliseconds: 400),
                  child: PremiumButton(
                    label: isSuccess ? 'ENTER WALLET' : 'RETRY PROTOCOL',
                    fullWidth: true,
                    onPressed: () {
                      // Navigate to dashboard or re-trigger wizard
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
