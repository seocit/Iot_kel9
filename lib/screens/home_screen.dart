import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('sensor'); // Path ke Firebase
  double _sensorValue = 0.0; // Nilai sensor
  bool _isLoading = true; // Status loading

  @override
  void initState() {
    super.initState();
    _fetchSensorData();
  }

  // Fungsi untuk mengambil data sensor dari Firebase
  void _fetchSensorData() {
    _databaseReference.child('jarak').onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        setState(() {
          _sensorValue = double.tryParse(data.toString()) ?? 0.0;
          _isLoading = false; // Data berhasil dimuat
        });
      } else {
        setState(() {
          _sensorValue = 0.0;
          _isLoading = false; // Data kosong
        });
      }
    }, onError: (error) {
      setState(() {
        _isLoading = false; // Jika terjadi error
      });
      print('Error fetching data: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ketinggian Air',
          textAlign: TextAlign.center,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Indikator loading
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ketinggian Air (cm):",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: CircularProgressIndicator(
                          value: _normalizeSensorValue(_sensorValue), // Nilai normalisasi (0-1)
                          strokeWidth: 12,
                          backgroundColor: Colors.grey[300],
                          color: _getIndicatorColor(_sensorValue), // Warna indikator
                        ),
                      ),
                      Text(
                        "${_sensorValue.toStringAsFixed(1)} cm",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Status:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _getStatusText(_sensorValue),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _getIndicatorColor(_sensorValue),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // Normalisasi nilai sensor (0 - 1) untuk progress bar
  double _normalizeSensorValue(double value) {
    const double maxDistance = 100.0; // Maksimum nilai jarak (cm)
    return (value / maxDistance).clamp(0.0, 1.0);
  }

  // Menentukan warna indikator berdasarkan nilai
  Color _getIndicatorColor(double value) {
    if (value <= 30) {
      return Colors.red; // Bahaya
    } else if (value <= 60) {
      return Colors.orange; // Waspada
    } else {
      return Colors.green; // Aman
    }
  }

  // Mendapatkan status berdasarkan nilai sensor
  String _getStatusText(double value) {
    if (value <= 30) {
      return "Bahaya: Air Tinggi!";
    } else if (value <= 60) {
      return "Waspada: Air Sedang.";
    } else {
      return "Aman: Air Rendah.";
    }
  }
}
