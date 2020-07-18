import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String chatId;
  StreamSubscription _incomingMessageStream;

  ChatBloc(this.chatId) : super(ChatLoading()) {
    // Periodic stream to simulate incoming messages
    _incomingMessageStream?.cancel();
    _incomingMessageStream = Stream<ChatMessage>.periodic(
      Duration(seconds: 3),
      (v) {
        if (Random().nextBool()) {
          return ChatMessage("Navi", "Hey! Listen!");
        }
        return ChatMessage("Not Navi", "Hello!");
      },
    ).listen(
      (message) => add(MessageAdded(message)),
    );

    add(ChatLoaded());
  }

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatLoaded) yield* _mapLoadedToState(event);
    if (event is MessageAdded) yield* _mapMeesageAddedToState(event);
  }

  Stream<ChatState> _mapLoadedToState(ChatLoaded event) async* {
    yield ChatReady([
      ChatMessage("Not Navi",
          "This is an example of using bloc with animated list, it seems a little clunky though")
    ]);
  }

  Stream<ChatState> _mapMeesageAddedToState(MessageAdded event) async* {
    if (state is ChatReady) {
      var messages = (state as ChatReady).messages;
      print(messages.length);
      yield ChatReady(messages..insert(0, event.message));
    }
  }

  @override
  Future<void> close() {
    _incomingMessageStream.cancel();
    return super.close();
  }
}
