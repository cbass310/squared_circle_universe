import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'promoter_provider.dart';
import 'game_state_provider.dart'; 
import '../data/models/wrestler.dart';

class RosterImporter {
  final WidgetRef ref;
  final BuildContext context;

  RosterImporter(this.ref, this.context);

  // 📂 1. THE ORIGINAL LOCAL FILE PICKER (For testing/PC players)
  Future<void> pickAndImport() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        await _processJson(content);
      }
    } catch (e) {
      if (context.mounted) _showErrorDialog(e.toString());
    }
  }

  // ☁️ 2. THE NEW CLOUD INJECTOR (For the Community Hub)
  Future<void> importFromCloud(Map<String, dynamic> jsonMap) async {
    try {
      // Convert the JSON map back to a string so it passes through our standard processor
      String content = jsonEncode(jsonMap);
      await _processJson(content);
    } catch (e) {
      if (context.mounted) _showErrorDialog("Cloud Import Failed: ${e.toString()}");
    }
  }

  // ⚙️ THE MASTER PROCESSING ENGINE
  Future<void> _processJson(String content) async {
    Map<String, dynamic> data = jsonDecode(content);

    if (!data.containsKey('roster') || data['roster'] is! List) {
      throw Exception("Invalid JSON format: Missing 'roster' list.");
    }

    // 🚨 1. WIPE THE GAME CLEAN FIRST
    final gameNotifier = ref.read(gameProvider.notifier);
    await gameNotifier.resetGame();

    // 🚨 2. APPLY PROMOTION OVERRIDES FROM THE MOD
    if (data.containsKey('promotion')) {
      var promoData = data['promotion'];
      if (promoData['promotionName'] != null) {
        gameNotifier.renamePromotion(promoData['promotionName']);
      }
      if (promoData['tvShowName'] != null) {
        gameNotifier.renameTVShow(promoData['tvShowName']);
      }
    }

    // 🚨 3. PROCESS THE WRESTLERS
    List<dynamic> wrestlerList = data['roster'];
    List<Wrestler> newRoster = [];

    for (var item in wrestlerList) {
      final w = Wrestler()
        ..name = item['name'] ?? "Unknown Worker"
        ..imagePath = item['imagePath'] ?? item['imageUrl'] ?? "assets/images/default_avatar.png" 
        ..style = _parseStyle(item['style'])
        ..pop = (item['pop'] ?? 50)
        ..ringSkill = (item['ringSkill'] ?? 50)
        ..micSkill = (item['micSkill'] ?? 50)
        ..popPotential = (item['popPotential'] ?? 99)
        ..stamina = (item['stamina'] ?? 100)        
        ..condition = (item['condition'] ?? 100)    
        ..morale = (item['morale'] ?? 100)          
        ..salary = (item['salary'] ?? 500)
        ..contractWeeks = (item['contractWeeks'] ?? 48)
        ..isHeel = item['isHeel'] ?? false
        ..greed = (item['greed'] ?? 50)
        ..loyalty = (item['loyalty'] ?? 50)
        ..gimmickStaleness = (item['gimmickStaleness'] ?? 0) // 🚨 STALE GIMMICK MECHANIC
        ..isChampion = item['isChampion'] ?? false
        ..isTVChampion = item['isTVChampion'] ?? false
        ..companyId = (item['companyId'] ?? -1); // Default to Free Agent (-1) if not specified!
        
      newRoster.add(w);
    }

    final notifier = ref.read(rosterProvider.notifier);
    await notifier.clearDatabaseForImport(); 
    await notifier.importWrestlers(newRoster);

    if (context.mounted) {
      String modName = data['mod_name'] ?? 'Custom Roster';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("SUCCESS: '$modName' Installed!"),
          backgroundColor: Colors.greenAccent,
          duration: const Duration(seconds: 4),
        )
      );
    }
  }

  WrestlingStyle _parseStyle(String? styleStr) {
    switch (styleStr?.toLowerCase()) {
      case 'highflyer': return WrestlingStyle.highFlyer;
      case 'technician': return WrestlingStyle.technician;
      case 'giant': return WrestlingStyle.giant;
      case 'entertainer': return WrestlingStyle.entertainer;
      case 'powerhouse': return WrestlingStyle.powerhouse; 
      case 'luchador': return WrestlingStyle.luchador;     
      case 'hardcore': return WrestlingStyle.hardcore;     
      default: return WrestlingStyle.brawler;
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Import Failed", style: TextStyle(color: Colors.red)),
        content: Text(error, style: const TextStyle(color: Colors.white)),
        actions: [TextButton(child: const Text("OK"), onPressed: () => Navigator.pop(ctx))],
      ),
    );
  }
}