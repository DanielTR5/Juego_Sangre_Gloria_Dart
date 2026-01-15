// historia_intro.dart: Gestiona la historia introductoria del juego con decisiones narrativas que afectan las estadísticas del jugador.

import 'dart:io';
import 'jugador.dart';

// Función para reproducir la historia introductoria con elecciones interactivas.
void historiaIntroductoria(Jugador jugador) {
  // Muestra el título de la introducción narrativa.
  print('\n\n=== EL VIAJE DEL CONDENADO ===\n');

  // Crea una cuenta regresiva para aumentar la inmersión.
  print('>>> El destino se acerca en...');
  for (int i = 4; i > 0; i--) {
    print('>>> $i...');
    sleep(Duration(milliseconds: 800)); // Pausa breve entre cada número.
  }

  // Presenta la escena inicial en el barco esclavista.
  print('\n\n🌊 Mar de las Lágrimas, año 1023 del Imperio');
  print(
    'Encadenado en la bodega de un barco esclavista, el aire espeso de sudor y miedo',
  );
  print(
    'te ahoga. Recuerdas tu vida como ${jugador.origen.toLowerCase()}, ahora reducida',
  );
  print(
    'a este infierno flotante. "Al menos sigo vivo", piensas, mientras el barco se mece.\n',
  );

  // Primera decisión: Evento en cubierta con un guardia borracho.
  print('Un guardia borracho se acerca a tu grupo de esclavos:');
  print(
    '"¡Quién se ofrece para limpiar los excrementos de los caballos del capitán!"',
  );
  print('Nadie se mueve. El guardia saca su látigo con una sonrisa cruel.\n');

  print('¿Qué haces?');
  print('1. [Valentía] Ofrecerme voluntario');
  print('2. [Astucia] Señalar a otro prisionero');
  print('3. [Pasividad] Mantener la cabeza baja');
  stdout.write('Elige (1-3): ');

  String? opcion1 = stdin.readLineSync();
  switch (opcion1) {
    case '1':
      jugador.reputacion += 5;
      jugador.vida -= 10;
      print(
        '\n>> Te ofreces. El trabajo es repugnante y te hace perder salud,',
      );
      print(
        '>> pero ganas respeto entre los esclavos. (+5 Reputación, -10 Vida)',
      );
      break;
    case '2':
      jugador.reputacion -= 7;
      jugador.agilidad += 3;
      print(
        '\n>> Señalas a un prisionero débil. Los guardias se ríen de tu "astucia".',
      );
      print(
        '>> Aprendes a moverte rápido para evitar represalias. (-7 Reputación, +3 Agilidad)',
      );
      break;
    case '3':
      jugador.defensa += 4;
      print(
        '\n>> Mantienes la cabeza baja. El guardia golpea al azar a alguien cerca.',
      );
      print('>> Desarrollas instintos protectores. (+4 Defensa)');
      break;
    default:
      print(
        '\n>> Tu indecisión enfurece al guardia, que te golpea brutalmente.',
      );
      jugador.vida -= 15;
  }

  // Segunda decisión: Evento nocturno con conspiración de fuga.
  print(
    '\n\n🌙 En la oscuridad de la noche, oyes a dos prisioneros conspirando:',
  );
  print(
    '"Mañana al amanecer, cuando cambien la guardia... podemos saltar por la borda"',
  );
  print('Uno de ellos te mira directamente: "¿Te unes a nosotros?"\n');

  print('¿Cuál es tu respuesta?');
  print('1. [Lealtad] Unirme al plan de fuga');
  print('2. [Sobrevivencia] Delatarlos a los guardias');
  print('3. [Precaución] Rechazar pero guardar silencio');
  stdout.write('Elige (1-3): ');

  String? opcion2 = stdin.readLineSync();
  switch (opcion2) {
    case '1':
      print(
        '\n>> Te unes a la conspiración. En la confusión del intento de fuga...',
      );

      // Subdecisión para el intento de fuga fallido.
      print('\nEl plan falla cuando un guardia extravigilante los descubre.');
      print('¿Qué haces?');
      print('a) [Heroísmo] Distraer a los guardias para que otros escapen');
      print('b) [Egoísmo] Empujar a un compañero hacia los guardias');
      print('c) [Astucia] Fingir que eras rehén de los conspiradores');
      stdout.write('Elige (a-c): ');

      String? subopcion = stdin.readLineSync();
      switch (subopcion) {
        case 'a':
          jugador.reputacion += 10;
          jugador.vida -= 25;
          print(
            '\n>> Los guardias te golpean salvajemente, pero dos prisioneros escapan.',
          );
          print(
            '>> Te ganas el respeto de todos, pero pagas un alto precio. (+10 Reputación, -25 Vida)',
          );
          break;
        case 'b':
          jugador.reputacion -= 15;
          jugador.ataque += 5;
          print(
            '\n>> Tu traición te salva del castigo, pero todos te desprecian.',
          );
          print(
            '>> Desarrollas instintos agresivos. (-15 Reputación, +5 Ataque)',
          );
          break;
        case 'c':
          jugador.agilidad += 6;
          print('\n>> Tu actuación convincente engaña a los guardias.');
          print(
            '>> Aprendes a pensar rápido en situaciones límite. (+6 Agilidad)',
          );
          break;
        default:
          print('\n>> La indecisión te lleva al castigo junto con los demás.');
          jugador.vida -= 20;
      }
      break;

    case '2':
      jugador.reputacion -= 10;
      jugador.pociones += 2;
      print('\n>> Los guardias te recompensan con comida extra y pociones.');
      print(
        '>> Los prisioneros te marcan como traidor. (-10 Reputación, +2 Pociones)',
      );
      break;

    case '3':
      jugador.defensa += 3;
      jugador.reputacion += 2;
      print(
        '\n>> Al día siguiente, los conspiradores son capturados sin tu intervención.',
      );
      print(
        '>> Tu discreción te salva de problemas. (+3 Defensa, +2 Reputación)',
      );
      break;

    default:
      print('\n>> Tu silencio ambiguo te hace sospechoso para ambos bandos.');
      jugador.vida -= 10;
  }

  // Escena narrativa: Rumor sobre la nobleza y el linaje de Valerius.
  print(
    '\n\n🔥 Durante una parada en un puerto, un viejo esclavo te observa atentamente:',
  );
  print(
    '"Tienes los ojos de Lord Valerius... el que gobernaba estas tierras antes de la rebelión"',
  );
  print(
    'Baja la voz: "Dicen que tuvo un hijo bastardo con una campesina... justo antes de ser ejecutado"',
  );
  print('El viejo se aleja murmurando: "El destino es cruel, ¿verdad?"\n');

  print('¿Cómo reaccionas?');
  print('1. [Desprecio] "Viejo loco, solo busca sembrar falsas esperanzas"');
  print(
    '2. [Curiosidad] "¿Será posible? Quizá por eso mi madre nunca habló de él..."',
  );
  print('3. [Indiferencia] Ignorar el comentario y seguir trabajando');
  stdout.write('Elige (1-3): ');

  String? opcion3 = stdin.readLineSync();
  switch (opcion3) {
    case '1':
      print(
        '\n>> Descartas las palabras del viejo como tonterías. Sigues adelante.',
      );
      break;
    case '2':
      print(
        '\n>> La semilla de la duda queda plantada en tu mente. ¿Será verdad?',
      );
      break;
    case '3':
      print(
        '\n>> Decides que no importa. Tu pasado murió cuando te capturaron.',
      );
      break;
    default:
      print('\n>> No respondes, pero la idea se queda rondando en tu cabeza.');
  }

  // Escena final: Llegada a Rocanegra.
  print('\n\n🌅 En tu último amanecer en el barco, ves tierra a lo lejos:');
  print('"¿Qué esperas encontrar en Rocanegra?" te pregunta un compañero.\n');
  print('1. [Esperanza] "Mi libertad, aunque cueste sangre"');
  print(
    '2. [Venganza] "La oportunidad de hacer pagar a quienes me hicieron esto"',
  );
  print('3. [Supervivencia] "Solo sobrevivir un día más"');
  stdout.write('Elige (1-3): ');

  String? opcion4 = stdin.readLineSync();
  switch (opcion4) {
    case '1':
      print('\n>> "La libertad...", murmuras mientras observas la costa.');
      jugador.reputacion += 3; // Aumenta la reputación por esperanza.
      print('>> Tu determinación inspira a los demás. (+3 Reputación)');
      break;
    case '2':
      print(
        '\n>> Un fuego oscuro arde en tus ojos mientras aprietas los puños.',
      );
      jugador.ataque += 3; // Aumenta el ataque por venganza.
      print('>> Tu deseo de venganza agudiza tu fuerza. (+3 Ataque)');
      break;
    case '3':
      print('\n>> "Sobrevivir...", respondes con voz apagada.');
      jugador.defensa += 3; // Aumenta la defensa por supervivencia.
      print(
        '>> Tu instinto de supervivencia fortalece tu resistencia. (+3 Defensa)',
      );
      break;
    default:
      print('\n>> No respondes, pero la pregunta pesa en tu mente.');
      jugador.vida -= 5; // Penalización por indecisión.
      print('>> La incertidumbre debilita tu espíritu. (-5 Vida)');
  }

  // Conclusión de la introducción narrativa.
  print(
    '\n\n🏰 El barco atraca en Rocanegra. Los guardias te arrastran hacia la Arena.',
  );
  print('Tu destino como gladiador comienza ahora, ${jugador.nombre}.');
  print('Que la sangre y la gloria te guíen.\n');
}
