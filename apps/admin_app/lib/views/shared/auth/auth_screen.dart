import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'package:espy_app/theme/espy_theme.dart';
import 'package:espy_app/viewmodels/auth_service.dart';
import 'package:espy_app/widgets/common/premium_button.dart';
import 'package:espy_app/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  final String? initialRole;
  final bool isSignUpInitial;
  const AuthScreen({super.key, this.initialRole, this.isSignUpInitial = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _obscurePass = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EspyScaffold(
      useCinematicBackground: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBrandingZone(),
              const SizedBox(height: 32),
              _buildFormCard(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingZone() {
    return Column(
      children: [
        FadeIn(
          duration: const Duration(seconds: 2),
          child: Hero(
            tag: 'espy_icon',
            child: Image.asset(
              'assets/images/espy_icon.png',
              width: 80, height: 80, fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome_rounded, size: 60, color: EspyTheme.skyBlue),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ESPY ADMIN',
          style: EspyTheme.wordmarkStyle.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 10,
            color: Colors.white,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard(AppLocalizations l10n) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(children: [
              Text(l10n.theProtocol.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: EspyTheme.gold)),
              const SizedBox(height: 8),
              Text(l10n.accessPortal.toUpperCase(),
                  style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w800, color: EspyTheme.navyDeep, letterSpacing: 1), textAlign: TextAlign.center),
            ]),
            const SizedBox(height: 32),
            _buildTextField(
              controller: _emailController,
              hint: l10n.emailAddress.toUpperCase(),
              icon: Icons.mail_outline_rounded,
              autofillHint: AutofillHints.email,
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(l10n),
            const SizedBox(height: 24),
            PremiumButton(
              label: authService.isLoading ? l10n.syncing.toUpperCase() : l10n.secureLogin.toUpperCase(),
              isLoading: authService.isLoading,
              fullWidth: true,
              variant: PremiumButtonVariant.gold,
              icon: Icons.login_rounded,
              onPressed: _handleEmailAuth,
            ),
            const SizedBox(height: 24),
            Text(
              "FOR SECURITY REASONS, REGISTRATION IS DISABLED IN THIS ENVIRONMENT. ONLY AUTHORIZED ADMINISTRATORS MAY ACCESS THE PORTAL.",
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.black26, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon, required String autofillHint, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      autofillHints: [autofillHint],
      keyboardType: keyboardType,
      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500, color: EspyTheme.navyDeep),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20, color: EspyTheme.royalBlue.withValues(alpha: 0.5)),
        filled: true,
        fillColor: EspyTheme.platinum,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField(AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      autofillHints: const [AutofillHints.password],
      obscureText: _obscurePass,
      style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500, color: EspyTheme.navyDeep),
      decoration: InputDecoration(
        hintText: l10n.securePassword.toUpperCase(),
        prefixIcon: Icon(Icons.lock_outline_rounded, size: 20, color: EspyTheme.royalBlue.withValues(alpha: 0.5)),
        suffixIcon: IconButton(
          icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: EspyTheme.textSecondary),
          onPressed: () => setState(() => _obscurePass = !_obscurePass),
        ),
        filled: true,
        fillColor: EspyTheme.platinum,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Password required' : null,
    );
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmail(_emailController.text.trim(), _passwordController.text);
      if (mounted) {
        await authService.fetchUserData();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auth Error: $e'), backgroundColor: EspyTheme.error));
    }
  }
}
