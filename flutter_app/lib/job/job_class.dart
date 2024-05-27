class Job {
  DateTime startDate;
  DateTime? endDate;
  double? cuttingHeight;
  double? area;
  double? temperature;
  double? humidity;
  Duration? time;
  String? model3D;

  Job({
    required this.startDate,
    this.endDate,
    this.cuttingHeight,
    this.area,
    this.temperature,
    this.humidity,
    this.time,
    this.model3D,
  });
}