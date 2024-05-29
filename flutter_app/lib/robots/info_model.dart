import 'package:flutter/material.dart';
import '../functions/robots_requests.dart';

class ModelInfoScreen extends StatefulWidget {
  @override
  _ModelInfoScreenState createState() => _ModelInfoScreenState();
}

class _ModelInfoScreenState extends State<ModelInfoScreen> {
  Map<String, dynamic>? _modelInfo;

  @override
  void initState() {
    super.initState();
    _fetchModel();
  }

  Future<void> _fetchModel() async {
    final modelInfo = await getModel();
    setState(() {
      _modelInfo = modelInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Model Info'),
      ),
      body: _modelInfo != null
          ? ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildInfoItem('Model Name', _modelInfo!['model_name']),
          _buildInfoItem('Manufacturer', _modelInfo!['manufacturer']),
          _buildInfoItem('Release Date', _modelInfo!['release_date']),
          _buildInfoItem('Dimensions', _modelInfo!['dimensions']),
          _buildInfoItem('Weight', _modelInfo!['weight']),
          _buildInfoItem('Battery Life', _modelInfo!['battery_life']),
          _buildInfoItem('Charging Time', _modelInfo!['charging_time']),
          _buildInfoItem('Features', _modelInfo!['features']),
          _buildInfoItem('Price', _modelInfo!['price']),
          _buildInfoItem('Status', _modelInfo!['status']),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildInfoItem(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        Divider(),
      ],
    );
  }
}
