class Job {
  DateTime date;
  double? cuttingHeight;
  double? area;
  double? temperature;
  double? humidity;
  Duration? time;
  String? model3D;

  Job({
    required this.date,
    this.cuttingHeight,
    this.area,
    this.temperature,
    this.humidity,
    this.time,
    this.model3D,
  });
}
