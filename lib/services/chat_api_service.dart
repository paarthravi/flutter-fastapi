import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/conversation.dart';
import '../models/chat_message.dart';

class ChatApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
    ),
  );

  Future<List<Conversation>> getConversations() async {
    try {
      final response =
      await _dio.get('/api/conversations');

      final List data = response.data;

      return data
          .map(
            (json) => Conversation.fromJson(json),
      )
          .toList();
    } catch (e) {
      print("ERROR: $e");
      return [];
    }
  }
  Future<void> createConversation({
    String title = "New Chat",
  }) async {
    try {
      await _dio.post(
        '/api/conversations',
        data: {
          "title": title,
        },
      );
    } catch (e) {
      print("ERROR: $e");
    }
  }
  Future<List<ChatMessage>> getMessages(
      int conversationId,
      ) async {
    try {
      final response = await _dio.get(
        '/api/conversations/$conversationId/messages',
      );

      final List data = response.data;

      return data
          .map(
            (json) => ChatMessage.fromJson(json),
      )
          .toList();
    } catch (e) {
      print("ERROR: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        '/api/chat/send',
        data: {
          "conversation_id": conversationId,
          "message": message,
        },
      );

      return response.data;
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
  }

  // Delete Function
  Future<void> deleteConversation(
      int conversationId,
      ) async {
    try {
      await _dio.delete(
        '/api/conversations/$conversationId',
      );
    } catch (e) {
      print("ERROR: $e");
    }
  }



}