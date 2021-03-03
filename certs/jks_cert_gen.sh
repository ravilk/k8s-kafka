NAME=kafka-consumer
keytool -keystore $NAME.jks -storepass kafkapilot -alias $NAME -validity 365 -genkey -keypass kafkapilot -dname "CN=$NAME,OU=kafka,O=juplo,L=MS,ST=NRW,C=DE"
keytool -keystore $NAME.jks -storepass kafkapilot -alias $NAME -certreq -file cert-file
openssl x509 -req -CA ca-cert -CAkey ca-key -in cert-file -out $NAME.pem -days 365 -CAcreateserial -passin pass:kafkapilot -extensions SAN -extfile <(printf "\n[SAN]\nsubjectAltName=DNS:$NAME,DNS:localhost")
keytool -keystore $NAME.jks -storepass kafkapilot -import -alias ca-root -file ca-cert -noprompt
keytool -keystore $NAME.jks -storepass kafkapilot -import -alias $NAME -file $NAME.pem
