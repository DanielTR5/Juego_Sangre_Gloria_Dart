// main.dart: Punto de entrada del juego, maneja el bucle del menú principal y el flujo del juego.

import 'dart:io';
import 'package:juegosangreygloria/historia_intro.dart';
import 'package:juegosangreygloria/juego.dart';
import 'package:juegosangreygloria/jugador.dart';
import 'package:juegosangreygloria/menu.dart';

// Función principal para iniciar el juego y gestionar el bucle del menú principal.
void main() {
  bool salir = false; // Bandera para controlar el bucle principal.

  // Bucle principal del juego que se ejecuta hasta que el usuario elige salir.
  while (!salir) {
    mostrarMenuPrincipal(); // Muestra el menú principal.
    stdout.write('Elige una opción: '); // Solicita la entrada del usuario.
    String? opcion = stdin.readLineSync(); // Lee la entrada del usuario.

    // Maneja las opciones del menú.
    switch (opcion) {
      case '1': // Opción 1: Iniciar una nueva partida.
        Jugador jugador = crearJugador(); // Crea un nuevo jugador.
        historiaIntroductoria(jugador); // Reproduce la historia introductoria.
        iniciarJuego(jugador); // Inicia el bucle principal del juego.
        break;

      case '2': // Opción 2: Cargar una partida guardada.
        try {
          Jugador jugador =
              Jugador.cargarPartida(); // Carga los datos del jugador desde un archivo.
          print(
            '\n✅ Partida cargada exitosamente',
          ); // Confirma la carga exitosa.
          iniciarJuego(jugador); // Inicia el juego con el jugador cargado.
        } catch (e) {
          print('\n❌ Error: $e'); // Maneja errores durante la carga.
        }
        break;

      case '3': // Opción 3: Mostrar el tutorial.
        mostrarTutorial(); // Muestra el tutorial del juego.
        break;

      case '4': // Opción 4: Salir del juego.
        print('\n🛡️ ¡Gracias por jugar!'); // Mensaje de despedida.
        salir = true; // Establece la bandera para salir del bucle.
        break;

      default: // Maneja entradas inválidas.
        print('\n❌ Opción inválida. Intenta de nuevo.');
    }
  }
}
