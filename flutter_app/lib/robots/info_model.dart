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

  String _formatJson(Map<String, dynamic> dimensions) {
    final List<String> k = dimensions.keys.toList();
    String result = "";
    for (int i = 0; i < k.length; i++) {
      result += "${k[i]}: ${dimensions[k[i]]}\n";
    }
    result = result.substring(0, result.length - 1);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Info'),
      ),
      body: _modelInfo != null
          ? ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInfoItem('Model Name', _modelInfo!['name']),
          _buildInfoItem('Manufacturer', _modelInfo!['manufacturer']),
          _buildInfoItem('Release Date', _modelInfo!['release_date']),
          _buildInfoItem('Dimensions (m)', _formatJson(_modelInfo!['dimensions'])),
          _buildInfoItem('Weight (kg)', _modelInfo!['weight']),
          _buildInfoItem('Battery Life (🤔)', _modelInfo!['battery_life']),
          _buildInfoItem('Charging Time (min)', _modelInfo!['charging_time']),
          _buildInfoItem('Features', _formatJson(_modelInfo!['features'])),
          _buildInfoItem('Price', _modelInfo!['price']),
          _buildInfoItem('Status', _modelInfo!['status']),
        ],
      )
          : const Center(
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 16.0,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
