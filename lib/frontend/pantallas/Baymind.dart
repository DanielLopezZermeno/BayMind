import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:baymind/frontend/widgets/colors.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:baymind/servicios/api_service.dart';

class BaymindScreen extends StatefulWidget {
  const BaymindScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BayMindScreen createState() => _BayMindScreen();
}

class _BayMindScreen extends State<BaymindScreen> {
  final TextEditingController _textController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isListening = false;
  late stt.SpeechToText _speechToText;
  late DialogFlowtter dialogFlowtter;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
    _loadMessages();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  void _sendMessage(String message) async {
  if (message.trim().isEmpty) return;
  // 1. Obtener la fecha y hora actual
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  // 2. Agregar el mensaje del usuario en la interfaz de usuario
  setState(() {
    _messages.add({"from": "user", "message": message,"date":formattedDate});
  });
  _textController.clear();

  // 3. Enviar el mensaje a Dialogflow
  DetectIntentResponse response = await dialogFlowtter.detectIntent(
    queryInput: QueryInput(text: TextInput(text: message)),
  );

  if (response.message == null) return;

  formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  // 4. Agregar la respuesta de Dialogflow en la interfaz de usuario
  setState(() {
    _messages.add({"from": "ai", "message": response.message!.text!.text![0], "date":formattedDate});
  });

  // 5. Guardar el mensaje del usuario en la base de datos
  await ApiService.guardarMensaje(formattedDate.toString(), "user", message);

  // 6. Guardar la respuesta de Dialogflow en la base de datos
  await ApiService.guardarMensaje(formattedDate.toString(), "ai", response.message!.text!.text![0]);
}

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        });
      } else {
        Fluttertoast.showToast(msg: "Permiso para usar micrófono no otorgado");
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }
// Cargar los mensajes desde el backend
  Future<void> _loadMessages() async {
  final messages = await ApiService.obtenerMensajes();

  // Asegurarnos de convertir la fecha de String a DateTime
  for (var message in messages) {
    if (message['date'] != null) {
      message['date'] = DateTime.parse(message['date']);  // Convertir la fecha a DateTime
    }
  }

  // Ordenar los mensajes por fecha y hora
  messages.sort((a, b) => a['date'].compareTo(b['date']));
  
// Convertir la fecha de vuelta a String después de ordenar
  for (var message in messages) {
    if (message['date'] != null) {
      message['date'] = DateFormat('yyyy-MM-dd HH:mm:ss').format(message['date']);  // Convertir de DateTime a String
    }
  }
  setState(() {
    _messages = messages;
  });
}

  // Función para construir los mensajes
  Widget _buildMessage(String sender, String message, String dateTime) {
    bool isUser = sender == "user";
    // Convertir la fecha de String a DateTime
  DateTime parsedDate = DateTime.parse(dateTime);
    // Formatear la hora en formato HH:mm (hora y minutos)
   String formattedTime = DateFormat('HH:mm').format(parsedDate);
    return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: isUser ? const Color.fromARGB(255, 207, 101, 239) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // El mensaje
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          // Hora del mensaje en formato pequeño
          Text(
            formattedTime,
            style: TextStyle(
              color: isUser ? Colors.white70 : Colors.black54,
              fontSize: 12, // Tamaño pequeño para la hora
            ),
          ),
        ],
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Aquí esta tu amigo BayMind",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Manrope',
                color: AppColors.morado,
                fontSize: 24)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(202, 163, 214, 0.5),
              Color.fromRGBO(180, 145, 191, 0.5),
              Colors.white
            ],
            radius: 1.1,
            center: Alignment.center,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(34, 0, 0, 0),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[_messages.length - 1 - index];
                  return _buildMessage(message["from"]!, message["message"]!, message["date"]!);
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.only(right: 8, left: 8, bottom: 25),
      color: Colors.white,
      child: Row(
        children: [
          AvatarGlow(
            animate: _isListening,
            glowColor: AppColors.morado,
            endRadius: 30.0,
            duration: const Duration(milliseconds: 2000),
            repeat: true,
            showTwoGlows: true,
            child: GestureDetector(
              onTap: _listen,
              child: CircleAvatar(
                backgroundColor: AppColors.morado,
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                  hintText: "Exagerame los detalles..."),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.morado),
            onPressed: () => _sendMessage(_textController.text),
          ),
        ],
      ),
    );
  }
}
