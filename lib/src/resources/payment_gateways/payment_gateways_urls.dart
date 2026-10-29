/// Payment gateway path templates; the client fills `{api_version}`.
class PaymentGatewayUrls {
  PaymentGatewayUrls._();

  /// The listing; `POST` and `PUT` here are `405`.
  static const String paymentGateways =
      '/api/{api_version}/admin/payment_gateways';

  /// How many gateways the listing's filters match.
  static const String paymentGatewaysCount =
      '/api/{api_version}/admin/payment_gateways/count';

  /// One gateway by id; `POST` and `DELETE` here are `405`.
  static const String paymentGateway =
      '/api/{api_version}/admin/payment_gateways/{payment_gateway_id}';
}
