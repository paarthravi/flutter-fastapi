class ChatMessage {
  final int id;
  final String role;
  final String content;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
  });

  factory ChatMessage.fromJson(
      Map<String, dynamic> json,
      ) {
    return ChatMessage(
      id: json['id'],
      role: json['role'],
      content: json['content'],
    );
  }
}