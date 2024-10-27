class Book {
  final String title;
  final String author;
  final double price;
  final String imageUrl;
  final double rating;

  Book({
    required this.title,
    required this.author,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });
  // Factory constructor to create a Book from Firestore data
  // factory Book.fromFirestore(Map<String, dynamic> data) {
  //   return Book(
  //     title: data['title'] ?? 'Unknown Title',
  //     author: data['author'] ?? 'Unknown Author',
  //     price: (data['price'] as num).toDouble(),
  //     imageUrl: data['imageUrl'] ?? 'default_image.png',
  //     rating: (data['rating'] as num).toDouble(),
  //   );
  // }
}

