class CartItem {
  final String id;
  final String title;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    this.quantity = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': price,
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        title: json['title'],
        price: json['price'],
        quantity: json['quantity'],
      );
}
