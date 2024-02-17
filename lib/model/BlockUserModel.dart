import 'package:cloud_firestore/cloud_firestore.dart';

class BlockUserModel {
  Timestamp createdAt;

  String dest;

  String source;

  String type;

  String reason;

  BlockUserModel(
      {createdAt,
      this.dest = '',
      this.source = '',
      this.type = '',
      this.reason = ''})
      : this.createdAt = createdAt ?? Timestamp.now();

  factory BlockUserModel.fromJson(Map<String, dynamic> parsedJson) {
    return BlockUserModel(
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
      dest: parsedJson['dest'] ?? '',
      source: parsedJson['source'] ?? '',
      type: parsedJson['type'] ?? '',
      reason: parsedJson['reason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': this.createdAt,
      'dest': this.dest,
      'source': this.source,
      'type': this.type,
      'reason': this.reason,
    };
  }
}
