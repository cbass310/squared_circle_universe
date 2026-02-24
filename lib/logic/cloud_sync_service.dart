import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CloudSyncService {
  static Future syncScoreToCloud({
    required String promotionName,
    required int cash,
    required int fans,
    required int rep,
  }) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      // If not logged in (playing purely offline), silently return
      if (user == null) return;
      // Calculate the master Tycoon Score
      final int totalScore = cash + (fans * 10) + (rep * 100);
      // Upsert pushes a new row or overwrites the existing one based on the unique user_id
      await supabase.from('promoter_scores').upsert({
        'user_id': user.id,
        'promotion_name': promotionName.trim().isEmpty ? "SCW" : promotionName.trim(),
        'score': totalScore,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'user_id');
      debugPrint("Cloud Sync Successful: ${totalScore} pts");
    } catch (e) {
      debugPrint("Cloud Sync Error: ${e}");
    }
  }
}
