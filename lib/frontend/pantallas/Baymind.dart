import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:baymind/frontend/widgets/colors.dart';

class BaymindScreen extends StatefulWidget {
  const BaymindScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BayMindScreen createState() => _BayMindScreen();
}

class _BayMindScreen extends State<BaymindScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isListening = false;
  late stt.SpeechToText _speechToText;

  @override
  void initState() {
    super.initState();
    _speechToText = stt.SpeechToText();
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "user", "text": message});
    });
    _textController.clear();
    _simulateResponse(message);
  }

  // Simulación de respuesta de la IA
  void _simulateResponse(String userMessage) {
    setState(() {
      _messages.add({"sender": "ai", "text": "Estoy analizando tu mensaje..."});
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.removeLast();
        _messages.add({"sender": "ai", "text": "Entiendo, cuéntame más sobre eso."});
      });
    });
  }

  // Método para escuchar el mensaje de voz
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

  Widget _buildMessage(String sender, String message) {
    bool isUser = sender == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.morado : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Aquí esta tu amigo BayMind", style:
                TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Manrope', color: AppColors.morado, fontSize: 24)),
      ),
      body: Container(
        // Añadir un fondo de gradiente al contenedor
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.fromRGBO(202, 163, 214, 0.5),
              Color.fromRGBO(180, 145, 191, 0.5),
              Colors.white
            ], // El gradiente va de morado a blanco
            radius: 1.1, // Controla el tamaño del área del gradiente
            center: Alignment
                .center, // El centro del gradiente será el centro del widget
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
                return _buildMessage(message["sender"]!, message["text"]!);
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
          // Botón para grabar audio
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
          // Campo de texto para el mensaje
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(hintText: "Exagerame los detalles..."),
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
