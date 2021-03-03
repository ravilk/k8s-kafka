NAME=kafka-1
keytool -keystore $NAME.jks -storepass kafkapilot -alias $NAME -validity 365 -genkey -keypass kafkapilot -dname "CN=$NAME,OU=kafka,O=juplo,L=MS,ST=NRW,C=DE"
keytool -keystore $NAME.jks -storepass kafkapilot -alias $NAME -certreq -file cert-file
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out $NAME.pem -days 365 -CAcreateserial -passin pass:kafkapilot -extensions SAN -extfile <(printf "\n[SAN]\nsubjectAltName=DNS:$NAME,DNS:localhost")
keytool -keystore $NAME.jks -storepass kafkapilot -import -alias ca-root -file ca-cert -noprompt
keytool -keystore $NAME.jks -storepass kafkapilot -import -alias $NAME -file $NAME.pem



openssl req -new -x509 -days 365 -keyout ca-key -out ca-cert -subj "/C=DE/ST=NRW/L=MS/O=juplo/OU=kafka/CN=Root-CA" -passout pass:kafkapilot
keytool -keystore kafkaCA-trusted.jks -storepass kafkapilot -import -alias ca-root -file ca-cert -noprompt