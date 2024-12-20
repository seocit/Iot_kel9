import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('sensor'); // Path ke data Firebase
  List<String> _dataList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _databaseReference.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        setState(() {
          _dataList = data.values.map((e) => e.toString()).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Data from Firebase'),
      backgroundColor: Colors.blueAccent,
    ),
    body: _dataList.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text(
                  "Loading data...",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _dataList.length,
            itemBuilder: (context, index) {
              final data = _dataList[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      data[0].toUpperCase(), // Huruf pertama dari data
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    data,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    "Detail of $data",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16,
                  ),
                  onTap: () {
                    // Tambahkan aksi saat item diklik
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Selected Item"),
                        content: Text("You selected $data."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
  );
}

  }
