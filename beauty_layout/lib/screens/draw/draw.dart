import 'draw_page.dart';
import 'bloc/painter_bloc.dart';
import 'package:flutter/material.dart';

class DrawScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Draw'),
        ),
        body: BlocProvider<PainterBloc>(
          child: DrawPage(),
          bloc: PainterBloc(),
        ),
      ),
    );
  }
}
