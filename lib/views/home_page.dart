
import 'dart:io';

import 'package:chatbot_app/models/chat_message.dart';
import 'package:chatbot_app/widgets/chat_message_list_item.dart';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
TextEditingController _textFieldController = TextEditingController();
class TextFieldAlertDialog extends StatelessWidget {


  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Digite o seu CPF'),
            content: TextField(
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(hintText: "CPF"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ),
                  );
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot de Apoio ao Diagnóstico'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Digite o seu CPF para iniciar',style: TextStyle(color: Colors.white),),
          color: Colors.cyan,
          onPressed: () => _displayDialog(context),
          padding: new EdgeInsets.all(30),
        ),
      ),
    );
  }
}


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    var i = 100000;

  final _messageList = <ChatMessage>[];
  final _controllerText = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controllerText.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: new AppBar(
        title: Text('Chatbot de Apoio ao Diagnóstico'),
      ),
      body: Column(
        children: <Widget>[
          _buildList(),
          Divider(height: 1.0),
          _buildUserInput(),
        ],
      ),
    );
  }


  // Cria a lista de mensagens (de baixo para cima)
  Widget _buildList() {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        reverse: true,
        itemBuilder: (_, int index) => ChatMessageListItem(chatMessage: _messageList[index]),
        itemCount: _messageList.length,
      ),
    );
  }

  // Envia uma mensagem com o padrão a direita
  void _sendMessage({String text}) {
   _controllerText.clear();
    _addMessage(name: 'Paciente', text: text, type: ChatMessageType.sent);
  }

  // Adiciona uma mensagem na lista de mensagens
  void _addMessage({String name, String text, ChatMessageType type}) {
    var message = ChatMessage(
        text: text, name: name, type: type);
    setState(() {
      _messageList.insert(0, message);
    });

    if (type == ChatMessageType.sent) {
      // Envia a mensagem para o chatbot e aguarda sua resposta
      _dialogFlowRequest(query: message.text);
      final databaseReference = FirebaseDatabase(
          databaseURL:
          'https://chat-firebase-b0622-default-rtdb.firebaseio.com/')
          .reference();

      FirebaseDatabase database = new FirebaseDatabase();
      final dailySpecialRef = databaseReference.child('/dailySpecial');
      dailySpecialRef.child(_textFieldController.text).update(
        {
        'Sintomas $i':  text.toString(),
        },
      );
    }
    i = i +1;
  }

  Future _dialogFlowRequest({String query}) async {
    _addMessage(
        name: 'Helse - Bot',
        text: 'Escrevendo...',
        type: ChatMessageType.received);


    // Faz a autenticação com o serviço, envia a mensagem e recebe uma resposta da Intent
    AuthGoogle authGoogle = await AuthGoogle(
        fileJson: "assets/agente-ulpx-fee9457d17c0.json").build();
    DialogFlow dialogflow = DialogFlow(
        authGoogle: authGoogle, language: "pt-BR");
    AIResponse response = await dialogflow.detectIntent(query);

    // remove a mensagem temporária
    setState(() {
      _messageList.removeAt(0);
    });

    // adiciona a mensagem com a resposta do DialogFlow
    _addMessage(
        name: 'Helse - Bot',
        text: response.getMessage() ?? '',
        type: ChatMessageType.received);

    final databaseReference = FirebaseDatabase(
        databaseURL:
        'https://chat-firebase-b0622-default-rtdb.firebaseio.com/')
        .reference();

    FirebaseDatabase database = new FirebaseDatabase();
    final dailySpecialRef = databaseReference.child('/dailySpecial');
    dailySpecialRef.child(_textFieldController.text).update(
      {
        'Sintomas $i': response.getMessage().toString(),
      },
    );
    var b = i+i;
    i = i +1;
    return i;
  }
  // Campo para escrever a mensagem
  Widget _buildTextField() {
    return new Flexible(
      child: new TextField(
        controller: _controllerText,
        decoration: new InputDecoration.collapsed(
          hintText: "Enviar mensagem",
        ),
      ),
    );
  }

  // Botão para enviar a mensagem
  Widget _buildSendButton() {
    return new Container(
      margin: new EdgeInsets.only(left: 8.0),
      child: new IconButton(
          icon: new Icon(Icons.send, color: Theme.of(context).accentColor),

          onPressed: () {
            if (_controllerText.text.isNotEmpty) {
              _sendMessage(text: _controllerText.text);
            }
          }),
    );
  }

  // Monta uma linha com o campo de text e o botão de enviao
  Widget _buildUserInput() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          _buildTextField(),
          _buildSendButton(),
        ],
      ),
    );
  }
}