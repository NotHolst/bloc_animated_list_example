import 'package:bloc_animated_list/chat_example/bloc/chat_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _animListKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with Navi"),
      ),
      body: Container(
        child: BlocConsumer(
          bloc: ChatBloc("someChatId"),
          listener: (context, state) {
            if (state is ChatReady) {
              // This is assuming that only one message is added, and that it is always the first item of the array.
              // which is what i mean when i say this feels like a hacky solution.
              if (_animListKey?.currentState != null)
                _animListKey.currentState
                    .insertItem(0, duration: Duration(milliseconds: 500));
            }
          },
          builder: (context, state) {
            if (state is ChatReady)
              return AnimatedList(
                reverse: true,
                initialItemCount: state.messages.length,
                key: _animListKey,
                itemBuilder: (context, index, animation) {
                  var message = state.messages[index];
                  var isOwner = message.senderId != "Navi";

                  return SizeTransition(
                    sizeFactor: CurvedAnimation(
                      curve: Curves.easeInOutBack,
                      parent: animation,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textDirection:
                            isOwner ? TextDirection.rtl : TextDirection.ltr,
                        children: <Widget>[
                          CircleAvatar(radius: 15),
                          Container(width: 10),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    message.content,
                                    style: TextStyle(
                                      color:
                                          isOwner ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  )),
                              color: isOwner ? Colors.blue : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
