class NoDocumentReferenceException implements Exception {
  final dynamic error;

  NoDocumentReferenceException(this.error);
}