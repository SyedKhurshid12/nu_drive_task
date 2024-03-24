import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_drive_task/bloc/service_bloc/service_bloc.dart';
import 'package:nu_drive_task/bloc/service_bloc/service_event.dart';
import 'package:nu_drive_task/bloc/service_bloc/service_state.dart';
import 'package:nu_drive_task/models/services_model.dart';

class BlocExampleScreen extends StatefulWidget {
  const BlocExampleScreen({super.key});

  @override
  State<BlocExampleScreen> createState() => _BlocExampleScreenState();
}

class _BlocExampleScreenState extends State<BlocExampleScreen> {
  ServiceBloc serviceBloc = ServiceBloc();

  @override
  void initState() {
    // TODO: implement initState
    serviceBloc.add(GetServices());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bloc example"),
        ),
        body: BlocProvider(
            create: (_) => serviceBloc,
            child: BlocListener<ServiceBloc, ServiceState>(
              listener: (context, state) {
                if (state is ServiceErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Error fetching data"),
                    ),
                  );
                } else if (state is ServiceLoadingState) {}
              },
              child: BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  if (state is ServiceInitialState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ServiceLoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ServiceLoadedState) {
                    return _buildCard(context, state.servicesModel!);
                  } else if (state is ServiceErrorState) {
                    return Container();
                  } else {
                    return Container();
                  }
                },
              ),
            )));
  }

  Widget _buildCard(BuildContext context, ServicesModel model) {
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // const UserProfilingTopBar(index: 1,),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: Text(
          "Services",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xff333333),
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: model.services?.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.92,
              decoration: BoxDecoration(boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 4,
                  offset: Offset(0.0, 0.75),
                ),
              ], color: Colors.white, borderRadius: BorderRadius.circular(35)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    model.services?[index]?.name ?? "unknown",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87),
                  )
                ],
              ),
            ),
          );
        },
      ),
      const SizedBox(
        height: 50,
      ),
    ]));
  }
}
