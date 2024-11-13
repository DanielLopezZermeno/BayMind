import 'package:baymind/frontend/pantallas/cuestionario_screen.dart';
import 'package:baymind/main.dart';
import 'package:flutter/material.dart';

class ScrollScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Page1();
          } else {
            return LoginScreen(); // Navegación a LoginScreen
          }
        },
        itemCount: 2,
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Background(),
        MainContent()
      ],
    );
  }
}

class MainContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Expanded(child: Container()),
          Icon(Icons.keyboard_arrow_down, size: 100, color: Colors.white),
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
      color: Color(0xff30BAD6),
      height: double.infinity,
      width: double.infinity,
      child: Image(
        image: AssetImage('assets/Fondo.jpg'), // Reemplaza 'image.png' con la imagen correcta de tu fondo
        fit: BoxFit.cover,
      ),
    );
  }
}

// Pantalla de Login
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>(); // Para las validaciones del formulario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
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
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x000e5e5e5),
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
                        Text(
                          'Iniciar Sesión',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Manrope',),
                        ),
                        SizedBox(height: 20),
                        Text('Correo', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        SizedBox(height: 8),
                        TextFormField(  // Cambiamos a TextFormField
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'jon@gmail.com',
                            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Manrope',),
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
                        SizedBox(height: 20),
                        Text('Contraseña', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        SizedBox(height: 8),
                        TextFormField(  // Cambiamos a TextFormField
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Contraseña',
                            hintStyle: TextStyle(color: Colors.grey),
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
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 109, 174, 239), Color.fromARGB(255, 50, 151, 246)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {  // Validar el formulario
                                // Redirigir a la pantalla principal al iniciar sesión
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => MainScreen()), // Cambiar a MainScreen
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Iniciar', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              // Añadir lógica para "Olvidaste tu contraseña"
                            },
                            child: Text('¿Olvidaste la contraseña?', style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("o", style: TextStyle(fontSize: 20, fontFamily: 'Manrope', fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('¿No tienes cuenta?', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => RegisterScreen()), // Cambiar a RegisterScreen
                                  );
                                },
                                child: Text('Registrar', style: TextStyle(color: const Color.fromARGB(255, 50, 151, 245), fontSize: 14, fontFamily: 'Manrope',)),
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
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Background(),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Container(
                  padding: EdgeInsets.all(20.0),
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
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
                    boxShadow: [
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
                        Text('Registrar', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Manrope',)),
                        SizedBox(height: 20),
                        Text('Correo', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        SizedBox(height: 8),
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
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'correo@gmail.com',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Contraseña', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        SizedBox(height: 8),
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
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Contraseña',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('Confirmar Contraseña', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',)),
                        SizedBox(height: 8),
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
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                            hintText: 'Confirmar contraseña',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [Color.fromARGB(255, 109, 174, 239), Color.fromARGB(255, 50, 151, 246)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CuestionarioScreen()),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Registrar', style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text("o", style: TextStyle(fontSize: 20, fontFamily: 'Manrope', fontWeight: FontWeight.bold)),
                            ),
                            Expanded(child: Divider(thickness: 1, color: Colors.black)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('¿Ya tienes cuenta?', style: TextStyle(fontSize: 14, color: Colors.black, fontFamily: 'Manrope',fontWeight: FontWeight.bold)),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => LoginScreen()), // Cambiar a RegisterScreen
                                  );
                                },
                                child: Text('Iniciar sesión', style: TextStyle(color: Colors.blue, fontSize: 14, fontFamily: 'Manrope',)),
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
