class WeightData {
  late double weight;
  late DateTime date;
  late String? docId;
  WeightData({required this.weight, required this.date});
  WeightData.fromMap(Map<String, dynamic> map) {
    weight = map["weight"];
    date = map["date"].toDate();
    docId = map["docId"];
  }
  toJson() {
    return {"weight": weight, "date": date};
  }
}
