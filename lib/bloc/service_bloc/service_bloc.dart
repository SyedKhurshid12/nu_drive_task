import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_drive_task/bloc/service_bloc/service_event.dart';
import 'package:nu_drive_task/bloc/service_bloc/service_state.dart';
import 'package:nu_drive_task/models/services_model.dart';
import 'package:nu_drive_task/services/api_services.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  ServiceBloc() : super(ServiceInitialState()) {
    on<GetServices>((event, emit) async {
      final ApiServices apiServices = ApiServices();
      try {
        emit(ServiceLoadingState());

        ServicesModel res = await apiServices.getServices();

        emit(ServiceLoadedState(
          servicesModel: res,
        ));
      } catch (e) {
        debugPrint(
            '----------- the api isnt working crop listtttt---------  >');
      }
    });
  }
}
