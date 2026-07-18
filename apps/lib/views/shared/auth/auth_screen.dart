import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import 'package:shared_core/theme/espy_theme.dart';
import 'package:shared_core/services/auth_service.dart';
import 'package:shared_core/widgets/common/premium_button.dart';
import 'package:shared_core/widgets/common/espy_scaffold.dart';
import 'package:espy_app/l10n/app_localizations.dart';

class AuthScreen extends StatefulWidget {
  final String? initialRole;
  final bool isSignUpInitial;
  const AuthScreen({super.key, this.initialRole, this.isSignUpInitial = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late bool _isSignUp;
  bool _obscurePass = true;
  String _selectedRole = 'professional';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _redemptionCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isSignUpInitial;
    if (widget.initialRole != null) {
      _selectedRole = widget.initialRole!;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _redemptionCodeController.dispose();
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
          'ESPY',
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCardHeader(l10n),
            const SizedBox(height: 32),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  if (_isSignUp) ...[
                    _buildRoleSelector(l10n),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _nameController,
                      hint: l10n.legalFullName.toUpperCase(),
                      icon: Icons.person_outline_rounded,
                      autofillHint: AutofillHints.name,
                      validator: (v) => (v == null || v.isEmpty) ? 'Name required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _redemptionCodeController,
                      hint: 'REDEMPTION CODE (OPTIONAL)',
                      icon: Icons.qr_code_rounded,
                      autofillHint: '',
                    ),
                    const SizedBox(height: 16),
                  ],
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
                ],
              ),
            ),
            if (!_isSignUp) ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.passwordResetSent), backgroundColor: EspyTheme.royalBlue)
                    );
                  },
                  child: Text(l10n.forgotPassword, style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w600, color: EspyTheme.royalBlue)),
                ),
              ),
            ],
            const SizedBox(height: 24),
            PremiumButton(
              label: authService.isLoading
                  ? l10n.syncing.toUpperCase()
                  : (_isSignUp ? l10n.initializeAccount.toUpperCase() : l10n.secureLogin.toUpperCase()),
              isLoading: authService.isLoading,
              fullWidth: true,
              variant: PremiumButtonVariant.gold,
              icon: _isSignUp ? Icons.person_add_outlined : Icons.login_rounded,
              onPressed: _handleEmailAuth,
            ),
            const SizedBox(height: 16),
            PremiumButton(
              label: l10n.continueWithGoogle.toUpperCase(),
              isLoading: authService.isLoading,
              fullWidth: true,
              variant: PremiumButtonVariant.platinum,
              icon: Icons.g_mobiledata_rounded,
              onPressed: _onGoogleSignIn,
            ),
            const SizedBox(height: 32),
            _buildToggleRow(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader(AppLocalizations l10n) {
    return Column(children: [
      Text(l10n.theProtocol.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: EspyTheme.gold)),
      const SizedBox(height: 8),
      Text((_isSignUp ? l10n.createIdentity : l10n.accessPortal).toUpperCase(),
          style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w800, color: EspyTheme.navyDeep, letterSpacing: 1), textAlign: TextAlign.center),
    ]);
  }

  Widget _buildRoleSelector(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.registeringAs.toUpperCase(), 
          style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, color: EspyTheme.royalBlue, letterSpacing: 1)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _roleToggleItem(
                label: l10n.professional.toUpperCase(),
                isActive: _selectedRole == 'professional',
                onTap: () => setState(() => _selectedRole = 'professional'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _roleToggleItem(
                label: l10n.institution.toUpperCase(),
                isActive: _selectedRole == 'institution',
                onTap: () => setState(() => _selectedRole = 'institution'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _roleToggleItem({required String label, required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? EspyTheme.royalBlue : EspyTheme.platinum,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? EspyTheme.royalBlue : EspyTheme.skyBlue.withOpacity(0.3)),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: isActive ? Colors.white : EspyTheme.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
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
        prefixIcon: Icon(icon, size: 20, color: EspyTheme.royalBlue.withOpacity(0.5)),
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
        prefixIcon: Icon(Icons.lock_outline_rounded, size: 20, color: EspyTheme.royalBlue.withOpacity(0.5)),
        suffixIcon: IconButton(
          icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: EspyTheme.textSecondary),
          onPressed: () => setState(() => _obscurePass = !_obscurePass),
        ),
        filled: true,
        fillColor: EspyTheme.platinum,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      validator: (v) => (v == null || v.length < 6) ? 'Minimum 6 characters' : null,
    );
  }

  Widget _buildToggleRow(AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => setState(() { _isSignUp = !_isSignUp; _formKey.currentState?.reset(); }),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.montserrat(fontSize: 13, color: EspyTheme.textSecondary, fontWeight: FontWeight.w500),
          children: [
            TextSpan(text: _isSignUp ? '${l10n.alreadyPartOfNetwork} ' : '${l10n.newToProtocol} '),
            TextSpan(
              text: _isSignUp ? l10n.login.toUpperCase() : l10n.register.toUpperCase(),
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w800, color: EspyTheme.gold, letterSpacing: 1),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      if (_isSignUp) {
        await authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          initialRole: _selectedRole,
          redemptionCode: _redemptionCodeController.text.trim(),
        );
      } else {
        await authService.signInWithEmail(_emailController.text.trim(), _passwordController.text);
      }
      
      if (mounted) {
        await authService.fetchUserData();
        if (mounted && authService.user != null) {
          // Success: Auth state will trigger MainGate update
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Auth Error: $e'), backgroundColor: EspyTheme.error));
    }
  }

  Future<void> _onGoogleSignIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithGoogle(initialRole: _isSignUp ? _selectedRole : null);
      if (mounted) {
        await authService.fetchUserData();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Error: $e'), backgroundColor: EspyTheme.error));
    }
  }
}
