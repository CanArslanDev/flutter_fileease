import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef BlocBuilderCondition<S> = bool Function(S previous, S current);
typedef BlocWidgetBuilder3<StateA, StateB> = Widget Function(
  BuildContext,
  StateA,
  StateB,
);

class Multi2BlocBuilder<
    BlocA extends StateStreamable<BlocAState>,
    BlocAState,
    BlocB extends StateStreamable<BlocBState>,
    BlocBState> extends StatelessWidget {
  const Multi2BlocBuilder({
    required this.builder,
    super.key,
    this.blocA,
    this.blocB,
    this.buildWhenA,
    this.buildWhenB,
  });

  final BlocWidgetBuilder3<BlocAState, BlocBState> builder;

  final BlocA? blocA;
  final BlocB? blocB;

  final BlocBuilderCondition<BlocAState>? buildWhenA;
  final BlocBuilderCondition<BlocBState>? buildWhenB;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlocA, BlocAState>(
      bloc: blocA,
      buildWhen: buildWhenA,
      builder: (context, blocAState) {
        return BlocBuilder<BlocB, BlocBState>(
          bloc: blocB,
          buildWhen: buildWhenB,
          builder: (context, blocBState) {
            return builder(context, blocAState, blocBState);
          },
        );
      },
    );
  }
}
