part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatReady extends ChatState {
  final List<ChatMessage> messages;

  ChatReady(this.messages);
}
