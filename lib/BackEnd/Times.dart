import 'package:shared_preferences/shared_preferences.dart';

class ResumeTime {
  static void setResumeTime(String vid, int time) async {
    SharedPreferences sher = await SharedPreferences.getInstance();
    await sher.setInt(vid, time);
  }

  static Future<int?> getResumeTimeInSecond(String vid) async {
    SharedPreferences sher = await SharedPreferences.getInstance();
    return sher.getInt(vid);
  }
}
