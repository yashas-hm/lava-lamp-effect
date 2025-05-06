# Lava Lamp Effect

🌋✨ Immerse your app in the hypnotic beauty of molten motion with the `lava_lamp_effect`, a Flutter package designed to
bring mesmerizing, fluid animations to life. 🫧

## Demo

![Demo](https://raw.githubusercontent.com/yashas-hm/lava-lamp-effect/refs/heads/main/assets/demo.gif)

### **Show some ❤️ and ⭐️ the Repo**

Resources:

- [GitHub Repo](https://github.com/yashas-hm/lava-lamp-effect)
- [Example](https://github.com/yashas-hm/lava-lamp-effect/tree/main/example)
- [Pub Package](https://pub.dev/packages/lava_lamp_effect)

## How to Use?

Adding this bubbly beauty to your UI is smoother than a lava blob floating to the top. Customize it with parameters like `size`, `color`, `lavaCount`, and `speed` to shape your very own lamp of wonder. 🛠️🌈

```dart
import 'package:flutter/material.dart';
import 'package:lava_lamp_effect/lava_lamp_effect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lava Lamp Effect Demo'),
        ),
        body: Center(
          child: LavaLampEffect(
            size: Size(300, 500),
            color: Colors.deepPurple,
            lavaCount: 4,
            speed: 1,
            repeatDuration: Duration(seconds: 10),
          ),
        ),
      ),
    );
  }
}
```
Want a faster flow or more blobs? Crank up the `speed` or `lavaCount` and let the animation groove! 🎛️🎶

## Features
- 🫧 Smooth, organic lava motion
- 🎨 Fully customizable color palette
- 🧊 Adjustable blob size and count
- ⏱️ Control animation speed and cycle time

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  lava_lamp_effect: ^1.0.0
```

## Contributions

- [Fork it](https://github.com/yashas-hm/lava-lamp-effect/fork) on GitHub
- [Submit](https://github.com/yashas-hm/lava-lamp-effect/issues/new/choose) feedback, feature or bug report

## License

This project is licensed under the MIT License, see the LICENSE file for details.

## Credits

This package is inspired by [flutter_lava_clock](https://github.com/jamesblasco/flutter_lava_clock) by Jaime Blasco.
