import 'package:cloud_firestore/cloud_firestore.dart';

class Swipe {
  String id;

  String user1;

  String user2;

  bool hasBeenSeen;

  String type;

  Timestamp createdAt;

  bool ultraLike;

  bool otherLike;

  String whatLiked;

  // bool removeuser;

  Swipe(
      {this.id = '',
      this.user1 = '',
      this.user2 = '',
      createdAt,
      this.hasBeenSeen = false,
      this.ultraLike = false,
      this.otherLike = false,
      this.whatLiked = 'picture',
      //  this.removeuser=false,
      this.type = 'dislike'})
      : this.createdAt = createdAt ?? Timestamp.now();

  factory Swipe.fromJson(Map<String, dynamic> parsedJson) {
    return Swipe(
        id: parsedJson['id'] ?? '',
        user1: parsedJson['user1'] ?? '',
        user2: parsedJson['user2'] ?? '',
        createdAt: parsedJson['createdAt'] ??
            parsedJson['created_at'] ??
            Timestamp.now(),
        hasBeenSeen: parsedJson['hasBeenSeen'] ?? false,
        ultraLike: parsedJson['ultraLike'] ?? false,
        otherLike: parsedJson['otherLike'] ?? false,
        whatLiked: parsedJson['whatLiked'] ?? 'picture',
        // removeuser: parsedJson['removeuser'] ?? false,
        type: parsedJson['type'] ?? 'dislike');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'user1': this.user1,
      'user2': this.user2,
      'created_at': this.createdAt,
      'createdAt': this.createdAt,
      'hasBeenSeen': this.hasBeenSeen,
      'type': this.type,
      'ultraLike': this.ultraLike,
      'otherLike': this.otherLike,
      'whatLiked': this.whatLiked,
      // 'removeuser': this.removeuser
    };
  }
}
