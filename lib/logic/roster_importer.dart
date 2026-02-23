import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'promoter_provider.dart';
import '../data/models/wrestler.dart';

class RosterImporter {
  final WidgetRef ref;
  final BuildContext context;

  RosterImporter(this.ref, this.context);

  Future<void> pickAndImport() async {
    try {
      // 1. OPEN FILE PICKER
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        
        // 2. READ & PARSE JSON
        String content = await file.readAsString();
        Map<String, dynamic> data = jsonDecode(content);

        // 3. VALIDATE DATA
        if (!data.containsKey('roster') || data['roster'] is! List) {
          throw Exception("Invalid JSON format: Missing 'roster' list.");
        }

        List<dynamic> wrestlerList = data['roster'];
        List<Wrestler> newRoster = [];

        // 4. CONVERT JSON TO WRESTLER OBJECTS
        for (var item in wrestlerList) {
          final w = Wrestler()
            ..name = item['name'] ?? "Unknown"
            ..style = _parseStyle(item['style'])
            
            // STATS
            ..pop = (item['pop'] ?? 50)
            ..ringSkill = (item['ringSkill'] ?? 50)
            ..micSkill = (item['micSkill'] ?? 50)
            ..stamina = (item['stamina'] ?? 100)        // <--- NEW
            ..condition = (item['condition'] ?? 100)    // <--- NEW
            ..morale = (item['morale'] ?? 100)          // <--- NEW
            
            // CONTRACT
            ..salary = (item['salary'] ?? 500)
            ..contractWeeks = (item['contractWeeks'] ?? 12) // <--- NEW
            
            // STATUS
            ..isHeel = item['isHeel'] ?? false
            ..isChampion = item['isChampion'] ?? false
            ..isTVChampion = item['isTVChampion'] ?? false
            ..companyId = 0; // Set to Player's Company
            
          newRoster.add(w);
        }

        // 5. WIPE OLD SAVE & INJECT NEW UNIVERSE
        final notifier = ref.read(rosterProvider.notifier);
        
        // A. Clear current DB
        await notifier.clearDatabaseForImport(); 
        
        // B. Add new wrestlers
        await notifier.importWrestlers(newRoster);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("SUCCESS: Imported ${newRoster.length} wrestlers!"),
              backgroundColor: Colors.green,
            )
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  // UPDATED: Now supports all 8 styles
  WrestlingStyle _parseStyle(String? styleStr) {
    switch (styleStr?.toLowerCase()) {
      case 'highflyer': return WrestlingStyle.highFlyer;
      case 'technician': return WrestlingStyle.technician;
      case 'giant': return WrestlingStyle.giant;
      case 'entertainer': return WrestlingStyle.entertainer;
      case 'powerhouse': return WrestlingStyle.powerhouse; // <--- NEW
      case 'luchador': return WrestlingStyle.luchador;     // <--- NEW
      case 'hardcore': return WrestlingStyle.hardcore;     // <--- NEW
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
        actions: [
          TextButton(child: const Text("OK"), onPressed: () => Navigator.pop(ctx))
        ],
      ),
    );
  }
}