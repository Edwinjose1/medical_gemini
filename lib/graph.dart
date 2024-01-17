import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MedicalReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medical Report'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle('Patient Information'),
            _buildInfoItem('Name:', 'John Doe', Colors.blue),
            _buildInfoItem('Age:', '30', Colors.green),
            _buildInfoItem('Gender:', 'Male', Colors.orange),
            SizedBox(height: 20),
            _buildSectionTitle('Medical Details'),
            _buildChart(),
            SizedBox(height: 20),
            _buildSectionTitle('Notes'),
            _buildNotes(
              'Patient is in good health. Needs to monitor blood pressure regularly.',
              Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNotes(String note, Color color) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        note,
        style: TextStyle(
          fontSize: 16,
          color: color,
        ),
      ),
    );
  }

  Widget _buildChart() {
    return Container(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<ChartData, String>(
            dataSource: <ChartData>[
              ChartData('Jan', 30),
              ChartData('Feb', 50),
              ChartData('Mar', 40),
              ChartData('Apr', 60),
              ChartData('May', 45),
            ],
            xValueMapper: (ChartData data, _) => data.month,
            yValueMapper: (ChartData data, _) => data.value,
            name: 'Medical Data',
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String month;
  final double value;

  ChartData(this.month, this.value);
}
