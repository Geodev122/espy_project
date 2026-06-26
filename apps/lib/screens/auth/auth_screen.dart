// ─────────────────────────────────────────────────────────────────────────────
// Espy — AuthScreen
// Blue Flame identity · Hope, Healing, Humanity
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../core/theme.dart';
import 'package:shared_core/services/auth_service.dart';
import '../../widgets/common/premium_button.dart';
import '../../l10n/app_localizations.dart';

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

  late final AnimationController _cardCtrl;
  late final Animation<Offset> _cardSlide;
  late final Animation<double> _cardFade;

  @override
  void initState() {
    super.initState();
    _isSignUp = widget.isSignUpInitial;
    _cardCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    _cardSlide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOutCubic));
    _cardFade = CurvedAnimation(parent: _cardCtrl, curve: Curves.easeOut);
    Future.delayed(const Duration(milliseconds: 80), _cardCtrl.forward);
  }

  @override
  void dispose() {
    _cardCtrl.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: const BoxDecoration(
          gradient: EspyTheme.backgroundGradient,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.25), borderRadius: BorderRadius.circular(2)),
              ),
              if (!isKeyboardOpen) _buildBrandingZone(),
              Flexible(
                child: SlideTransition(
                  position: _cardSlide,
                  child: FadeTransition(
                    opacity: _cardFade,
                    child: _buildFormCard(l10n),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingZone() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: FadeInDown(
        duration: const Duration(milliseconds: 400),
        child: Column(
          children: [
            FadeIn(
              duration: const Duration(seconds: 2),
              child: Hero(
                tag: 'espy_icon',
                child: Image.asset(
                  'assets/images/espy_icon.png',
                  width: 52, height: 52, fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.auto_awesome_rounded, size: 36, color: EspyTheme.skyBlue),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'ESPY',
              style: EspyTheme.wordmarkStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: Colors.white,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'HOPE, HEALING, HUMANITY',
              style: EspyTheme.taglineStyle.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: EspyTheme.textOnDarkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard(AppLocalizations l10n) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      decoration: EspyTheme.cardDecoration,
      // Constraints ensure the sheet doesn't disappear on transition
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          0, 24, 0, 
          MediaQuery.of(context).viewInsets.bottom + 32
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 32, height: 3,
                  decoration: BoxDecoration(gradient: EspyTheme.metallicGold, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 24),
              _buildCardHeader(l10n),
              const SizedBox(height: 28),
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOut,
                child: Column(
                  children: [
                    if (_isSignUp) ...[
                      _buildRoleSelector(l10n),
                      const SizedBox(height: 20),
                      // Username field for Chrome/Password Manager accessibility
                      const Offstage(
                        child: TextField(
                          autofillHints: [AutofillHints.username],
                          decoration: InputDecoration(hintText: 'Username'),
                        ),
                      ),
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
                    ] else ...[
                       // Username field for Chrome/Password Manager accessibility
                       const Offstage(
                         child: TextField(
                           autofillHints: [AutofillHints.username],
                           decoration: InputDecoration(hintText: 'Username'),
                         ),
                       ),
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
                    onPressed: () {},
                    style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(vertical: 8)),
                    child: Text('Forgot password?', style: GoogleFonts.montserrat(fontSize: 11, fontWeight: FontWeight.w600, color: EspyTheme.royalBlue)),
                  ),
                ),
              ],
              const SizedBox(height: 16),
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
              const SizedBox(height: 12),
              PremiumButton(
                label: l10n.continueWithGoogle.toUpperCase(),
                isLoading: authService.isLoading,
                fullWidth: true,
                variant: PremiumButtonVariant.platinum,
                icon: Icons.g_mobiledata_rounded,
                onPressed: _onGoogleSignIn,
              ),
              const SizedBox(height: 24),
              _buildToggleRow(l10n),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(AppLocalizations l10n) {
    return Column(children: [
      Text(l10n.theProtocol.toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 2, color: EspyTheme.gold)),
      const SizedBox(height: 8),
      Text((_isSignUp ? l10n.createIdentity : l10n.accessPortal).toUpperCase(),
          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w800, color: EspyTheme.navyDeep, letterSpacing: 1), textAlign: TextAlign.center),
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
          border: Border.all(color: isActive ? EspyTheme.royalBlue : EspyTheme.skyBlue.withValues(alpha: 0.3)),
          boxShadow: isActive ? [BoxShadow(color: EspyTheme.royalBlue.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : null,
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
        prefixIcon: Icon(icon, size: 20, color: EspyTheme.royalBlue.withValues(alpha: 0.5)),
        filled: true,
        fillColor: EspyTheme.platinum,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: EspyTheme.skyBlue.withValues(alpha: 0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: EspyTheme.royalBlue, width: 1.5)),
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
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: EspyTheme.skyBlue.withValues(alpha: 0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: EspyTheme.royalBlue, width: 1.5)),
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
          style: GoogleFonts.lora(fontSize: 13, color: EspyTheme.textSecondary),
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
      final credential = _isSignUp
          ? await authService.signUpWithEmail(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
              initialRole: _selectedRole,
              redemptionCode: _redemptionCodeController.text.trim(),
            )
          : await authService.signInWithEmail(
              _emailController.text.trim(),
              _passwordController.text);
      
      if (credential != null && mounted) {
        // Critical: Wait for user data to be fully loaded before popping
        // This ensures MainGate is ready to show the next screen immediately
        await authService.fetchUserData();
        
        if (mounted) {
          // Force close any keyboard
          FocusScope.of(context).unfocus();
          
          // Use a robust closing sequence
          await Future.delayed(const Duration(milliseconds: 400));
          if (mounted) {
             // Use rootNavigator: true to ensure the bottom sheet itself is popped
             Navigator.of(context, rootNavigator: true).pop(true);
             
             // Extra safety for PWA/Redirection
             debugPrint("Auth success: Redirection triggered.");
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Auth Error: $e'),
          backgroundColor: EspyTheme.error,
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }

  Future<void> _onGoogleSignIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      final credential = await authService.signInWithGoogle(initialRole: _isSignUp ? _selectedRole : null);
      if (credential != null && mounted) {
        await authService.fetchUserData();
        if (mounted) {
          FocusScope.of(context).unfocus();
          await Future.delayed(const Duration(milliseconds: 400));
          if (mounted) {
             Navigator.of(context, rootNavigator: true).pop(true);
             debugPrint("Google Auth success: Redirection triggered.");
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Error: $e'),
          backgroundColor: EspyTheme.error,
          behavior: SnackBarBehavior.floating,
        )
      );
    }
  }
}
