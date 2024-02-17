class PurchaseModel {
  int transactionDate;
  String userID;
  String userID2;
  String subscriptionPeriod;
  String receipt;
  String productId;
  String serverVerificationData;
  String source;
  String ultralikeCount;
  bool active;

  PurchaseModel({
    this.transactionDate = 0,
    this.userID = '',
    this.userID2 = '',
    this.subscriptionPeriod = '',
    this.receipt = '',
    this.productId = '',
    this.serverVerificationData = '',
    this.source = '',
    this.ultralikeCount='',
    this.active = false,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> parsedJson) {
    return PurchaseModel(
      transactionDate: parsedJson['transactionDate'] ?? 0,
      userID: parsedJson['userID'] ?? '',
      userID2: parsedJson['userID2'] ?? '',
      subscriptionPeriod: parsedJson['subscriptionPeriod'] ?? '',
      receipt: parsedJson['receipt'] ?? '',
      productId: parsedJson['productId'] ?? '',
      serverVerificationData: parsedJson['serverVerificationData'] ?? '',
      source: parsedJson['source'] ?? '',
      ultralikeCount: parsedJson['ultralikeCount'] ?? '',
      active: parsedJson['active'] ?? false,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'transactionDate': this.transactionDate,
      'userID': this.userID,
      'userID2': this.userID2,
      'subscriptionPeriod': this.subscriptionPeriod,
      'receipt': this.receipt,
      'productId': this.productId,
      'serverVerificationData': this.serverVerificationData,
      'source': this.source,
      'ultralikeCount': this.ultralikeCount,
      'active': this.active,
    };
  }
}
