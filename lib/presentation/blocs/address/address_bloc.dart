import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_addresses_usecase.dart';
import '../../../domain/usecases/add_address_usecase.dart';
import '../../../domain/usecases/update_address_usecase.dart';
import '../../../domain/usecases/delete_address_usecase.dart';
import '../../../domain/usecases/set_primary_address_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final DeleteAddressUseCase deleteAddressUseCase;
  final SetPrimaryAddressUseCase setPrimaryAddressUseCase;

  AddressBloc({
    required this.getAddressesUseCase,
    required this.addAddressUseCase,
    required this.updateAddressUseCase,
    required this.deleteAddressUseCase,
    required this.setPrimaryAddressUseCase,
  }) : super(AddressInitial()) {
    on<GetAddressesEvent>(_onGetAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<SetPrimaryAddressEvent>(_onSetPrimaryAddress);
  }

  Future<void> _onGetAddresses(
    GetAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await getAddressesUseCase.execute();
    result.fold(
      (failure) => emit(AddressFailure(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await addAddressUseCase.execute(
      name: event.address.name,
      fullAddress: event.address.fullAddress,
      receiverName: event.address.receiverName,
      phoneNumber: event.address.phoneNumber,
      isPrimary: event.address.isPrimary,
    );
    result.fold(
      (failure) => emit(AddressFailure(failure.message)),
      (address) {
        emit(const AddressActionSuccess('Berhasil menambahkan alamat'));
        add(GetAddressesEvent());
      },
    );
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await updateAddressUseCase.execute(
      id: event.id,
      name: event.address.name,
      fullAddress: event.address.fullAddress,
      receiverName: event.address.receiverName,
      phoneNumber: event.address.phoneNumber,
      isPrimary: event.address.isPrimary,
    );
    result.fold(
      (failure) => emit(AddressFailure(failure.message)),
      (address) {
        emit(const AddressActionSuccess('Berhasil memperbarui alamat'));
        add(GetAddressesEvent());
      },
    );
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await deleteAddressUseCase.execute(event.id);
    result.fold(
      (failure) => emit(AddressFailure(failure.message)),
      (_) {
        emit(const AddressActionSuccess('Berhasil menghapus alamat'));
        add(GetAddressesEvent());
      },
    );
  }

  Future<void> _onSetPrimaryAddress(
    SetPrimaryAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    final result = await setPrimaryAddressUseCase.execute(event.id);
    result.fold(
      (failure) => emit(AddressFailure(failure.message)),
      (address) {
        emit(const AddressActionSuccess('Berhasil mengatur alamat utama'));
        add(GetAddressesEvent());
      },
    );
  }
}
