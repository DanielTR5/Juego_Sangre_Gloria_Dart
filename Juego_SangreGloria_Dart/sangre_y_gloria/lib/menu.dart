
// menu.dart: Gestiona los menús del juego, combates, tienda e inventario.
// Cambios: Aumentada ganancia de XP (50->75), ajustada escalabilidad de enemigos para niveles bajos, añadida lógica para pelea contra el rey.

import 'dart:io';
import 'dart:math';
import 'jugador.dart';
import 'tienda.dart';
import 'historia_post_arena.dart';

// Muestra el menú principal del juego.
void mostrarMenuPrincipal() {
  print('\n=== SANGRE Y GLORIA ===');
  print('1. Nueva Partida');
  print('2. Cargar Partida');
  print('3. Tutorial');
  print('4. Salir');
}

// Muestra el menú de acciones dentro del juego.
void mostrarMenuJuego() {
  print('\n=== MENÚ DE ACCIONES ===');
  print('1. Ir a la Arena ⚔️');
  print('2. Visitar Tienda 🏪');
  print('3. Ver Personaje 📊');
  print('4. Inventario 🎒');
  print('5. Guardar y salir 💾');
}

// Muestra el tutorial inicial del juego.
void mostrarTutorial() {
  print('''
\n--- TUTORIAL INICIAL ---
Eres un esclavo del Imperio, luchando por tu libertad en la Arena de Rocanegra.
Objetivo: Gana combates para liderar una rebelión contra el rey.
Controles: Atacar (⚔️), Ataque Especial (💥), Defender (🛡️), Esquivar (💨), Poción (🧪).
Inventario: Equipa armas, armaduras o amuletos.
¡Forja tu destino!
''');
}

// Gestiona un combate en la arena contra un enemigo.
void irALaArena(Jugador jugador) {
  print('\n⚔️ Entrando en la Arena de Rocanegra...');
  Enemigo enemigo;
  // Caso especial para la pelea final contra el rey.
  if (jugador.progresoHistoria == 10) {
    enemigo = Enemigo(
      nombre: 'Rey de Rocanegra',
      vida: 150 + jugador.nivel * 5, // Ajustado para nivel 12.
      ataque: 18,
      defensa: 8,
      agilidad: 6,
      tipo: 'Rey',
    );
  } else {
    // Genera un enemigo aleatorio según el nivel del jugador.
    List<Map<String, dynamic>> tiposEnemigos = [
      {'tipo': 'Berserker', 'vida': 80, 'ataque': 12, 'defensa': 3, 'agilidad': 4},
      {'tipo': 'Defender', 'vida': 100, 'ataque': 8, 'defensa': 6, 'agilidad': 3},
      {'tipo': 'Assassin', 'vida': 70, 'ataque': 10, 'defensa': 4, 'agilidad': 7},
    ];
    var enemigoData = tiposEnemigos[Random().nextInt(tiposEnemigos.length)];
    enemigo = Enemigo(
      nombre: 'Gladiador ${enemigoData['tipo']}',
      vida: enemigoData['vida'] + Random().nextInt(20) + jugador.nivel * 5, // Escalabilidad reducida.
      ataque: enemigoData['ataque'] + Random().nextInt(3),
      defensa: enemigoData['defensa'] + Random().nextInt(2),
      agilidad: enemigoData['agilidad'] + Random().nextInt(2),
      tipo: enemigoData['tipo'],
    );
  }

  // Muestra las estadísticas del enemigo.
  print('\n🆚 Enfrentándote a ${enemigo.nombre}');
  print('Vida: ${enemigo.vida}, Ataque: ${enemigo.ataque}, Defensa: ${enemigo.defensa}, Agilidad: ${enemigo.agilidad}\n');

  // Bucle de combate mientras ambos tengan vida.
  while (jugador.vida > 0 && enemigo.vida > 0) {
    print('\n=== Turno de ${jugador.nombre} (Vida: ${jugador.vida}, Stamina: ${jugador.stamina}) ===');
    print('1. Atacar ⚔️');
    print('2. Ataque Especial 💥${jugador.cooldownAtaqueEspecial > 0 ? " (Cooldown: ${jugador.cooldownAtaqueEspecial})" : ""}');
    print('3. Defender 🛡️');
    print('4. Esquivar 💨');
    print('5. Usar Poción 🧪');
    stdout.write('Elige una acción (1-5): ');
    int? accion = parseInput(stdin.readLineSync(), 1, 5);

    // Turno del jugador.
    switch (accion) {
      case 1: // Atacar
        int dano = max(0, jugador.ataque - enemigo.defensa); // Calcula daño.
        if (Random().nextInt(100) < enemigo.agilidad * 2) {
          print('\n¡${enemigo.nombre} esquivó tu ataque!');
        } else {
          enemigo.vida -= dano;
          print(dano > 10 ? '\n¡Golpeas con fuerza a ${enemigo.nombre} por $dano de daño!' : '\nGolpeas a ${enemigo.nombre} por $dano de daño.');
          print('Vida restante: ${enemigo.vida}');
        }
        break;
      case 2: // Ataque Especial
        if (jugador.cooldownAtaqueEspecial > 0) {
          print('\n❌ Ataque especial en cooldown (${jugador.cooldownAtaqueEspecial} turnos).');
        } else if (jugador.stamina < 30) {
          print('\n❌ No tienes suficiente stamina (necesitas 30).');
        } else if (jugador.armaEquipada == null || jugador.armaEquipada!.ataqueEspecial == null) {
          print('\n❌ No tienes un arma con ataque especial equipada.');
        } else {
          jugador.stamina -= 30; // Consume estamina.
          jugador.cooldownAtaqueEspecial = 3; // Establece enfriamiento.
          int dano = (jugador.ataque * 1.5 - enemigo.defensa).floor(); // Calcula daño especial.
          if (Random().nextInt(100) < enemigo.agilidad * 2) {
            print('\n¡${enemigo.nombre} esquivó tu ${jugador.armaEquipada!.ataqueEspecial}!');
          } else {
            enemigo.vida -= dano;
            print('\n¡Lanzas ${jugador.armaEquipada!.ataqueEspecial} contra ${enemigo.nombre} por $dano de daño!');
            print('Vida restante: ${enemigo.vida}');
          }
        }
        break;
      case 3: // Defender
        print('\nTe preparas para defender, reduciendo el próximo daño recibido.');
        break;
      case 4: // Esquivar
        if (jugador.stamina < 20) {
          print('\n❌ No tienes suficiente stamina (necesitas 20).');
        } else {
          jugador.stamina -= 20; // Consume estamina.
          print('\nIntentas esquivar el próximo ataque.');
        }
        break;
      case 5: // Usar poción
        jugador.usarPocion(); // Usa una poción de vida.
        break;
      default:
        print('\n❌ Acción inválida. Pierdes el turno.');
    }

    // Actualiza enfriamientos y estamina.
    if (jugador.cooldownAtaqueEspecial > 0) jugador.cooldownAtaqueEspecial--;
    jugador.regenerarStamina();

    // Turno del enemigo (si sigue vivo).
    if (enemigo.vida > 0) {
      print('\n=== Turno de ${enemigo.nombre} (Vida: ${enemigo.vida}) ===');
      bool esquivado = accion == 4 && Random().nextInt(100) < 50; // 50% de probabilidad de esquivar.
      if (esquivado) {
        print('\n¡Esquivas hábilmente el ataque de ${enemigo.nombre}!');
      } else {
        int danoEnemigo = 0;
        if (enemigo.tipo == 'Berserker' && Random().nextInt(100) < 30) {
          danoEnemigo = (enemigo.ataque * 1.5 - (accion == 3 ? jugador.defensa + 2 : jugador.defensa)).floor(); // Ataque furioso.
          print('\n${enemigo.nombre} lanza un ataque furioso por $danoEnemigo de daño!');
        } else if (enemigo.tipo == 'Defender' && Random().nextInt(100) < 30) {
          print('\n${enemigo.nombre} adopta una postura defensiva, reduciendo el próximo daño.');
          danoEnemigo = max(0, enemigo.ataque - (accion == 3 ? jugador.defensa + 2 : jugador.defensa));
        } else if (enemigo.tipo == 'Rey') {
          danoEnemigo = (enemigo.ataque * 1.2 - (accion == 3 ? jugador.defensa + 2 : jugador.defensa)).floor(); // Ataque real.
          print('\n${enemigo.nombre} ataca con furia real por $danoEnemigo de daño!');
        } else {
          danoEnemigo = max(0, enemigo.ataque - (accion == 3 ? jugador.defensa + 2 : jugador.defensa)); // Ataque normal.
          print('\n${enemigo.nombre} te golpea por $danoEnemigo de daño.');
        }
        jugador.vida -= danoEnemigo;
        print('Vida restante: ${jugador.vida}');
      }
    }
  }

  // Resultado del combate.
  if (jugador.vida <= 0) {
    print('\n💀 Has sido derrotado por ${enemigo.nombre}!');
    jugador.peleasPerdidas++; // Incrementa derrotas.
    jugador.vida = jugador.maxVida; // Restaura vida.
    jugador.stamina = 100; // Restaura estamina.
    if (jugador.progresoHistoria == 10) {
      jugador.progresoHistoria = 9; // Permite reintentar la pelea contra el rey.
    }
  } else {
    print('\n🏆 ¡Has derrotado a ${enemigo.nombre}!');
    int oroGanado = 20 + Random().nextInt(20); // Recompensa en oro.
    int expGanada = 75; // Recompensa en experiencia (aumentada).
    jugador.oro += oroGanado;
    jugador.experiencia += expGanada;
    jugador.peleasGanadas++; // Incrementa victorias.
    jugador.stamina = 100; // Restaura estamina.
    print('Recompensas: +$oroGanado oro, +$expGanada experiencia');
    // Verifica si el jugador sube de nivel.
    if (jugador.experiencia >= jugador.nivel * 100) {
      jugador.nivel++;
      jugador.experiencia = 0;
      jugador.maxVida += 10;
      jugador.vida = jugador.maxVida;
      jugador.ataque += 2;
      jugador.defensa += 1;
      jugador.agilidad += 1;
      print('\n🎉 ¡Subiste al nivel ${jugador.nivel}!');
      print('Vida +10, Ataque +2, Defensa +1, Agilidad +1');
    }
    if (jugador.progresoHistoria < 10) {
      historiaPostArena(jugador); // Activa evento de historia si no es la pelea final.
    }
  }
}

// Gestiona la interacción con la tienda.
void visitarTienda(Jugador jugador) {
  Tienda tienda = Tienda();
  print('\n🏪 Bienvenido a la Tienda de Rocanegra');
  print('Oro disponible: ${jugador.oro}');
  print('Descuento por reputación: ${(jugador.reputacion / 100).toStringAsFixed(2)}%');

  while (true) {
    tienda.mostrarItems(jugador.reputacion); // Muestra ítems disponibles.
    print('\nOpciones:');
    print('1. Comprar un ítem');
    print('2. Vender un ítem');
    print('3. Volver al menú');
    int? opcion = parseInput(stdin.readLineSync(), 1, 3);
    if (opcion == null) {
      print('\n❌ Opción inválida.');
      continue;
    }

    if (opcion == 1) {
      stdout.write('Ingresa el número del ítem a comprar (1-${tienda.items.length}): ');
      int? index = parseInput(stdin.readLineSync(), 1, tienda.items.length);
      if (index != null) {
        Item item = tienda.items[index - 1];
        int precioConDescuento = tienda.calcularPrecioConDescuento(item, jugador.reputacion);
        if (jugador.oro >= precioConDescuento) {
          jugador.oro -= precioConDescuento; // Resta el oro.
          jugador.items = [...jugador.items, Item(
            nombre: item.nombre,
            tipo: item.tipo,
            valor: item.valor,
            precio: item.precio,
            ataqueEspecial: item.ataqueEspecial,
          )]; // Añade el ítem al inventario.
          if (item.tipo == 'poción') {
            jugador.pociones++; // Incrementa pociones.
          }
          print('\n✅ Compraste ${item.nombre} por $precioConDescuento oro.');
        } else {
          print('\n❌ No tienes suficiente oro.');
        }
      } else {
        print('\n❌ Ítem inválido.');
      }
    } else if (opcion == 2) {
      if (jugador.items.isEmpty) {
        print('\n❌ No tienes ítems para vender.');
      } else {
        print('\n📜 Tus ítems:');
        for (int i = 0; i < jugador.items.length; i++) {
          Item item = jugador.items[i];
          int precioVenta = (item.precio * 0.5).floor(); // Calcula precio de venta.
          print('${i + 1}. ${item.nombre} (${item.tipo}, Precio de venta: $precioVenta oro)');
        }
        stdout.write('Ingresa el número del ítem a vender (1-${jugador.items.length}) o 0 para cancelar: ');
        int? index = parseInput(stdin.readLineSync(), 0, jugador.items.length);
        if (index == 0) {
          print('\n👋 Venta cancelada.');
        } else if (index != null) {
          Item item = jugador.items[index - 1];
          if (item.equipado) {
            jugador.desequiparItem(item); // Desequipa si está equipado.
          }
          int precioVenta = (item.precio * 0.5).floor();
          jugador.oro += precioVenta; // Añade oro.
          jugador.items = List.from(jugador.items)..removeAt(index - 1); // Elimina el ítem.
          if (item.tipo == 'poción') {
            jugador.pociones--; // Reduce pociones.
          }
          print('\n✅ Vendiste ${item.nombre} por $precioVenta oro.');
        } else {
          print('\n❌ Ítem inválido.');
        }
      }
    } else if (opcion == 3) {
      print('\n👋 Saliendo de la tienda...');
      break;
    }
  }
}

// Muestra las estadísticas y estado del personaje.
void verPersonaje(Jugador jugador) {
  jugador.mostrarEstado(); // Muestra el estado completo.
  print('\n📊 Estadísticas Adicionales:');
  print('Total de Oro Ganado: ${jugador.oro + (jugador.peleasGanadas * 20)}');
  print('Victorias en la Arena: ${jugador.peleasGanadas}');
  print('Derrotas en la Arena: ${jugador.peleasPerdidas}');
}

// Gestiona el inventario del jugador.
void verInventario(Jugador jugador) {
  print('\n🎒 Inventario de ${jugador.nombre}');
  if (jugador.items.isEmpty) {
    print('Tu inventario está vacío.');
  } else {
    for (int i = 0; i < jugador.items.length; i++) {
      Item item = jugador.items[i];
      String estado = item.equipado ? '(Equipado)' : '';
      String especial = item.ataqueEspecial != null ? ', Ataque Especial: ${item.ataqueEspecial}' : '';
      print('${i + 1}. ${item.nombre} (${item.tipo}, Valor: ${item.valor}, Precio: ${item.precio} oro$especial) $estado');
    }
  }
  print('Pociones: ${jugador.pociones}');

  while (true) {
    print('\nOpciones:');
    print('1. Equipar/Usar ítem');
    print('2. Desequipar ítem');
    print('3. Volver al menú');
    int? opcion = parseInput(stdin.readLineSync(), 1, 3);
    if (opcion == null) {
      print('\n❌ Opción inválida.');
      continue;
    }

    if (opcion == 1) {
      if (jugador.items.isEmpty) {
        print('\n❌ No tienes ítems para equipar.');
      } else {
        stdout.write('Ingresa el número del ítem a equipar/usar (1-${jugador.items.length}): ');
        int? index = parseInput(stdin.readLineSync(), 1, jugador.items.length);
        if (index != null) {
          jugador.equiparItem(jugador.items[index - 1], index - 1); // Equipa o usa el ítem.
        } else {
          print('\n❌ Ítem inválido.');
        }
      }
    } else if (opcion == 2) {
      if (jugador.items.isEmpty) {
        print('\n❌ No tienes ítems para desequipar.');
      } else {
        print('\n📜 Ítems equipados:');
        bool tieneEquipado = false;
        for (int i = 0; i < jugador.items.length; i++) {
          if (jugador.items[i].equipado) {
            tieneEquipado = true;
            print('${i + 1}. ${jugador.items[i].nombre} (${jugador.items[i].tipo})');
          }
        }
        if (!tieneEquipado) {
          print('No tienes ítems equipados.');
        } else {
          stdout.write('Ingresa el número del ítem a desequipar (1-${jugador.items.length}) o 0 para cancelar: ');
          int? index = parseInput(stdin.readLineSync(), 0, jugador.items.length);
          if (index == 0) {
            print('\n👋 Desequipado cancelado.');
          } else if (index != null && jugador.items[index - 1].equipado) {
            jugador.desequiparItem(jugador.items[index - 1]); // Desequipa el ítem.
          } else {
            print('\n❌ Ítem inválido o no está equipado.');
          }
        }
      }
    } else if (opcion == 3) {
      print('\n👋 Volviendo al menú...');
      break;
    }
  }
}

// Guarda la partida y sale al menú principal.
void guardarYSalir(Jugador jugador) {
  jugador.guardarPartida(); // Guarda el estado del jugador.
  print('\n💾 Volviendo al menú principal...');
}
