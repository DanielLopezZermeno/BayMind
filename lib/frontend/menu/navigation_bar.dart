import 'package:flutter/material.dart';
import 'package:baymind/frontend/widgets/colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.morado, AppColors.azul],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Icon(Icons.home),
              ),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.morado, AppColors.azul],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Icon(Icons.calendar_today),
              ),
              label: 'Registros',
            ),
            const BottomNavigationBarItem(
              icon: SizedBox
                  .shrink(), // Espacio reservado para el botón "BayMind"
              label: '',
            ),
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.morado, AppColors.azul],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Icon(Icons.lightbulb),
              ),
              label: 'Avance',
            ),
            BottomNavigationBarItem(
              icon: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.morado, AppColors.azul],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Icon(Icons.person),
              ),
              label: 'Perfil',
            ),
          ],
          selectedItemColor: const Color.fromARGB(
              171, 214, 140, 243), // No afecta el color directamente
          unselectedItemColor: const Color.fromARGB(
              43, 0, 0, 0), // Color de íconos no seleccionados
          onTap: onTap,
        ),
        Positioned(
          bottom: 20, // Ajusta esta posición según lo necesites
          left:
              MediaQuery.of(context).size.width / 2 - 40, // Centrado horizontal
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.azul,
                    AppColors.azul,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(141, 202, 163,
                    214), // Deja el fondo transparente para que el gradiente sea visible
                onPressed: () {
                  onTap(2); // Invoca onTap con el índice de BaymindScreen
                },
                child: Image.asset(
                  'assets/baymind.png', // Asegúrate de que esta ruta es correcta
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
