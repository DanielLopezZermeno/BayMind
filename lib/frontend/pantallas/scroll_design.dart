// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:baymind/frontend/pantallas/cuestionario_screen.dart';
import 'package:baymind/main.dart';
import 'package:baymind/servicios/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


final String apiUrl ="https://baymind-backend-yyfm.onrender.com/api/auth/";

class ScrollScreen extends StatelessWidget {
  const ScrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Page1();
          } else {
            return const LoginScreen(); // Navegación a LoginScreen
          }
        },
        itemCount: 2,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Background(),
        MainContent()
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  const MainContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          Expanded(child: Container()),
          const Icon(Icons.keyboard_arrow_down, size: 100, color: Colors.white),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff30BAD6),
      height: double.infinity,
      width: double.infinity,
      child: const Image(
        image: AssetImage('assets/Fondo.jpg'), // Reemplaza 'image.png' con la imagen correcta de tu fondo
        fit: BoxFit.cover,
      ),
    );
  }
}

Future<void> saveToken(String userName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', userName); // Guarda el token con la clave 'authToken'
}




// Pantalla de Login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>(); // Para las validaciones del formulario

Future<void> _login(String email, String password) async {
  final url = Uri.parse('$apiUrl/login'); // Cambia la URL de tu servidor

  try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
        
      );

      if (response.statusCode == 200) {
        // Aquí puedes manejar la rqespuesta del servidor, como el token JWT
        final responseData = json.decode(response.body);
        print ("Respuesta exitosa: ${response.body}");
        if (responseData['error'] == null) {
          // Login exitoso,
          String userName = responseData['data']['user']['email'];

          saveToken(userName);

          // redirigir a la pantalla principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          // Mostrar mensaje de error
          _showErrorDialog(responseData['message'] ?? 'Credenciales incorrectas');
        }
      } else {
        _showErrorDialog('Hubo un error al intentar iniciar sesión');
      }
    } catch (error) {
      _showErrorDialog('Error de conexión');
    }
  }

  // Mostrar un cuadro de diálogo con el error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x00e5e5e5),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(  // Agregamos el widget Form
                    key: _formKey, // Asignamos la clave del formulario
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Manrope',),
                        ),
                        const SizedBox(height: 20),
                        const Text('Correo', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        const SizedBox(height: 8),
                        TextFormField(  // Cambiamos a TextFormField
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.mail),
                            hintText: 'jon@gmail.com',
                            hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Manrope',),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          validator: (value) {  // Validación del correo
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su correo electrónico';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Por favor ingrese un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text('Contraseña', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        const SizedBox(height: 8),
                        TextFormField(  // Cambiamos a TextFormField
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Contraseña',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                          validator: (value) {  // Validación de la contraseña
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 109, 174, 239), Color.fromARGB(255, 50, 151, 246)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {  // Validar el formulario
                                _login(_emailController.text, _passwordController.text);
                                
                                // Redirigir a la pantalla principal al iniciar sesión
                                //Navigator.pushReplacement(
                                  //context,
                                 // MaterialPageRoute(builder: (context) => const MainScreen()), // Cambiar a MainScreen
                                //);
                                //ApiService.guardarUserId("1");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Iniciar', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Añadir lógica para "Olvidaste tu contraseña"
                            },
                            child: const Text('¿Olvidaste la contraseña?', style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const Row(
                          children: [
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("o", style: TextStyle(fontSize: 20, fontFamily: 'Manrope', fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('¿No tienes cuenta?', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const RegisterScreen()), // Cambiar a RegisterScreen
                                  );
                                },
                                child: const Text('Registrar', style: TextStyle(color: Color.fromARGB(255, 50, 151, 245), fontSize: 14, fontFamily: 'Manrope',)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Pantalla de Registro
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();


  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

    try{
      final response = await http.post(
        Uri.parse('$apiUrl/register'), // Cambia la URL a la de tu servidor
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print("Respuesta del servidor: ${response.body}");
      print("Código de estado: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Registro exitoso, redirigir a otra pantalla
        final responseData = json.decode(response.body);
        String token = responseData['data']['token'];
        saveToken(token);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CuestionarioScreen()),
        );
      } else {
        // Error en el registro
        final responseData = json.decode(response.body);
        String errorMessage = responseData['error'] ?? 'Error al registrar';
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al registrar')));
      }
    } catch (error) {
      // En caso de error en la solicitud HTTP
        print("Error al realizar la solicitud: $error");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error de conexión')));
    }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Registrar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Manrope',)),
                        const SizedBox(height: 20),
                        const Text('Correo', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu correo';
                            }
                            // Expresión regular para validar formato de correo electrónico
                            String pattern = r'\w+@\w+\.\w+';
                            RegExp regExp = RegExp(pattern);
                            if (!regExp.hasMatch(value)) {
                              return 'Por favor ingresa un correo válido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.mail),
                            hintText: 'correo@gmail.com',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Contraseña', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu contraseña';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Contraseña',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text('Confirmar Contraseña', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor confirma tu contraseña';
                            }
                            if (value != _passwordController.text) {
                              return 'Las contraseñas no coinciden';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Confirmar contraseña',
                            hintStyle: const TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: const LinearGradient(
                              colors: [Color.fromARGB(255, 109, 174, 239), Color.fromARGB(255, 50, 151, 246)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed:_register, //() {
                              //if (_formKey.currentState!.validate()) {
                                //Navigator.push(
                                  //context,
                                  //MaterialPageRoute(builder: (context) => const CuestionarioScreen()),
                                //);
                              //}
                            //},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Registrar', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("o", style: TextStyle(fontSize: 20, fontFamily: 'Manrope', fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('¿Ya tienes cuenta?', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()), // Cambiar a RegisterScreen
                                  );
                                },
                                child: const Text('Iniciar sesión', style: TextStyle(color: Colors.blue, fontSize: 14, fontFamily: 'Manrope',)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
