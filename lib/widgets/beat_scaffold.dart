import 'package:beat/utils/colors.dart';
import 'package:flutter/material.dart';

class BeatScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;

  const BeatScaffold({
    Key? key,
    required this.body,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;

    return Scaffold(
      backgroundColor: BeatColors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            body,
            if (canPop)
              _BackButton(
                onPress: () {
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPress;

  const _BackButton({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: ElevatedButton.icon(
          onPressed: onPress,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black, // Define a cor de fundo como branca
            foregroundColor:
                Colors.white, // Define a cor do texto e do ícone como preto
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          label: const Text('Voltar'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
    );
  }
}
