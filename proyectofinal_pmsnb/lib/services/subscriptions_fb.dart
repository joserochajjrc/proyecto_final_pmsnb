import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/subscription_model.dart';

class SubscriptionsCollection {
  FirebaseFirestore? _firestore;
  CollectionReference? _subscriptionsCollection;

  SubscriptionsCollection() {
    _firestore = FirebaseFirestore.instance;
    _subscriptionsCollection = _firestore!.collection('suscripciones');
  }

  Future<void> insert(
      SubscriptionModel subscriptionsCollection, String id) async {
    return _subscriptionsCollection!.doc(id).set(
      {
        'Cremas': subscriptionsCollection.Cremas,
        'Ensaladas': subscriptionsCollection.Ensaladas,
        'Guisos': subscriptionsCollection.Guisos,
        'Panes': subscriptionsCollection.Panes,
        'Postres': subscriptionsCollection.Postres,
      },
    );
  }

  Future<void> update(
      SubscriptionModel subscriptionsCollection, String id) async {
    return _subscriptionsCollection!.doc(id).update(
      {
        'Cremas': subscriptionsCollection.Cremas,
        'Ensaladas': subscriptionsCollection.Ensaladas,
        'Guisos': subscriptionsCollection.Guisos,
        'Panes': subscriptionsCollection.Panes,
        'Postres': subscriptionsCollection.Postres,
      },
    );
  }

  Future<Map<String, dynamic>> getSubscriptions(String id) async {
    var data;
    await _subscriptionsCollection!.doc(id).get().then(
        (DocumentSnapshot doc) => data = doc.data() as Map<String, dynamic>);
    return data;
  }

  verifySubscriptions(String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('suscripciones')
        .doc(id)
        .get();
    return documentSnapshot.exists;
  }
}
