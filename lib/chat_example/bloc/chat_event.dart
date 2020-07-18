part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatLoaded extends ChatEvent {}

class MessageSent extends ChatEvent {
  final String senderId;
  final String message;

  MessageSent(this.senderId, this.message);
}

class MessageAdded extends ChatEvent {
  final ChatMessage message;

  MessageAdded(this.message);
}
