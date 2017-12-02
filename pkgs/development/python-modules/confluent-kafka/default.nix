{ stdenv, buildPythonPackage, fetchPypi, isPy3k, rdkafka, requests, avro3k, avro}:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.11.0";
  pname = "confluent-kafka";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4c34bfe8f823ee3777d93820ec6578365d2bde3cd1302cbd0e44c86b68643667";
  };

  buildInputs = [ rdkafka requests ] ++ (if isPy3k then [ avro3k ] else [ avro ]) ;

  # Tests fail for python3 under this pypi release
  doCheck = if isPy3k then false else true;

  meta = with stdenv.lib; {
    description = "Confluent's Apache Kafka client for Python";
    homepage = https://github.com/confluentinc/confluent-kafka-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ mlieberman85 ];
  };
}
