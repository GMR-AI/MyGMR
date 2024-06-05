import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../globals.dart';
import 'dart:developer';
import 'dart:async';

class DefineAreaPage extends StatefulWidget {
  const DefineAreaPage({Key? key}) : super(key: key);

  @override
  _DefineAreaPageState createState() => _DefineAreaPageState();
}

class _DefineAreaPageState extends State<DefineAreaPage> {
  List<Offset> _points = [];
  List<Offset> _pointsApp = [];
  final Completer<Size> _imageSizeCompleter = Completer<Size>();
  final GlobalKey _imageKey = GlobalKey();

  void _addPoint(Offset point) {
    final RenderBox renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox;
    final Size widgetSize = renderBox.size;

    final Offset scaledPoint = _convertToImageCoordinates(point, widgetSize);

    setState(() {
      if (_points.length < 4) {
        _points.add(scaledPoint);
        _pointsApp.add(point);
      } else {
        _points.clear();
        _pointsApp.clear();
        _points.add(scaledPoint);
        _pointsApp.add(point);
      }
    });
  }

  Offset _convertToImageCoordinates(Offset point, Size widgetSize) {
    final double scaleX = 255 / widgetSize.width;
    final double scaleY = 255 / widgetSize.height;

    final double imageX = point.dx * scaleX;
    final double imageY = point.dy * scaleY;

    return Offset(imageX, imageY);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step 2'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            globalJob!.cutting_height = null;
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          color: Colors.green.shade100,
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Select the area',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTapUp: (details) {
                  _addPoint(details.localPosition);
                },
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      FutureBuilder<Size>(
                        future: _imageSizeCompleter.future,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return Image.network(
                              globalJob!.top_image!,
                              key: _imageKey,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      CustomPaint(
                        painter: AreaPainter(points: _pointsApp),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _points.length == 4 ? _navigateToResume : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToResume() {
    Map<String, dynamic> areaMap = {};

    for (int i = 0; i < _points.length; i++) {
      areaMap[i.toString()] = [double.parse((_points[i].dx).toStringAsFixed(2)),
        double.parse((_points[i].dy).toStringAsFixed(2))];
    }
    globalJob!.area = areaMap;
    context.goNamed("resume");
  }
}

class AreaPainter extends CustomPainter {
  final List<Offset> points;

  AreaPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    if (points.length == 4) {
      final path = Path()
        ..moveTo(points[0].dx, points[0].dy)
        ..lineTo(points[1].dx, points[1].dy)
        ..lineTo(points[2].dx, points[2].dy)
        ..lineTo(points[3].dx, points[3].dy)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
