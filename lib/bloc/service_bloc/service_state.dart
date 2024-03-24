

import 'package:nu_drive_task/models/services_model.dart';

abstract class ServiceState {}

class ServiceInitialState extends ServiceState {}

class ServiceLoadingState extends ServiceState {}

class ServiceErrorState extends ServiceState {
  final String errorMessage;

  ServiceErrorState({
    required this.errorMessage,
  });
}

class ServiceLoadedState extends ServiceState {
  final ServicesModel? servicesModel;


  ServiceLoadedState({
    this.servicesModel,

  });

  ServiceLoadedState copyWith({
    ServicesModel? newServiceModel,

  }) {
    return ServiceLoadedState(
      servicesModel: newServiceModel ?? this.servicesModel,

    );
  }
}
