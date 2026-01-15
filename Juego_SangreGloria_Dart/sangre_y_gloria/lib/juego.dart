// juego.dart: Manages game initialization and main loop.
// Changes: Added final screen display, checks for ending conditions, uses input utility.

import 'dart:io';
import 'jugador.dart';
import 'menu.dart';

Jugador crearJugador() {
  print('\n=== CREAR GLADIADOR ===');
  stdout.write('Ingresa el nombre de tu gladiador: ');
  String nombre = stdin.readLineSync() ?? 'SinNombre';

  print('\nElige tu origen:');
  print('1. Campesino rebelde (+Agilidad)');
  print('2. Esclavo de guerra (+Vida)');
  print('3. Guerrero del norte (+Fuerza)');
  print('4. Noble traicionado (+Reputación)');
  stdout.write('Opción (1-4): ');
  int? opcion = parseInput(stdin.readLineSync(), 1, 4);

  String origen = switch (opcion ?? 1) {
    1 => 'Campesino rebelde',
    2 => 'Esclavo de guerra',
    3 => 'Guerrero del norte',
    4 => 'Noble traicionado',
    _ => 'Campesino rebelde'
  };

  var jugador = Jugador(
    nombre: nombre,
    origen: origen,
  );
  
  jugador.aplicarOrigen();
  jugador.mostrarDatos();
  return jugador;
}

void mostrarFinal(Jugador jugador) {
  print('\n=== FIN DEL JUEGO ===');
  if (jugador.progresoHistoria == 10 && jugador.vida > 30) {
    print('🏆 FINAL HEROICO 🏆');
    print('Derrotas al rey y reclamas el trono. ¡Rocanegra es libre!');
    print('Tu nombre, ${jugador.nombre}, será recordado como el heredero de Valerius.');
  } else if (jugador.progresoHistoria == 10 && jugador.vida <= 30) {
    print('💔 FINAL TRÁGICO 💔');
    print('Vences al rey, pero mueres en el combate. Tu sacrificio libera Rocanegra.');
    print('Los rebeldes honran tu memoria como héroe.');
  } else if (jugador.progresoHistoria == 9 && jugador.reputacion < 50) {
    print('🏃 FINAL TRAICIÓN 🏃');
    print('Traicionas a los rebeldes y huyes con riquezas, viviendo como fugitivo.');
    print('Rocanegra cae en el caos, y tu nombre es maldito.');
  } else if (jugador.progresoHistoria == 9 && jugador.peleasGanadas >= 30) {
    print('🌟 FINAL ABIERTO 🌟');
    print('Eliges la gloria de la arena, convirtiéndote en una leyenda viva.');
    print('La rebelión espera, pero tu destino es la inmortalidad en Rocanegra.');
  }
  print('\nEstadísticas Finales:');
  print('Nivel: ${jugador.nivel}, Reputación: ${jugador.reputacion}');
  print('Victorias: ${jugador.peleasGanadas}, Oro: ${jugador.oro}');
  print('\n¡Gracias por jugar!');
}

void iniciarJuego(Jugador jugador) {
  print('\n⚔️ ¡Bienvenido a la Arena, ${jugador.nombre}! ⚔️');
  jugador.mostrarEstado();
  
  bool enJuego = true;
  while (enJuego) {
    // Check for ending conditions
    if (jugador.progresoHistoria >= 9) {
      mostrarFinal(jugador);
      enJuego = false;
      break;
    }
    mostrarMenuJuego();
    stdout.write('Elige una opción: ');
    int? opcion = parseInput(stdin.readLineSync(), 1, 5);
    if (opcion == null) {
      print('\n❌ Opción inválida.');
      continue;
    }

    switch (opcion) {
      case 1: // Ir a la Arena
        irALaArena(jugador);
        break;
      case 2: // Visitar Tienda
        visitarTienda(jugador);
        break;
      case 3: // Ver Personaje
        verPersonaje(jugador);
        break;
      case 4: // Inventario
        verInventario(jugador);
        break;
      case 5: // Guardar y salir
        guardarYSalir(jugador);
        enJuego = false;
        break;
    }
  }
}