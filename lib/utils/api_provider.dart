import 'dart:developer';

import 'package:graphql/client.dart';
import 'package:graphql_test/models/country_model.dart';

const baseURL = "https://countries.trevorblades.com/";

final _httpLink = HttpLink(
  baseURL,
);

final GraphQLClient client = GraphQLClient(
  link: _httpLink,
  cache: GraphQLCache(),
);

Future<List<Countries>> getAllCountries(String? code, String? currency) async {
  Map<String, dynamic> variables = {};

  variables = {
    "filter": {},
  };

  if (code!.isNotEmpty) {
    variables["filter"]["code"] = {"in": code};
  }

  if (currency!.isNotEmpty && currency != 'Filter') {
    variables["filter"]["currency"] = {"in": currency};
  }

  var result = await client.query(
    QueryOptions(
      document: gql(_getAllCountries),
      variables: variables,
    ),
  );
  if (result.hasException) {
    log(result.exception.toString());
    throw result.exception!;
  }
  var json = result.data!["countries"];

  log(json.toString());

  List<Countries> countries = [];
  for (var res in json) {
    var country = Countries.fromJson(res);
    countries.add(country);
  }
  return countries;
}

const _getAllCountries = r'''
query getCountry($filter:CountryFilterInput){
  countries(filter:$filter){
    code
    name
    native
    phone
    currency
  }
}
''';
