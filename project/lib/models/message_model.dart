class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isRead;
  final bool isDelivered;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isRead = false,
    this.isDelivered = true,
  });

  MessageModel copyWith({bool? isRead, bool? isDelivered}) {
    return MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      text: text,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
      isDelivered: isDelivered ?? this.isDelivered,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'text': text,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'isRead': isRead,
    'isDelivered': isDelivered,
  };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
    id: map['id'] ?? '',
    senderId: map['senderId'] ?? '',
    receiverId: map['receiverId'] ?? '',
    text: map['text'] ?? '',
    timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] ?? 0),
    isRead: map['isRead'] ?? false,
    isDelivered: map['isDelivered'] ?? true,
  );
}
