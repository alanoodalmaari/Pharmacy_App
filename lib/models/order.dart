class Order {
  String documentId;
  int totallPrice;
  String address;
  bool status;
  String user;
  String pharmacy;
  String deliveryTime;

  Order({
    this.totallPrice,
    this.address,
    this.documentId,
    this.status,
    this.user,
    this.pharmacy,
    this.deliveryTime
  });
}
