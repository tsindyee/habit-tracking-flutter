import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool notificationsEnabled = false;
  List<String> selectedHabits = [];
  List<String> selectedTimes = [];
  Map<String, String> allHabitsMap = {};

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadData();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
      allHabitsMap = Map<String, String>.from(
          jsonDecode(prefs.getString('selectedHabitsMap') ?? '{}'));
      selectedHabits = prefs.getStringList('notificationHabits') ?? [];
      selectedTimes = prefs.getStringList('notificationTimes') ?? [];
    });
  }

  Future<void> _saveNotificationSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setStringList('notificationHabits', selectedHabits);
    await prefs.setStringList('notificationTimes', selectedTimes);
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  void _sendTestNotification() {
    if (html.Notification.permission != "granted") {
      html.Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          html.Notification("Habit Reminder",
              body: "It's time to work on your habits!");
          print('Notification permission granted. Notification sent.');
        } else {
          print('Notification permission denied.');
        }
      });
    } else {
      html.Notification("Habit Reminder",
          body: "It's time to work on your habits!");
      print('Notification sent directly.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text('Notifications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text('Enable Notifications'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
                _saveNotificationSettings();
              },
            ),
            Divider(),
            Text(
              'Select Habits for Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: allHabitsMap.entries.map((entry) {
                final habit = entry.key;
                final colorHex = entry.value;
                final color = _getColorFromHex(colorHex);
                return FilterChip(
                  label: Text(habit),
                  labelStyle: TextStyle(color: color),
                  selected: selectedHabits.contains(habit),
                  selectedColor: color.withOpacity(0.3),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: color, width: 2.0),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedHabits.add(habit);
                      } else {
                        selectedHabits.remove(habit);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Select Times for Notification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: ['Morning', 'Afternoon', 'Evening'].map((time) {
                return FilterChip(
                  label: Text(time),
                  selected: selectedTimes.contains(time),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTimes.add(time);
                      } else {
                        selectedTimes.remove(time);
                      }
                    });
                    _saveNotificationSettings();
                  },
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                _sendTestNotification();
              },
              child: Text('Send Test Notification'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
