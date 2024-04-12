import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  _StackedNotificationsState createState() => _StackedNotificationsState();
}

class _StackedNotificationsState extends State<Alert> {
  List<String> notifications = [];

  void addNotification(String message) {
    setState(() {
      notifications.add(message);
    });
  }

  void removeNotification() {
    setState(() {
      if (notifications.isNotEmpty) {
        notifications.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('ALERTS'),
        backgroundColor: Colors.blueAccent,
           elevation: 20,
      ),
      body: Stack(
        children: [
          // Main content of the page
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 113, 182, 239),
                padding: const EdgeInsets.all(15),
              ),
              onPressed: () {
                addNotification("New notification added!");
              },
              child: Text('Add Notification',
                  style: TextStyle(color: Colors.white)),
            ),
          ),
          // Stacked notifications
          Positioned(
            top: 50.0,
            right: 10.0,
            left: 10.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: notifications.map((message) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Card(
                    elevation: 3.0,
                    child: ListTile(
                      title: Text(message),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          removeNotification();
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Alert(),
  ));
}
