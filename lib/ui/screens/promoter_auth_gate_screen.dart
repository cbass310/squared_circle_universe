import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../modes/network/global_network_auth_screen.dart';

class PromoterAuthGateScreen extends StatelessWidget {
  const PromoterAuthGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.cyanAccent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.cloud_sync_rounded, size: 80, color: Colors.cyanAccent),
            const SizedBox(height: 24),
            const Text(
              "TAKE YOUR PROMOTION GLOBAL",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            _buildBenefitRow(Icons.leaderboard, "Compete on the Global Leaderboard"),
            const SizedBox(height: 16),
            _buildBenefitRow(Icons.save, "Secure Cloud Saves across devices"),
            const SizedBox(height: 16),
            _buildBenefitRow(Icons.shield, "Protect your roster from data loss"),

            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.login, color: Colors.black),
              label: const Text("SIGN IN / CREATE ACCOUNT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const GlobalNetworkAuthScreen()));
              },
            ),

            const SizedBox(height: 16),

            TextButton(
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Routing to Offline Promoter Mode... (Coming Soon)"), 
                  backgroundColor: Colors.grey
                ));
              },
              child: const Text(
                "Skip for now (Play Locally)",
                style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
