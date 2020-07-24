import 'package:firestore_bloc/src/firestore_query_cubit/firestore_query_cubit.dart';
import 'package:firestore_doc/firestore_doc.dart';

import '../../firestore_bloc.dart';

abstract class FirestoreCollectionCubit<T extends FirestoreDocument,
    R extends FirestoreRepository<T>> extends FirestoreQueryCubit<T, R> {
  final R collectionRepo;
  final FirestoreCollectionPath collectionPath;

  FirestoreCollectionCubit(this.collectionRepo, this.collectionPath)
      : super(collectionRepo);

  void loadAll() {
    super.load(() => collectionRepo.queryAll(collectionPath));
  }
}
