import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../logic/game_state_provider.dart';
import '../../../logic/promoter_provider.dart';

// 🚨 The exact path to the HubScreen based on your VS Code structure
import '../../screens/hub_screen.dart'; 

class BankruptcyScreen extends ConsumerStatefulWidget {
  const BankruptcyScreen({super.key});

  @override
  ConsumerState<BankruptcyScreen> createState() => _BankruptcyScreenState();
}

class _BankruptcyScreenState extends ConsumerState<BankruptcyScreen> {
  late final int finalWeeks;
  late final int finalDebt;
  late final int finalFans;
  late final String promoName;

  // 🚨 THE FIX: A state variable to change the button instead of a pop-up!
  bool _isWiping = false; 

  @override
  void initState() {
    super.initState();
    final gameState = ref.read(gameProvider);
    finalWeeks = gameState.week + ((gameState.year - 1) * 52);
    finalDebt = gameState.cash;
    finalFans = gameState.fans;
    promoName = gameState.promotionName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet_rounded, color: Colors.redAccent, size: 80),
              const SizedBox(height: 20),
              const Text(
                "BANKRUPT!",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.redAccent, letterSpacing: 2.0),
              ),
              const SizedBox(height: 10),
              Text(
                "The Board of Directors at $promoName has officially relieved you of your duties due to gross financial mismanagement.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    const Text("FINAL LEDGER", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    const Divider(color: Colors.white24, height: 30),
                    _buildStatRow("Weeks Survived:", "$finalWeeks"),
                    const SizedBox(height: 10),
                    _buildStatRow("Final Debt:", "\$$finalDebt"),
                    const SizedBox(height: 10),
                    _buildStatRow("Total Fans:", "$finalFans"),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // 🚨 THE FIX: The dynamic, safe button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  icon: _isWiping 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3))
                      : const Icon(Icons.refresh, color: Colors.black),
                  label: Text(
                    _isWiping ? "LIQUIDATING ASSETS..." : "START NEW PROMOTION", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1.0)
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    disabledBackgroundColor: Colors.amber.shade700,
                  ),
                  // Disable the button while it is wiping so it can't be clicked twice
                  onPressed: _isWiping ? null : () async {
                    HapticFeedback.heavyImpact();

                    // 1. Tell the UI to turn the button into a loading spinner
                    setState(() {
                      _isWiping = true;
                    });

                    // 2. Give the UI a half-second to update before we freeze the CPU doing database math
                    await Future.delayed(const Duration(milliseconds: 500));

                    // 3. Safely wipe the universe
                    try {
                      await ref.read(gameProvider.notifier).resetGame();
                      await ref.read(rosterProvider.notifier).factoryReset();
                    } catch (e) {
                      debugPrint("Safe Fail during reset: $e");
                    }

                    // 4. Push directly to the Hub Screen
                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HubScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}