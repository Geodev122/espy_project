import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:espy_core/espy_core.dart';
import '../../../theme/espy_theme.dart';
import '../../../viewmodels/token_package_view_model.dart';
import '../../../widgets/common/premium_button.dart';
import '../../../widgets/common/premium_card.dart';
import '../../../widgets/common/espy_scaffold.dart';

class TokenPackageScreen extends StatelessWidget {
  const TokenPackageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TokenPackageViewModel(context.read<EspyRepository>()),
      child: const _TokenPackageView(),
    );
  }
}

class _TokenPackageView extends StatefulWidget {
  const _TokenPackageView();

  @override
  State<_TokenPackageView> createState() => _TokenPackageViewState();
}

class _TokenPackageViewState extends State<_TokenPackageView> {
  UserRole? _filterRole;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    Provider.of<TokenPackageViewModel>(context, listen: false).listenToTokenPackages(targetRole: _filterRole);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TokenPackageViewModel>(context);

    return EspyScaffold(
      useCinematicBackground: false,
      appBar: AppBar(
        title: Text("TOKEN PACKAGE GOVERNANCE", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 14)),
        backgroundColor: Colors.white,
        foregroundColor: EspyTheme.navyDeep,
        actions: [
          _buildRoleFilter(),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ACTIVE ECONOMY PACKAGES", style: GoogleFonts.cinzel(fontWeight: FontWeight.w900, fontSize: 18)),
                    Text("Configuring the value exchange for Protocol services", style: GoogleFonts.lora(fontSize: 12, color: Colors.black45)),
                  ],
                ),
                PremiumButton(
                  label: "CREATE NEW PACKAGE",
                  onPressed: () => _showPackageDialog(context),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildPackageGrid(vm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleFilter() {
    return DropdownButton<UserRole?>(
      value: _filterRole,
      hint: const Text("FILTER BY ROLE"),
      underline: const SizedBox(),
      items: [
        const DropdownMenuItem(value: null, child: Text("ALL ROLES")),
        ...UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name.toUpperCase()))),
      ],
      onChanged: (val) {
        setState(() => _filterRole = val);
        _loadData();
      },
    );
  }

  Widget _buildPackageGrid(TokenPackageViewModel vm) {
    if (vm.packages.isEmpty) {
      return Center(child: Text("NO PACKAGES FOUND FOR THIS ROLE", style: GoogleFonts.lora(color: Colors.black26)));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.5,
      ),
      itemCount: vm.packages.length,
      itemBuilder: (context, index) {
        final pkg = vm.packages[index];
        return _buildPackageCard(pkg, vm);
      },
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> pkg, TokenPackageViewModel vm) {
    final bool isActive = pkg['isActive'] ?? true;
    return PremiumCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: EspyTheme.royalBlue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(pkg['targetRole'].toString().toUpperCase(), style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: EspyTheme.royalBlue)),
              ),
              Switch(
                value: isActive,
                onChanged: (val) => vm.togglePackageStatus(pkg['id'], pkg, val),
                activeColor: EspyTheme.gold,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(pkg['nameEn'].toString().toUpperCase(), style: GoogleFonts.montserrat(fontWeight: FontWeight.w900, fontSize: 16)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("TOKENS", style: GoogleFonts.montserrat(fontSize: 8, color: Colors.black38, fontWeight: FontWeight.bold)),
                  Text(pkg['tokenCount'].toString(), style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.gold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("PRICE", style: GoogleFonts.montserrat(fontSize: 8, color: Colors.black38, fontWeight: FontWeight.bold)),
                  Text("\$${pkg['price']}", style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w900, color: EspyTheme.navyDeep)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          PremiumButton(
            label: "EDIT PACKAGE",
            variant: PremiumButtonVariant.outline,
            fullWidth: true,
            onPressed: () => _showPackageDialog(context, existing: pkg),
          ),
        ],
      ),
    );
  }

  void _showPackageDialog(BuildContext context, {Map<String, dynamic>? existing}) {
    final id = TextEditingController(text: existing?['id']);
    final nameEn = TextEditingController(text: existing?['nameEn']);
    final tokenCount = TextEditingController(text: existing?['tokenCount']?.toString());
    final price = TextEditingController(text: existing?['price']?.toString());
    UserRole targetRole = existing != null ? UserRole.parse(existing['targetRole']) : UserRole.visitor;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(existing == null ? "CREATE TOKEN PACKAGE" : "EDIT PACKAGE"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (existing == null) TextField(controller: id, decoration: const InputDecoration(hintText: "Package ID (e.g. starter_LB)")),
                const SizedBox(height: 8),
                TextField(controller: nameEn, decoration: const InputDecoration(hintText: "Name (English)")),
                const SizedBox(height: 8),
                TextField(controller: tokenCount, decoration: const InputDecoration(hintText: "Token Count"), keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                TextField(controller: price, decoration: const InputDecoration(hintText: "Price (USD)"), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                DropdownButtonFormField<UserRole>(
                  value: targetRole,
                  items: UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.name.toUpperCase()))).toList(),
                  onChanged: (val) => setDialogState(() => targetRole = val!),
                  decoration: const InputDecoration(labelText: "TARGET ROLE"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<TokenPackageViewModel>(context, listen: false).upsertTokenPackage({
                  'id': id.text,
                  'nameEn': nameEn.text,
                  'tokenCount': int.tryParse(tokenCount.text) ?? 0,
                  'price': double.tryParse(price.text) ?? 0.0,
                  'targetRole': targetRole.name,
                  'isActive': true,
                });
                if (mounted) Navigator.pop(context);
              },
              child: const Text("SAVE"),
            ),
          ],
        ),
      ),
    );
  }
}
