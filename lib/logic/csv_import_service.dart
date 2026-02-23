import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CsvImportService {
  
  // The magic function that handles the entire upload process
  static Future<void> importRosterCSV(String leagueId) async {
    try {
      // 1. Open the Windows File Explorer to let the Commissioner pick the roster
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      // If they hit 'Cancel' on the file explorer, gracefully exit
      if (result == null || result.files.single.path == null) {
        print("Commissioner canceled the file picker.");
        return;
      }

      // 2. Read the file off the Windows hard drive
      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();

      // 3. Parse the raw text into a neat list of rows and columns
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString);

      // If the file is empty or only has the title row, stop.
      if (csvTable.length <= 1) {
        print("Error: CSV is empty or only has a header row.");
        return;
      }

      // 4. Map the spreadsheet data to match our Supabase Cloud Table
      List<Map<String, dynamic>> wrestlersToInsert = [];

      // We start the loop at '1' to skip the Title row (Name, Promotion, etc.)
      for (int i = 1; i < csvTable.length; i++) {
        final row = csvTable[i];
        
        // Safety check: ensure the row has all 4 columns before parsing
        if (row.length >= 4) {
          wrestlersToInsert.add({
            'league_id': leagueId,
            'name': row[0].toString().trim(),
            'promotion': row[1].toString().trim(),
            'faction': row[2].toString().trim(),
            // If popularity is missing, default it to 50
            'popularity': int.tryParse(row[3].toString()) ?? 50, 
          });
        }
      }

      // 5. The Batch Upload (Fires the whole roster to the cloud in one shot)
      print("Uploading ${wrestlersToInsert.length} wrestlers to the Global Network...");
      
      await Supabase.instance.client.from('wrestlers').insert(wrestlersToInsert);
      
      print("Upload complete! 🚀 The Roster is live.");

    } catch (e) {
      print("System Error parsing CSV: $e");
    }
  }
}