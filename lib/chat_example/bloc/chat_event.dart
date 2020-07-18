part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatLoaded extends ChatEvent {}

class MessageAdded extends ChatEvent {
  final ChatMessage message;

  MessageAdded(this.message);
}
