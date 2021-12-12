import 'package:cloud_firestore/cloud_firestore.dart';

import 'databaseItem.dart';

class DbTransaction extends DatabaseItem {
  final String? id;
  final String name;
  final String description;
  final double amount;
  final String userId;
  final Timestamp updateDate;

  DbTransaction({
    required this.name,
    this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.updateDate,
  }) : super(id);

  factory DbTransaction.fromMap(String id, Map<String, dynamic> data) => DbTransaction(
       id: id,
        name: data['name'],
        userId: data['userId'],
        description: data['description'],
        amount: data['amount'],
        updateDate: data['updateDate'],
       );

  Map<String, dynamic> toMap() => {
        "name": name,
        "userId": userId,
        "description": description,
        "amount": amount,
        "updateDate": updateDate,
      };
}
